import 'package:flutter/material.dart';
import 'package:pokemon_clean_arch/pokemon/domain/entities/pokemon_entity.dart';

extension PokemonColorExtension on PokemonEntity {
  Color get cardColor {
    final colors = [
      const Color(0xFF48D0B0), 
      const Color(0xFFFA6555), 
      const Color(0xFF76BCFD),
      const Color(0xFFFFCE4B), 
      const Color(0xFF9F5BBA),
      const Color(0xFFCA8179),
    ];
    return colors[id % colors.length];
  }
}