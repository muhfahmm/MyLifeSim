// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/daftar_tim/basket/basket_logic/logika_pemain_basket.dart

import 'dart:math';

class LogikaPemainBasket {
  static int hitungPeluangDiterimaKontrak({
    required int usia,
    required int durasiKontrakTahun,
  }) {
    if (usia >= 31) {
      if (durasiKontrakTahun == 5) return 25;
      if (durasiKontrakTahun == 4) return 30;
      if (durasiKontrakTahun == 3) return 90;
      if (durasiKontrakTahun == 2) return 60;
      if (durasiKontrakTahun == 1) return 80;
    }
    return 80;
  }

  static List<int> getOpsiDurasiKontrak(int usia) {
    if (usia >= 31) {
      return [5, 4, 3, 2, 1];
    }
    return [5, 4, 3];
  }

  static double getRasioPenampilanBerdasarkanUsia(int usia) {
    if (usia <= 20) {
      return 0.80;
    } else if (usia <= 30) {
      return 0.90;
    } else {
      return 0.50;
    }
  }

  static Map<String, dynamic> simulasiMusim({
    required int usia,
    required String teamName,
    required String jobTitle,
    required int totalPertandinganLiga,
    required int health,
    required int discipline,
    required Random rand,
  }) {
    return {
      'age': usia,
      'team': teamName,
      'jobTitle': jobTitle,
      'appearances': totalPertandinganLiga,
      'goals': 0,
      'assists': 0,
      'rating': 7.5,
      'leagueMatches': totalPertandinganLiga,
    };
  }
}
