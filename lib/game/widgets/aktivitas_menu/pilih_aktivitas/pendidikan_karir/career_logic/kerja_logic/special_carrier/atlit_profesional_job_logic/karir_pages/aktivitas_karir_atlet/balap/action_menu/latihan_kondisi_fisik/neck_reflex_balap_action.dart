// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/balap/action_menu/latihan_kondisi_fisik/neck_reflex_balap_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class NeckReflexBalapAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.health < 15) {
      showResult('Stamina Lemah ⚠️', 'Fisik terlalu lelah untuk latihan beban otot leher & refleks.', Icons.warning, Colors.red);
      return;
    }
    character.health = (character.health - 8).clamp(0, 100);
    character.discipline = (character.discipline + 3).clamp(0, 100);
    onRefresh();

    showResult(
      'Latihan Otot Leher & Refleks G-Force 🏋️‍♂️',
      'Melatih kekuatan otot leher menahan gaya G-Force saat tikungan tajam serta reaksi mata kilat.',
      Icons.fitness_center,
      Colors.deepOrange,
    );
  }
}
