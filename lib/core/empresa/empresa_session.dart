enum Empresa { innpack, faret }

/// Estado en memoria de la empresa activa y la sesión FARET.
///
/// Sin persistencia a propósito: hoy INNPACK tampoco conserva sesión entre
/// aperturas de la app, así que FARET replica el mismo comportamiento.
class EmpresaSession {
  static Empresa? empresa;

  static String? faretToken;
  static String? faretNombreUsuario;
  static String? faretRol;

  static void iniciarFaret({
    required String token,
    required String nombreUsuario,
    required String rol,
  }) {
    empresa = Empresa.faret;
    faretToken = token;
    faretNombreUsuario = nombreUsuario;
    faretRol = rol;
  }

  static void limpiar() {
    empresa = null;
    faretToken = null;
    faretNombreUsuario = null;
    faretRol = null;
  }
}
