import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/prenda.dart';

class PrendaCard extends StatefulWidget {
  final Prenda prenda;
  final VoidCallback onTap;

  const PrendaCard({super.key, required this.prenda, required this.onTap});

  @override
  State<PrendaCard> createState() => _PrendaCardState();
}

class _PrendaCardState extends State<PrendaCard> {
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _currentImageIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.prenda.imagenes;
    final hasMultiple = images.length > 1;
    final currentImage = hasMultiple
        ? images[_currentImageIndex].url
        : widget.prenda.imagenPrincipal;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: currentImage.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: currentImage,
                              fit: BoxFit.cover,
                              placeholder: (c, u) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (c, u, e) => const Icon(Icons.broken_image),
                            )
                          : Container(color: Colors.grey.shade200, child: const Icon(Icons.checkroom)),
                    ),
                    if (hasMultiple) ...[
                      Positioned(
                        left: 0, top: 0, bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                          onPressed: () {
                            setState(() {
                              _currentImageIndex = (_currentImageIndex - 1) % images.length;
                              if (_currentImageIndex < 0) _currentImageIndex = images.length - 1;
                            });
                          },
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      Positioned(
                        right: 0, top: 0, bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
                          onPressed: () {
                            setState(() {
                              _currentImageIndex = (_currentImageIndex + 1) % images.length;
                            });
                          },
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      Positioned(
                        bottom: 4, left: 0, right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: images.asMap().entries.map((entry) {
                            return Container(
                              width: 6, height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
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
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.prenda.nombrePrenda,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'S/ ${widget.prenda.precioAlquiler.toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (widget.prenda.stockDisponible == 0)
                      const Text('Sin stock', style: TextStyle(color: Colors.red, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
