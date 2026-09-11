import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prenda.dart';
import '../services/prenda_service.dart';

class CartItem {
  final Prenda prenda;
  final int idInventario;
  int cantidad;

  CartItem({
    required this.prenda,
    required this.idInventario,
    this.cantidad = 1,
  });

  double get subtotal => prenda.precioAlquiler * cantidad;
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]) {
    _restore();
  }

  static const _storageKey = 'cart_items_v1';
  final _prendaService = PrendaService();

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null || raw.isEmpty) return;

      final List decoded = jsonDecode(raw);
      final items = <CartItem>[];

      for (final entry in decoded) {
        try {
          final prenda = await _prendaService.getById(entry['idPrenda'] as int);
          items.add(CartItem(
            prenda: prenda,
            idInventario: entry['idInventario'] as int,
            cantidad: entry['cantidad'] as int,
          ));
        } catch (_) {
          continue;
        }
      }

      state = items;
    } catch (_) {
      state = [];
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(state
        .map((i) => {
              'idPrenda': i.prenda.idPrenda,
              'idInventario': i.idInventario,
              'cantidad': i.cantidad,
            })
        .toList());
    await prefs.setString(_storageKey, encoded);
  }

  bool add(Prenda prenda, int idInventario) {
    final yaExiste = state.any((i) => i.prenda.idPrenda == prenda.idPrenda);
    if (yaExiste) {
      return false;
    }
    state = [...state, CartItem(prenda: prenda, idInventario: idInventario)];
    _persist();
    return true;
  }

  void remove(int idInventario) {
    state = state.where((i) => i.idInventario != idInventario).toList();
    _persist();
  }

  void clear() {
    state = [];
    _persist();
  }

  double get total => state.fold(0, (sum, item) => sum + item.subtotal);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});