// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/esport_logic/ba_esport_percentage.dart
class BaEsportPercentage {
  /// Peluang diterima saat MENDAFTAR SENDIRI (Manual Apply) sebagai Brand Ambassador E-Sport:
  /// 75% untuk wanita dan 25% untuk pria.
  static double getApplyChance(String gender) {
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan' || g == 'wanita') {
      return 0.75;
    }
    return 0.25;
  }

  /// Peluang mendapatkan TAWARAN LANGSUNG (Direct Offer) sebagai Brand Ambassador E-Sport:
  /// Hanya bisa didapatkan pada rentang usia 15-22 tahun.
  static double getOfferChance(String gender, int age) {
    if (age < 15 || age > 22) {
      return 0.0;
    }
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan' || g == 'wanita') {
      return 0.15;
    }
    return 0.05;
  }
}
