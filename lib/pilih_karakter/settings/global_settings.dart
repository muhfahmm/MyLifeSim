// lib/pilih_karakter/customization/global_settings.dart

import 'package:flutter/material.dart';

class GlobalSettings {
  // --- TAMBAHAN BARU: STATUS PREMIUM ---
  // (Ini yang dipanggil oleh store_page.dart untuk membuka fitur 18+)
  static final ValueNotifier<bool> isPremium = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isSpecialCareerUnlocked = ValueNotifier<bool>(false);

  // Status Pembelian Karir Militer per Cabang
  static final ValueNotifier<bool> isMiliterADUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isMiliterALUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isMiliterAUUnlocked = ValueNotifier<bool>(false);

  // Status Pembelian Karir E-Sports per Kategori
  static final ValueNotifier<bool> isEsportsProPlayerUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isEsportsTalentUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isEsportsBAUnlocked = ValueNotifier<bool>(false);

  // Status Pembelian Karir Spesial Lainnya
  static final ValueNotifier<bool> isPolitikusUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isPebisnisUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isAtlitUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isAktorFilmUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isAstronotUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isModelUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isIdolUnlocked = ValueNotifier<bool>(false);

  static final ValueNotifier<bool> musicEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> soundEffectsEnabled = ValueNotifier<bool>(true);
  static final ValueNotifier<bool> animationsEnabled = ValueNotifier<bool>(true);

  // Filter Konten Dewasa
  static final ValueNotifier<String> userGender = ValueNotifier<String>('Perempuan');
  static final ValueNotifier<String> userSexuality = ValueNotifier<String>('Heteroseksual');
  static final ValueNotifier<bool> disableMasturbationFamily = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> disableMasturbationNonFamily = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> disableMakeLoveFamily = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> disableMakeLoveNonFamily = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> disablePacaranFamily = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> disablePacaranNonFamily = ValueNotifier<bool>(false);

  // Method helper untuk mereset seluruh settingan ke default
  static void resetAll() {
    // CATATAN: Status premium biasanya TIDAK direset saat "Reset All" 
    // karena bersifat permanen setelah dibeli. 
    // Jika Anda ingin menghapusnya juga, hilangkan tanda komentar (//) di bawah ini:
    // isPremium.value = false; 

    musicEnabled.value = true;
    soundEffectsEnabled.value = true;
    animationsEnabled.value = true;
    disableMasturbationFamily.value = false;
    disableMasturbationNonFamily.value = false;
    disableMakeLoveFamily.value = false;
    disableMakeLoveNonFamily.value = false;
    disablePacaranFamily.value = false;
    disablePacaranNonFamily.value = false;
  }
}
