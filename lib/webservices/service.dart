import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sandbox_app/webservices/models/pokemon.dart';

class Service {
  static const String _baseUrl =
      'https://api-pokemon-fr.vercel.app/api/v1/pokemon';

  static Future<Pokemon?> getPokemonById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));
    final jsonBody = json.decode(response.body);
    if (jsonBody == null) {
      return Future.error('Pokemon not found');
    }
    return Pokemon.fromJson(jsonBody);
  }
}
