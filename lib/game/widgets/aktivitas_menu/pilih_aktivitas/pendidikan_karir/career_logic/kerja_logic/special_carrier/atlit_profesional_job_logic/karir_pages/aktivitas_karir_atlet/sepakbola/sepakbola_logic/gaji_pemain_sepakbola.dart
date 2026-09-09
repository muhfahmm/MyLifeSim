// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/sepakbola_logic/gaji_pemain_sepakbola.dart

import 'dart:math';

class GajiPemainSepakbolaLogic {
  /// Menghitung standar gaji default (USD/tahun) pemain sepakbola berdasarkan rentang usia:
  /// • Usia 13 - 20 th: $1,000 - $2,000
  /// • Usia 21 - 25 th: $3,000 - $15,000
  /// • Usia 26 - 30 th: $5,000 - $10,000
  /// • Usia 31 - 40 th: $1,000 - $2,500
  static int hitungGajiBerdasarkanUsia({
    required int usia,
    Random? rand,
  }) {
    final Random random = rand ?? Random();
    int minSalary = 1000;
    int maxSalary = 2000;

    if (usia >= 13 && usia <= 20) {
      minSalary = 1000;
      maxSalary = 2000;
    } else if (usia >= 21 && usia <= 25) {
      minSalary = 3000;
      maxSalary = 15000;
    } else if (usia >= 26 && usia <= 30) {
      minSalary = 5000;
      maxSalary = 10000;
    } else if (usia >= 31 && usia <= 40) {
      minSalary = 1000;
      maxSalary = 2500;
    } else if (usia > 40) {
      minSalary = 800;
      maxSalary = 1500;
    } else {
      // Usia di bawah 13 tahun (misal akademi dini)
      minSalary = 500;
      maxSalary = 1000;
    }

    final int salaryRange = maxSalary - minSalary;
    return minSalary + random.nextInt(salaryRange + 1);
  }

  /// Menghitung tawaran gaji baru untuk perpanjangan kontrak berdasarkan rentang usia & rating karir
  static int hitungTawaranGajiBaru({
    required int currentSalary,
    required int usia,
    required double rating,
    Random? rand,
  }) {
    final Random random = rand ?? Random();
    final int minAgeSalary = getMinGajiUsia(usia);
    final int maxAgeSalary = getMaxGajiUsia(usia);

    // Kenaikan performa berdasarkan rating karir
    double raiseMultiplier = 1.0;
    if (rating >= 8.5) {
      raiseMultiplier = 1.20 + (random.nextDouble() * 0.15); // +20% s/d +35%
    } else if (rating >= 7.5) {
      raiseMultiplier = 1.10 + (random.nextDouble() * 0.10); // +10% s/d +20%
    } else if (rating >= 6.5) {
      raiseMultiplier = 1.02 + (random.nextDouble() * 0.05); // +2% s/d +7%
    } else {
      raiseMultiplier = 0.90 + (random.nextDouble() * 0.08); // -10% s/d -2%
    }

    int baseSalary = currentSalary > 0 ? currentSalary : minAgeSalary;
    int offeredSalary = (baseSalary * raiseMultiplier).round();

    // Pastikan gaji tidak jatuh di bawah batas minimal usia dan tidak melampaui batas wajar
    if (offeredSalary < minAgeSalary) {
      offeredSalary = minAgeSalary;
    } else if (offeredSalary > maxAgeSalary * 2) {
      offeredSalary = maxAgeSalary * 2;
    }

    return offeredSalary;
  }

  static int getMinGajiUsia(int usia) {
    if (usia <= 20) return 1000;
    if (usia <= 25) return 3000;
    if (usia <= 30) return 5000;
    return 1000;
  }

  static int getMaxGajiUsia(int usia) {
    if (usia <= 20) return 2000;
    if (usia <= 25) return 15000;
    if (usia <= 30) return 10000;
    return 2500;
  }
}
