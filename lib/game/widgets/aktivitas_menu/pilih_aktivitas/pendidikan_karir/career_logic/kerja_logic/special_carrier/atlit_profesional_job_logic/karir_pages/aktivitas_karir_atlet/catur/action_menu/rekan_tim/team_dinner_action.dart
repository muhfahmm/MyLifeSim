import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class TeamDinnerAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    character.happiness = (character.happiness + 8).clamp(0, 100);
    onRefresh();

    showResult(
      'Makan Malam Bersama Tim 🍽️',
      'Suasana keakraban bersama kawan-kawan tim dan pelatih berlangsung hangat. (+8 Kebahagiaan)',
      Icons.restaurant,
      Colors.amber,
    );
  }
}
