// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/action_menu/sosial_media_fans/press_conference_renang_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PressConferenceRenangAction {
  static void execute(BuildContext context, Character character, Function(String, String, IconData, Color) showResult) {
    character.popularity = (character.popularity + 4).clamp(0, 100);
    showResult(
      'Konferensi Pers Kejuaraan Renang 🎙️',
      'Kamu memberikan komentar kepada jurnalis menjelang kejuaraan renang.',
      Icons.mic,
      Colors.purple,
    );
  }
}
