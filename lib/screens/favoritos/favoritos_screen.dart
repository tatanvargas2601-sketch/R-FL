import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Consumer;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../legacy_provider/favoritos_notifier.dart';
import '../../providers/catalog_provider.dart';
import '../../widgets/loading_error_view.dart';
import '../../widgets/prenda_card.dart';

class FavoritosScreen extends ConsumerWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prendasAsync = ref.watch(prendasFavoritasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis favoritos')),
      body: Consumer<FavoritosNotifier>(
        builder: (context, favoritos, _) {
          final ids = favoritos.favoritos;
          if (ids.isEmpty) {
            return const Center(child: Text('Aún no marcaste ninguna prenda como favorita'));
          }
          return AsyncValueView(
            value: prendasAsync,
            builder: (todasLasPrendas) {
              final favoritas =
                  todasLasPrendas.where((p) => ids.contains(p.idPrenda)).toList();
              if (favoritas.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Tus favoritos no aparecen con el filtro de categoría actual. '
                      'Ve al catálogo y selecciona "Todas" para verlos.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemCount: favoritas.length,
                itemBuilder: (context, i) {
                  final p = favoritas[i];
                  return PrendaCard(
                    prenda: p,
                    onTap: () => context.push('/prenda/${p.idPrenda}'),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
