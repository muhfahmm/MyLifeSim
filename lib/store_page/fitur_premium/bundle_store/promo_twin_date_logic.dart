// lib/store_page/fitur_premium/bundle_store/promo_twin_date_logic.dart

class PromoTwinDateLogic {
  /// Checks if today is a twin date (day == month, e.g. 1.1, 2.2, ..., 12.12)
  static bool isTwinDate([DateTime? date]) {
    final d = date ?? DateTime.now();
    return d.day == d.month;
  }

  /// Extra bonus discount rate (+5% = 0.05 when active)
  static double getBonusDiscountRate([DateTime? date]) {
    return isTwinDate(date) ? 0.05 : 0.0;
  }

  /// Get active promo title banner text
  static String getPromoBannerText([DateTime? date]) {
    final d = date ?? DateTime.now();
    if (!isTwinDate(d)) return '';
    return '🎉 PROMO TANGGAL KEMBAR ${d.day}.${d.month}! DAPATKAN EXTRA +5% DISKON!';
  }
}
