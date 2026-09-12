// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/balap/action_menu/sosial_media_fans/post_social_media_balap_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PostSocialMediaBalapAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    character.followers += 300;
    character.popularity = (character.popularity + 3).clamp(0, 100);
    onRefresh();

    showResult(
      'Posting On-Board Camera 📲',
      'Mengunggah video kamera on-board aksi overtaking dramatis di tikungan sirkuit! (+300 Followers & +3 Popularitas).',
      Icons.thumb_up,
      Colors.blueAccent,
    );
  }
}
