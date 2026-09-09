// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/action_menu/sosial_media_fans/press_conference_action.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class PressConferenceAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    final Random random = Random();
    final bool positiveRep = random.nextBool();

    if (positiveRep) {
      character.happiness = (character.happiness + 5).clamp(0, 100);
      showResult(
        'Konferensi Pers 🎙️✨',
        'Jawabanmu yang rendah hati dipuji oleh wartawan dan pelatih. Kepercayaan publik meningkat!',
        Icons.mic,
        Colors.blue,
      );
    } else {
      showResult(
        'Konferensi Pers 🎙️🔥',
        'Pernyataanmu memicu perdebatan panas di media olahraga. Fans menantikan pembuktianmu di pertandingan!',
        Icons.campaign,
        Colors.orange,
      );
    }
    onRefresh();
  }
}
