// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/idol_logic/persentase_tawaran_idol.dart
//
// Menghitung probabilitas kemunculan event tawaran menjadi idol dari General Manager.
// Hanya untuk karakter perempuan berusia 10–15 tahun.
// Base chance: 25% – 40% tergantung atribut karakter.

import 'package:mylifesim/pilih_karakter/character.dart';

class PersentaseTawaranIdol {
  // ================================================================
  // KONSTANTA
  // ================================================================

  /// Batas usia minimum untuk tawaran idol (inklusif).
  static const int minAge = 10;

  /// Batas usia maksimum untuk tawaran idol (inklusif).
  static const int maxAge = 15;

  /// Base chance terendah (%).
  static const double baseChanceMin = 25.0;

  /// Base chance tertinggi (%). Dicapai jika semua atribut maksimal.
  static const double baseChanceMax = 40.0;

  // ================================================================
  // MAIN API
  // ================================================================

  /// Apakah karakter memenuhi syarat DASAR untuk mendapat tawaran idol?
  /// (Perempuan, usia 10–15, belum berstatus idol/artis.)
  static bool memenuhiSyarat(Character character) {
    final bool isPerempuan = character.gender.toLowerCase() == 'perempuan';
    final int age = character.age;
    final bool sudahJadiIdol = character.ownedLicenses.contains('Idol');
    return isPerempuan && age >= minAge && age <= maxAge && !sudahJadiIdol;
  }

  /// Menghitung persentase kemunculan event (0–100).
  /// Semakin tinggi kecerdasan, tampilan, dan keberuntungan → semakin besar.
  static int hitungProbabilitas(Character character) {
    if (!memenuhiSyarat(character)) return 0;

    // Spread berdasarkan usia: usia 12–13 adalah prime time
    double ageFactor = _getAgeFactor(character.age);

    // Kecerdasan mempengaruhi potensi belajar vokal/akting
    int kecerdasan = character.intelligence;
    double kecerdasanFactor = _normalizeAttr(kecerdasan); // 0.0–1.0

    // Kebahagiaan (sebagai proxy daya tarik / aura positif)
    int kebahagiaan = character.happiness;
    double kebahagiaanFactor = _normalizeAttr(kebahagiaan);

    // Kesehatan (stamina untuk latihan intensif)
    int kesehatan = character.health;
    double kesehatanFactor = _normalizeAttr(kesehatan);

    // Weighted average dari atribut (kecerdasan paling penting)
    double atributScore =
        (kecerdasanFactor * 0.5) + (kebahagiaanFactor * 0.3) + (kesehatanFactor * 0.2);

    // Interpolasi antara baseChanceMin dan baseChanceMax
    double spread = baseChanceMax - baseChanceMin;
    double probabilitas =
        (baseChanceMin + (spread * atributScore)) * ageFactor;

    return probabilitas.clamp(0, 100).round();
  }

  /// Cek apakah event harus muncul berdasarkan roll acak.
  static bool apakahEventMuncul(Character character, int random0to99) {
    return random0to99 < hitungProbabilitas(character);
  }

  /// Menghitung persentase kelulusan saat pendaftaran manual/audisi (0–100%).
  static int hitungProbabilitasLamaran(Character character) {
    double base = 35.0;

    double healthBonus = (character.health.clamp(0, 100) / 100.0) * 15.0;
    double disciplineBonus = (character.discipline.clamp(0, 100) / 100.0) * 15.0;
    double intelBonus = (character.intelligence.clamp(0, 100) / 100.0) * 15.0;
    double happyBonus = (character.happiness.clamp(0, 100) / 100.0) * 15.0;

    double ageBonus = 0.0;
    if (character.age >= 12 && character.age <= 14) {
      ageBonus = 10.0;
    } else if (character.age >= 10 && character.age <= 17) {
      ageBonus = 5.0;
    }

    double total = base + healthBonus + disciplineBonus + intelBonus + happyBonus + ageBonus;
    if (character.ownedLicenses.contains('Idol') || character.hasGraduatedIdol) {
      total += 10.0;
    }

    return total.clamp(5, 95).round();
  }

  // ================================================================
  // INTERNAL HELPERS
  // ================================================================

  /// Factor berdasarkan usia. Usia 12–13 memiliki peluang lebih tinggi.
  static double _getAgeFactor(int age) {
    switch (age) {
      case 10: return 0.75;
      case 11: return 0.85;
      case 12: return 1.00;
      case 13: return 1.00;
      case 14: return 0.90;
      case 15: return 0.80;
      default: return 0.0;
    }
  }

  /// Normalisasi nilai atribut 0–100 menjadi 0.0–1.0.
  static double _normalizeAttr(int value) => value.clamp(0, 100) / 100.0;
}
