// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/balap/balap_logic/logika_pemain_balap.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/daftar_tim/database_tim_olahraga.dart';

class LogikaPemainBalap {
  /// Syarat usia minimal untuk bergabung sebagai pebalap (12 tahun)
  static const int minAge = 12;

  /// Peluang diterima kontrak balap motor/mobil.
  /// Tidak membutuhkan ekstrakurikuler sekolah, namun WAJIB berusia minimal 12 tahun.
  static int hitungPeluangDiterimaKontrak({
    required int usia,
    required int durasiKontrakTahun,
    bool isMelamarBaru = false,
    Character? character,
  }) {
    // Jika usia di bawah 12 tahun, peluang diterima adalah 0%
    if (usia < minAge) {
      return 0;
    }

    int chance = 85;
    if (isMelamarBaru && usia > 32) {
      chance = 20;
    } else if (usia >= 12 && usia <= 15) {
      chance = (durasiKontrakTahun <= 2) ? 90 : 75;
    } else if (usia >= 16 && usia <= 25) {
      chance = (durasiKontrakTahun <= 3) ? 95 : 85;
    } else if (usia >= 26 && usia <= 32) {
      chance = (durasiKontrakTahun <= 3) ? 90 : 75;
    } else {
      chance = (durasiKontrakTahun <= 2) ? 80 : 40;
    }

    return chance;
  }

  /// Opsi durasi kontrak yang tersedia berdasarkan usia pebalap
  static List<int> getOpsiDurasiKontrak(int usia) {
    if (usia < 12) {
      return [1];
    } else if (usia >= 12 && usia <= 15) {
      return [2, 1];
    } else if (usia >= 16 && usia <= 25) {
      return [3, 2, 1];
    } else {
      return [5, 4, 3, 2, 1];
    }
  }

  /// Perhitungan Simulasi Musim Balap (Podium, Pole Position, Lap Tercepat, Rating)
  static Map<String, dynamic> simulasiMusim({
    required int usia,
    required String teamName,
    required String jobTitle,
    required int totalSeriBalap,
    required int health,
    required int discipline,
    required Random rand,
  }) {
    final double fitnessFactor = (health + discipline) / 200.0;
    final int minAppearances = totalSeriBalap > 1 ? 1 : totalSeriBalap;
    int appearances = (totalSeriBalap * (0.85 + (fitnessFactor * 0.15))).round().clamp(minAppearances, totalSeriBalap);

    final int formRoll = rand.nextInt(100);
    double formMultiplier = 1.0;
    double ratingBonus = 0.0;

    if (formRoll < 20) {
      formMultiplier = 0.4 + (rand.nextDouble() * 0.2);
      ratingBonus = -1.0;
    } else if (formRoll > 80) {
      formMultiplier = 1.5 + (rand.nextDouble() * 0.4);
      ratingBonus = 1.2;
    } else {
      formMultiplier = 0.9 + (rand.nextDouble() * 0.2);
    }

    int podiums = (appearances * (0.35 * formMultiplier)).round().clamp(0, appearances);
    int polePositions = (appearances * (0.20 * formMultiplier)).round().clamp(0, appearances);
    int fastestLaps = (appearances * (0.15 * formMultiplier)).round().clamp(0, appearances);

    final double baseRating = 7.0 + (fitnessFactor * 0.7) + ratingBonus;
    final double avgRating = baseRating.clamp(5.0, 9.9);

    return {
      'age': usia,
      'team': teamName,
      'jobTitle': jobTitle,
      'appearances': appearances,
      'goals': podiums, // diset ke goals agar kompatibel dengan widget umum
      'podiums': podiums,
      'polePositions': polePositions,
      'fastestLaps': fastestLaps,
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'leagueMatches': totalSeriBalap,
    };
  }

  /// Menjalankan simulasi atlet balap musiman untuk karakter
  static void jalankanSimulasiMusim(Character character, List<String> events) {
    if (character.jobName == null) return;
    final String title = character.jobName!;
    if (!title.toLowerCase().contains('balap') && !title.toLowerCase().contains('formula') && !title.toLowerCase().contains('moto')) return;

    final rand = Random();
    String teamName = 'Tim Balap Utama';
    if (title.contains(' - ')) {
      teamName = title.split(' - ').last.trim();
    }

    final int totalTeams = TimOlahragaDatabase.getLeagueTeamCount(teamName);
    final int totalSeriBalap = totalTeams > 0 ? totalTeams * 2 : 20;

    character.currentAthleteStats = simulasiMusim(
      usia: character.age,
      teamName: teamName,
      jobTitle: title,
      totalSeriBalap: totalSeriBalap,
      health: character.health,
      discipline: character.discipline,
      rand: rand,
    );

    final int appearances = character.currentAthleteStats!['appearances'] as int;
    final int podiums = character.currentAthleteStats!['podiums'] as int;
    final int poles = character.currentAthleteStats!['polePositions'] as int;
    final double avgRating = character.currentAthleteStats!['rating'] as double;

    character.athleteSeasonStats.add(Map<String, dynamic>.from(character.currentAthleteStats!));

    final String notice = '🏎️ Statistik Seri Balap Usia ${character.age} ($teamName):\n'
        '• Race Diikuti: $appearances / $totalSeriBalap Seri\n'
        '• Podium: $podiums | Pole Position: $poles\n'
        '• Rating Rata-rata: ${avgRating.toStringAsFixed(1)} / 10.0 ⭐';
    character.pendingAthleteSeasonNotice = notice;
    character.inbox.add(notice);

    character.athleteContractYears -= 1;
  }
}
