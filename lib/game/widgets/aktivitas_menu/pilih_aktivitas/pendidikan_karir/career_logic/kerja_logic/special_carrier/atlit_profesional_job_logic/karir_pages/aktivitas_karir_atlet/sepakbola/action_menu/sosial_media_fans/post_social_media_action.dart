// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/action_menu/sosial_media_fans/post_social_media_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'sosial_media_logic/social_media_dialog.dart';

class PostSocialMediaAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    SocialMediaDialog.show(
      context: context,
      character: character,
      onDone: onRefresh,
    );
  }
}
