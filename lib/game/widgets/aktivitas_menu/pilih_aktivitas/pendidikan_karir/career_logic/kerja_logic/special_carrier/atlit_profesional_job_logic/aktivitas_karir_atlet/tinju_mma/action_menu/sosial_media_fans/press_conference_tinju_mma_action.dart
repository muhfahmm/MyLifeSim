import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PressConferenceTinjuMMAAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    character.popularity = (character.popularity + 4).clamp(0, 100);
    character.publicTrust = (character.publicTrust + 3).clamp(0, 100);
    onRefresh();

    showResult(
      'Konferensi Pers Tinju / MMA 🥊',
      'Kamu menjawab pertanyaan wartawan olahraga tentang target bertanding Tinju / MMA musim ini secara bijak. Popularitas dan Kepercayaan Publik meningkat!',
      Icons.mic,
      Colors.lightBlue,
    );
  }
}
