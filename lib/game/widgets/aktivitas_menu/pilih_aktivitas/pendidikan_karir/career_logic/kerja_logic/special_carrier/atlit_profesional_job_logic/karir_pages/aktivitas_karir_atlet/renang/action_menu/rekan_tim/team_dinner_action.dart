// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/action_menu/rekan_tim/team_dinner_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class TeamDinnerAction {
  static void execute(BuildContext context, Character character, Function(String, String, IconData, Color) showResult) {
    character.happiness = (character.happiness + 5).clamp(0, 100);
    showResult(
      'Makan Bersam Tim Renang 🍽️',
      'Kamu makan malam bersama sesama perenang dan tim pelatih.',
      Icons.restaurant,
      Colors.orange,
    );
  }
}
