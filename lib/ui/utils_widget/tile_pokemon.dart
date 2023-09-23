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
    return ListTile(
      title: Text(
        pokemon.name,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: //concatane the index with total of 4 digits
          Text(
        pokemon.pokedexId.toString().padLeft(4, '0'),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      leading: Image.network(pokemon.url),
      onTap: () {

      },
    );
  }
}
