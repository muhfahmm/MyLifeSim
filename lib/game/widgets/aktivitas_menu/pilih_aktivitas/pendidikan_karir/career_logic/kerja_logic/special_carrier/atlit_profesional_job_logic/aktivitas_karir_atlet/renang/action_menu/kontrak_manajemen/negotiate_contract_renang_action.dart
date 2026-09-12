// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/renang/action_menu/kontrak_manajemen/negotiate_contract_renang_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class NegotiateContractRenangAction {
  static void execute(BuildContext context, Character character, Function(String, String, IconData, Color) showResult) {
    showResult(
      'Negosiasi Kontrak Renang 📝',
      'Kamu mendiskusikan klausul dan bonus medali dengan manajemen klub renang.',
      Icons.assignment,
      Colors.blue,
    );
  }
}
