import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';





class FavoritosNotifier extends ChangeNotifier {
  static const _storageKey = 'favoritos_v1';
  final Set<int> _idsFavoritos = {};

  Set<int> get favoritos => _idsFavoritos;

  FavoritosNotifier() {
    _restore();
  }

  bool esFavorito(int idPrenda) => _idsFavoritos.contains(idPrenda);

  Future<void> toggle(int idPrenda) async {
    if (_idsFavoritos.contains(idPrenda)) {
      _idsFavoritos.remove(idPrenda);
    } else {
      _idsFavoritos.add(idPrenda);
    }
    notifyListeners(); 
    await _persist();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;

    final List decoded = jsonDecode(raw);
    _idsFavoritos.addAll(decoded.map((e) => e as int));
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_idsFavoritos.toList()));
  }
}