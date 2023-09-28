import 'package:flutter/material.dart';

class DropDownMenuPokemon extends StatelessWidget {
  DropDownMenuPokemon({
    super.key,
    required this.onCrossAxisCountChanged
  });

  final void Function(int? newValue) onCrossAxisCountChanged;
  final List<int> listViewPokemon = [1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<int>(
      label: const Text('Nombre de colonnes'),
      initialSelection: 2,
      onSelected: (int? value) {
        onCrossAxisCountChanged(value);
      },
      dropdownMenuEntries:
          listViewPokemon.map<DropdownMenuEntry<int>>((int value) {
        return DropdownMenuEntry<int>(value: value, label: value.toString());
      }).toList(),
    );
  }
}
