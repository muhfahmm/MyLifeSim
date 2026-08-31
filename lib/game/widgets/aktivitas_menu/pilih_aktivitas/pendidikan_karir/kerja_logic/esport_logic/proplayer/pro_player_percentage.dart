// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/esport_logic/pro_player_percentage.dart
class ProPlayerPercentage {
  /// Peluang diterima saat MENDAFTAR SENDIRI (Manual Apply) sebagai Pro Player E-Sport:
  /// - Normal: Laki-laki 75%, Perempuan 25% (kebalikan dari BA Esport)
  /// - Talenta Olahraga: Laki-laki 90%, Perempuan 40% (mendapat bonus +15% peluang)
  static double getApplyChance(String gender, String specialTalent) {
    final String g = gender.trim().toLowerCase();
    final bool hasSportsTalent = specialTalent.trim().toLowerCase() == 'olahraga';

    if (g == 'perempuan' || g == 'wanita') {
      return hasSportsTalent ? 0.40 : 0.25;
    }
    // Laki-laki
    return hasSportsTalent ? 0.90 : 0.75;
  }

  /// Peluang mendapatkan TAWARAN LANGSUNG (Direct Offer) sebagai Pro Player E-Sport:
  /// Hanya bisa didapatkan pada rentang usia 13-18 tahun.
  /// - Normal: Laki-laki 20%, Perempuan 5%
  /// - Talenta Olahraga: Laki-laki 40%, Perempuan 15%
  static double getOfferChance(String gender, String specialTalent, int age) {
    if (age < 13 || age > 18) {
      return 0.0;
    }
    final String g = gender.trim().toLowerCase();
    final bool hasSportsTalent = specialTalent.trim().toLowerCase() == 'olahraga';

    if (g == 'perempuan' || g == 'wanita') {
      return hasSportsTalent ? 0.15 : 0.05;
    }
    // Laki-laki
    return hasSportsTalent ? 0.40 : 0.20;
  }
}
