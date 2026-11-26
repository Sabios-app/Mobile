import 'package:flutter_test/flutter_test.dart';
import 'package:sabios_app/core/services/api_service.dart';

void main() {
  test('ApiService baseUrl retorna rota padrão da API v1', () {
    expect(ApiService.baseUrl, contains('/api/v1'));
  });
}
