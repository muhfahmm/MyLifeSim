// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/bulutangkis/bulutangkis_logic/logika_pemain_bulutangkis.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'logika_ekskul_bulutangkis.dart';

class LogikaPemainBulutangkis {
  static int hitungPeluangDiterimaKontrak({
    required int usia,
    required int durasiKontrakTahun,
    bool isMelamarBaru = false,
    Character? character,
  }) {
    int chance = 80;
    if (isMelamarBaru && usia > 28) {
      chance = 15;
    } else if (usia <= 10) {
      chance = (durasiKontrakTahun == 1) ? 95 : 80;
    } else if (usia >= 11 && usia <= 15) {
      chance = (durasiKontrakTahun <= 2) ? 95 : 80;
    } else if (usia >= 16 && usia <= 20) {
      chance = (durasiKontrakTahun <= 2) ? 95 : 85;
    } else {
      chance = (durasiKontrakTahun <= 2) ? 90 : 75;
    }

    if (character != null) {
      return LogikaEkskulBulutangkis.hitungPeluangDiterima(character, chance);
    }
    return chance;
  }

  static List<int> getOpsiDurasiKontrak(int usia) {
    if (usia <= 10) {
      return [1];
    } else if (usia >= 11 && usia <= 15) {
      return [2, 1];
    } else if (usia >= 16 && usia <= 19) {
      return [3, 2, 1];
    } else {
      return [5, 4, 3, 2, 1];
    }
  }

  static Map<String, dynamic> simulasiMusim({
    required int usia,
    required String teamName,
    required String jobTitle,
    required int totalTurnamen,
    required int health,
    required int discipline,
    required Random rand,
  }) {
    final double fitnessFactor = (health + discipline) / 200.0;
    int appearances = (totalTurnamen * (0.80 + (fitnessFactor * 0.20))).round().clamp(1, totalTurnamen);

    final int formRoll = rand.nextInt(100);
    double formMultiplier = formRoll > 80 ? 1.5 : (formRoll < 20 ? 0.5 : 1.0);
    int titles = (appearances * (0.25 * formMultiplier)).round().clamp(0, appearances);
    int runnerUps = (appearances * (0.20 * formMultiplier)).round().clamp(0, appearances);

    final double avgRating = (6.5 + (fitnessFactor * 1.0) + (titles * 0.4)).clamp(5.0, 9.9);

    return {
      'age': usia,
      'team': teamName,
      'jobTitle': jobTitle,
      'appearances': appearances,
      'titles': titles,
      'runnerUps': runnerUps,
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'leagueMatches': totalTurnamen,
    };
  }
}
