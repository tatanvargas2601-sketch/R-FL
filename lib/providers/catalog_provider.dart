import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/categoria.dart';
import '../models/prenda.dart';
import '../services/categoria_service.dart';
import '../services/prenda_service.dart';

final categoriaServiceProvider = Provider((ref) => CategoriaService());

final prendaServiceProvider = Provider((ref) => PrendaService());

final categoriasProvider = FutureProvider<List<Categoria>>((ref) {
  return ref.read(categoriaServiceProvider).getAll();
});

class CategoriaFiltroNotifier extends StateNotifier<int?> {
  CategoriaFiltroNotifier() : super(null) {
    _restore();
  }

  static const _storageKey = 'categoria_filtro_v1';

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_storageKey);
    if (saved != null) state = saved;
  }

  Future<void> set(int? idCategoria) async {
    state = idCategoria;
    final prefs = await SharedPreferences.getInstance();
    if (idCategoria == null) {
      await prefs.remove(_storageKey);
    } else {
      await prefs.setInt(_storageKey, idCategoria);
    }
  }
}

final categoriaFiltroProvider =
    StateNotifierProvider<CategoriaFiltroNotifier, int?>((ref) {
  return CategoriaFiltroNotifier();
});

final prendasProvider = FutureProvider<List<Prenda>>((ref) {
  final idCategoria = ref.watch(categoriaFiltroProvider);
  return ref.read(prendaServiceProvider).getAll(idCategoria: idCategoria);
});

final busquedaProvider = StateProvider<String>((ref) => '');

final prendasFiltradasProvider = Provider<AsyncValue<List<Prenda>>>((ref) {
  final asyncPrendas = ref.watch(prendasProvider);
  final query = ref.watch(busquedaProvider).trim().toLowerCase();

  return asyncPrendas.whenData((prendas) {
    if (query.isEmpty) return prendas;
    return prendas.where((p) {
      final nombre = p.nombrePrenda.toLowerCase();
      final color = (p.color ?? '').toLowerCase();
      final descripcion = (p.descripcion ?? '').toLowerCase();
      final categoria = (p.categoriaNombre ?? '').toLowerCase();
      return nombre.contains(query) ||
          color.contains(query) ||
          descripcion.contains(query) ||
          categoria.contains(query);
    }).toList();
  });
});

final prendaByIdProvider = FutureProvider.family<Prenda, int>((ref, id) {
  return ref.read(prendaServiceProvider).getById(id);
});

final prendasFavoritasProvider = Provider<AsyncValue<List<Prenda>>>((ref) {
  final asyncPrendas = ref.watch(prendasProvider);
  return asyncPrendas;
});