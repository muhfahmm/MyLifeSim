// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/renang/action_menu/latihan_kondisi_fisik/physio_consultation_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PhysioConsultationAction {
  static void execute(BuildContext context, Character character, Function(String, String, IconData, Color) showResult) {
    character.health = (character.health + 8).clamp(0, 100);
    showResult(
      'Konsultasi Fisioterapis 🏥',
      'Tim medis mengecek kesehatan persendian dan bahu kamu.',
      Icons.local_hospital,
      Colors.redAccent,
    );
  }
}
