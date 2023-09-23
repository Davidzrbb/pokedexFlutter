import 'package:flutter/material.dart';
import 'package:sandbox_app/ui/utils_widget/tile_pokemon.dart';
import 'package:sandbox_app/webservices/models/pokemon.dart';
import 'package:sandbox_app/webservices/service.dart';
import '../utils_widget/app_bar.dart';
import '../utils_widget/bottom_navigation.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final ScrollController _scrollController = ScrollController();
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  int _pokemonDisplay = 0;
  final List<Pokemon> _pokemon = [];
  List<Future> fetchPokemonFutures = [];

  @override
  initState() {
    super.initState();
    _getMorePokemon();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMorePokemon();
      }
    });
  }

  _getMorePokemon() {
    setState(() {
      _loadingMore = true;
    });
    fetchPokemonFutures.clear();
    for (var i = _pokemonDisplay + 1; i <= _pokemonDisplay + 10; i++) {
      fetchPokemonFutures.add(Service.getPokemonById(i));
    }

    setState(() {
      _pokemonDisplay += 10;
    });

    Future.wait(fetchPokemonFutures).then((pokemonList) {
      setState(() {
        _pokemon.addAll(
            pokemonList.where((pokemon) => pokemon != null).cast<Pokemon>());
        _pokemon.sort((a, b) => a.pokedexId.compareTo(b.pokedexId));
        _loadingMore = false;
        _loading = false;
      });
    }).catchError((error) {
      setState(() {
        _loadingMore = false;
        _loading = false;
        _error = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(),
      body: _buildContent(context),
      bottomNavigationBar: const BottomNavigatorBar(),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(_error ?? ''),
      );
    }

    if (_pokemon.isEmpty) {
      return const Center(
        child: Text('Hey, y\'a pas de pokemon ici !'),
      );
    }
    return GridView.builder(
      itemCount: _pokemon.length + 1,
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index == _pokemon.length) {
          if (_loadingMore) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //empty container to avoid error
            return IconButton(
              onPressed: () => _getMorePokemon(),
              icon: const Icon(Icons.expand_more, color: Colors.red,size:
                40,),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final pokemon = _pokemon[index];
        return TilePokemon(
          pokemon: pokemon,
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      shrinkWrap: true,
    );
  }
}
