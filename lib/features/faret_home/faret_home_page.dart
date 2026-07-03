import 'package:flutter/material.dart';

import '../../core/api/faret_catalogos_api.dart';
import '../../core/empresa/empresa_session.dart';
import '../empresa_selector/empresa_selector_page.dart';
import 'faret_control_form_page.dart';

/// Home FARET: selección Área → Operador/Máquina/Defectos (dependientes del
/// área) + Inspector (independiente) (sin escáner QR, a diferencia de
/// INNPACK — la API FARET no tiene contexto por QR, se eligen directo de
/// catálogo). Mismo patrón visual que `HomePage` de INNPACK.
///
/// Proceso queda deliberadamente fuera de este flujo por ahora (se agregará
/// en una actualización futura) — el backend ya soporta `procesoId` como
/// opcional en `POST /api/registros-control`, solo no se pide en esta UI.
class FaretHomePage extends StatefulWidget {
  const FaretHomePage({super.key});

  @override
  State<FaretHomePage> createState() => _FaretHomePageState();
}

class _FaretHomePageState extends State<FaretHomePage> {
  final FaretCatalogosApi _catalogosApi = FaretCatalogosApi();

  List<Map<String, dynamic>> _areas = [];
  List<Map<String, dynamic>> _operadores = [];
  List<Map<String, dynamic>> _maquinas = [];
  List<Map<String, dynamic>> _defectos = [];
  List<Map<String, dynamic>> _inspectores = [];

  Map<String, dynamic>? _selectedArea;
  Map<String, dynamic>? _selectedOperador;
  Map<String, dynamic>? _selectedMaquina;
  Map<String, dynamic>? _selectedInspector;

  bool _loadingAreas = true;
  bool _loadingInspectores = true;
  bool _loadingDependientes = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    _loadAreas();
    _loadInspectores();
  }

  Future<void> _loadAreas() async {
    setState(() {
      _loadingAreas = true;
      _error = null;
    });

    try {
      final areas = await _catalogosApi.obtenerAreas();

      if (!mounted) return;

      setState(() {
        _areas = areas;
        _loadingAreas = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loadingAreas = false;
        _error = 'No se pudo cargar áreas: $error';
      });
    }
  }

  Future<void> _loadInspectores() async {
    setState(() {
      _loadingInspectores = true;
    });

    try {
      final inspectores = await _catalogosApi.obtenerInspectores();

      if (!mounted) return;

      setState(() {
        _inspectores = inspectores;
        _loadingInspectores = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loadingInspectores = false;
        _error = 'No se pudo cargar inspectores: $error';
      });
    }
  }

  Future<void> _onAreaSelected(Map<String, dynamic>? area) async {
    setState(() {
      _selectedArea = area;
      _selectedOperador = null;
      _selectedMaquina = null;
      _operadores = [];
      _maquinas = [];
      _defectos = [];
    });

    if (area == null) return;

    setState(() {
      _loadingDependientes = true;
      _error = null;
    });

    try {
      final areaId = int.parse(area['id'].toString());

      final operadores = await _catalogosApi.obtenerOperadores(areaId);
      final maquinas = await _catalogosApi.obtenerMaquinas(areaId);
      final defectos = await _catalogosApi.obtenerDefectos(areaId);

      if (!mounted) return;

      setState(() {
        _operadores = operadores;
        _maquinas = maquinas;
        _defectos = defectos;
        _loadingDependientes = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loadingDependientes = false;
        _error = 'No se pudo cargar operadores/máquinas/defectos: $error';
      });
    }
  }

  void _continuar() {
    if (_selectedArea == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar área')),
      );
      return;
    }

    if (_selectedOperador == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar operador')),
      );
      return;
    }

    if (_selectedMaquina == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar máquina')),
      );
      return;
    }

    if (_selectedInspector == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar inspector')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FaretControlFormPage(
          area: _selectedArea!,
          operador: _selectedOperador!,
          maquina: _selectedMaquina!,
          inspector: _selectedInspector!,
          defectosDisponibles: _defectos,
        ),
      ),
    );
  }

  void _salir() {
    EmpresaSession.limpiar();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const EmpresaSelectorPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nombre = EmpresaSession.faretNombreUsuario ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF17212B),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.72),
                Colors.black.withOpacity(0.60),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: 360,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2A33).withOpacity(0.88),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 64,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.verified_outlined,
                              size: 56,
                              color: Color(0xFF607D8B),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Control de Calidad FARET',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Hola, $nombre',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFB0BEC5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 28),
                      if (_error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935).withOpacity(0.16),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE53935)),
                          ),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Color(0xFFFFCDD2),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      const Text(
                        'Área',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB0BEC5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _loadingAreas
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF8BC34A),
                                ),
                              ),
                            )
                          : DropdownButtonFormField<Map<String, dynamic>>(
                              value: _selectedArea,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFEEF3F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF8FA3AD),
                                  ),
                                ),
                              ),
                              items: _areas
                                  .map(
                                    (area) => DropdownMenuItem(
                                      value: area,
                                      child: Text(area['nombre'].toString()),
                                    ),
                                  )
                                  .toList(),
                              onChanged: _onAreaSelected,
                            ),
                      const SizedBox(height: 16),
                      Text(
                        _loadingInspectores
                            ? 'Cargando inspectores...'
                            : 'Inspector',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB0BEC5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<Map<String, dynamic>>(
                        value: _selectedInspector,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEEF3F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF8FA3AD),
                            ),
                          ),
                        ),
                        items: _inspectores
                            .map(
                              (inspector) => DropdownMenuItem(
                                value: inspector,
                                child: Text(inspector['nombre'].toString()),
                              ),
                            )
                            .toList(),
                        onChanged: _loadingInspectores
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedInspector = value;
                                });
                              },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _loadingDependientes ? 'Cargando operadores...' : 'Operador',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB0BEC5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<Map<String, dynamic>>(
                        value: _selectedOperador,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEEF3F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF8FA3AD),
                            ),
                          ),
                        ),
                        items: _operadores
                            .map(
                              (operador) => DropdownMenuItem(
                                value: operador,
                                child: Text(operador['nombre'].toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (_selectedArea == null || _loadingDependientes)
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedOperador = value;
                                });
                              },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _loadingDependientes ? 'Cargando máquinas...' : 'Máquina',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB0BEC5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<Map<String, dynamic>>(
                        value: _selectedMaquina,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFEEF3F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFF8FA3AD),
                            ),
                          ),
                        ),
                        items: _maquinas
                            .map(
                              (maquina) => DropdownMenuItem(
                                value: maquina,
                                child: Text(maquina['nombre'].toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (_selectedArea == null || _loadingDependientes)
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedMaquina = value;
                                });
                              },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _continuar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'CONTINUAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _salir,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF607D8B)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Salir'),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
