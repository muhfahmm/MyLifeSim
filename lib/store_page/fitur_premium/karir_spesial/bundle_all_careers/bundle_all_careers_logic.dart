import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'package:mylifesim/store_page/fitur_premium/bundle_store/promo_twin_date_logic.dart';

class BundleAllCareersLogic {
  static const List<int> individualPrices = [
    249000, // Politik
    199000, // Pembisnis
    149000, // Atlit
    179000, // Aktor
    259000, // Astronot
    99000,  // Model
    129000, // Idol
    99000,  // Militer AD
    149000, // Militer AL
    189000, // Militer AU
    199000, // Esports Pro Player
    119000, // Esports Talent
    159000, // Esports BA
  ];

  static const double baseDiscountRate = 0.25; // 25% base

  static double get effectiveDiscountRate => baseDiscountRate + PromoTwinDateLogic.getBonusDiscountRate();

  static int get originalTotalPrice => individualPrices.reduce((a, b) => a + b);
  static int get bundlePrice => (originalTotalPrice * (1.0 - effectiveDiscountRate)).round();
  static int get savingsAmount => originalTotalPrice - bundlePrice;

  static String get originalPriceStr => formatRupiah(originalTotalPrice);
  static String get bundlePriceStr => formatRupiah(bundlePrice);
  static String get savingsStr {
    final int percent = (effectiveDiscountRate * 100).round();
    return 'Hemat ${formatRupiah(savingsAmount)} ($percent%)';
  }

  static String formatRupiah(int number) {
    final s = number.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) {
        buf.write('.');
      }
      buf.write(s[i]);
    }
    return 'Rp ${buf.toString()}';
  }

  /// Check if ALL special career options are unlocked
  static bool get isAllCareersUnlocked {
    return GlobalSettings.isPolitikusUnlocked.value &&
        GlobalSettings.isPebisnisUnlocked.value &&
        GlobalSettings.isAtlitUnlocked.value &&
        GlobalSettings.isAktorFilmUnlocked.value &&
        GlobalSettings.isAstronotUnlocked.value &&
        GlobalSettings.isModelUnlocked.value &&
        GlobalSettings.isIdolUnlocked.value &&
        GlobalSettings.isMiliterADUnlocked.value &&
        GlobalSettings.isMiliterALUnlocked.value &&
        GlobalSettings.isMiliterAUUnlocked.value &&
        GlobalSettings.isEsportsProPlayerUnlocked.value &&
        GlobalSettings.isEsportsTalentUnlocked.value &&
        GlobalSettings.isEsportsBAUnlocked.value;
  }

  /// Unlock ALL special career options in one action
  static void unlockAllCareers() {
    GlobalSettings.isSpecialCareerUnlocked.value = true;
    GlobalSettings.isPolitikusUnlocked.value = true;
    GlobalSettings.isPebisnisUnlocked.value = true;
    GlobalSettings.isAtlitUnlocked.value = true;
    GlobalSettings.isAktorFilmUnlocked.value = true;
    GlobalSettings.isAstronotUnlocked.value = true;
    GlobalSettings.isModelUnlocked.value = true;
    GlobalSettings.isIdolUnlocked.value = true;
    GlobalSettings.isMiliterADUnlocked.value = true;
    GlobalSettings.isMiliterALUnlocked.value = true;
    GlobalSettings.isMiliterAUUnlocked.value = true;
    GlobalSettings.isEsportsProPlayerUnlocked.value = true;
    GlobalSettings.isEsportsTalentUnlocked.value = true;
    GlobalSettings.isEsportsBAUnlocked.value = true;
  }
}
