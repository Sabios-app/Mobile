import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../services/session_service.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic details;

  ApiException({
    required this.statusCode,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  static final http.Client _client = http.Client();

  static Future<Map<String, String>> _headers({bool requiresAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await SessionService.getValidToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static dynamic _handleResponse(http.Response response) {
    debugPrint('[ApiClient] ${response.request?.method} ${response.request?.url} -> ${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return response.body;
      }
    }

    String message = 'Erro desconhecido (${response.statusCode})';
    dynamic details;
    try {
      final decoded = jsonDecode(response.body);
      details = decoded;
      if (decoded is Map<String, dynamic>) {
        message = decoded['message'] ?? decoded['error'] ?? message;
      }
    } catch (_) {
      if (response.body.isNotEmpty) {
        message = response.body;
      }
    }

    if (response.statusCode == 401) {
      debugPrint('[ApiClient] 401 Não autorizado em ${response.request?.url}.');
      // Apenas limpa a sessão se o 401 ocorrer em endpoints vitais ou se não for login
      final path = response.request?.url.path ?? '';
      if (path.contains('/auth/login') || path.contains('/auth/register')) {
        // Não limpa o token em tentativa de login incorreta
      } else if (path.contains('/users/me')) {
        debugPrint('[ApiClient] Token JWT inválido ou revogado. Limpando token...');
        SessionService.clearToken();
      }
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: message,
      details: details,
    );
  }

  static Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    var uri = Uri.parse(url);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final cleanParams = queryParameters
          .where((k, v) => v != null)
          .map((k, v) => MapEntry(k, v.toString()));
      uri = uri.replace(queryParameters: {
        ...uri.queryParameters,
        ...cleanParams,
      });
    }

    final headers = await _headers(requiresAuth: requiresAuth);
    final response = await _client.get(uri, headers: headers);
    return _handleResponse(response);
  }

  static Future<dynamic> post(
    String url, {
    dynamic body,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse(url);
    final headers = await _headers(requiresAuth: requiresAuth);
    final response = await _client.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  static Future<dynamic> patch(
    String url, {
    dynamic body,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse(url);
    final headers = await _headers(requiresAuth: requiresAuth);
    final response = await _client.patch(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  static Future<dynamic> delete(
    String url, {
    dynamic body,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse(url);
    final headers = await _headers(requiresAuth: requiresAuth);
    final response = await _client.delete(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }
}

extension _MapFilterExtension on Map<String, dynamic> {
  Map<String, dynamic> where(bool Function(String key, dynamic value) test) {
    final result = <String, dynamic>{};
    forEach((key, value) {
      if (test(key, value)) result[key] = value;
    });
    return result;
  }
}
