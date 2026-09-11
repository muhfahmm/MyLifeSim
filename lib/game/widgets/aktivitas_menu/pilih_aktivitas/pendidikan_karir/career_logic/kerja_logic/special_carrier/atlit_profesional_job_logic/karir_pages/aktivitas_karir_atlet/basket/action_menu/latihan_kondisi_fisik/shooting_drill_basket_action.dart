// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/basket/action_menu/latihan_kondisi_fisik/shooting_drill_basket_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class ShootingDrillBasketAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.health < 15) {
      showResult('Stamina Lemah ⚠️', 'Kebugaran fisik terlalu rendah untuk latihan tembakan.', Icons.warning, Colors.red);
      return;
    }
    character.health = (character.health - 8).clamp(0, 100);
    character.discipline = (character.discipline + 3).clamp(0, 100);
    onRefresh();

    showResult(
      'Latihan Jump Shot & 3-Pointer 🏀',
      'Melatih 200 tembakan tiga angka dan jump shot dari berbagai sudut. Akurasi tembakan dan disiplin meningkat!',
      Icons.sports_basketball,
      Colors.orange,
    );
  }
}
