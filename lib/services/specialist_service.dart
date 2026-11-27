import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/specialist_model.dart';

class SpecialistService {
  static Future<List<SpecialistModel>> getSpecialists({
    String? specialty,

    String? search,

    double? minRating,

    double? minPrice,

    double? maxPrice,

    String? availableDay,

    int page = 0,

    int size = 20,

    String? sort,
  }) async {
    final safeSize = size.clamp(1, 50);

    final params = <String, dynamic>{
      if (specialty != null && specialty.isNotEmpty && specialty != 'Todos')
        'specialty': specialty,

      if (search != null && search.isNotEmpty) 'search': search,

      if (minRating != null) 'minRating': minRating,

      if (minPrice != null) 'minPrice': minPrice,

      if (maxPrice != null) 'maxPrice': maxPrice,

      if (availableDay != null) 'availableDay': availableDay,

      'page': page,

      'size': safeSize,

      if (sort != null) 'sort': sort,
    };

    try {
      final response = await ApiClient.get(
        ApiEndpoints.specialists,

        queryParameters: params,
      );

      if (response is Map<String, dynamic> && response['content'] is List) {
        return (response['content'] as List)
            .map(
              (item) => SpecialistModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else if (response is List) {
        return response
            .map(
              (item) => SpecialistModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
    } catch (_) {}

    return [];
  }

  static Future<SpecialistModel?> getSpecialistById(String id) async {
    try {
      final response = await ApiClient.get(ApiEndpoints.specialistById(id));

      if (response is Map<String, dynamic>) {
        return SpecialistModel.fromJson(response);
      }
    } catch (_) {}

    return null;
  }

  static Future<Map<String, dynamic>> createMyProfile({
    required String title,

    required String specialty,

    required String bio,

    required double hourlyRate,
  }) async {
    final response = await ApiClient.post(
      '${ApiEndpoints.specialists}/me',

      body: {
        'title': title.trim(),

        'specialty': specialty.trim(),

        'bio': bio.trim(),

        'hourlyRate': hourlyRate,
      },
    );

    return response is Map<String, dynamic> ? response : <String, dynamic>{};
  }

  static Future<Map<String, dynamic>> updateMyProfile({
    required String title,

    required String specialty,

    required String bio,

    required double hourlyRate,
  }) async {
    final response = await ApiClient.patch(
      '${ApiEndpoints.specialists}/me',

      body: {
        'title': title.trim(),

        'specialty': specialty.trim(),

        'bio': bio.trim(),

        'hourlyRate': hourlyRate,
      },
    );

    return response is Map<String, dynamic> ? response : <String, dynamic>{};
  }

  static Future<bool> hasCounselorProfile() async {
    try {
      await ApiClient.get(ApiEndpoints.agendaMe);

      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return false;
      }

      rethrow;
    }
  }
}
