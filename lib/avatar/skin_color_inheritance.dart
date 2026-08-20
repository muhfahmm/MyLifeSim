// lib/avatar/skin_color_inheritance.dart
import 'dart:math';

/// Kelas pembantu untuk logika warisan warna kulit antar generasi.
/// Palet diurutkan dari paling terang ke paling gelap.
class SkinColorInheritance {
  /// Palet warna kulit (hex), diurutkan terang → gelap
  static const List<String> palette = [
    'ffdbb4', // Putih Pale
    'edb98a', // Putih Terang
    'f8d25c', // Kuning Langsat
    'fd9841', // Sawo Matang
    'd08b5b', // Cokelat Gelap (swap urutan agar konsisten)
    'ae5d29', // Cokelat
    '614335', // Hitam
  ];

  /// Mewarisi warna kulit anak dari warna kulit ayah dan ibu.
  /// Hasilnya bisa sama dengan salah satu orang tua (40%+40%)
  /// atau satu level lebih terang/gelap (20%).
  static String blendChildSkin(String? parentA, String? parentB) {
    final rng = Random();
    final a = _indexOf(parentA);
    final b = _indexOf(parentB);

    final roll = rng.nextInt(10);
    int resultIdx;

    if (roll < 4) {
      // 40%: ambil warna salah satu orang tua
      resultIdx = a;
    } else if (roll < 8) {
      // 40%: ambil warna orang tua lainnya
      resultIdx = b;
    } else {
      // 20%: rata-rata lalu geser ±1
      final avg = ((a + b) / 2).round();
      final shift = rng.nextBool() ? 1 : -1;
      resultIdx = (avg + shift).clamp(0, palette.length - 1);
    }

    return palette[resultIdx.clamp(0, palette.length - 1)];
  }

  /// Generate warna kulit orang tua yang logis berdasarkan warna kulit anak.
  /// Orang tua biasanya 1-2 level terang/gelap dari anak.
  static String parentSkinFromChild(String? childSkin, {int shift = 0}) {
    final rng = Random();
    final idx = _indexOf(childSkin);
    final delta = rng.nextInt(3) - 1 + shift; // -1, 0, +1 relative to child
    return palette[(idx + delta).clamp(0, palette.length - 1)];
  }

  /// Generate warna kulit random dari palet
  static String randomSkin([int? seed]) {
    final rng = seed != null ? Random(seed) : Random();
    return palette[rng.nextInt(palette.length)];
  }

  static int _indexOf(String? hex) {
    if (hex == null) return 1; // default: 'edb98a' (terang)
    final idx = palette.indexOf(hex.toLowerCase());
    return idx >= 0 ? idx : 1;
  }
}
