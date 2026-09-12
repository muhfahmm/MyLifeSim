// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/tinju_mma/tinju_mma_logic/logika_pemain_tinju_mma.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'logika_ekskul_tinju_mma.dart';

class LogikaPemainTinjuMMA {
  static const int minAge = 16; // Wajib minimal 16 tahun untuk bertarung di ring/octagon

  static int hitungPeluangDiterimaKontrak({
    required int usia,
    required int durasiKontrakTahun,
    bool isMelamarBaru = false,
    Character? character,
  }) {
    if (usia < minAge) {
      return 0; // Tidak boleh di bawah 16 tahun
    }

    int chance = 80;
    if (isMelamarBaru && usia > 33) {
      chance = 15;
    } else if (usia >= 16 && usia <= 20) {
      chance = (durasiKontrakTahun <= 2) ? 90 : 75;
    } else {
      chance = (durasiKontrakTahun <= 3) ? 90 : 75;
    }

    if (character != null) {
      return LogikaEkskulTinjuMMA.hitungPeluangDiterima(character, chance);
    }
    return chance;
  }

  static List<int> getOpsiDurasiKontrak(int usia) {
    if (usia < 16) {
      return [1];
    } else {
      return [3, 2, 1];
    }
  }

  static Map<String, dynamic> simulasiMusim({
    required int usia,
    required String teamName,
    required String jobTitle,
    required int totalPertarungan,
    required int health,
    required int discipline,
    required Random rand,
  }) {
    final double fitnessFactor = (health + discipline) / 200.0;
    int appearances = (totalPertarungan * (0.80 + (fitnessFactor * 0.20))).round().clamp(1, totalPertarungan);

    final int formRoll = rand.nextInt(100);
    double formMultiplier = formRoll > 80 ? 1.4 : (formRoll < 20 ? 0.5 : 1.0);
    int wins = (appearances * (0.65 * formMultiplier)).round().clamp(0, appearances);
    int kos = (wins * (0.50 * formMultiplier)).round().clamp(0, wins);

    final double avgRating = (6.8 + (fitnessFactor * 0.8) + (kos * 0.4)).clamp(5.0, 9.9);

    return {
      'age': usia,
      'team': teamName,
      'jobTitle': jobTitle,
      'appearances': appearances,
      'wins': wins,
      'kos': kos,
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'leagueMatches': totalPertarungan,
    };
  }

  static void jalankanSimulasiMusim(Character character, List<String> events) {
    if (character.jobName == null) return;
    final String title = character.jobName!;
    if (!title.toLowerCase().contains('tinju') && !title.toLowerCase().contains('mma') && !title.toLowerCase().contains('boxing')) return;

    final rand = Random();
    String teamName = 'Promosi / Sasana Petarung';
    if (title.contains(' - ')) {
      teamName = title.split(' - ').last.trim();
    }

    character.currentAthleteStats = simulasiMusim(
      usia: character.age,
      teamName: teamName,
      jobTitle: title,
      totalPertarungan: 5,
      health: character.health,
      discipline: character.discipline,
      rand: rand,
    );

    final int appearances = character.currentAthleteStats!['appearances'] as int;
    final int wins = character.currentAthleteStats!['wins'] as int;
    final int kos = character.currentAthleteStats!['kos'] as int;
    final double avgRating = character.currentAthleteStats!['rating'] as double;

    character.athleteSeasonStats.add(Map<String, dynamic>.from(character.currentAthleteStats!));

    final String notice = '🥊 Statistik Musim Usia ${character.age} ($teamName):\n'
        '• Pertarungan Diikuti: $appearances / 5 Laga\n'
        '• Menang: $wins 🥊 | Menang KO: $kos 💥\n'
        '• Performa Rating: ${avgRating.toStringAsFixed(1)} / 10.0 ⭐';
    character.pendingAthleteSeasonNotice = notice;
    character.inbox.add(notice);

    character.athleteContractYears -= 1;
  }
}

