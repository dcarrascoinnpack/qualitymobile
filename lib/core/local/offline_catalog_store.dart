import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineCatalogStore {
  static const String _catalogKey = 'offline_catalog';
  Future<void> ensureSeedCatalogLoaded() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_catalogKey);

    if (raw != null && raw.isNotEmpty) {
      return;
    }

    final seedRaw = await rootBundle.loadString(
      'assets/data/offline_catalog_seed.json',
    );

    final seedCatalog = jsonDecode(seedRaw);

    await saveCatalog(
      Map<String, dynamic>.from(seedCatalog),
    );
  }

  Future<void> saveCatalog(Map<String, dynamic> catalog) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _catalogKey,
      jsonEncode(catalog),
    );
  }

  Future<Map<String, dynamic>?> getCatalog() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_catalogKey);

    if (raw == null || raw.isEmpty) {
      return null;
    }

    return jsonDecode(raw);
  }

  Future<List<dynamic>> getQrContexts() async {
    final catalog = await getCatalog();

    if (catalog == null) {
      return [];
    }

    return catalog['qrContexts'] ?? [];
  }

  Future<List<dynamic>> getUsuarios() async {
    final catalog = await getCatalog();

    if (catalog == null) {
      return [];
    }

    return catalog['usuarios'] ?? [];
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_catalogKey);
  }

  Future<List<dynamic>> getEnsayosLaboratorio() async {
    final catalog = await getCatalog();

    if (catalog == null) {
      return [];
    }

    return catalog['ensayosLaboratorio'] ?? [];
  }

  Future<List<dynamic>> getTiposOnda() async {
    final catalog = await getCatalog();

    if (catalog == null) {
      return [];
    }

    return catalog['tiposOnda'] ?? [];
  }

  Future<List<dynamic>> getParametrosVisuales() async {
    final catalog = await getCatalog();

    if (catalog == null) {
      return [];
    }

    return catalog['parametrosVisuales'] ?? [];
  }
}
