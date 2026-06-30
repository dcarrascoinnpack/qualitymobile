import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ProductQrScannerPage extends StatelessWidget {
  const ProductQrScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool scanned = false;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Escanear Código Producto'),
        backgroundColor: const Color(0xFF1F2A33),
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (scanned) return;

          final barcode = capture.barcodes.first;

          if (barcode.rawValue == null) return;

          scanned = true;

          Navigator.pop(context, barcode.rawValue);
        },
      ),
    );
  }
}