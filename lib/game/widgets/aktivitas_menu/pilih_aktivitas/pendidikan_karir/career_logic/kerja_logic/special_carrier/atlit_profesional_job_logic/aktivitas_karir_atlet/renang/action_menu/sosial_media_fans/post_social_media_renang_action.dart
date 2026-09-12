// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/renang/action_menu/sosial_media_fans/post_social_media_renang_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PostSocialMediaRenangAction {
  static void execute(BuildContext context, Character character, Function(String, String, IconData, Color) showResult) {
    character.popularity = (character.popularity + 3).clamp(0, 100);
    showResult(
      'Unggah Media Sosial 📱',
      'Kamu mengunggah foto latihan di kolam renang yang disukai banyak pendukung.',
      Icons.share,
      Colors.pink,
    );
  }
}
