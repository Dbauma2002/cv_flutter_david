import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/family_member.dart';
import 'api_config.dart';
import 'api_exception.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _tokenKey = 'cv_flutter_david.jwt';
  static String? _tokenCache;
  final http.Client _client;

  static Future<String?> loadToken() async {
    _tokenCache ??= (await SharedPreferences.getInstance()).getString(
      _tokenKey,
    );
    return _tokenCache;
  }

  Future<String?> getToken() => loadToken();

  static Future<void> clearToken() async {
    _tokenCache = null;
    await (await SharedPreferences.getInstance()).remove(_tokenKey);
  }

  Future<Map<String, String>> headers() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      throw const ApiException('Veuillez vous connecter à nouveau.');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<void> register(String email, String password) async {
    final response = await _client
        .post(
          ApiConfig.endpoint('auth/register'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 15));
    decodeApiResponse(response);
  }

  Future<void> login(String email, String password) async {
    final response = await _client
        .post(
          ApiConfig.endpoint('auth/login'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(const Duration(seconds: 15));

    final body = decodeApiResponse(response);
    final token = body is Map<String, dynamic>
        ? body['token'] ?? body['access_token']
        : null;
    if (token is! String || token.isEmpty) {
      throw const ApiException('Le serveur n’a pas confirmé la connexion.');
    }
    _tokenCache = token;
    await (await SharedPreferences.getInstance()).setString(_tokenKey, token);
  }

  Future<List<FamilyMember>> getFamille() async {
    final response = await _client
        .get(ApiConfig.endpoint('famille'), headers: await headers())
        .timeout(const Duration(seconds: 15));
    final body = decodeApiResponse(response);
    if (body is! List) {
      throw const ApiException('La liste des membres reçue est invalide.');
    }
    return body.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const ApiException('Un membre reçu est invalide.');
      }
      return FamilyMember.fromJson(item);
    }).toList();
  }

  Future<FamilyMember> addFamille(FamilyMember member) async {
    final response = await _client
        .post(
          ApiConfig.endpoint('famille'),
          headers: await headers(),
          body: jsonEncode(member.toJson()),
        )
        .timeout(const Duration(seconds: 15));
    return _memberFromResponse(response);
  }

  Future<FamilyMember> updateFamille(FamilyMember member) async {
    final id = member.id;
    if (id == null) {
      throw const ApiException(
        'Impossible de modifier ce membre sans identifiant.',
      );
    }
    final response = await _client
        .put(
          ApiConfig.endpoint('famille/$id'),
          headers: await headers(),
          body: jsonEncode(member.toJson()),
        )
        .timeout(const Duration(seconds: 15));
    return _memberFromResponse(response);
  }

  Future<void> deleteFamille(String id) async {
    final response = await _client
        .delete(ApiConfig.endpoint('famille/$id'), headers: await headers())
        .timeout(const Duration(seconds: 15));
    decodeApiResponse(response);
  }

  FamilyMember _memberFromResponse(http.Response response) {
    final body = decodeApiResponse(response);
    if (body is! Map<String, dynamic>) {
      throw const ApiException('Le membre reçu du serveur est invalide.');
    }
    return FamilyMember.fromJson(body);
  }

  void close() => _client.close();
}
