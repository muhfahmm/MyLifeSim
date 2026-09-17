import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';

class AdultFeatures {
  /// Memeriksa apakah fitur Premium Akses Penuh (18+) aktif secara global.
  static bool get isPremiumUnlocked => GlobalSettings.isPremium.value;

  /// Memeriksa akses per-kategori (bebas jika bundle premium aktif)
  static bool get isMasturbationUnlocked => isPremiumUnlocked || GlobalSettings.isMasturbationUnlocked.value;
  static bool get isMakeLoveUnlocked => isPremiumUnlocked || GlobalSettings.isMakeLoveUnlocked.value;
  static bool get isIncestUnlocked => isPremiumUnlocked || GlobalSettings.isIncestUnlocked.value;
  static bool get isTeacherStudentUnlocked => isPremiumUnlocked || GlobalSettings.isTeacherStudentUnlocked.value;

  /// Memeriksa apakah user diizinkan pacaran dengan relasi tertentu.
  static bool canProposeDating(String role, String relation, {int userAge = 18}) {
    if (userAge < 9) return false;
    if (isPremiumUnlocked) return true;

    final rLower = '$role $relation'.toLowerCase();

    const familyRoles = [
      'ayah', 'ibu', 'ortu', 'orang tua', 'kakak', 'adik', 'saudara',
      'anak', 'sepupu', 'paman', 'bibi', 'kakek', 'nenek', 'keluarga', 'kandung',
      'father', 'mother', 'parent', 'brother', 'sister', 'uncle', 'aunt', 'cousin',
    ];

    const teacherBossRoles = [
      'guru', 'teacher', 'dosen', 'professor',
      'kepala sekolah', 'supervisor', 'ceo', 'bos',
      'staf idol', 'manajer idol',
    ];

    final isFamily = familyRoles.any((r) => rLower.contains(r));
    if (isFamily) return isIncestUnlocked;

    final isTeacherBoss = teacherBossRoles.any((r) => rLower.contains(r));
    if (isTeacherBoss) return isTeacherStudentUnlocked;

    return true;
  }

  /// Memeriksa apakah user diizinkan berhubungan intim / Make Love (ML) dengan target tertentu.
  static bool canMakeLove({
    required int userAge,
    required String role,
    required String relation,
  }) {
    if (userAge < 10) return false;
    if (isPremiumUnlocked) return true;

    final rLower = '$role $relation'.toLowerCase();

    const familyRoles = [
      'ayah', 'ibu', 'ortu', 'orang tua', 'kakak', 'adik', 'saudara',
      'anak', 'sepupu', 'paman', 'bibi', 'kakek', 'nenek', 'keluarga', 'kandung',
      'father', 'mother', 'parent', 'brother', 'sister', 'uncle', 'aunt', 'cousin',
    ];

    const teacherBossRoles = [
      'guru', 'teacher', 'dosen', 'professor',
      'kepala sekolah', 'supervisor', 'ceo', 'bos',
      'staf idol', 'manajer idol',
    ];

    final isFamily = familyRoles.any((r) => rLower.contains(r));
    if (isFamily) return isIncestUnlocked;

    final isTeacherBoss = teacherBossRoles.any((r) => rLower.contains(r));
    if (isTeacherBoss) return isTeacherStudentUnlocked;

    // Bebas untuk usia >= 18 tahun (hubungan intim standar tanpa role sensitif)
    if (userAge >= 18) return true;

    return isMakeLoveUnlocked;
  }

  /// Memeriksa apakah user diizinkan melakukan Masturbasi Bersama.
  static bool canMasturbateTogether() {
    return isMasturbationUnlocked;
  }
}
