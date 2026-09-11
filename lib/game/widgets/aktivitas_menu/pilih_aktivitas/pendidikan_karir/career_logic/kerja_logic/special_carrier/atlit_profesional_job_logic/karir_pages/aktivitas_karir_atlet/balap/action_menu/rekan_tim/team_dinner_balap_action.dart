// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/balap/action_menu/rekan_tim/team_dinner_balap_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class TeamDinnerBalapAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.money < 400) {
      showResult('Uang Tidak Cukup 💵', 'Kamu membutuhkan \$400 untuk mentraktir kru paddock & mekanik balap.', Icons.warning, Colors.red);
      return;
    }

    character.money -= 400;
    character.happiness = (character.happiness + 8).clamp(0, 100);
    for (var cw in character.coworkers) {
      int r = int.tryParse(cw['relationship'] ?? '50') ?? 50;
      cw['relationship'] = (r + 10).clamp(0, 100).toString();
    }
    onRefresh();

    showResult(
      'Makan Malam Bersama Tim Paddock 🥩🍷',
      'Kamu mengajak seluruh teknisi, insinyur mesin, dan kru paddock makan malam bersama. Kekompakan tim balap makin tinggi!',
      Icons.restaurant,
      Colors.amber.shade800,
    );
  }
}
