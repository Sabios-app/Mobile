import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';

class AgendaSlot {
  final DateTime dateTime;

  AgendaSlot(this.dateTime);

  factory AgendaSlot.fromJson(dynamic json) {
    if (json is String) {
      return AgendaSlot(DateTime.tryParse(json) ?? DateTime.now());
    }
    return AgendaSlot(DateTime.now());
  }
}

class SpecialistAvailability {
  final String id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;

  SpecialistAvailability({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory SpecialistAvailability.fromJson(Map<String, dynamic> json) {
    String formatTime(dynamic timeObj) {
      if (timeObj is String) return timeObj;
      if (timeObj is Map<String, dynamic>) {
        final h = timeObj['hour']?.toString().padLeft(2, '0') ?? '00';
        final m = timeObj['minute']?.toString().padLeft(2, '0') ?? '00';
        return '$h:$m';
      }
      return '00:00';
    }

    return SpecialistAvailability(
      id: json['id']?.toString() ?? '',
      dayOfWeek: json['dayOfWeek']?.toString() ?? 'MONDAY',
      startTime: formatTime(json['startTime']),
      endTime: formatTime(json['endTime']),
    );
  }
}

class AgendaService {
  static bool _isMissingSpecialistProfile(ApiException e) {
    if (e.statusCode != 404) return false;
    final msg = e.message.toLowerCase();
    return msg.contains('especialista') || msg.contains('conselheiro');
  }

  static Future<List<SpecialistAvailability>> getMyAgenda({
    void Function(bool missingProfile)? onProfileStatus,
  }) async {
    try {
      final response = await ApiClient.get(ApiEndpoints.agendaMe);
      onProfileStatus?.call(false);
      if (response is List) {
        return response
            .map((item) => SpecialistAvailability.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } on ApiException catch (e) {
      if (_isMissingSpecialistProfile(e) || e.statusCode == 404) {
        onProfileStatus?.call(true);
        return [];
      }
    } catch (_) {}
    return [];
  }

  static Future<List<DateTime>> getSpecialistSlots({
    required String specialistId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final fromStr = '${from.year}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}';
      final toStr = '${to.year}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}';

      final response = await ApiClient.get(
        ApiEndpoints.specialistSlots(specialistId),
        queryParameters: {
          'from': fromStr,
          'to': toStr,
        },
      );

      if (response is List) {
        return response
            .map((item) => DateTime.tryParse(item.toString()))
            .whereType<DateTime>()
            .toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<bool> addAvailability({
    required String dayOfWeek,
    required String startTime,
    required String endTime,
  }) async {
    try {
      await ApiClient.post(
        ApiEndpoints.agenda,
        body: {
          'dayOfWeek': dayOfWeek,
          'startTime': startTime,
          'endTime': endTime,
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deleteAvailability(String id) async {
    try {
      await ApiClient.delete(ApiEndpoints.agendaDelete(id));
      return true;
    } catch (_) {
      return false;
    }
  }
}