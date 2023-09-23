import 'package:flutter/material.dart';
import 'package:sandbox_app/ui/utils_widget/tile_pokemon.dart';
import 'package:sandbox_app/webservices/models/pokemon.dart';
import 'package:sandbox_app/webservices/service.dart';
import '../utils_widget/app_bar.dart';
import '../utils_widget/bottom_navigation.dart';

List<String> listViewPokemon = ['1', '2', '3', '4'];

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

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
  int crossAxisCount = 2; // Default value
  List<Future> fetchPokemonFutures = [];

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

  void _getMorePokemon() {
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
    int newCrossAxisCount = 2; // Default value
    String dropdownValue = listViewPokemon[2];
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
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: DropdownMenu<String>(

              label: const Text('Nombre de colonnes'),
              initialSelection: newCrossAxisCount.toString(),
              onSelected: (String? value) {
                setState(() {
                  dropdownValue = value ?? '2';
                });
                if (value == '1') {
                  newCrossAxisCount = 1;
                } else if (value == '2') {
                  newCrossAxisCount = 2;
                } else if (value == '3') {
                  newCrossAxisCount = 3;
                } else if (value == '4') {
                  newCrossAxisCount = 4;
                }

                setState(() {
                  crossAxisCount = newCrossAxisCount;
                });
              },
              dropdownMenuEntries: listViewPokemon
                  .map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: _pokemon.length + 1,
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index == _pokemon.length) {
                  if (_loadingMore) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return IconButton(
                      onPressed: () => _getMorePokemon(),
                      icon: const Icon(
                        Icons.downloading,
                        color: Colors.red,
                        size: 40,
                      ),
                    );
                  }
                }
                final pokemon = _pokemon[index];
                return TilePokemon(
                  pokemon: pokemon,
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
              ),
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
