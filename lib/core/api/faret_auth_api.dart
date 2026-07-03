import 'faret_api_client.dart';

/// Login contra la API FARET (`POST api/Auth/login`), mismos usuarios que ya
/// usa el Desktop FARET (BD `qualitycontrolfaret`, sin acceso directo desde
/// la app). Réplica del parseo de `FaretAuthApiService.LoginAsync` (Desktop).
class FaretAuthApi {
  final FaretApiClient _client = FaretApiClient();

  /// Devuelve `{ token, nombre, rol }`. Lanza [Exception] con el mensaje real
  /// de la API en caso de credenciales inválidas u otro error.
  Future<Map<String, dynamic>> login(
    String identificador,
    String password,
  ) async {
    final response = await _client.post('/api/Auth/login', {
      'identificador': identificador,
      'password': password,
    });

    final success = response['success'] == true;
    if (!success) {
      throw Exception(response['message']?.toString() ?? 'Credenciales incorrectas');
    }

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw Exception('Respuesta de login inválida');
    }

    final token = data['token']?.toString();
    if (token == null || token.isEmpty) {
      throw Exception('Token no recibido en la respuesta');
    }

    final usuario = data['usuario'];
    String nombre = '';
    String rol = '';

    if (usuario is Map<String, dynamic>) {
      nombre = usuario['nombre']?.toString() ?? '';

      final roles = usuario['roles'];
      if (roles is List && roles.isNotEmpty) {
        rol = roles.first.toString();
      }
    }

    return {
      'token': token,
      'nombre': nombre,
      'rol': rol,
    };
  }
}
