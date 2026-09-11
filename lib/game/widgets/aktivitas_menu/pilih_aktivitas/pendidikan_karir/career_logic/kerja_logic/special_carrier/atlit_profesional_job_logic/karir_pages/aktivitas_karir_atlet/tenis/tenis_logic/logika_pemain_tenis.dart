// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/tenis/tenis_logic/logika_pemain_tenis.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'logika_ekskul_tenis.dart';

class LogikaPemainTenis {
  static int hitungPeluangDiterimaKontrak({
    required int usia,
    required int durasiKontrakTahun,
    bool isMelamarBaru = false,
    Character? character,
  }) {
    int chance = 80;
    if (isMelamarBaru && usia > 30) {
      chance = 15;
    } else if (usia <= 10) {
      chance = (durasiKontrakTahun == 1) ? 95 : 80;
    } else if (usia >= 11 && usia <= 15) {
      chance = (durasiKontrakTahun <= 2) ? 95 : 80;
    } else {
      chance = (durasiKontrakTahun <= 3) ? 90 : 75;
    }

    if (character != null) {
      return LogikaEkskulTenis.hitungPeluangDiterima(character, chance);
    }
    return chance;
  }

  static List<int> getOpsiDurasiKontrak(int usia) {
    if (usia <= 10) {
      return [1];
    } else if (usia >= 11 && usia <= 15) {
      return [2, 1];
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
    int grandSlamTitles = (appearances * (0.15 * formMultiplier)).round().clamp(0, appearances);

    final double avgRating = (6.6 + (fitnessFactor * 0.9) + (grandSlamTitles * 0.5)).clamp(5.0, 9.9);

    return {
      'age': usia,
      'team': teamName,
      'jobTitle': jobTitle,
      'appearances': appearances,
      'grandSlamTitles': grandSlamTitles,
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'leagueMatches': totalTurnamen,
    };
  }
}
