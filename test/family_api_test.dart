import 'dart:convert';

import 'package:cv_flutter_david/models/family_member.dart';
import 'package:cv_flutter_david/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final memberJson = {
    'id': '00000000-0000-4000-8000-000000000007',
    'nom': 'Joseph Bauma',
    'lien': 'Père',
    'profession': 'Commerçant',
    'photo_url': null,
  };

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'cv_flutter_david.jwt': 'test-token',
    });
    await ApiService.loadToken();
  });

  test('loads family members with the bearer token', () async {
    late http.Request request;
    final api = ApiService(
      client: MockClient((incoming) async {
        request = incoming;
        return http.Response(jsonEncode([memberJson]), 200);
      }),
    );
    addTearDown(api.close);

    final members = await api.getFamille();

    expect(request.method, 'GET');
    expect(request.url.path, '/api/famille');
    expect(request.headers['authorization'], 'Bearer test-token');
    expect(members.single.name, 'Joseph Bauma');
  });

  test('adds family members using the API field names', () async {
    late http.Request request;
    final api = ApiService(
      client: MockClient((incoming) async {
        request = incoming;
        return http.Response(jsonEncode(memberJson), 201);
      }),
    );
    addTearDown(api.close);

    final created = await api.addFamille(
      const FamilyMember(
        id: null,
        name: 'Joseph Bauma',
        relationship: 'Père',
        profession: 'Commerçant',
      ),
    );

    expect(request.method, 'POST');
    expect(request.url.path, '/api/famille');
    expect(request.headers['authorization'], 'Bearer test-token');
    expect(jsonDecode(request.body), {
      'nom': 'Joseph Bauma',
      'lien': 'Père',
      'profession': 'Commerçant',
      'photo_url': null,
    });
    expect(created.id, '00000000-0000-4000-8000-000000000007');
  });

  test('updates and deletes family members by database id', () async {
    final requests = <http.Request>[];
    final api = ApiService(
      client: MockClient((request) async {
        requests.add(request);
        if (request.method == 'PUT') {
          return http.Response(jsonEncode(memberJson), 200);
        }
        return http.Response('', 204);
      }),
    );
    addTearDown(api.close);
    final member = FamilyMember.fromJson(memberJson);

    await api.updateFamille(member);
    await api.deleteFamille(member.id!);

    expect(requests.map((request) => request.method), ['PUT', 'DELETE']);
    expect(requests.map((request) => request.url.path), [
      '/api/famille/00000000-0000-4000-8000-000000000007',
      '/api/famille/00000000-0000-4000-8000-000000000007',
    ]);
    expect(
      requests.every(
        (request) => request.headers['authorization'] == 'Bearer test-token',
      ),
      isTrue,
    );
  });
}
