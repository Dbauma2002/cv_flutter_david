import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

Object? decodeApiResponse(http.Response response) {
  if (response.statusCode == 204) return null;

  final Object? body;
  try {
    body = jsonDecode(response.body);
  } on FormatException {
    throw ApiException(
      'Réponse invalide du serveur (code ${response.statusCode}).',
    );
  }

  if (response.statusCode < 200 ||
      response.statusCode >= 300 ||
      (body is Map<String, dynamic> && body['success'] == false)) {
    throw ApiException(_errorMessage(body, response.statusCode));
  }

  return body;
}

String _errorMessage(Object? body, int statusCode) {
  if (body is Map<String, dynamic>) {
    final message = body['message'] ?? body['error'] ?? body['detail'];
    if (message is String && message.isNotEmpty) return message;

    if (message is List && message.isNotEmpty && message.first is Map) {
      final detail = (message.first as Map)['msg'];
      if (detail is String && detail.isNotEmpty) return detail;
    }

    final errors = body['errors'];
    if (errors is Map) {
      final messages = errors.values.whereType<String>().toList();
      if (messages.isNotEmpty) return messages.join('\n');
    }

    if (errors is List && errors.isNotEmpty && errors.first is Map) {
      final message = (errors.first as Map)['msg'];
      if (message is String && message.isNotEmpty) return message;
    }
  }

  return 'Le serveur a répondu avec le code $statusCode.';
}
