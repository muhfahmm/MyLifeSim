// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/esport_logic/BA/ba_esport_percentage.dart
class BaEsportPercentage {
  /// Peluang diterima saat MENDAFTAR SENDIRI (Manual Apply) sebagai Brand Ambassador E-Sport:
  /// 75% untuk wanita dan 25% untuk pria. Naik 15% jika memiliki riwayat pekerjaan sebagai Idol.
  static double getApplyChance(String gender, {bool hasIdolHistory = false}) {
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan' || g == 'wanita') {
      return hasIdolHistory ? 0.90 : 0.75;
    }
    return 0.25;
  }

  /// Peluang mendapatkan TAWARAN LANGSUNG (Direct Offer) sebagai Brand Ambassador E-Sport:
  /// Hanya bisa didapatkan pada rentang usia 15-22 tahun. Naik 15% jika memiliki riwayat pekerjaan sebagai Idol.
  static double getOfferChance(String gender, int age, {bool hasIdolHistory = false}) {
    if (age < 15 || age > 22) {
      return 0.0;
    }
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan' || g == 'wanita') {
      return hasIdolHistory ? 0.30 : 0.15;
    }
    return 0.05;
  }
}
