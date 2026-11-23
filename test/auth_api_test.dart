import 'dart:convert';

import 'package:cv_flutter_david/services/api_exception.dart';
import 'package:cv_flutter_david/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await ApiService.clearToken();
  });

  test('login sends credentials and persists the server JWT', () async {
    late http.Request request;
    final api = ApiService(
      client: MockClient((incoming) async {
        request = incoming;
        return http.Response(
          jsonEncode({
            'token': 'test-token',
            'user': {'id': 1, 'email': 'david@example.com'},
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    addTearDown(api.close);
    addTearDown(ApiService.clearToken);

    await api.login('david@example.com', 'mot-de-passe-solide');

    expect(request.url.path, '/api/auth/login');
    expect(jsonDecode(request.body), {
      'email': 'david@example.com',
      'password': 'mot-de-passe-solide',
    });
    expect(await api.getToken(), 'test-token');
    expect(
      (await SharedPreferences.getInstance()).getString('cv_flutter_david.jwt'),
      'test-token',
    );
  });

  test('registration reports server-side conflicts', () async {
    late http.Request request;
    final api = ApiService(
      client: MockClient((incoming) async {
        request = incoming;
        return http.Response(
          jsonEncode({'error': 'Cette adresse e-mail est déjà inscrite.'}),
          409,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    addTearDown(api.close);

    await expectLater(
      api.register('david@example.com', 'mot-de-passe-solide'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          'Cette adresse e-mail est déjà inscrite.',
        ),
      ),
    );
    expect(request.url.path, '/api/auth/register');
  });
}
