import 'package:flutter/material.dart';
import 'package:sandbox_app/ui/utils_widget/dropdown_menu.dart';
import 'package:sandbox_app/ui/utils_widget/grid_view_pokemon.dart';
import 'package:sandbox_app/webservices/models/pokemon.dart';
import 'package:sandbox_app/webservices/service.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => WelcomeWidget();
}

class WelcomeWidget extends State<Welcome> {
  final ScrollController _scrollController = ScrollController();
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  final List<Pokemon> _pokemon = [];
  int? crossAxisCount;

  @override
  void initState() {
    super.initState();
    _getMorePokemon();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMorePokemon();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(_error!),
      );
    }

    if (_pokemon.isEmpty) {
      return const Center(
        child: Text('Hey, y\'a pas de pokemon ici !'),
      );
    }
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: DropDownMenuPokemon(
              onCrossAxisCountChanged: (int? newValue) =>
                  setState(() => crossAxisCount = newValue),
            ),
          ),
          Expanded(
            child: GridViewPokemon(
              getMorePokemon: _getMorePokemon,
              pokemon: _pokemon,
              crossAxisCount: crossAxisCount ?? 2,
              scrollController: _scrollController,
              loadingMore: _loadingMore,
            ),
          ),
        ],
      ),
    );
  }

  void _getMorePokemon() {
    Service.getMorePokemon(
      activeLoaderMore: () => setState(() => _loadingMore = true),
      addPokemon: (List<Pokemon> pokemonList) {
        setState(() {
          _pokemon.clear();
          _pokemon.addAll(pokemonList);
          _pokemon.sort((a, b) => a.pokedexId.compareTo(b.pokedexId));
          _loadingMore = false;
          _loading = false;
        });
      },
      onError: (error) {
        setState(() {
          _loadingMore = false;
          _loading = false;
          _error = error.toString();
        });
      },
    );
  }
}
