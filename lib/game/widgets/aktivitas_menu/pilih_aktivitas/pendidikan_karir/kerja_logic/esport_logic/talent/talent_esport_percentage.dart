// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/esport_logic/talent/talent_esport_percentage.dart
class TalentEsportPercentage {
  /// Peluang diterima saat MENDAFTAR SENDIRI (Manual Apply) sebagai Talent E-Sport:
  /// 75% untuk wanita dan 25% untuk pria (sama seperti BA). Naik 15% jika memiliki riwayat pekerjaan sebagai Idol.
  static double getApplyChance(String gender, {bool hasIdolHistory = false}) {
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan' || g == 'wanita') {
      return hasIdolHistory ? 0.90 : 0.75;
    }
    return 0.25;
  }

  /// Peluang mendapatkan TAWARAN LANGSUNG (Direct Offer) sebagai Talent E-Sport:
  /// Hanya aktif pada rentang usia 13 tahun ke atas. Naik 15% jika memiliki riwayat pekerjaan sebagai Idol.
  static double getOfferChance(String gender, int age, {bool hasIdolHistory = false}) {
    if (age < 13) {
      return 0.0;
    }
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan' || g == 'wanita') {
      return hasIdolHistory ? 0.30 : 0.15;
    }
    return 0.05;
  }
}
