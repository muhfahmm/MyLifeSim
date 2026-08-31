// lib/pilih_karakter/customization/premium_guard.dart
import 'package:bitlife/pilih_karakter/customization/global_settings.dart';

class PremiumGuard {
  // Mendefinisikan jenis konten yang dilindungi
  static const String adultContent = 'adult_content';
  static const String adultAction = 'adult_action';

  /// Metode utama: Cek apakah user boleh mengakses fitur tertentu
  static bool isLocked(String feature) {
    // Jika user sudah premium, SEMUA fitur terbuka (return false)
    if (GlobalSettings.isPremium.value) return false;

    // Jika belum premium, kunci fitur dewasa
    if (feature == adultContent || feature == adultAction) {
      return true; // Terkunci
    }

    // Fitur lain (seperti main game biasa) tidak terkunci
    return false;
  }
}