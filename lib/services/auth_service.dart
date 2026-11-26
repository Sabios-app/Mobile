import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'device_token_sync_service.dart';
import 'notification_service.dart';
import 'session_service.dart';

class AuthService {
  static const String _apiBase = 'https://api-sabios.lmagalhaes.com/api/v1';

  static Future<String?> register({
    required String name,
    required String email,
    required String password,
    String? role,
  }) async {
    final response = await http.post(
      Uri.parse('$_apiBase/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        if (role != null) 'role': role,
      }),
    );

    debugPrint('[AuthService] Register status: ${response.statusCode} | body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final jwt = (json['token'] ?? json['accessToken'])?.toString();
      if (jwt != null && jwt.isNotEmpty) {
        await SessionService.saveToken(jwt);
        await NotificationService.initialize(jwtToken: jwt);
      }
      return jwt;
    }

    throw Exception('Falha no cadastro (${response.statusCode}): ${response.body}');
  }

  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_apiBase/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    debugPrint('[AuthService] Login status: ${response.statusCode} | body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final jwt = (json['token'] ?? json['accessToken'])?.toString();
      if (jwt != null && jwt.isNotEmpty) {
        await SessionService.saveToken(jwt);
        await NotificationService.initialize(jwtToken: jwt);
      }
      return jwt;
    }
    if (response.statusCode == 409) {
      debugPrint('[AuthService] E-mail já cadastrado (409), autenticando via login...');
      return await login(email: email, password: password);
    }
    throw Exception('Falha no login (${response.statusCode}): ${response.body}');
  }

  /// Logout limpo:
  /// 1. Desativa o token FCM no backend via DeviceTokenSyncService.removerToken()
  /// 2. Apaga o JWT salvo localmente no storage seguro
  static Future<void> logout() async {
    debugPrint('[AuthService] Iniciando logout limpo...');
    try {
      await DeviceTokenSyncService.removerToken();
    } catch (e) {
      debugPrint('[AuthService] Erro ao remover token no logout: $e');
    }
    await SessionService.clearToken();
    debugPrint('[AuthService] Logout limpo concluído.');
  }
}