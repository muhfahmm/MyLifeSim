import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../../negosiasi_kontrak_tenis_modal.dart';

class NegotiateContractTenisAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.athleteContractYears >= 4) {
      showResult('Kontrak Masih Panjang 📝', 'Sisa kontrakmu masih panjang (${character.athleteContractYears} tahun). Manajemen menolak bernegosiasi.', Icons.info, Colors.blue);
      return;
    }

    final String teamName = character.jobName != null && character.jobName!.contains(' - ')
        ? character.jobName!.split(' - ').last
        : 'Klub';
    final int currentSalary = character.jobSalary ?? 10000;

    NegosiasiKontrakTenisModal.show(
      context: context,
      character: character,
      offerData: {
        'teamName': teamName,
        'offeredSalary': currentSalary,
        'offeredYears': 2,
        'jobTitle': character.jobName ?? 'Atlet',
      },
      onDone: onRefresh,
    );
  }
}
