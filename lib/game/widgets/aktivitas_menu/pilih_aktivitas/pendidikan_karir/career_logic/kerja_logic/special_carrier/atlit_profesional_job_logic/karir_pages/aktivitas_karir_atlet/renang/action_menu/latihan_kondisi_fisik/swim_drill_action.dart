// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/action_menu/latihan_kondisi_fisik/swim_drill_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class SwimDrillAction {
  static void execute(BuildContext context, Character character, Function(String, String, IconData, Color) showResult) {
    character.health = (character.health + 3).clamp(0, 100);
    showResult(
      'Latihan Teknik Renang 🏊‍♂️',
      'Kamu melatih kepakan kaki dan teknik pembalikan dinding kolam renang.',
      Icons.pool,
      Colors.blue,
    );
  }
}
