import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Consumer;
import 'package:provider/provider.dart';
import '../../legacy_provider/favoritos_notifier.dart';
import '../../models/inventario.dart';
import '../../providers/catalog_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/inventario_service.dart';
import '../../widgets/favoritos_action.dart';

class PrendaDetailScreen extends ConsumerStatefulWidget {
  final int idPrenda;
  const PrendaDetailScreen({super.key, required this.idPrenda});

  @override
  ConsumerState<PrendaDetailScreen> createState() => _PrendaDetailScreenState();
}

class _PrendaDetailScreenState extends ConsumerState<PrendaDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final prendaAsync = ref.watch(prendaByIdProvider(widget.idPrenda));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
        actions: const [FavoritosAction()],
      ),
      body: prendaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('No se pudo cargar la prenda: $err', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(prendaByIdProvider(widget.idPrenda)),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        data: (prenda) {
          final images = prenda.imagenes;
          final hasMultiple = images.length > 1;
          final currentImage = hasMultiple && images.isNotEmpty
              ? images[_currentImageIndex].url
              : prenda.imagenPrincipal;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: currentImage.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: currentImage,
                              fit: BoxFit.cover,
                              placeholder: (c, u) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (c, u, e) => const Icon(Icons.broken_image),
                            )
                          : Container(color: Colors.grey.shade200),
                    ),
                    if (hasMultiple) ...[
                      Positioned(
                        left: 0, top: 0, bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                          onPressed: () {
                            setState(() {
                              _currentImageIndex = (_currentImageIndex - 1) % images.length;
                              if (_currentImageIndex < 0) _currentImageIndex = images.length - 1;
                            });
                          },
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      Positioned(
                        right: 0, top: 0, bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_right, color: Colors.white, size: 32),
                          onPressed: () {
                            setState(() {
                              _currentImageIndex = (_currentImageIndex + 1) % images.length;
                            });
                          },
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      Positioned(
                        bottom: 8, left: 0, right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: images.asMap().entries.map((entry) {
                            return Container(
                              width: 8, height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: entry.key == _currentImageIndex
                                    ? Colors.white
                                    : Colors.white54,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prenda.nombrePrenda, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('S/ ${prenda.precioAlquiler.toStringAsFixed(2)} / alquiler',
                              style: Theme.of(context).textTheme.titleMedium),
                          Consumer<FavoritosNotifier>(
                            builder: (context, favoritos, _) {
                              final esFavorito = favoritos.esFavorito(prenda.idPrenda);
                              return IconButton(
                                icon: Icon(
                                  esFavorito ? Icons.favorite : Icons.favorite_border,
                                  color: esFavorito ? Colors.red : null,
                                ),
                                onPressed: () => favoritos.toggle(prenda.idPrenda),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (prenda.descripcion != null) Text(prenda.descripcion!),
                      const SizedBox(height: 20),
                      Text('Disponibilidad: ${prenda.stockDisponible} de ${prenda.stockTotal}'),
                      const SizedBox(height: 20),
                      FutureBuilder<List<Inventario>>(
                        future: InventarioService().getAll(idPrenda: widget.idPrenda),
                        builder: (context, invSnapshot) {
                          final disponibles = (invSnapshot.data ?? [])
                              .where((i) => i.estado == EstadoInventario.disponible)
                              .toList();
                          if (disponibles.isEmpty) {
                            return const Text('No hay unidades disponibles ahora mismo.');
                          }
                          return FilledButton.icon(
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text('Agregar al carrito'),
                            onPressed: () {
                              final agregado = ref
                                  .read(cartProvider.notifier)
                                  .add(prenda, disponibles.first.idInventario);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    agregado
                                        ? 'Agregado al carrito'
                                        : 'Esta prenda ya está en tu carrito',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
