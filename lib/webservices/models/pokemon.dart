class Pokemon {
  final int pokedexId;
  final String name;
  final String url;
  final List<int>? pokemonEvolutionsId;

  Pokemon({
    required this.pokedexId,
    required this.name,
    required this.url,
    required this.pokemonEvolutionsId,
  });

  static Future<Pokemon>? fromJson(Map<String, dynamic> jsonBody) {
    final evolutionData = jsonBody['evolution'];

    if (evolutionData == null || evolutionData.isEmpty) {
      return null;
    }

    final nextEvolutions = (evolutionData['next'] as List<dynamic>? ?? [])
        .where((element) => element.isNotEmpty)
        .map<int>((element) => element['pokedexId'] as int);
    final previousEvolutions = (evolutionData['pre'] as List<dynamic>? ?? [])
        .map<int>((element) => element['pokedexId'] as int);
    final pokemonEvolutionsId = [
      ...previousEvolutions,
      ...nextEvolutions,
    ];

    if (pokemonEvolutionsId.isEmpty) {
      return null;
    }

    return Future.value(Pokemon(
      pokedexId: jsonBody['pokedexId'] as int,
      name: jsonBody['name']['fr'] as String,
      url: jsonBody['sprites']['regular'] as String,
      pokemonEvolutionsId: pokemonEvolutionsId,
    ));
  }
}
