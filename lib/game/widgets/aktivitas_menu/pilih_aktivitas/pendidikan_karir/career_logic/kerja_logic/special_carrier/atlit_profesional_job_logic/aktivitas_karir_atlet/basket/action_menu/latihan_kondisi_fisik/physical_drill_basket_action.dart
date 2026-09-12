// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/basket/action_menu/latihan_kondisi_fisik/physical_drill_basket_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PhysicalDrillBasketAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.health < 20) {
      showResult('Stamina Lemah ⚠️', 'Kebugaran fisik terlalu rendah untuk latihan fisik intensif.', Icons.warning, Colors.red);
      return;
    }
    character.health = (character.health - 12).clamp(0, 100);
    character.discipline = (character.discipline + 5).clamp(0, 100);
    onRefresh();

    showResult(
      'Latihan Kecepatan & Sprint Lay-up 🏃‍♂️',
      'Melatih daya tahan fisik, sprint transisi cepat, dan ketangkasan lay-up di bawah tekanan lawan.',
      Icons.speed,
      Colors.deepOrange,
    );
  }
}
