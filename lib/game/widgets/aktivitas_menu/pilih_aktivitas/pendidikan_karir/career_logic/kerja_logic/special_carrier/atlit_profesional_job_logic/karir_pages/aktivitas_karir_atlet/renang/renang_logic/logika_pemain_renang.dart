// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/renang_logic/logika_pemain_renang.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'logika_ekskul_renang.dart';

class LogikaPemainRenang {
  static int hitungPeluangDiterimaKontrak({
    required int usia,
    required int durasiKontrakTahun,
    bool isMelamarBaru = false,
    Character? character,
  }) {
    int chance = 80;
    if (isMelamarBaru && usia > 26) {
      chance = 15;
    } else if (usia <= 10) {
      chance = (durasiKontrakTahun == 1) ? 95 : 80;
    } else if (usia >= 11 && usia <= 15) {
      chance = (durasiKontrakTahun <= 2) ? 95 : 80;
    } else {
      chance = (durasiKontrakTahun <= 2) ? 90 : 75;
    }

    if (character != null) {
      return LogikaEkskulRenang.hitungPeluangDiterima(character, chance);
    }
    return chance;
  }

  static List<int> getOpsiDurasiKontrak(int usia) {
    if (usia <= 10) {
      return [1];
    } else if (usia >= 11 && usia <= 15) {
      return [2, 1];
    } else {
      return [3, 2, 1];
    }
  }

  static Map<String, dynamic> simulasiMusim({
    required int usia,
    required String teamName,
    required String jobTitle,
    required int totalPerlombaan,
    required int health,
    required int discipline,
    required Random rand,
  }) {
    final double fitnessFactor = (health + discipline) / 200.0;
    int appearances = (totalPerlombaan * (0.85 + (fitnessFactor * 0.15))).round().clamp(1, totalPerlombaan);

    final int formRoll = rand.nextInt(100);
    double formMultiplier = formRoll > 80 ? 1.4 : (formRoll < 20 ? 0.6 : 1.0);
    int goldMedals = (appearances * (0.30 * formMultiplier)).round().clamp(0, appearances);
    int totalMedals = (appearances * (0.60 * formMultiplier)).round().clamp(goldMedals, appearances);

    final double avgRating = (6.8 + (fitnessFactor * 0.8) + (goldMedals * 0.3)).clamp(5.0, 9.9);

    return {
      'age': usia,
      'team': teamName,
      'jobTitle': jobTitle,
      'appearances': appearances,
      'goldMedals': goldMedals,
      'totalMedals': totalMedals,
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'leagueMatches': totalPerlombaan,
    };
  }

  static void jalankanSimulasiMusim(Character character, List<String> events) {
    if (character.jobName == null) return;
    final String title = character.jobName!;
    if (!title.toLowerCase().contains('renang')) return;

    final rand = Random();
    String teamName = 'Klub Usia Muda';
    if (title.contains(' - ')) {
      teamName = title.split(' - ').last.trim();
    }

    character.currentAthleteStats = simulasiMusim(
      usia: character.age,
      teamName: teamName,
      jobTitle: title,
      totalPerlombaan: 10,
      health: character.health,
      discipline: character.discipline,
      rand: rand,
    );

    final int appearances = character.currentAthleteStats!['appearances'] as int;
    final int goldMedals = character.currentAthleteStats!['goldMedals'] as int;
    final int totalMedals = character.currentAthleteStats!['totalMedals'] as int;
    final double avgRating = character.currentAthleteStats!['rating'] as double;

    character.athleteSeasonStats.add(Map<String, dynamic>.from(character.currentAthleteStats!));

    final String notice = '🏊‍♂️ Statistik Musim Usia ${character.age} ($teamName):\n'
        '• Keikutsertaan: $appearances / 10 Perlombaan\n'
        '• Medali Emas: $goldMedals 🥇 | Total Medali: $totalMedals 🏅\n'
        '• Performa Rating: ${avgRating.toStringAsFixed(1)} / 10.0 ⭐';
    character.pendingAthleteSeasonNotice = notice;
    character.inbox.add(notice);

    character.athleteContractYears -= 1;
  }
}
