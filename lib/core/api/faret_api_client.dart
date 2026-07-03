import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;

import '../empresa/empresa_session.dart';

/// Cliente HTTP para la API FARET (`qualitycontrol`), totalmente separado de
/// [ApiClient] (INNPACK) — misma separación que en el Desktop entre
/// `DbService` y `FaretApiClient`.
class FaretApiClient {
  static const String baseUrl = String.fromEnvironment(
    'FARET_API_BASE_URL',
    defaultValue: 'https://api.faret.cl/qualitycontrol',
  );

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};

    final token = EmpresaSession.faretToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    debugPrint('[FARET][GET] -> $uri');

    final response = await http.get(uri, headers: _headers);

    debugPrint(
      '[FARET][GET] <- $uri status=${response.statusCode} body=${response.body}',
    );

    return _parseBody(response);
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    debugPrint('[FARET][POST] -> $uri');

    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(body),
    );

    debugPrint(
      '[FARET][POST] <- $uri status=${response.statusCode} body=${response.body}',
    );

    return _parseBody(response);
  }

  /// A diferencia de `ApiClient`, no lanza excepción solo por el status:
  /// la API FARET devuelve el motivo real del error en el body
  /// (`{ success: false, message, errors }`) incluso en respuestas no-2xx.
  Map<String, dynamic> _parseBody(http.Response response) {
    if (response.body.isEmpty) {
      throw Exception('Respuesta vacía de la API FARET (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Respuesta inválida de la API FARET (${response.statusCode})');
    }

    return decoded;
  }
}
