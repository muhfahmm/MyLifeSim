// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/balap/action_menu/latihan_kondisi_fisik/track_drill_balap_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class TrackDrillBalapAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.health < 15) {
      showResult('Stamina Lemah ⚠️', 'Fisik terlalu lelah untuk sesi latihan di sirkuit balap.', Icons.warning, Colors.red);
      return;
    }
    character.health = (character.health - 10).clamp(0, 100);
    character.discipline = (character.discipline + 4).clamp(0, 100);
    onRefresh();

    showResult(
      'Latihan Simulasi Lap Sirkuit 🏎️',
      'Melatih garis balap (racing line), pengereman mendadak (trail braking), dan reflekstik overtaking di lintasan sirkuit!',
      Icons.sports_motorsports,
      Colors.red,
    );
  }
}
