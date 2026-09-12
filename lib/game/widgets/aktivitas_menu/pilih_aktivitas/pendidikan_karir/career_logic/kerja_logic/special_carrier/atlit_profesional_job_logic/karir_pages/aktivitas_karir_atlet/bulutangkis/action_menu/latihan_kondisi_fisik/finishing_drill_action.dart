import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class FinishingDrillAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    character.discipline = (character.discipline + 2).clamp(0, 100);
    character.happiness = (character.happiness + 2).clamp(0, 100);
    onRefresh();

    showResult(
      'Latihan Teknik & Ketajaman 🎯',
      'Latihan meningkatkan akurasi dan ketajaman teknik bertanding. (+2 Kedisiplinan, +2 Kebahagiaan)',
      Icons.ads_click,
      Colors.green,
    );
  }
}
