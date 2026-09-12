// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/catur/catur_logic/logika_pemain_catur.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'logika_ekskul_catur.dart';

class LogikaPemainCatur {
  static int hitungPeluangDiterimaKontrak({
    required int usia,
    required int durasiKontrakTahun,
    bool isMelamarBaru = false,
    Character? character,
  }) {
    int chance = 80;
    if (isMelamarBaru && usia > 35) {
      chance = 20;
    } else if (usia <= 10) {
      chance = (durasiKontrakTahun == 1) ? 95 : 80;
    } else if (usia >= 11 && usia <= 15) {
      chance = (durasiKontrakTahun <= 2) ? 95 : 80;
    } else {
      chance = (durasiKontrakTahun <= 3) ? 90 : 75;
    }

    if (character != null) {
      return LogikaEkskulCatur.hitungPeluangDiterima(character, chance);
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
    required int totalPertandingan,
    required int health,
    required int discipline,
    required Random rand,
  }) {
    final double fitnessFactor = (health + discipline) / 200.0;
    int appearances = (totalPertandingan * (0.85 + (fitnessFactor * 0.15))).round().clamp(1, totalPertandingan);

    final int formRoll = rand.nextInt(100);
    double formMultiplier = formRoll > 80 ? 1.4 : (formRoll < 20 ? 0.6 : 1.0);
    int wins = (appearances * (0.50 * formMultiplier)).round().clamp(0, appearances);
    int draws = (appearances * (0.30 * formMultiplier)).round().clamp(0, appearances - wins);
    int losses = (appearances - wins - draws).clamp(0, appearances);

    final double avgRating = (7.0 + (fitnessFactor * 0.8) + (wins * 0.2)).clamp(5.0, 9.9);

    return {
      'age': usia,
      'team': teamName,
      'jobTitle': jobTitle,
      'appearances': appearances,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'leagueMatches': totalPertandingan,
    };
  }

  static void jalankanSimulasiMusim(Character character, List<String> events) {
    if (character.jobName == null) return;
    final String title = character.jobName!;
    if (!title.toLowerCase().contains('catur') && !title.toLowerCase().contains('chess')) return;

    final rand = Random();
    String teamName = 'Klub Catur';
    if (title.contains(' - ')) {
      teamName = title.split(' - ').last.trim();
    }

    character.currentAthleteStats = simulasiMusim(
      usia: character.age,
      teamName: teamName,
      jobTitle: title,
      totalPertandingan: 15,
      health: character.health,
      discipline: character.discipline,
      rand: rand,
    );

    final int appearances = character.currentAthleteStats!['appearances'] as int;
    final int wins = character.currentAthleteStats!['wins'] as int;
    final int draws = character.currentAthleteStats!['draws'] as int;
    final int losses = character.currentAthleteStats!['losses'] as int;
    final double avgRating = character.currentAthleteStats!['rating'] as double;

    character.athleteSeasonStats.add(Map<String, dynamic>.from(character.currentAthleteStats!));

    final String notice = '♟️ Statistik Musim Usia ${character.age} ($teamName):\n'
        '• Pertandingan Diikuti: $appearances / 15 Game\n'
        '• Menang: $wins 🏆 | Seri: $draws 🤝 | Kalah: $losses ❌\n'
        '• Performa Rating: ${avgRating.toStringAsFixed(1)} / 10.0 ⭐';
    character.pendingAthleteSeasonNotice = notice;
    character.inbox.add(notice);

    character.athleteContractYears -= 1;
  }
}
