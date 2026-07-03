import 'package:flutter/material.dart';

import '../features/empresa_selector/empresa_selector_page.dart';

class QualityControlApp extends StatelessWidget {
  const QualityControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quality Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blueGrey,
      ),
      home: const EmpresaSelectorPage(),
    );
  }
}