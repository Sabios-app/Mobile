import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _jwtKey = 'jwt_token';

  /// Salva o JWT recebido no storage seguro.
  static Future<void> saveToken(String token) async {
    debugPrint('[SessionService] Salvando JWT localmente...');
    try {
      await _storage.write(key: _jwtKey, value: token);
    } catch (e) {
      debugPrint(e.toString());
    }
    debugPrint('[SessionService] JWT salvo com sucesso.');
  }

  /// Retorna o JWT salvo se existir e não estiver expirado.
  /// Se expirado ou inválido, limpa o token e retorna null.
  static Future<String?> getValidToken() async {
    try {
      final token = await _storage.read(key: _jwtKey);
      if (token == null || token.isEmpty) {
        debugPrint('[SessionService] Nenhum JWT salvo encontrado.');
        return null;
      }

      if (isTokenExpired(token)) {
        debugPrint('[SessionService] JWT salvo está expirado. Removendo...');
        await clearToken();
        return null;
      }

      debugPrint('[SessionService] JWT válido recuperado do storage.');
      return token;
    } catch (e) {
      debugPrint('[SessionService] Erro ao ler token do storage: $e');
      return null;
    }
  }

  /// Remove o token do storage.
  static Future<void> clearToken() async {
    debugPrint('[SessionService] Apagando JWT local...');
    try {
      await _storage.delete(key: _jwtKey);
      debugPrint('[SessionService] JWT local apagado.');
    } catch (e) {
      debugPrint('[SessionService] Aviso: erro ao apagar token do storage: $e');
    }
  }

  /// Verifica se o token JWT está expirado com base no claim 'exp'.
  static bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        // Se não for um formato JWT padrão (ex: token mock de teste), não consideramos expirado por tempo.
        return false;
      }

      final payload = _decodeBase64(parts[1]);
      final payloadMap = jsonDecode(payload);

      if (payloadMap is! Map<String, dynamic> || !payloadMap.containsKey('exp')) {
        return false;
      }

      final exp = payloadMap['exp'];
      if (exp is! num) return false;

      final expDate = DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000);
      // Margem de segurança de 30 segundos
      return DateTime.now().isAfter(expDate.subtract(const Duration(seconds: 30)));
    } catch (e) {
      debugPrint('[SessionService] Erro ao verificar expiração do token: $e');
      return true;
    }
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('String base64url inválida!');
    }
    return utf8.decode(base64Url.decode(output));
  }
}
