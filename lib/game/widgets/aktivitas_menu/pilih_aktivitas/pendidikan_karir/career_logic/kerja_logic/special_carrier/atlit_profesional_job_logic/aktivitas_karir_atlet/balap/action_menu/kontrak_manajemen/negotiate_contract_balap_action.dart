// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/balap/action_menu/kontrak_manajemen/negotiate_contract_balap_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../../negosiasi_kontrak_balap_modal.dart';

class NegotiateContractBalapAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.athleteContractYears >= 4) {
      showResult('Kontrak Masih Panjang 📝', 'Sisa kontrakmu di tim balap masih panjang (${character.athleteContractYears} tahun). Manajemen menolak bernegosiasi.', Icons.info, Colors.blue);
      return;
    }

    final String teamName = character.jobName != null && character.jobName!.contains(' - ')
        ? character.jobName!.split(' - ').last
        : 'Tim Balap';
    final int currentSalary = character.jobSalary ?? 20000;

    NegosiasiKontrakBalapModal.show(
      context: context,
      character: character,
      offerData: {
        'teamName': teamName,
        'offeredSalary': currentSalary,
        'offeredYears': 2,
        'jobTitle': character.jobName ?? 'Pebalap Profesional',
      },
      onDone: onRefresh,
    );
  }
}
