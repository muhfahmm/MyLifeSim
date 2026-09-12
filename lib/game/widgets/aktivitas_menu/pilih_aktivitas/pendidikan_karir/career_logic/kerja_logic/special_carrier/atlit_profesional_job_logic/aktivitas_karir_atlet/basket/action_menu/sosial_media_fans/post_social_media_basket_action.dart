// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/basket/action_menu/sosial_media_fans/post_social_media_basket_action.dart

import 'package:flutter/material.dart';

import 'package:mylifesim/pilih_karakter/character.dart';

class PostSocialMediaBasketAction {
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
      'Posting Highlight Basket 📲',
      'Mengunggah cuplikan slam dunk & 3-pointer di media sosial. Penggemar basket menyukainya! (+250 Followers & +2 Popularitas).',
      Icons.thumb_up,
      Colors.blueAccent,
    );
  }
}
