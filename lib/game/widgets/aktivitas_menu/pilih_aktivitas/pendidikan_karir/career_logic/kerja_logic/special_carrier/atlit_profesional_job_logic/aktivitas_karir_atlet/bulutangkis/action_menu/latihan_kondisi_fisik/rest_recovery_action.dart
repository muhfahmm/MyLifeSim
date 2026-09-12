import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class RestRecoveryAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    character.health = (character.health + 10).clamp(0, 100);
    character.happiness = (character.happiness + 5).clamp(0, 100);
    onRefresh();

    showResult(
      'Istirahat & Pemulihan 💤',
      'Kamu mengambil waktu istirahat penuh untuk memulihkan kebugaran tubuh. (+10 Kesehatan, +5 Kebahagiaan)',
      Icons.bed,
      Colors.blue,
    );
  }
}
