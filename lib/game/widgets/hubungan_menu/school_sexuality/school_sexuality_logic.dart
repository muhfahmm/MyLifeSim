// lib/game/widgets/hubungan_menu/sexuality/sexuality_logic.dart
import 'dart:math';

class SexualityLogic {
  static final Random _random = Random();

  /// Menghasilkan orientasi seksual untuk Guru berdasarkan jenis kelamin (gender)
  /// Laki-laki: Heteroseksual 80%, Biseksual 10%, Gay 10%
  /// Perempuan: Heteroseksual 70%, Biseksual 15%, Lesbian 15%
  static String getTeacherSexuality(String gender) {
    final roll = _random.nextInt(100);
    if (gender == 'Laki-laki' || gender == 'Laki-Laki' || gender == 'male') {
      if (roll < 80) return 'Heteroseksual';
      if (roll < 90) return 'Biseksual';
      return 'Gay';
    } else {
      if (roll < 70) return 'Heteroseksual';
      if (roll < 85) return 'Biseksual';
      return 'Lesbian';
    }
  }

  /// Menghasilkan orientasi seksual untuk Siswa-siswi berdasarkan jenis kelamin (gender)
  /// Siswa (Laki-laki): Heteroseksual 70%, Biseksual 15%, Gay 15%
  /// Siswi (Perempuan): Heteroseksual 70%, Biseksual 15%, Lesbian 15%
  static String getStudentSexuality(String gender) {
    final roll = _random.nextInt(100);
    if (gender == 'Laki-laki' || gender == 'Laki-Laki' || gender == 'male') {
      if (roll < 70) return 'Heteroseksual';
      if (roll < 85) return 'Biseksual';
      return 'Gay';
    } else {
      if (roll < 70) return 'Heteroseksual';
      if (roll < 85) return 'Biseksual';
      return 'Lesbian';
    }
  }
}
