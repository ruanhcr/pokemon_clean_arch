import 'package:flutter/material.dart';
import 'package:pokemon_clean_arch/core/ui/widgets/skeleton.dart';

class PokemonGridSkeleton extends StatelessWidget {
  const PokemonGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return const Skeleton(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          );
        }, childCount: 8),
      ),
    );
  }
}
