import 'api_client.dart';

class CatalogosApi {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> obtenerCatalogoOffline() async {
    final response = await _apiClient.get('/catalogos/offline');

    if (response is Map<String, dynamic>) {
      return Map<String, dynamic>.from(response['data']);
    }

    throw Exception('Respuesta inválida catálogo offline');
  }

  Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    final response = await _apiClient.get('/catalogos/usuarios');

    if (response is Map<String, dynamic> && response['data'] is List) {
      return List<Map<String, dynamic>>.from(response['data']);
    }

    throw Exception('Respuesta inválida al obtener usuarios');
  }
}
