import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/notification_model.dart';

class AppNotificationService {
  static Future<List<NotificationModel>> getNotifications({
    bool unreadOnly = false,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await ApiClient.get(
        ApiEndpoints.notifications,
        queryParameters: {
          'unreadOnly': unreadOnly,
          'page': page,
          'size': size,
          'sort': 'createdAt,DESC',
        },
      );

      if (response is Map<String, dynamic> && response['content'] is List) {
        return (response['content'] as List)
            .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response is List) {
        return response
            .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<int> getUnreadCount() async {
    try {
      final response = await ApiClient.get(ApiEndpoints.notificationsUnreadCount);
      if (response is num) return response.toInt();
      if (response is Map<String, dynamic>) {
        if (response.containsKey('count')) return (response['count'] as num).toInt();
        if (response.isNotEmpty) {
          final firstVal = response.values.first;
          if (firstVal is num) return firstVal.toInt();
        }
      }
    } catch (_) {}
    return 0;
  }

  static Future<bool> markAsRead(String id) async {
    try {
      await ApiClient.patch(ApiEndpoints.notificationRead(id));
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> markAllAsRead() async {
    try {
      await ApiClient.patch(ApiEndpoints.notificationsReadAll);
      return true;
    } catch (_) {
      return false;
    }
  }
}
