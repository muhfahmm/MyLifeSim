import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/daftar_tim/database_tim_olahraga.dart';
import 'perpanjangan_kontrak_logic.dart';

class LogikaPemainSepakbola {
  /// Peluang diterima kontrak berdasarkan usia pemain dan durasi kontrak
  static int hitungPeluangDiterimaKontrak({
    required int usia,
    required int durasiKontrakTahun,
    bool isMelamarBaru = false,
  }) {
    if (isMelamarBaru && usia > 25) {
      return 10;
    }

    if (usia <= 10) {
      if (durasiKontrakTahun == 1) return 95;
      return 80;
    } else if (usia >= 11 && usia <= 15) {
      if (durasiKontrakTahun == 2) return 90;
      if (durasiKontrakTahun == 1) return 95;
      return 80;
    } else if (usia >= 16 && usia <= 20) {
      if (durasiKontrakTahun == 5) return 85;
      if (durasiKontrakTahun == 4) return 80;
      if (durasiKontrakTahun == 3) return 90;
      if (durasiKontrakTahun == 2) return 95;
      if (durasiKontrakTahun == 1) return 95;
    } else if (usia >= 21 && usia <= 25) {
      if (durasiKontrakTahun == 5) return 70;
      if (durasiKontrakTahun == 4) return 80;
      if (durasiKontrakTahun == 3) return 90;
      if (durasiKontrakTahun == 2) return 95;
      if (durasiKontrakTahun == 1) return 95;
    } else if (usia >= 26 && usia <= 30) {
      if (durasiKontrakTahun == 5) return 55;
      if (durasiKontrakTahun == 4) return 80;
      if (durasiKontrakTahun == 3) return 90;
      if (durasiKontrakTahun == 2) return 95;
      if (durasiKontrakTahun == 1) return 95;
    } else if (usia >= 31) {
      if (durasiKontrakTahun == 5) return 25;
      if (durasiKontrakTahun == 4) return 30;
      if (durasiKontrakTahun == 3) return 90;
      if (durasiKontrakTahun == 2) return 90;
      if (durasiKontrakTahun == 1) return 80;
    }
    return 80;
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

  /// Mengecek apakah sisa masa kontrak pemain masih panjang (>= 4 tahun)
  static bool isKontrakMasihPanjang(int? sisaKontrakTahun) {
    if (sisaKontrakTahun == null) return false;
    return sisaKontrakTahun >= 4;
  }

  /// Mendapatkan persentase rasio penampilan dasar berdasarkan usia:
  /// Usia Muda (13-20 th): 80% (0.80)
  /// Usia Prima (21-30 th): 90% (0.90)
  /// Usia Tua (31+ th): 50% (0.50)
  static double getRasioPenampilanBerdasarkanUsia(int usia) {
    if (usia <= 20) {
      return 0.80; // Usia Muda
    } else if (usia <= 30) {
      return 0.90; // Usia Prima
    } else {
      return 0.50; // Usia Tua
    }
  }

  /// Perhitungan Simulasi Musim Sepakbola
  /// Menghasilkan statistik penampilan, gol, assist, dan rating per musim.
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
    final bool isStriker = jobUpper.contains('ST') || jobUpper.contains('LW') || jobUpper.contains('RW') || jobTitle.contains('Striker') || jobTitle.contains('Penyerang');
    final bool isMidfielder = jobUpper.contains('CM') || jobUpper.contains('CAM') || jobUpper.contains('CDM') || jobTitle.contains('Gelandang');

    // 1. Rasio dasar dari usia (80%, 90%, atau 50%)
    final double baseAgeRatio = getRasioPenampilanBerdasarkanUsia(usia);

    // Kebugaran & disiplin memberikan variasi (+/- 10%)
    final double fitnessFactor = (health + discipline) / 200.0;
    final double fitnessAdjustment = (fitnessFactor - 0.5) * 0.20; // -10% s/d +10%

    final double targetRatio = (baseAgeRatio + fitnessAdjustment).clamp(0.20, 1.0);

    final int minAppearances = totalPertandinganLiga > 1 ? 1 : totalPertandinganLiga;
    int appearances = (totalPertandinganLiga * targetRatio).round().clamp(minAppearances, totalPertandinganLiga);

    // 2. Performa Musim (Random Roll: Bagus, Normal, Buruk)
    // 0 = Buruk (Drop / statistik sedikit)
    // 1 = Normal
    // 2 = Sangat Bagus (Bisa melebih penampilan / sangat produktif)
    final int formRoll = rand.nextInt(100);
    double formMultiplier = 1.0;
    double ratingBonus = 0.0;

    if (formRoll < 20) {
      // 20% Peluang Musim Buruk / Drop
      formMultiplier = 0.35 + (rand.nextDouble() * 0.25); // 35% - 60% dari standar
      ratingBonus = -1.2 + (rand.nextDouble() * 0.5);
      // Penampilan juga bisa drop sedikit jika performa buruk
      appearances = (appearances * 0.85).round().clamp(1, totalPertandinganLiga);
    } else if (formRoll > 80) {
      // 20% Peluang Musim Sangat Bagus (Overperforming)
      formMultiplier = 1.4 + (rand.nextDouble() * 0.6); // 140% - 200% dari standar
      ratingBonus = 1.0 + (rand.nextDouble() * 1.0);
      // Penampilan maksimal
      appearances = totalPertandinganLiga;
    } else {
      // 60% Musim Normal
      formMultiplier = 0.85 + (rand.nextDouble() * 0.35); // 85% - 120%
      ratingBonus = (rand.nextDouble() * 0.8) - 0.4;
    }

    int goals = 0;
    int assists = 0;

    if (isStriker) {
      double baseGoalRatio = 0.40 * formMultiplier;
      double baseAssistRatio = 0.15 * formMultiplier;
      goals = (appearances * baseGoalRatio).round();
      assists = (appearances * baseAssistRatio).round();
    } else if (isMidfielder) {
      double baseGoalRatio = 0.15 * formMultiplier;
      double baseAssistRatio = 0.40 * formMultiplier;
      goals = (appearances * baseGoalRatio).round();
      assists = (appearances * baseAssistRatio).round();
    } else {
      // Bek / Kiper
      double baseGoalRatio = 0.04 * formMultiplier;
      double baseAssistRatio = 0.08 * formMultiplier;
      goals = (appearances * baseGoalRatio).round();
      assists = (appearances * baseAssistRatio).round();
    }

    // Rating rata-rata musim
    final double baseRating = 6.8 + (fitnessFactor * 0.8) + ratingBonus;
    final double avgRating = baseRating.clamp(5.2, 9.9);

    return {
      'age': usia,
      'team': teamName,
      'jobTitle': jobTitle,
      'appearances': appearances,
      'goals': goals,
      'assists': assists,
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'leagueMatches': totalPertandinganLiga,
    };
  }

  /// Menjalankan simulasi atlet tahunan untuk karakter
  static void jalankanSimulasiMusim(Character character, List<String> events) {
    if (character.jobName == null) return;
    final String title = character.jobName!;
    final String tUpper = title.toUpperCase();
    final bool isAthlete = tUpper.contains('ST') ||
        tUpper.contains('LW') ||
        tUpper.contains('RW') ||
        tUpper.contains('CAM') ||
        tUpper.contains('CM') ||
        tUpper.contains('CDM') ||
        tUpper.contains('CB') ||
        tUpper.contains('LB') ||
        tUpper.contains('RB') ||
        tUpper.contains('GK') ||
        title.contains('Striker') ||
        title.contains('Gelandang') ||
        title.contains('Bek') ||
        title.contains('Kiper') ||
        title.contains('Point Guard') ||
        title.contains('Shooting Guard') ||
        title.contains('Center') ||
        title.contains('Pebalap') ||
        title.contains('Petenis') ||
        title.contains('MMA') ||
        title.contains('Petinju') ||
        title.contains('Renang');

    if (!isAthlete) return;

    final rand = Random();
    String teamName = 'Klub Usia Muda';
    if (title.contains(' - ')) {
      teamName = title.split(' - ').last.trim();
    }

    final bool isSoccer = title.contains('Striker') || title.contains('Gelandang') || title.contains('Bek') || title.contains('Kiper');

    // Hitung total pertandingan secara dinamis dari jumlah tim yang ada di liga (Total Tim - 1 Tim User)
    final int totalTeamsInLeague = TimOlahragaDatabase.getLeagueTeamCount(teamName);
    final int maxLeagueMatches = isSoccer ? (totalTeamsInLeague - 1) : totalTeamsInLeague;

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
    final int goals = character.currentAthleteStats!['goals'] as int;
    final int assists = character.currentAthleteStats!['assists'] as int;
    final double avgRating = character.currentAthleteStats!['rating'] as double;

    character.athleteSeasonStats.add(Map<String, dynamic>.from(character.currentAthleteStats!));

    final String notice = '⚽ Statistik Musim Usia ${character.age} ($teamName):\n'
        '• Penampilan: $appearances / $maxLeagueMatches Laga\n'
        '• Gol: $goals Gol | Assist: $assists Assist\n'
        '• Performa Rata-rata: ${avgRating.toStringAsFixed(1)} / 10.0 ⭐';
    character.pendingAthleteSeasonNotice = notice;
    character.inbox.add(notice);

    // Pengurangan Durasi Kontrak Atlet & Penanganan Kontrak Habis
    character.athleteContractYears -= 1;
    if (character.athleteContractYears <= 0) {
      PerpanjanganKontrakLogic.evaluasiPerpanjanganKontrak(
        character: character,
        teamName: teamName,
        jobTitle: title,
        currentSeasonRating: avgRating,
        rand: rand,
      );
    }
  }
}

