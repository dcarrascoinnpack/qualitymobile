import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api/control_api.dart';
import '../../../core/local/pending_records_store.dart';
import '../../../core/network/network_mode_service.dart';
import '../domain/control_context.dart';
import 'product_qr_scanner_page.dart';

class ControlMeasurementsPage extends StatefulWidget {
  final ControlContext controlContext;
  final String np;
  final List<String> selectedFailures;
  final bool visualValidatedWithoutFailures;
  final String observation;

  const ControlMeasurementsPage({
    super.key,
    required this.controlContext,
    required this.np,
    required this.selectedFailures,
    required this.visualValidatedWithoutFailures,
    required this.observation,
  });

  @override
  State<ControlMeasurementsPage> createState() =>
      _ControlMeasurementsPageState();
}

class _ControlMeasurementsPageState extends State<ControlMeasurementsPage> {
  final ControlApi _controlApi = ControlApi();
  final PendingRecordsStore _pendingRecordsStore = PendingRecordsStore();
  final NetworkModeService _networkModeService = NetworkModeService();
  final TextEditingController _wasteQuantityController =
      TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  Uint8List? _selectedAttachmentBytes;
  String? _selectedAttachmentName;

  String? _selectedVisualControlResult;
  final Set<int> _selectedLabTestIds = {};
  final Set<int> _selectedMaterialIds = {};
  String? _selectedAction;
  String? _selectedWasteType;
  String? _selectedTipoOndaId;
  String? _selectedState;
  String? _productCode;
  String? _productDescription;

  bool _hasWaste = false;
  bool _hasLabTest = false;

  final List<String> _visualControlResults = [
    'Cumple',
    'No Cumple',
    'No Aplica',
  ];

  final List<String> _actions = [
    'Ajuste',
    'Segregar',
    'No Liberar',
    'Detener',
  ];

  List<String> get _wasteTypes {
    if (widget.controlContext.processId == 1) {
      return [
        'Insumos - Desponche de bobinas',
        'Proceso - Merma por monotapa',
      ];
    }

    return [
      'Corrugado',
      'Emplacado',
      'Troquelado',
      'Pegado',
      'Termoformado',
      'Producto Terminado',
    ];
  }

  final List<String> _states = [
    'Aprobado',
    'Aprobado con observaciones',
    'Rechazado',
    'Cuarentena',
    'Liberado',
    'Despachado',
  ];
  Future<void> _scanProductCode() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const ProductQrScannerPage(),
      ),
    );

    if (result == null || result.trim().isEmpty) return;

    try {
      final data = jsonDecode(result);

      setState(() {
        _productCode = data['codigo']?.toString();
        _productDescription = data['descripcion']?.toString();
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR de producto no válido')),
      );
    }
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

  Future<void> _saveControl() async {
    if (_selectedVisualControlResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar resultado visual'),
        ),
      );
      return;
    }

    if (_selectedVisualControlResult == 'No Cumple' &&
        _selectedAction == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar acción'),
        ),
      );
      return;
    }

    if (_selectedState == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar estado'),
        ),
      );
      return;
    }
    if (_hasLabTest && _selectedMaterialIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar tipo de material'),
        ),
      );
      return;
    }

    if (_hasLabTest && _selectedLabTestIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar al menos un ensayo'),
        ),
      );
      return;
    }
    if (widget.controlContext.processId == 1 && _selectedTipoOndaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar tipo de onda')),
      );
      return;
    }

    int actionId = 1;

    switch (_selectedAction) {
      case 'Ajuste':
        actionId = 1;
        break;
      case 'Segregar':
        actionId = 2;
        break;
      case 'No Liberar':
        actionId = 3;
        break;
      case 'Detener':
        actionId = 4;
        break;
    }

    final payload = {
      'usuarioId': widget.controlContext.userId,
      'procesoId': widget.controlContext.processId,
      'maquinaId': widget.controlContext.machineId,
      'formularioId': widget.controlContext.formId,
      'area': widget.controlContext.operatorArea,
      'np': widget.np,
      'codigoProducto': _productCode,
      'descripcionProducto': _productDescription,
      'tipoOndaId': widget.controlContext.processId == 1
          ? int.tryParse(_selectedTipoOndaId ?? '')
          : null,
      'turno': 'A',
      'resultadoVisual': _selectedVisualControlResult,
      'observacion': widget.observation,
      'fallasVisuales': widget.selectedFailures
          .map(
            (id) => {
              'parametroId': int.parse(id),
              'accionId': actionId,
              'observacion': widget.observation,
            },
          )
          .toList(),
      'ensayosLaboratorio': _hasLabTest
          ? _selectedLabTestIds
              .expand(
                (ensayoId) => _selectedMaterialIds.map(
                  (materialId) => {
                    'ensayoId': ensayoId,
                    'materialId': materialId,
                    'observacion': null,
                  },
                ),
              )
              .toList()
          : [],
      'tipoMerma': _hasWaste ? _selectedWasteType : null,
      'cantidadMerma':
          _hasWaste ? double.tryParse(_wasteQuantityController.text) : null,
      'mermaInsumosDesponcheBobinas':
          (_hasWaste &&
                  widget.controlContext.processId == 1 &&
                  _selectedWasteType == 'Insumos - Desponche de bobinas')
              ? double.tryParse(_wasteQuantityController.text)
              : null,
      'mermaProcesoMonotapas':
          (_hasWaste &&
                  widget.controlContext.processId == 1 &&
                  _selectedWasteType == 'Proceso - Merma por monotapa')
              ? double.tryParse(_wasteQuantityController.text)
              : null,
    };

    final shouldUseOffline = await _networkModeService.shouldUseOfflineMode();

    if (shouldUseOffline && _selectedAttachmentBytes != null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se puede guardar evidencia sin conexión. Revise conexión e intente nuevamente.',
          ),
        ),
      );

      return;
    }

    if (shouldUseOffline) {
      await _pendingRecordsStore.savePendingRecord(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sin conexión. Registro guardado localmente para sincronizar.',
          ),
        ),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }

    debugPrint('PAYLOAD ENVIADO: ${jsonEncode(payload)}');

    try {
      await _controlApi.guardarRegistro(
        payload,
        archivoBytes: _selectedAttachmentBytes,
        archivoNombre: _selectedAttachmentName,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Control calidad guardado correctamente'),
        ),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (error) {
      if (_selectedAttachmentBytes != null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo guardar con evidencia. Revise conexión e intente nuevamente.',
            ),
          ),
        );

        return;
      }

      await _pendingRecordsStore.savePendingRecord(payload);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sin conexión. Registro guardado localmente para sincronizar.',
          ),
        ),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _wasteQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isCorrugado = widget.controlContext.processId == 1;
    return Scaffold(
      backgroundColor: const Color(0xFF17212B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2A33),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Mediciones y Cierre'),
        centerTitle: true,
      ),
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
                Colors.black.withOpacity(0.74),
                Colors.black.withOpacity(0.62),
              ],
            ),
          ),
          child: SafeArea(
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
                              widget.controlContext.machineName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Proceso: ${widget.controlContext.processName}',
                              style: const TextStyle(
                                color: Color(0xFFCFD8DC),
                              ),
                            ),
                            Text(
                              'NP: ${widget.np}',
                              style: const TextStyle(
                                color: Color(0xFFCFD8DC),
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _scanProductCode,
                              icon: const Icon(Icons.qr_code_scanner),
                              label: const Text('Escanear Código Producto'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                foregroundColor: Colors.white,
                                side:
                                    const BorderSide(color: Color(0xFF8BC34A)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                            if (_productCode != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Código: $_productCode',
                                style: const TextStyle(
                                  color: Color(0xFFCFD8DC),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_productDescription != null)
                                Text(
                                  'Producto: $_productDescription',
                                  style: const TextStyle(
                                    color: Color(0xFFCFD8DC),
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isCorrugado) ...[
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Corrugado',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: _selectedTipoOndaId,
                                dropdownColor: const Color(0xFFEEF3F5),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                selectedItemBuilder: (context) {
                                  return widget.controlContext.tiposOnda
                                      .map((item) {
                                    return Text(
                                      item['nombre'].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }).toList();
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Tipo de onda',
                                  labelStyle: TextStyle(
                                    color: Color(0xFFB0BEC5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF546E7A),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF8BC34A),
                                    ),
                                  ),
                                ),
                                items: widget.controlContext.tiposOnda
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item['id'].toString(),
                                        child: Text(
                                          item['nombre'].toString(),
                                          style: const TextStyle(
                                            color: Color(0xFF263238),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTipoOndaId = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Resultado visual',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _selectedVisualControlResult,
                              dropdownColor: const Color(0xFFEEF3F5),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              selectedItemBuilder: (context) {
                                return _visualControlResults.map((item) {
                                  return Text(
                                    item,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }).toList();
                              },
                              decoration: const InputDecoration(
                                labelText: 'Resultado',
                                labelStyle: TextStyle(
                                  color: Color(0xFFB0BEC5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF546E7A),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF8BC34A),
                                  ),
                                ),
                              ),
                              items: _visualControlResults
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          color: Color(0xFF263238),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedVisualControlResult = value;

                                  if (value != 'No Cumple') {
                                    _selectedAction = null;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Acción',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (_selectedVisualControlResult ==
                                'No Cumple') ...[
                              DropdownButtonFormField<String>(
                                value: _selectedAction,
                                dropdownColor: const Color(0xFFEEF3F5),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                selectedItemBuilder: (context) {
                                  return _actions.map((item) {
                                    return Text(
                                      item,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }).toList();
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Acción',
                                  labelStyle: TextStyle(
                                    color: Color(0xFFB0BEC5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF546E7A),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF8BC34A),
                                    ),
                                  ),
                                ),
                                items: _actions
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Color(0xFF263238),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAction = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                            DropdownButtonFormField<String>(
                              value: _selectedState,
                              dropdownColor: const Color(0xFFEEF3F5),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              selectedItemBuilder: (context) {
                                return _states.map((item) {
                                  return Text(
                                    item,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }).toList();
                              },
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                                labelStyle: TextStyle(
                                  color: Color(0xFFB0BEC5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF546E7A),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF8BC34A),
                                  ),
                                ),
                              ),
                              items: _states
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          color: Color(0xFF263238),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedState = value;
                                });
                              },
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
                                'Registrar ensayo laboratorio',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              value: _hasLabTest,
                              onChanged: (value) {
                                setState(() {
                                  _hasLabTest = value;

                                  if (!_hasLabTest) {
                                    _selectedLabTestIds.clear();
                                    _selectedMaterialIds.clear();
                                  }
                                });
                              },
                            ),
                            if (_hasLabTest) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF8BC34A).withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xFF8BC34A)),
                                ),
                                child: const Text(
                                  'Tipo de Material',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              for (final material
                                  in widget.controlContext.materiales)
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: const Color(0xFF8BC34A),
                                  checkColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  title: Text(
                                    material['nombre'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  value: _selectedMaterialIds.contains(
                                    int.parse(material['id'].toString()),
                                  ),
                                  onChanged: (value) {
                                    final materialId =
                                        int.parse(material['id'].toString());

                                    setState(() {
                                      if (value == true) {
                                        _selectedMaterialIds.add(materialId);
                                      } else {
                                        _selectedMaterialIds.remove(materialId);
                                      }
                                    });
                                  },
                                ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF8BC34A).withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color(0xFF8BC34A)),
                                ),
                                child: const Text(
                                  'Ensayos de Laboratorio',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              for (final labTest
                                  in widget.controlContext.ensayosLaboratorio)
                                CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: const Color(0xFF8BC34A),
                                  checkColor: Colors.white,
                                  side: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  title: Text(
                                    labTest['nombre'].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  value: _selectedLabTestIds.contains(
                                    int.parse(labTest['id'].toString()),
                                  ),
                                  onChanged: (value) {
                                    final labTestId =
                                        int.parse(labTest['id'].toString());

                                    setState(() {
                                      if (value == true) {
                                        _selectedLabTestIds.add(labTestId);
                                      } else {
                                        _selectedLabTestIds.remove(labTestId);
                                      }
                                    });
                                  },
                                ),
                            ],
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
                                'Registrar merma',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              value: _hasWaste,
                              onChanged: (value) {
                                setState(() {
                                  _hasWaste = value;
                                });
                              },
                            ),
                            if (_hasWaste) ...[
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: _selectedWasteType,
                                dropdownColor: const Color(0xFFEEF3F5),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                selectedItemBuilder: (context) {
                                  return _wasteTypes.map((item) {
                                    return Text(
                                      item,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  }).toList();
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Tipo de merma',
                                  labelStyle: TextStyle(
                                    color: Color(0xFFB0BEC5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF546E7A),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF8BC34A),
                                    ),
                                  ),
                                ),
                                items: _wasteTypes
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            color: Color(0xFF263238),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedWasteType = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _wasteQuantityController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Cantidad merma',
                                  labelStyle: TextStyle(
                                    color: Color(0xFFB0BEC5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF546E7A),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF8BC34A),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
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
                            const SizedBox(height: 8),
                            const Text(
                              'Puede adjuntar una foto o archivo PDF/JPG/PNG.',
                              style: TextStyle(color: Color(0xFFB0BEC5)),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _takePhoto,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Tomar foto'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                foregroundColor: Colors.white,
                                side:
                                    const BorderSide(color: Color(0xFF8BC34A)),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                foregroundColor: Colors.white,
                                side:
                                    const BorderSide(color: Color(0xFF8BC34A)),
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
                          onPressed: _saveControl,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
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
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1F2A33).withOpacity(0.90),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}
