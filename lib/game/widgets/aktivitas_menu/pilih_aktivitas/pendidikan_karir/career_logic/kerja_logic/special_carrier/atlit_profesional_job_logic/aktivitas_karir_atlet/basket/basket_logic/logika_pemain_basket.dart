// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/basket/basket_logic/logika_pemain_basket.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/daftar_tim/database_tim_olahraga.dart';
import 'logika_ekskul_basket.dart';

class LogikaPemainBasket {
  /// Peluang diterima kontrak berdasarkan usia pemain dan durasi kontrak
  static int hitungPeluangDiterimaKontrak({
    required int usia,
    required int durasiKontrakTahun,
    bool isMelamarBaru = false,
    Character? character,
  }) {
    int chance = 80;
    if (isMelamarBaru && usia > 25) {
      chance = 10;
    } else if (usia <= 10) {
      chance = (durasiKontrakTahun == 1) ? 95 : 80;
    } else if (usia >= 11 && usia <= 15) {
      chance = (durasiKontrakTahun == 2 || durasiKontrakTahun == 1) ? 95 : 80;
    } else if (usia >= 16 && usia <= 20) {
      chance = (durasiKontrakTahun <= 2) ? 95 : 85;
    } else if (usia >= 21 && usia <= 25) {
      chance = (durasiKontrakTahun <= 2) ? 95 : 80;
    } else if (usia >= 26 && usia <= 30) {
      chance = (durasiKontrakTahun <= 2) ? 95 : 75;
    } else if (usia >= 31) {
      chance = (durasiKontrakTahun <= 2) ? 90 : 30;
    }

    if (character != null) {
      return LogikaEkskulBasket.hitungPeluangDiterimaBasket(character, chance);
    }

    return chance;
  }

  /// Opsi durasi kontrak yang tersedia berdasarkan usia pemain
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

  /// Rasio penampilan berdasarkan kelompok usia
  static double getRasioPenampilanBerdasarkanUsia(int usia) {
    if (usia <= 20) {
      return 0.80; // Usia Muda
    } else if (usia <= 30) {
      return 0.90; // Usia Prima
    } else {
      return 0.50; // Usia Tua
    }
  }

  /// Perhitungan Simulasi Musim Basket (Poin, Rebound, Assist, Rating)
  static Map<String, dynamic> simulasiMusim({
    required int usia,
    required String teamName,
    required String jobTitle,
    required int totalPertandinganLiga,
    required int health,
    required int discipline,
    required Random rand,
  }) {
    final String jobUpper = jobTitle.toUpperCase();
    final bool isGuard = jobUpper.contains('POINT') || jobUpper.contains('SHOOTING') || jobUpper.contains('PG') || jobUpper.contains('SG');
    final bool isBigman = jobUpper.contains('CENTER') || jobUpper.contains('FORWARD') || jobUpper.contains('C') || jobUpper.contains('PF');

    final double baseAgeRatio = getRasioPenampilanBerdasarkanUsia(usia);
    final double fitnessFactor = (health + discipline) / 200.0;
    final double fitnessAdjustment = (fitnessFactor - 0.5) * 0.20;

    final double targetRatio = (baseAgeRatio + fitnessAdjustment).clamp(0.20, 1.0);
    final int minAppearances = totalPertandinganLiga > 1 ? 1 : totalPertandinganLiga;
    int appearances = (totalPertandinganLiga * targetRatio).round().clamp(minAppearances, totalPertandinganLiga);

    final int formRoll = rand.nextInt(100);
    double formMultiplier = 1.0;
    double ratingBonus = 0.0;

    if (formRoll < 20) {
      formMultiplier = 0.35 + (rand.nextDouble() * 0.25);
      ratingBonus = -1.2 + (rand.nextDouble() * 0.5);
      appearances = (appearances * 0.85).round().clamp(1, totalPertandinganLiga);
    } else if (formRoll > 80) {
      formMultiplier = 1.4 + (rand.nextDouble() * 0.6);
      ratingBonus = 1.0 + (rand.nextDouble() * 1.0);
      appearances = totalPertandinganLiga;
    } else {
      formMultiplier = 0.85 + (rand.nextDouble() * 0.35);
      ratingBonus = (rand.nextDouble() * 0.8) - 0.4;
    }

    int points = 0;
    int rebounds = 0;
    int assists = 0;

    if (isGuard) {
      points = (appearances * (18.0 * formMultiplier)).round();
      rebounds = (appearances * (4.0 * formMultiplier)).round();
      assists = (appearances * (8.0 * formMultiplier)).round();
    } else if (isBigman) {
      points = (appearances * (16.0 * formMultiplier)).round();
      rebounds = (appearances * (11.0 * formMultiplier)).round();
      assists = (appearances * (3.0 * formMultiplier)).round();
    } else {
      points = (appearances * (14.0 * formMultiplier)).round();
      rebounds = (appearances * (6.0 * formMultiplier)).round();
      assists = (appearances * (5.0 * formMultiplier)).round();
    }

    final double baseRating = 6.8 + (fitnessFactor * 0.8) + ratingBonus;
    final double avgRating = baseRating.clamp(5.2, 9.9);

    return {
      'age': usia,
      'team': teamName,
      'jobTitle': jobTitle,
      'appearances': appearances,
      'points': points,
      'rebounds': rebounds,
      'assists': assists,
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'leagueMatches': totalPertandinganLiga,
    };
  }

  /// Menjalankan simulasi atlet basket musiman untuk karakter
  static void jalankanSimulasiMusim(Character character, List<String> events) {
    if (character.jobName == null) return;
    final String title = character.jobName!;
    if (!title.toLowerCase().contains('basket')) return;

    final rand = Random();
    String teamName = 'Klub Usia Muda';
    if (title.contains(' - ')) {
      teamName = title.split(' - ').last.trim();
    }

    final int totalTeamsInLeague = TimOlahragaDatabase.getLeagueTeamCount(teamName);
    final int maxLeagueMatches = totalTeamsInLeague > 0 ? totalTeamsInLeague * 2 : 40;

    character.currentAthleteStats = simulasiMusim(
      usia: character.age,
      teamName: teamName,
      jobTitle: title,
      totalPertandinganLiga: maxLeagueMatches,
      health: character.health,
      discipline: character.discipline,
      rand: rand,
    );

    final int appearances = character.currentAthleteStats!['appearances'] as int;
    final int points = character.currentAthleteStats!['points'] as int;
    final int rebounds = character.currentAthleteStats!['rebounds'] as int;
    final int assists = character.currentAthleteStats!['assists'] as int;
    final double avgRating = character.currentAthleteStats!['rating'] as double;

    character.athleteSeasonStats.add(Map<String, dynamic>.from(character.currentAthleteStats!));

    final String notice = '🏀 Statistik Musim Usia ${character.age} ($teamName):\n'
        '• Penampilan: $appearances / $maxLeagueMatches Laga\n'
        '• Poin: $points Pts | Rebound: $rebounds Reb | Assist: $assists Ast\n'
        '• Rating Rata-rata: ${avgRating.toStringAsFixed(1)} / 10.0 ⭐';
    character.pendingAthleteSeasonNotice = notice;
    character.inbox.add(notice);

    character.athleteContractYears -= 1;
  }
}
