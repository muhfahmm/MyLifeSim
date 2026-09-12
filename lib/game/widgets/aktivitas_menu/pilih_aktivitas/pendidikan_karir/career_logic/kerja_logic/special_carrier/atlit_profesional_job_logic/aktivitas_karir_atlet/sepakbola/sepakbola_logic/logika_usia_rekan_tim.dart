// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/sepakbola_logic/logika_usia_rekan_tim.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class LogikaUsiaRekanTim {
  /// Mendapatkan nama kategori tim berdasarkan usia pemain dan peluang promosi:
  /// • Usia 6 - 9 tahun   : Tim U-6
  /// • Usia 10 - 15 tahun : Tim U-12
  /// • Usia 16 - 19 tahun : Tim U-16 (berpeluang masuk Tim Utama jika performa/hoki tinggi)
  /// • Usia 20 - 22 tahun : Tim U-20 (berpeluang masuk Tim Utama)
  /// • Usia 23+ tahun     : Tim Utama
  static String getKategoriTimBerdasarkanUsia({
    required int usia,
    double rating = 7.0,
    Random? rand,
  }) {
    final Random random = rand ?? Random();

    if (usia >= 6 && usia <= 9) {
      return 'Tim U-6';
    } else if (usia >= 10 && usia <= 15) {
      return 'Tim U-12';
    } else if (usia >= 16 && usia <= 19) {
      // Peluang dimasukkan ke Tim Utama di usia 16-19 tahun (misal 25% dasar + bonus rating)
      final double promotionChance = 25 + (rating >= 7.5 ? 20 : 0);
      final double roll = random.nextDouble() * 100;
      if (roll < promotionChance) {
        return 'Tim Utama';
      }
      return 'Tim U-16';
    } else if (usia >= 20 && usia <= 22) {
      // Peluang dimasukkan ke Tim Utama di usia 20-22 tahun (misal 50% dasar)
      final double promotionChance = 50 + (rating >= 7.0 ? 25 : 0);
      final double roll = random.nextDouble() * 100;
      if (roll < promotionChance) {
        return 'Tim Utama';
      }
      return 'Tim U-20';
    } else {
      return 'Tim Utama';
    }
  }

  /// Mengecek apakah pemain di usia 16-19 tahun berpeluang dipromosikan ke Tim Utama
  static bool cekPeluangPromosiTimUtama({
    required int usia,
    required double rating,
    Random? rand,
  }) {
    if (usia < 16) return false;
    if (usia >= 23) return true;

    final Random random = rand ?? Random();
    int baseChance = 0;
    if (usia >= 16 && usia <= 19) {
      baseChance = 30; // 30% peluang promosi
    } else if (usia >= 20 && usia <= 22) {
      baseChance = 60; // 60% peluang promosi
    }

    if (rating >= 8.0) {
      baseChance += 25;
    } else if (rating >= 7.0) {
      baseChance += 10;
    }

    return random.nextInt(100) < baseChance;
  }

  /// Generate rentang usia rekan tim yang mendekati usia user
  static int generateUsiaRekanTim({
    required int userAge,
    Random? rand,
  }) {
    final Random random = rand ?? Random();

    if (userAge >= 6 && userAge <= 9) {
      final int minA = max(6, userAge - 1);
      final int maxA = min(9, userAge + 2);
      final int range = max(1, maxA - minA);
      return minA + random.nextInt(range);
    } else if (userAge >= 10 && userAge <= 15) {
      final int minA = max(10, userAge - 2);
      final int maxA = min(15, userAge + 2);
      final int range = max(1, maxA - minA);
      return minA + random.nextInt(range);
    } else if (userAge >= 16 && userAge <= 19) {
      final int minA = max(16, userAge - 2);
      final int maxA = min(19, userAge + 2);
      final int range = max(1, maxA - minA);
      return minA + random.nextInt(range);
    } else if (userAge >= 20 && userAge <= 22) {
      final int minA = max(20, userAge - 2);
      final int maxA = min(22, userAge + 2);
      final int range = max(1, maxA - minA);
      return minA + random.nextInt(range);
    } else {
      return 18 + random.nextInt(18); // Usia 18 - 35 tahun (Tim Utama)
    }
  }

  /// Menyelaraskan usia rekan tim dengan usia user terkini jika terjadi perbedaan yang signifikan
  static void syncTeammateAges(Character character) {
    if (character.jobName == null || character.coworkers.isEmpty) return;
    final String job = character.jobName!;
    final bool isAthlete = job.contains('Sepakbola') ||
        job.contains('Basket') ||
        job.contains('Pemain') ||
        job.contains('Striker') ||
        job.contains('Gelandang') ||
        job.contains('Bek') ||
        job.contains('Kiper') ||
        job.contains('Point Guard') ||
        job.contains('Shooting Guard') ||
        job.contains('Center') ||
        job.contains('Pebalap') ||
        job.contains('Petenis') ||
        job.contains('MMA') ||
        job.contains('Petinju') ||
        job.contains('Renang');

    if (!isAthlete) return;

    final int userAge = character.age;
    final String targetCat = getKategoriTimBerdasarkanUsia(usia: userAge);
    final random = Random();

    for (final cw in character.coworkers) {
      final int currentCwAge = int.tryParse(cw['age'] ?? '20') ?? 20;

      // Jika user berusia di bawah 18 tahun dan usia rekan tim jauh melebihi batas kelompok usia user
      if (userAge < 18 && (currentCwAge >= 18 || (currentCwAge - userAge).abs() > 3)) {
        final int newAge = generateUsiaRekanTim(userAge: userAge, rand: random);
        cw['age'] = newAge.toString();
        final bool isCadangan = cw['role'] == 'Pemain Cadangan' || (cw['teamCategory']?.contains('Cadangan') ?? false);
        cw['teamCategory'] = isCadangan ? '$targetCat (Cadangan)' : targetCat;
      }
    }
  }
}

