import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/api/faret_control_api.dart';

/// Captura de un control operativo FARET: recibe el contexto ya elegido en
/// `FaretHomePage` (área, operador, máquina, inspector, defectos disponibles
/// del área) y guarda un registro nuevo vía `POST /api/registros-control`
/// (+ evidencia opcional). Sin clases de modelo nuevas — mismo patrón que el
/// resto de FARET (`Map<String, dynamic>`).
///
/// Proceso queda fuera de este formulario por ahora (se retoma en una
/// actualización futura) — el backend ya acepta `procesoId` como opcional.
class FaretControlFormPage extends StatefulWidget {
  final Map<String, dynamic> area;
  final Map<String, dynamic> operador;
  final Map<String, dynamic> maquina;
  final Map<String, dynamic> inspector;
  final List<Map<String, dynamic>> defectosDisponibles;

  const FaretControlFormPage({
    super.key,
    required this.area,
    required this.operador,
    required this.maquina,
    required this.inspector,
    required this.defectosDisponibles,
  });

  @override
  State<FaretControlFormPage> createState() => _FaretControlFormPageState();
}

class _FaretControlFormPageState extends State<FaretControlFormPage> {
  final FaretControlApi _controlApi = FaretControlApi();
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _nvFaretController = TextEditingController();
  final TextEditingController _numeroPliegoController =
      TextEditingController();
  final TextEditingController _numeroItemController = TextEditingController();
  final TextEditingController _pliegoControlController =
      TextEditingController();
  final TextEditingController _numeroPasadaController =
      TextEditingController();
  final TextEditingController _accionCorrectivaController =
      TextEditingController();
  final TextEditingController _observacionesController =
      TextEditingController();
  final Map<int, TextEditingController> _comentarioPorDefecto = {};

  bool _presentaDefecto = false;
  final Set<int> _selectedDefectoIds = {};

  Uint8List? _selectedAttachmentBytes;
  String? _selectedAttachmentName;

  bool _guardando = false;

  @override
  void dispose() {
    _nvFaretController.dispose();
    _numeroPliegoController.dispose();
    _numeroItemController.dispose();
    _pliegoControlController.dispose();
    _numeroPasadaController.dispose();
    _accionCorrectivaController.dispose();
    _observacionesController.dispose();
    for (final c in _comentarioPorDefecto.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _comentarioController(int defectoId) =>
      _comentarioPorDefecto.putIfAbsent(defectoId, () => TextEditingController());

  void _toggleDefecto(int defectoId) {
    setState(() {
      if (_selectedDefectoIds.contains(defectoId)) {
        _selectedDefectoIds.remove(defectoId);
      } else {
        _selectedDefectoIds.add(defectoId);
      }
    });
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
    );

    if (photo == null) return;

    final bytes = await photo.readAsBytes();

    setState(() {
      _selectedAttachmentBytes = bytes;
      _selectedAttachmentName = photo.name;
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) return;

    setState(() {
      _selectedAttachmentBytes = result.files.single.bytes;
      _selectedAttachmentName = result.files.single.name;
    });
  }

  void _removeAttachment() {
    setState(() {
      _selectedAttachmentBytes = null;
      _selectedAttachmentName = null;
    });
  }

  Future<void> _guardar() async {
    if (_presentaDefecto && _selectedDefectoIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar al menos un defecto'),
        ),
      );
      return;
    }

    setState(() => _guardando = true);

    final payload = {
      'areaId': int.parse(widget.area['id'].toString()),
      'operadorId': int.parse(widget.operador['id'].toString()),
      'maquinaId': int.parse(widget.maquina['id'].toString()),
      'inspectorId': int.parse(widget.inspector['id'].toString()),
      'nvFaret': _nvFaretController.text.trim().isEmpty
          ? null
          : _nvFaretController.text.trim(),
      'numeroPliego': int.tryParse(_numeroPliegoController.text.trim()),
      'numeroItem': _numeroItemController.text.trim().isEmpty
          ? null
          : _numeroItemController.text.trim(),
      'pliegoControl': int.tryParse(_pliegoControlController.text.trim()),
      'presentaDefecto': _presentaDefecto,
      'numeroPasada': int.tryParse(_numeroPasadaController.text.trim()),
      'accionCorrectiva': _accionCorrectivaController.text.trim().isEmpty
          ? null
          : _accionCorrectivaController.text.trim(),
      'observaciones': _observacionesController.text.trim().isEmpty
          ? null
          : _observacionesController.text.trim(),
      'defectos': _presentaDefecto
          ? _selectedDefectoIds
              .map(
                (id) => {
                  'defectoId': id,
                  'comentario': _comentarioController(id).text.trim().isEmpty
                      ? null
                      : _comentarioController(id).text.trim(),
                },
              )
              .toList()
          : [],
    };

    try {
      final registro = await _controlApi.guardarRegistro(payload);

      if (_selectedAttachmentBytes != null) {
        final registroId = int.parse(registro['id'].toString());
        await _controlApi.subirEvidencia(
          registroId: registroId,
          bytes: _selectedAttachmentBytes!,
          nombreArchivo: _selectedAttachmentName ?? 'evidencia',
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Control FARET guardado correctamente')),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (error) {
      if (!mounted) return;

      setState(() => _guardando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo guardar: ${error.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17212B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2A33),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Control FARET'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.maquina['nombre'].toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.area['nombre'].toString(),
                          style: const TextStyle(color: Color(0xFFB0BEC5)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Operador: ${widget.operador['nombre']}',
                          style: const TextStyle(color: Color(0xFFCFD8DC)),
                        ),
                        Text(
                          'Inspector: ${widget.inspector['nombre']}',
                          style: const TextStyle(color: Color(0xFFCFD8DC)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField(_nvFaretController, 'NV Faret'),
                        const SizedBox(height: 12),
                        _buildTextField(
                          _numeroPliegoController,
                          'N° Pliego',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(_numeroItemController, 'N° Item'),
                        const SizedBox(height: 12),
                        _buildTextField(
                          _pliegoControlController,
                          'Pliego control',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          _numeroPasadaController,
                          'N° Pasada',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeColor: const Color(0xFF8BC34A),
                          title: const Text(
                            'Presenta defecto',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          value: _presentaDefecto,
                          onChanged: (value) {
                            setState(() {
                              _presentaDefecto = value;
                              if (!value) _selectedDefectoIds.clear();
                            });
                          },
                        ),
                        if (_presentaDefecto) ...[
                          const SizedBox(height: 8),
                          if (widget.defectosDisponibles.isEmpty)
                            const Text(
                              'No hay defectos configurados para esta área.',
                              style: TextStyle(color: Color(0xFFFFCC80)),
                            )
                          else
                            for (final defecto in widget.defectosDisponibles)
                              _buildDefectoTile(defecto),
                          const SizedBox(height: 12),
                          _buildTextField(
                            _accionCorrectivaController,
                            'Acción correctiva',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    child: _buildTextField(
                      _observacionesController,
                      'Observaciones',
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Evidencia opcional',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _takePhoto,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Tomar foto'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF8BC34A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: _pickFile,
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Seleccionar archivo'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFF8BC34A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        if (_selectedAttachmentName != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Archivo: $_selectedAttachmentName',
                            style: const TextStyle(
                              color: Color(0xFFCFD8DC),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _removeAttachment,
                            icon: const Icon(Icons.close),
                            label: const Text('Quitar archivo'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFFFCC80),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 64,
                    child: ElevatedButton(
                      onPressed: _guardando ? null : _guardar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BC34A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _guardando
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'GUARDAR CONTROL',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFB0BEC5)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF546E7A)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8BC34A)),
        ),
      ),
    );
  }

  Widget _buildDefectoTile(Map<String, dynamic> defecto) {
    final defectoId = int.parse(defecto['id'].toString());
    final selected = _selectedDefectoIds.contains(defectoId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            activeColor: const Color(0xFF8BC34A),
            checkColor: Colors.white,
            side: const BorderSide(color: Colors.white, width: 2),
            title: Text(
              defecto['nombre'].toString(),
              style: const TextStyle(color: Colors.white),
            ),
            value: selected,
            onChanged: (_) => _toggleDefecto(defectoId),
          ),
          if (selected)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: _buildTextField(
                _comentarioController(defectoId),
                'Comentario (opcional)',
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F2A33).withOpacity(0.90),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.white.withOpacity(0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}
