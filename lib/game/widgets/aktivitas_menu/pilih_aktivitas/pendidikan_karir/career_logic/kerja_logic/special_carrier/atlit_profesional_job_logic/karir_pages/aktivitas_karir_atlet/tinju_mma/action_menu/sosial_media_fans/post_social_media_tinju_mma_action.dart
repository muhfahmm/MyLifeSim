import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PostSocialMediaTinjuMMAAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    character.followers += 250;
    character.popularity = (character.popularity + 2).clamp(0, 100);
    onRefresh();

    showResult(
      'Posting Highlight Tinju / MMA 📲',
      'Mengunggah cuplikan performa Tinju / MMA di media sosial. Penggemar menyukainya! (+250 Followers & +2 Popularitas).',
      Icons.thumb_up,
      Colors.blueAccent,
    );
  }
}
