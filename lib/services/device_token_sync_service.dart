import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Serviço que sincroniza o token FCM com o backend e expõe
/// os endpoints de dispositivos e notificações.
///
/// Endpoints cobertos:
///   POST   /api/v1/devices/token           → registra token FCM
///   DELETE /api/v1/devices/token           → desativa token (logout)
///   GET    /api/v1/devices/me              → lista dispositivos do usuário
///   POST   /api/v1/notifications/send      → envia push p/ usuário  (ADMIN)
///   POST   /api/v1/notifications/send/topic → envia push p/ tópico  (ADMIN)
class DeviceTokenSyncService {
  // ── Configuração ──────────────────────────────────────────────
  // TODO: Substituir pela URL real da sua API.
  static const String _apiBase = 'https://api-sabios.lmagalhaes.com/api/v1';

  static const Duration _timeout = Duration(seconds: 10);
  static const int _maxRetries = 3;

  /// JWT do usuário autenticado.
  static String? _jwtToken;

  // ═══════════════════════════════════════════════════════════════
  //  DISPOSITIVOS
  // ═══════════════════════════════════════════════════════════════

  /// Inicializa: obtém o token FCM, envia ao backend via
  /// `POST /api/v1/devices/token` e fica escutando rotações.
  static Future<void> inicializar(String jwtTokenUsuario) async {
    debugPrint('[DeviceTokenSync] Inicializando com JWT do usuário...');
    _jwtToken = jwtTokenUsuario;

    try {
      final String? fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('[DeviceTokenSync] Token FCM obtido do Firebase: $fcmToken');
      if (fcmToken != null) {
        await _registrarToken(fcmToken);
      } else {
        debugPrint('[DeviceTokenSync] Aviso: Token FCM retornado pelo Firebase foi nulo.');
      }
    } catch (e) {
      debugPrint('[DeviceTokenSync] Erro ao obter token FCM do Firebase: $e');
    }

    // Firebase pode rotacionar o token a qualquer momento.
    FirebaseMessaging.instance.onTokenRefresh.listen((novoToken) {
      debugPrint('[DeviceTokenSync] Evento onTokenRefresh disparado com novo token: $novoToken');
      _registrarToken(novoToken);
    });
  }

  /// Atualiza o JWT (ex.: após refresh do auth token).
  static void atualizarJwt(String novoJwt) {
    debugPrint('[DeviceTokenSync] Atualizando JWT do usuário no serviço.');
    _jwtToken = novoJwt;
  }

  /// `DELETE /api/v1/devices/token` — desativa o token no logout.
  static Future<void> removerToken() async {
    final jwt = _jwtToken;
    if (jwt == null) {
      debugPrint('[DeviceTokenSync] removerToken cancelado: JWT ausente.');
      return;
    }

    try {
      debugPrint('[DeviceTokenSync] Obtendo token FCM atual para desativação no backend...');
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        debugPrint('[DeviceTokenSync] removerToken: Token FCM não encontrado.');
        return;
      }

      debugPrint('[DeviceTokenSync] Enviando requisição de exclusão (DELETE /devices/token)...');
      final response = await http
          .delete(
            Uri.parse('$_apiBase/devices/token'),
            headers: _headers(jwt),
            body: jsonEncode({'fcmToken': fcmToken}),
          )
          .timeout(_timeout);

      debugPrint(
        '[DeviceTokenSync] Resposta da remoção de token: status ${response.statusCode}',
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('[DeviceTokenSync] Token removido do backend com sucesso.');
      } else {
        debugPrint('[DeviceTokenSync] Backend retornou erro ao remover token: ${response.body}');
      }
    } catch (e) {
      debugPrint('[DeviceTokenSync] Erro ao remover token: $e');
    } finally {
      _jwtToken = null;
      debugPrint('[DeviceTokenSync] JWT local resetado para null.');
    }
  }

  /// `GET /api/v1/devices/me` — lista dispositivos do usuário.
  /// Retorna a lista decodificada ou `null` em caso de erro.
  static Future<List<dynamic>?> listarDispositivos() async {
    final jwt = _jwtToken;
    if (jwt == null) {
      debugPrint('[DeviceTokenSync] listarDispositivos abortado: JWT ausente.');
      return null;
    }

    try {
      debugPrint('[DeviceTokenSync] Buscando lista de dispositivos (GET /devices/me)...');
      final response = await http
          .get(
            Uri.parse('$_apiBase/devices/me'),
            headers: _headers(jwt),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        final data = jsonDecode(response.body) as List<dynamic>;
        debugPrint('[DeviceTokenSync] Dispositivos listados com sucesso: ${data.length} dispositivo(s).');
        return data;
      }

      debugPrint(
        '[DeviceTokenSync] listarDispositivos → ${response.statusCode} - Body: ${response.body}',
      );
    } catch (e) {
      debugPrint('[DeviceTokenSync] Erro ao listar dispositivos: $e');
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════
  //  NOTIFICAÇÕES (ADMIN)
  // ═══════════════════════════════════════════════════════════════

  /// `POST /api/v1/notifications/send` — envia push para um usuário.
  ///
  /// [targetUserId] — ID do usuário destinatário.
  /// [title] e [body] — conteúdo da notificação.
  /// [data] — payload extra (opcional).
  static Future<bool> enviarParaUsuario({
    required String targetUserId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final jwt = _jwtToken;
    if (jwt == null) {
      debugPrint('[DeviceTokenSync] enviarParaUsuario abortado: JWT ausente.');
      return false;
    }

    try {
      debugPrint('[DeviceTokenSync] Enviando push para o usuário $targetUserId: "$title"...');
      final response = await http
          .post(
            Uri.parse('$_apiBase/notifications/send'),
            headers: _headers(jwt),
            body: jsonEncode({
              'userId': targetUserId,
              'title': title,
              'body': body,
              if (data != null) 'data': data,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        debugPrint('[DeviceTokenSync] Push enviado com sucesso para $targetUserId.');
        return true;
      }

      debugPrint(
        '[DeviceTokenSync] enviarParaUsuario → ${response.statusCode} - Body: ${response.body}',
      );
    } catch (e) {
      debugPrint('[DeviceTokenSync] Erro ao enviar push para usuário: $e');
    }

    return false;
  }

  /// `POST /api/v1/notifications/send/topic` — envia push para um tópico.
  ///
  /// [topic] — nome do tópico (ex.: "novidades", "mentores").
  /// [title] e [body] — conteúdo da notificação.
  /// [data] — payload extra (opcional).
  static Future<bool> enviarParaTopico({
    required String topic,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final jwt = _jwtToken;
    if (jwt == null) {
      debugPrint('[DeviceTokenSync] enviarParaTopico abortado: JWT ausente.');
      return false;
    }

    try {
      debugPrint('[DeviceTokenSync] Enviando push para tópico "$topic": "$title"...');
      final response = await http
          .post(
            Uri.parse('$_apiBase/notifications/send/topic'),
            headers: _headers(jwt),
            body: jsonEncode({
              'topic': topic,
              'title': title,
              'body': body,
              if (data != null) 'data': data,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        debugPrint('[DeviceTokenSync] Push enviado com sucesso para tópico "$topic".');
        return true;
      }

      debugPrint(
        '[DeviceTokenSync] enviarParaTopico → ${response.statusCode} - Body: ${response.body}',
      );
    } catch (e) {
      debugPrint('[DeviceTokenSync] Erro ao enviar push p/ tópico: $e');
    }

    return false;
  }

  // ═══════════════════════════════════════════════════════════════
  //  INTERNALS
  // ═══════════════════════════════════════════════════════════════

  static String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }

  static Map<String, String> _headers(String jwt) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      };

  /// `POST /api/v1/devices/token` com retry exponencial.
  static Future<void> _registrarToken(String fcmToken) async {
    final jwt = _jwtToken;
    if (jwt == null) {
      debugPrint('[DeviceTokenSync] JWT ausente — ignorando envio do token ao backend.');
      return;
    }

    int tentativa = 0;
    debugPrint(
      '[DeviceTokenSync] Sincronizando token FCM com o backend ($_apiBase/devices/token) na plataforma $_platform...',
    );

    while (tentativa < _maxRetries) {
      try {
        debugPrint(
          '[DeviceTokenSync] Tentativa ${tentativa + 1}/$_maxRetries de registro do token...',
        );
        final response = await http
            .post(
              Uri.parse('$_apiBase/devices/token'),
              headers: _headers(jwt),
              body: jsonEncode({
                'fcmToken': fcmToken,
                'deviceInfo': _platform,
              }),
            )
            .timeout(_timeout);

        if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
          debugPrint('[DeviceTokenSync] Token FCM sincronizado com sucesso no backend.');
          return;
        }

        if (response.statusCode == 401 || response.statusCode == 403) {
          debugPrint(
            '[DeviceTokenSync] Falha de autenticação (${response.statusCode}): JWT inválido ou expirado. Cancelando retentativas.',
          );
          return;
        }

        debugPrint(
          '[DeviceTokenSync] Backend retornou ${response.statusCode} '
          '— tentativa ${tentativa + 1}/$_maxRetries. Body: ${response.body}',
        );
      } catch (e) {
        debugPrint(
          '[DeviceTokenSync] Erro de rede '
          '— tentativa ${tentativa + 1}/$_maxRetries: $e',
        );
      }

      tentativa++;
      if (tentativa < _maxRetries) {
        final delaySegundos = 1 << tentativa;
        debugPrint('[DeviceTokenSync] Aguardando $delaySegundos s antes da próxima tentativa...');
        await Future.delayed(Duration(seconds: delaySegundos));
      }
    }

    debugPrint('[DeviceTokenSync] Falha no registro do token após $_maxRetries tentativas.');
  }
}
