import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../webservices/models/pokemon.dart';

class TilePokemon extends StatelessWidget {
  const TilePokemon({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 5,
            child: CachedNetworkImage(
              imageUrl: pokemon.url,
              placeholder: (context, url) => Container(
                width: 200,
                height: 200,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 1,
            child: Text(
              pokemon.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              pokemon.pokedexId.toString().padLeft(4, '0'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
