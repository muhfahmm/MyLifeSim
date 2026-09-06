// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/persentase_ajakan_luar_negeri.dart
//
// File ini bertanggung jawab menghitung PROBABILITAS kemunculan event
// "Orang Tua Mengajak ke Luar Negeri" setiap kali giliran (hari) berganti.
//
// Formula:
//   Probabilitas = (BaseChance * UsiaModifier) * EkonomiModifier * RelasiModifier
//
// Referensi: saran_deepseek.md

import 'package:mylifesim/pilih_karakter/character.dart';

class PersentaseAjakanLuarNegeri {
  // ================================================================
  // KONSTANTA BATAS
  // ================================================================

  /// Usia minimum untuk event ini (orang tua baru bisa mengajak setelah anak
  /// bisa memahami perjalanan).
  static const int minAge = 3;

  /// Usia maksimum anak masih dianggap "diajak" orang tua secara aktif.
  /// Di atas ini user dianggap sudah mandiri (urus paspor sendiri).
  static const int maxAge = 19;

  /// Biaya paspor anak yang ditanggung orang tua (dalam satuan uang game).
  static const int biayaPasporAnak = 350000;

  /// Biaya tiket + akomodasi yang ditanggung orang tua.
  static const int biayaPerjalanan = 1500000;

  // ================================================================
  // MAIN API
  // ================================================================

  /// Menghitung persentase (0–100) kemunculan event ajakan ke luar negeri
  /// pada giliran saat ini. Kembalikan 0 jika kondisi tidak memungkinkan.
  static int hitungProbabilitas(Character character) {
    final int age = character.age;

    // Tidak relevan jika di luar rentang usia
    if (age < minAge || age > maxAge) return 0;

    // Orang tua harus masih hidup (minimal salah satu)
    final bool adaAyah = character.fatherName != null &&
        !character.isFatherDeceased &&
        !character.isFatherImprisoned;
    final bool adaIbu =
        character.motherName != null && !character.isMotherDeceased;
    final bool adaAyahTiri = character.stepFatherName != null &&
        !character.isStepFatherDeceased;

    if (!adaAyah && !adaIbu && !adaAyahTiri) return 0;

    // ---- Base Chance berdasarkan usia ----
    double baseChance = _getBaseChance(age);

    // ---- Usia Modifier ----
    double usiaModifier = _getUsiaModifier(age);

    // ---- Ekonomi Modifier ----
    // Gunakan kekayaan ayah kandung atau ayah tiri sebagai acuan
    int kekayaanKeluarga = 0;
    if (adaAyah) {
      kekayaanKeluarga = character.getFatherWealth();
    } else if (adaAyahTiri) {
      kekayaanKeluarga = character.getStepFatherWealth();
    }
    double ekonomiModifier = _getEkonomiModifier(kekayaanKeluarga);

    // ---- Relasi Modifier ----
    // Ambil hubungan terbaik dengan orang tua yang masih ada
    int relasiTerbaik = 0;
    if (adaAyah) {
      relasiTerbaik =
          _max(relasiTerbaik, character.fatherRelationship ?? 50);
    }
    if (adaIbu) {
      relasiTerbaik =
          _max(relasiTerbaik, character.motherRelationship ?? 50);
    }
    if (adaAyahTiri) {
      relasiTerbaik =
          _max(relasiTerbaik, character.stepFatherRelationship ?? 40);
    }
    double relasiModifier = _getRelasiModifier(relasiTerbaik);

    // ---- Hitung Akhir ----
    double probabilitas =
        baseChance * usiaModifier * ekonomiModifier * relasiModifier;

    return probabilitas.clamp(0, 100).round();
  }

  /// Cek apakah event boleh muncul saat ini.
  /// [random0to99] adalah nilai acak 0–99 dari RNG pemanggil.
  static bool apakahEventMuncul(Character character, int random0to99) {
    final int prob = hitungProbabilitas(character);
    return random0to99 < prob;
  }

  // ================================================================
  // HELPER: CEK KAPASITAS BIAYA ORANG TUA
  // ================================================================

  /// Apakah orang tua mampu menanggung biaya paspor + perjalanan penuh?
  static bool orangTuaMampu(Character character) {
    final int total = biayaPasporAnak + biayaPerjalanan;
    final bool adaAyah =
        character.fatherName != null && !character.isFatherDeceased;
    final bool adaAyahTiri =
        character.stepFatherName != null && !character.isStepFatherDeceased;

    if (adaAyah) {
      return character.getFatherWealth() >= total;
    } else if (adaAyahTiri) {
      return character.getStepFatherWealth() >= total;
    }
    return false;
  }

  /// Apakah orang tua memiliki paspor?
  /// Karena paspor orang tua tidak dilacak di Character, digunakan
  /// kekayaan keluarga sebagai proxy (> 3.000.000 = punya paspor).
  static bool orangTuaPunyaPaspor(Character character) {
    final bool adaAyah =
        character.fatherName != null && !character.isFatherDeceased;
    final bool adaAyahTiri =
        character.stepFatherName != null && !character.isStepFatherDeceased;
    final bool adaIbu =
        character.motherName != null && !character.isMotherDeceased;

    int kekayaan = 0;
    if (adaAyah) {
      kekayaan = character.getFatherWealth();
    } else if (adaAyahTiri) {
      kekayaan = character.getStepFatherWealth();
    }

    final bool kayaEkonomi = kekayaan >= 3000000;
    // Bonus: ibu berpendidikan/hubungan baik memperbesar kemungkinan paspor
    final int relasiIbu = character.motherRelationship ?? 50;
    final bool ibuBerpendidikan = adaIbu && relasiIbu >= 40;

    return kayaEkonomi || ibuBerpendidikan;
  }

  // ================================================================
  // INTERNAL MODIFIERS
  // ================================================================

  /// Base chance murni berdasarkan usia (sebelum modifier).
  static double _getBaseChance(int age) {
    if (age < 10) return 7.0;   // Anak kecil (5–10% sebelum modifier)
    if (age <= 16) return 10.0; // Prime time (15–25% setelah modifier)
    return 5.0;                 // Remaja (5% di atas 17)
  }

  /// Pengali berdasarkan rentang usia.
  static double _getUsiaModifier(int age) {
    if (age < 10) return 0.8;
    if (age <= 16) return 2.0; // Prime time keluarga mengajak liburan
    return 0.5;                // Di atas 17 sudah semi-mandiri
  }

  /// Pengali berdasarkan kekayaan keluarga.
  static double _getEkonomiModifier(int kekayaan) {
    if (kekayaan >= 10000000) return 2.0; // Sangat kaya
    if (kekayaan >= 5000000) return 1.5;  // Kaya
    if (kekayaan >= 2000000) return 1.0;  // Menengah
    if (kekayaan >= 500000) return 0.5;   // Pas-pasan
    return 0.2;                           // Miskin → hampir tidak pernah
  }

  /// Pengali berdasarkan kualitas hubungan dengan orang tua.
  static double _getRelasiModifier(int relasi) {
    if (relasi >= 80) return 1.5; // Hubungan sangat baik
    if (relasi >= 60) return 1.2; // Baik
    if (relasi >= 40) return 1.0; // Normal
    if (relasi >= 20) return 0.6; // Renggang
    return 0.2;                   // Sangat buruk → hampir tidak pernah
  }

  static int _max(int a, int b) => a > b ? a : b;
}
