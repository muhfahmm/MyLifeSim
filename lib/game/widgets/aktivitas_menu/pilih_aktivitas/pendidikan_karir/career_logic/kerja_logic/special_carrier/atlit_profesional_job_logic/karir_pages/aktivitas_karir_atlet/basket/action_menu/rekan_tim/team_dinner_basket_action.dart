// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/basket/action_menu/rekan_tim/team_dinner_basket_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class TeamDinnerBasketAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.money < 300) {
      showResult('Uang Tidak Cukup 💵', 'Kamu membutuhkan \$300 untuk mentraktir makan malam tim basket.', Icons.warning, Colors.red);
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
      'Makan Malam Tim Basket 🥩🍷',
      'Kamu mengajak tim basket utama & cadangan makan malam bersama. Chemistry & suasana ruang ganti makin solid!',
      Icons.restaurant,
      Colors.amber.shade800,
    );
  }
}
