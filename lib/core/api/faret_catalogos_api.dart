import 'faret_api_client.dart';

/// Catálogos de la API FARET (`api/catalogos`): áreas, operadores, máquinas,
/// defectos e inspectores. Los operadores/máquinas/defectos dependen de un
/// área (`areaId`), igual como exige `RegistrosService` en el backend.
class FaretCatalogosApi {
  final FaretApiClient _client = FaretApiClient();

  Future<List<Map<String, dynamic>>> obtenerAreas() async {
    final response = await _client.get('/api/catalogos/areas');
    return _extraerLista(response, 'áreas');
  }

  Future<List<Map<String, dynamic>>> obtenerProcesos() async {
    final response = await _client.get('/api/catalogos/procesos');
    return _extraerLista(response, 'procesos');
  }

  Future<List<Map<String, dynamic>>> obtenerOperadores(int areaId) async {
    final response = await _client.get(
      '/api/catalogos/operadores?areaId=$areaId',
    );
    return _extraerLista(response, 'operadores');
  }

  Future<List<Map<String, dynamic>>> obtenerMaquinas(int areaId) async {
    final response = await _client.get(
      '/api/catalogos/maquinas?areaId=$areaId',
    );
    return _extraerLista(response, 'máquinas');
  }

  Future<List<Map<String, dynamic>>> obtenerDefectos(int areaId) async {
    final response = await _client.get(
      '/api/catalogos/defectos?areaId=$areaId',
    );
    return _extraerLista(response, 'defectos');
  }

  Future<List<Map<String, dynamic>>> obtenerInspectores() async {
    final response = await _client.get('/api/catalogos/inspectores');
    return _extraerLista(response, 'inspectores');
  }

  List<Map<String, dynamic>> _extraerLista(
    Map<String, dynamic> response,
    String nombreCatalogo,
  ) {
    if (response['success'] == true && response['data'] is List) {
      return List<Map<String, dynamic>>.from(response['data']);
    }

    throw Exception(
      response['message']?.toString() ??
          'Respuesta inválida al obtener $nombreCatalogo',
    );
  }
}
