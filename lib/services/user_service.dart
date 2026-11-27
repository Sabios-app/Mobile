import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/user_model.dart';

class UserService {
  static UserModel? _currentUser;
  static Future<UserModel?>? _inFlightRequest;

  static UserModel? get currentUser => _currentUser;

  static Future<UserModel?> getMe({bool forceRefresh = false}) async {
    if (!forceRefresh && _currentUser != null) {
      return _currentUser;
    }

    if (!forceRefresh && _inFlightRequest != null) {
      return _inFlightRequest!;
    }

    final future = _fetchMe();
    if (!forceRefresh) {
      _inFlightRequest = future;
    }

    try {
      return await future;
    } finally {
      if (identical(_inFlightRequest, future)) {
        _inFlightRequest = null;
      }
    }
  }

  static Future<UserModel?> _fetchMe() async {
    try {
      final data = await ApiClient.get(ApiEndpoints.userMe);
      if (data is Map<String, dynamic>) {
        _currentUser = UserModel.fromJson(data);
        return _currentUser;
      }
    } catch (e) {
      // Retorna nulo se houver falha de rede/auth
    }
    return null;
  }

  static void clearUser() {
    _currentUser = null;
    _inFlightRequest = null;
  }
}