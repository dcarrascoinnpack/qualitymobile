import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ProductQrScannerPage extends StatefulWidget {
  const ProductQrScannerPage({super.key});

  @override
  State<ProductQrScannerPage> createState() => _ProductQrScannerPageState();
}

class _ProductQrScannerPageState extends State<ProductQrScannerPage> {
  bool _scanned = false;
  late bool _showManualInput;
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    _showManualInput = kIsWeb;
    if (!kIsWeb) {
      _scannerController = MobileScannerController();
    }
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    _codeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    if (capture.barcodes.isEmpty) return;
    final value = capture.barcodes.first.rawValue;
    if (value == null) return;
    _scanned = true;
    Navigator.pop(context, value);
  }

  void _submitManual() {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;
    final payload = jsonEncode({
      'codigo': code,
      'descripcion': _descController.text.trim(),
    });
    Navigator.pop(context, payload);
  }

  void _toggleMode() {
    setState(() {
      _showManualInput = !_showManualInput;
      if (!_showManualInput && _scannerController == null) {
        _scannerController = MobileScannerController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Escanear Código Producto'),
        backgroundColor: const Color(0xFF1F2A33),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _toggleMode,
            icon: Icon(
              _showManualInput ? Icons.qr_code_scanner : Icons.keyboard,
              color: const Color(0xFF8BC34A),
              size: 20,
            ),
            label: Text(
              _showManualInput ? 'Usar cámara' : 'Manual',
              style: const TextStyle(
                color: Color(0xFF8BC34A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: _showManualInput ? _buildManualInput() : _buildScanner(),
    );
  }

  Widget _buildScanner() {
    return MobileScanner(
      controller: _scannerController,
      onDetect: _onDetect,
    );
  }

  Widget _buildManualInput() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.qr_code,
                size: 80,
                color: Color(0xFF8BC34A),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ingresa los datos del producto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _codeController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Código de producto',
                  labelStyle: const TextStyle(color: Color(0xFF90A4AE)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF546E7A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF8BC34A)),
                  ),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Descripción del producto',
                  labelStyle: const TextStyle(color: Color(0xFF90A4AE)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF546E7A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF8BC34A)),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submitManual(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitManual,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8BC34A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'CONFIRMAR',
                    style: TextStyle(
                      fontSize: 18,
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
    );
  }
}
