// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/action_menu/latihan_kondisi_fisik/rest_recovery_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class RestRecoveryAction {
  static void execute(BuildContext context, Character character, Function(String, String, IconData, Color) showResult) {
    character.health = (character.health + 10).clamp(0, 100);
    showResult(
      'Istirahat & Pemulihan 🛌',
      'Kamu beristirahat dan melakukan terapi es untuk pemulihan otot.',
      Icons.bed,
      Colors.teal,
    );
  }
}
