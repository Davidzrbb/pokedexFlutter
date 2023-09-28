import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sandbox_app/webservices/models/pokemon.dart';

class Service {
  static const String _baseUrl =
      'https://api-pokemon-fr.vercel.app/api/v1/pokemon';
  static List<Future<Pokemon?>> fetchPokemonFutures = [];
  static int _pokemonDisplay = 0;

  static Future<Pokemon?> getPokemonById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    final jsonBody = json.decode(response.body);
    if (jsonBody == null) {
      return Future.error('Pokemon not found');
    }
    return Pokemon.fromJson(jsonBody);
  }

  static void getMorePokemon({
    required void Function() activeLoaderMore,
    required void Function(List<Pokemon> pokemonList) addPokemon,
    required void Function(String error) onError,
  }) async {
    try {
      activeLoaderMore();

      for (var i = _pokemonDisplay + 1; i <= _pokemonDisplay + 10; i++) {
        fetchPokemonFutures.add(Service.getPokemonById(i));
      }
      _pokemonDisplay += 10;
      final pokemonList = await Future.wait(fetchPokemonFutures);
      final validPokemonList = pokemonList.whereType<Pokemon>().toList();

      addPokemon(validPokemonList);
    } catch (error) {
      onError(error.toString());
    }
  }
}
