import 'package:flutter/material.dart';
import 'package:sandbox_app/ui/utils_widget/tile_pokemon.dart';
import 'package:sandbox_app/webservices/models/pokemon.dart';

class GridViewPokemon extends StatelessWidget {
  const GridViewPokemon({
    super.key,
    required this.getMorePokemon,
    required this.pokemon,
    required this.crossAxisCount,
    required this.scrollController,
    required this.loadingMore,
  });
  final VoidCallback getMorePokemon;
  final List<Pokemon> pokemon;
  final int crossAxisCount;
  final ScrollController scrollController;
  final bool loadingMore;

  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
      itemCount: pokemon.length + 1,
      controller: scrollController,
      itemBuilder: (context, index) {
        if (index == pokemon.length) {
          if (loadingMore) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return IconButton(
              onPressed: () {
                getMorePokemon(); // Appelez la fonction _getMorePokemon ici
              },
              icon: const Icon(
                Icons.downloading,
                color: Colors.red,
                size: 40,
              ),
            );
          }
        }
        return TilePokemon(
          pokemon: pokemon[index],
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      shrinkWrap: true,
    );
  }
}
