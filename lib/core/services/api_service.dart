import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _keyToken = 'sabios_token';
  static const String _keyUser = 'sabios_user';

  // Configuração automática de host:
  // - Emulador Android: 10.0.2.2
  // - iOS / Desktop / Web: localhost
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8080/api/v1';
    if (Platform.isAndroid) return 'http://10.0.2.2:8080/api/v1';
    return 'http://localhost:8080/api/v1';
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> saveSession(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUser, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyUser);
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
  }

  static Future<Map<String, String>> _headers() async {
    final token = await getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // --- Auth ---
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;
      await saveSession(token, user);
      return data;
    } else {
      final error = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(error['message'] ?? 'Falha ao autenticar.');
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role.toUpperCase(),
        'phone': phone,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final token = data['token'] as String;
      final user = data['user'] as Map<String, dynamic>;
      await saveSession(token, user);
      return data;
    } else {
      final error = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(error['message'] ?? 'Falha ao cadastrar.');
    }
  }

  // --- Specialists ---
  static Future<List<dynamic>> listSpecialists({String? search, String? specialty}) async {
    final queryParams = <String, String>{'page': '0', 'size': '20'};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (specialty != null && specialty.isNotEmpty) queryParams['specialty'] = specialty;

    final url = Uri.parse('$baseUrl/specialists').replace(queryParameters: queryParams);
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['content'] as List<dynamic>;
    }
    return [];
  }

  // --- Mentorings ---
  static Future<Map<String, dynamic>?> getNextMentoring() async {
    final url = Uri.parse('$baseUrl/mentorings/next');
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<List<dynamic>> listMyMentorings() async {
    final url = Uri.parse('$baseUrl/mentorings');
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    }
    return [];
  }

  // --- Action Plans ---
  static Future<List<dynamic>> listActionPlans() async {
    final url = Uri.parse('$baseUrl/action-plans');
    final response = await http.get(url, headers: await _headers());

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    }
    return [];
  }

  static Future<void> toggleActionPlan(int id) async {
    final url = Uri.parse('$baseUrl/action-plans/$id/toggle');
    await http.patch(url, headers: await _headers());
  }

  static Future<Map<String, dynamic>> createActionPlan({
    required String title,
    String? deadline,
    String? conselheiroNome,
  }) async {
    final url = Uri.parse('$baseUrl/action-plans');
    final response = await http.post(
      url,
      headers: await _headers(),
      body: jsonEncode({
        'title': title,
        'deadline': deadline ?? DateTime.now().toIso8601String(),
        'conselheiroNome': conselheiroNome ?? 'Anotação própria',
      }),
    );
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}
