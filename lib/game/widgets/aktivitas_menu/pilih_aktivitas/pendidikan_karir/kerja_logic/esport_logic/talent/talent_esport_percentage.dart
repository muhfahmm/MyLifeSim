// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/esport_logic/talent_esport_percentage.dart
class TalentEsportPercentage {
  /// Peluang diterima saat MENDAFTAR SENDIRI (Manual Apply) sebagai Talent E-Sport:
  /// 75% untuk wanita dan 25% untuk pria (sama seperti BA).
  static double getApplyChance(String gender) {
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan' || g == 'wanita') {
      return 0.75;
    }
    return 0.25;
  }

  /// Peluang mendapatkan TAWARAN LANGSUNG (Direct Offer) sebagai Talent E-Sport:
  /// Hanya aktif pada rentang usia 13 tahun ke atas.
  static double getOfferChance(String gender, int age) {
    if (age < 13) {
      return 0.0;
    }
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan' || g == 'wanita') {
      return 0.15;
    }
    return 0.05;
  }
}
