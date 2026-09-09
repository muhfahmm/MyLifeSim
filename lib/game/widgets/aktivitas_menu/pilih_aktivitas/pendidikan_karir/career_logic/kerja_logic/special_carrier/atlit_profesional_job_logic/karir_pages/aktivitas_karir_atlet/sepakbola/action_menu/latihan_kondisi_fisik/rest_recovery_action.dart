import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class RestRecoveryAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    character.athleteTrainingCountInTurn = (character.athleteTrainingCountInTurn - 2).clamp(0, 10);

    final bool wasInjured = character.athleteIsInjured;
    if (wasInjured) {
      character.athleteIsInjured = false;
      character.athleteInjuryType = null;
    }

    character.health = (character.health + 8).clamp(0, 100);
    character.happiness = (character.happiness + 5).clamp(0, 100);
    onRefresh();

    if (wasInjured) {
      showResult(
        'Pemulihan Cedera Berhasil! 🩹✨',
        'Dengan istirahat dan mandi es secara rutin, cederamu akhirnya sembuh total! Tubuhmu siap kembali berlatih.',
        Icons.check_circle_outline,
        Colors.teal,
      );
    } else {
      showResult(
        'Istirahat & Pemulihan 🛀🌱',
        'Kamu melakukan mandi es, pijat otot, dan tidur nyenyak. Tubuhmu merasa sangat segar! (+8 Kesehatan, +5 Kebahagiaan).',
        Icons.hot_tub,
        Colors.teal,
      );
    }
  }
}
