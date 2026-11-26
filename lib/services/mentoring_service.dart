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

  static Future<MentoringModel?> createMentoring({
    required String specialistId,
    required DateTime scheduledAt,
    String? title,
    String? description,
    String? doubts,
  }) async {
    try {
      final body = {
        'specialistId': specialistId,
        'scheduledAt': scheduledAt.toIso8601String(),
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (doubts != null) 'doubts': doubts,
      };

      final response = await ApiClient.post(ApiEndpoints.mentorings, body: body);
      if (response is Map<String, dynamic>) {
        return MentoringModel.fromJson(response);
      }
    } catch (_) {}
    return null;
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
}