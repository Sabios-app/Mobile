import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/message_model.dart';

class MessageService {
  static bool _isMissingSpecialistProfile(ApiException e) {
    if (e.statusCode != 404) return false;
    final msg = e.message.toLowerCase();
    return msg.contains('especialista') || msg.contains('conselheiro');
  }

  static Future<List<ConversationModel>> getConversations({
    void Function(bool missingProfile)? onProfileStatus,
  }) async {
    try {
      final response = await ApiClient.get(ApiEndpoints.conversations);
      onProfileStatus?.call(false);
      if (response is List) {
        return response
            .map((item) => ConversationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } on ApiException catch (e) {
      if (_isMissingSpecialistProfile(e)) {
        onProfileStatus?.call(true);
        return [];
      }
    } catch (_) {}
    return [];
  }

  static Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    try {
      final response = await ApiClient.get(ApiEndpoints.conversationById(conversationId));
      if (response is List) {
        return response
            .map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<ChatMessageModel?> sendMessage({
    required String specialistId,
    required String content,
  }) async {
    try {
      final response = await ApiClient.post(
        ApiEndpoints.sendMessage,
        body: {
          'specialistId': specialistId,
          'content': content,
        },
      );
      if (response is Map<String, dynamic>) {
        return ChatMessageModel.fromJson(response);
      }
    } catch (_) {}
    return null;
  }
}