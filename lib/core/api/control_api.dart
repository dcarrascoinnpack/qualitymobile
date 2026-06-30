import 'api_client.dart';
import '../local/offline_catalog_store.dart';

class ControlApi {
  final ApiClient _apiClient = ApiClient();
  final OfflineCatalogStore _offlineCatalogStore = OfflineCatalogStore();

  Future<Map<String, dynamic>> obtenerContextoPorQr(String codigoQr) async {
    final response = await _apiClient.get('/control/contexto/$codigoQr');

    if (response is Map<String, dynamic> &&
        response['data'] is Map<String, dynamic>) {
      return response['data'];
    }

    throw Exception('Respuesta inválida al obtener contexto QR');
  }

  Future<void> descargarCatalogoOffline() async {
    final response = await _apiClient.get(
      '/catalogos/offline',
    );

    if (response is Map<String, dynamic> &&
        response['data'] is Map<String, dynamic>) {
      await _offlineCatalogStore.saveCatalog(
        response['data'],
      );

      return;
    }

    throw Exception(
      'Respuesta inválida al descargar catálogo offline',
    );
  }

  Future<Map<String, dynamic>> guardarRegistro(
    Map<String, dynamic> payload,
  ) async {
    final response = await _apiClient.post(
      '/control/registros',
      payload,
    );

    if (response is Map<String, dynamic> && response['ok'] == true) {
      return response;
    }

    throw Exception('Respuesta inválida al guardar registro');
  }
}
