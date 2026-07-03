import 'dart:convert';

import 'package:http/http.dart' as http;

import '../empresa/empresa_session.dart';
import 'faret_api_client.dart';

/// Registro de control de calidad FARET (`api/registros-control`).
class FaretControlApi {
  final FaretApiClient _client = FaretApiClient();

  /// Crea un registro. `payload` debe calzar con `RegistroControlRequest`
  /// del backend (AreaId, OperadorId, MaquinaId, PresentaDefecto, etc.).
  /// Devuelve el `RegistroControlDetalleDto` creado (incluye `Id`).
  Future<Map<String, dynamic>> guardarRegistro(
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post('/api/registros-control', payload);

    if (response['success'] == true && response['data'] is Map<String, dynamic>) {
      return response['data'];
    }

    throw Exception(
      response['message']?.toString() ?? 'Respuesta inválida al guardar registro',
    );
  }

  /// Sube una evidencia (foto) para un registro ya creado. `bytes` viene del
  /// picker (mobile o web), sin depender de `dart:io File` para que funcione
  /// también en Flutter Web.
  Future<Map<String, dynamic>> subirEvidencia({
    required int registroId,
    required List<int> bytes,
    required String nombreArchivo,
  }) async {
    final uri = Uri.parse(
      '${FaretApiClient.baseUrl}/api/registros-control/$registroId/evidencias',
    );

    final request = http.MultipartRequest('POST', uri);

    final token = EmpresaSession.faretToken;
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(
      http.MultipartFile.fromBytes('archivo', bytes, filename: nombreArchivo),
    );

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (responseBody.isEmpty) {
      throw Exception('Respuesta vacía al subir evidencia');
    }

    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Respuesta inválida al subir evidencia');
    }

    if (decoded['success'] == true && decoded['data'] is Map<String, dynamic>) {
      return decoded['data'];
    }

    throw Exception(
      decoded['message']?.toString() ?? 'No se pudo subir la evidencia',
    );
  }
}
