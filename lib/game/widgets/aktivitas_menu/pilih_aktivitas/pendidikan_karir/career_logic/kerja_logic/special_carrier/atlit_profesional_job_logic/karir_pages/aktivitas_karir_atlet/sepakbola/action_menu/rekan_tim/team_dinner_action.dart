// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/action_menu/rekan_tim/team_dinner_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class TeamDinnerAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.money < 300) {
      showResult('Uang Tidak Cukup 💵', 'Kamu butuh \$300 untuk mentraktir makan malam tim.', Icons.warning, Colors.red);
      return;
    }

    character.money -= 300;
    character.happiness = (character.happiness + 8).clamp(0, 100);
    for (var cw in character.coworkers) {
      int r = int.tryParse(cw['relationship'] ?? '50') ?? 50;
      cw['relationship'] = (r + 10).clamp(0, 100).toString();
    }
    onRefresh();

    showResult(
      'Makan Malam Tim 🥩🍷',
      'Kamu mengajak tim utama & cadangan makan malam bersama. Kekompakan dan suasana ruang ganti semakin solid! (+10% Hubungan Rekan Tim).',
      Icons.restaurant,
      Colors.amber.shade800,
    );
  }
}
