import 'package:flutter/cupertino.dart';

import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/mentoring_model.dart';

class MentoringService {
  static Future<List<MentoringModel>> getMyMentorings() async {
    try {
      final response = await ApiClient.get(ApiEndpoints.mentoringsMe);
      if (response is List) {
        return response
            .map((item) => MentoringModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return [];
      }
    } catch (_) {}
    return [];
  }
  static Future<List<DateTime>> getFreeSlots({
    required String specialistId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      String fmt(DateTime d) =>
          '${d.year.toString().padLeft(4, '0')}-'
              '${d.month.toString().padLeft(2, '0')}-'
              '${d.day.toString().padLeft(2, '0')}';

      final query = '?from=${fmt(from)}&to=${fmt(to)}';
      final response = await ApiClient.get(
        '${ApiEndpoints.specialistSlots(specialistId)}$query',
      );

      if (response is List) {
        return response
            .map((e) => DateTime.tryParse(e.toString())?.toLocal())
            .whereType<DateTime>()
            .toList();
      }
    } catch (_) {}
    return [];
  }
  static String _formatWithBrazilOffset(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');

    return '$y-$m-${d}T$h:$min:$s-03:00';
  }
  static Future<MentoringModel> createMentoring({
    required String specialistId,
    required DateTime scheduledAt,
    required String title,
    String? description,
    String? doubts,
  }) async {
    final body = <String, dynamic>{
      'specialistId': specialistId.trim(),
      'title': title.trim(),
      'scheduledAt': _formatWithBrazilOffset(scheduledAt),
      if (description != null && description.trim().isNotEmpty)
        'description': description.trim(),
      if (doubts != null && doubts.trim().isNotEmpty)
        'doubts': doubts.trim(),
    };

    debugPrint('[MentoringService] POST /mentorings body: $body');

    final response = await ApiClient.post(ApiEndpoints.mentorings, body: body);
    if (response is Map<String, dynamic>) {
      return MentoringModel.fromJson(response);
    }
    throw Exception('Resposta inesperada do servidor ao agendar mentoria.');
  }
  static Future<bool> acceptMentoring(String id) async {
    try {
      await ApiClient.patch(ApiEndpoints.mentoringAccept(id));
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> updateMeetingLink(String id, String link) async {
    try {
      await ApiClient.patch(
        ApiEndpoints.mentoringLink(id),
        body: {'meetingLink': link},
      );
      return true;
    } catch (_) {
      return false;
    }
  }
  static Future<void> rejectMentoring(String mentoringId) async {
    await ApiClient.patch(ApiEndpoints.mentoringReject(mentoringId));
  }
}