// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/balap/balap_logic/gaji_pemain_balap.dart

import 'dart:math';

class GajiPemainBalapLogic {
  static int hitungGajiBerdasarkanUsia({
    required int usia,
    required Random rand,
  }) {
    if (usia <= 14) {
      return 5000 + rand.nextInt(3000);
    } else if (usia <= 18) {
      return 12000 + rand.nextInt(5000);
    } else if (usia <= 25) {
      return 25000 + rand.nextInt(15000);
    } else {
      return 35000 + rand.nextInt(20000);
    }
  }

  static int hitungTawaranGajiBaru({
    required int currentSalary,
    required int usia,
    required double rating,
    required Random rand,
  }) {
    double multiplier = 1.0;
    if (rating >= 8.5) {
      multiplier = 1.35 + (rand.nextDouble() * 0.25);
    } else if (rating >= 7.0) {
      multiplier = 1.15 + (rand.nextDouble() * 0.15);
    } else {
      multiplier = 0.95 + (rand.nextDouble() * 0.1);
    }

    return (currentSalary * multiplier).round();
  }
}
