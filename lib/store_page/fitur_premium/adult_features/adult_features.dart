import 'package:bitlife/pilih_karakter/settings/global_settings.dart';

class AdultFeatures {
  /// Memeriksa apakah fitur Premium Akses Penuh (18+) aktif.
  static bool get isPremiumUnlocked => GlobalSettings.isPremium.value;

  /// Memeriksa apakah user diizinkan pacaran dengan relasi tertentu.
  ///
  /// Aturan:
  /// - Usia minimum 12 tahun (untuk semua user, premium maupun tidak).
  /// - Pacaran dengan Guru, Dosen, dan peran sejenis HANYA untuk premium (karena sensitif).
  /// - Selain itu, pacaran bebas (open untuk non-premium) — tidak perlu premium hanya untuk pacaran biasa.
  static bool canProposeDating(String role, String relation, {int userAge = 18}) {
    // Cek usia minimum absolut (12 tahun)
    if (userAge < 12) return false;

    final rLower = '$role $relation'.toLowerCase();

    // Peran sensitif (termasuk Keluarga, Guru, Dosen, Bos, Idol, dll) yang HANYA boleh untuk premium
    const sensitiveRoles = [
      'guru', 'teacher', 'dosen', 'professor',
      'kepala sekolah', 'supervisor', 'ceo', 'bos',
      'staf idol', 'manajer idol',
      'ayah', 'ibu', 'ortu', 'orang tua', 'kakak', 'adik', 'saudara',
      'anak', 'sepupu', 'paman', 'bibi', 'kakek', 'nenek', 'keluarga', 'kandung',
      'father', 'mother', 'parent', 'brother', 'sister', 'uncle', 'aunt', 'cousin',
    ];
    final isSensitiveRole = sensitiveRoles.any((r) => rLower.contains(r));

    if (isSensitiveRole) {
      return isPremiumUnlocked; // Hanya premium
    }

    // Semua role lain bebas, tidak perlu premium
    return true;
  }

  /// Memeriksa apakah user diizinkan berhubungan intim / Make Love (ML) dengan target tertentu.
  ///
  /// Aturan:
  /// - Non-Premium: Usia >= 18 tahun, hanya dengan Teman Sekolah/Kuliah/Partner.
  /// - Premium: Semua role diizinkan (selama usia >= 18).
  static bool canMakeLove({
    required int userAge,
    required String role,
    required String relation,
  }) {
    if (isPremiumUnlocked) return true;

    if (userAge < 18) return false;

    final rLower = role.toLowerCase();
    final relLower = relation.toLowerCase();

    // Hanya boleh dengan teman sekelas / teman kuliah / partner pacar/istri/suami biasa
    if (rLower == 'teman sekelas' || rLower == 'teman kuliah' ||
        relLower == 'teman sekolah' || relLower == 'teman kuliah') {
      return true;
    }
    if (rLower == 'partner') {
      return true;
    }

    return false;
  }

  /// Memeriksa apakah user diizinkan melakukan Masturbasi Bersama.
  /// Non-Premium: Dilarang total untuk semua role.
  static bool canMasturbateTogether() {
    if (isPremiumUnlocked) return true;
    return false;
  }
}