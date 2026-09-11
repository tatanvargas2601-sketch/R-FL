import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../legacy_provider/favoritos_notifier.dart';

class FavoritosAction extends StatelessWidget {
  const FavoritosAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritosNotifier>(
      builder: (context, favoritos, _) {
        final count = favoritos.favoritos.length;
        return IconButton(
          tooltip: 'Mis favoritos',
          icon: Badge(
            label: Text('$count'),
            isLabelVisible: count > 0,
            child: const Icon(Icons.favorite_border),
          ),
          onPressed: () => context.push('/favoritos'),
        );
      },
    );
  }
}
