// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/basket/action_menu/kontrak_manajemen/negotiate_contract_basket_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../../negosiasi_kontrak_basket_modal.dart';

class NegotiateContractBasketAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.athleteContractYears >= 4) {
      showResult('Kontrak Masih Panjang 📝', 'Sisa kontrakmu di klub basket masih panjang (${character.athleteContractYears} tahun). Manajemen menolak bernegosiasi.', Icons.info, Colors.blue);
      return;
    }

    final String teamName = character.jobName != null && character.jobName!.contains(' - ')
        ? character.jobName!.split(' - ').last
        : 'Klub Basket';
    final int currentSalary = character.jobSalary ?? 10000;

    NegosiasiKontrakBasketModal.show(
      context: context,
      character: character,
      offerData: {
        'teamName': teamName,
        'offeredSalary': currentSalary,
        'offeredYears': 2,
        'jobTitle': character.jobName ?? 'Pemain Basket',
      },
      onDone: onRefresh,
    );
  }
}
