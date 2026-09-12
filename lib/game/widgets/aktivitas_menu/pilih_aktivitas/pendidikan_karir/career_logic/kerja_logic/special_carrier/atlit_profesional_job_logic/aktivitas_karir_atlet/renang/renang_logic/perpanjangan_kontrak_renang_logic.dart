// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/renang/renang_logic/perpanjangan_kontrak_renang_logic.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'gaji_pemain_renang.dart';

class PerpanjanganKontrakRenangLogic {
  static void evaluasiPerpanjanganKontrak({
    required Character character,
    required String teamName,
    required String jobTitle,
    required double currentSeasonRating,
    required Random rand,
  }) {
    final int validYears = 2 + rand.nextInt(3);
    final int currentSalary = character.jobSalary ?? GajiPemainRenang.hitungGajiTahunanRenang(character);
    final int offeredSalary = (currentSalary * 1.15).round();

    character.pendingContractOffer = {
      'teamName': teamName,
      'offeredYears': validYears,
      'offeredSalary': offeredSalary,
      'currentSalary': currentSalary,
      'jobTitle': jobTitle,
    };
  }
}
