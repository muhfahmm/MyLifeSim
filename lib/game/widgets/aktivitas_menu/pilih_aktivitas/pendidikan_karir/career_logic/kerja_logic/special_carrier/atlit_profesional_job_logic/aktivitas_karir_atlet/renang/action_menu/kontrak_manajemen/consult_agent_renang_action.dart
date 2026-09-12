// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/renang/action_menu/kontrak_manajemen/consult_agent_renang_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class ConsultAgentRenangAction {
  static void execute(BuildContext context, Character character, Function(String, String, IconData, Color) showResult) {
    showResult(
      'Konsultasi Agen Renang 👔',
      'Agenmu memberikan masukan mengenai sponsor baju renang dan jadwal kejuaraan.',
      Icons.support_agent,
      Colors.indigo,
    );
  }
}
