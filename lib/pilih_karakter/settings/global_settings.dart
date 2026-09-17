// lib/pilih_karakter/customization/global_settings.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class GlobalSettings {
  // --- TAMBAHAN BARU: STATUS PREMIUM ---
  // (Ini yang dipanggil oleh store_page.dart untuk membuka fitur 18+)
  static final ValueNotifier<bool> isPremium = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isGodModeUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isRemoveAdsUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isImmunityUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isSpecialCareerUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isSkipUsiaUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isMataSehatUnlocked = ValueNotifier<bool>(false);
  static final ValueNotifier<bool> isObatObatanUnlocked = ValueNotifier<bool>(false);

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

  static bool _sessionInitialized = false;

  static final Map<String, ValueNotifier<bool>> _purchaseMap = {
    'isPremium': isPremium,
    'isGodModeUnlocked': isGodModeUnlocked,
    'isRemoveAdsUnlocked': isRemoveAdsUnlocked,
    'isImmunityUnlocked': isImmunityUnlocked,
    'isSpecialCareerUnlocked': isSpecialCareerUnlocked,
    'isSkipUsiaUnlocked': isSkipUsiaUnlocked,
    'isMataSehatUnlocked': isMataSehatUnlocked,
    'isObatObatanUnlocked': isObatObatanUnlocked,
    'isMiliterADUnlocked': isMiliterADUnlocked,
    'isMiliterALUnlocked': isMiliterALUnlocked,
    'isMiliterAUUnlocked': isMiliterAUUnlocked,
    'isEsportsProPlayerUnlocked': isEsportsProPlayerUnlocked,
    'isEsportsTalentUnlocked': isEsportsTalentUnlocked,
    'isEsportsBAUnlocked': isEsportsBAUnlocked,
    'isPolitikusUnlocked': isPolitikusUnlocked,
    'isPebisnisUnlocked': isPebisnisUnlocked,
    'isAtlitUnlocked': isAtlitUnlocked,
    'isAktorFilmUnlocked': isAktorFilmUnlocked,
    'isAstronotUnlocked': isAstronotUnlocked,
    'isModelUnlocked': isModelUnlocked,
    'isIdolUnlocked': isIdolUnlocked,
  };

  static File get _sessionFile {
    final tempDir = Directory.systemTemp.path;
    return File('$tempDir/mylifesim_session_purchases.json');
  }

  static void initSessionStorage() {
    if (_sessionInitialized) return;
    _sessionInitialized = true;

    try {
      final file = _sessionFile;
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        final data = jsonDecode(content) as Map<String, dynamic>;
        final storedPid = data['pid'];

        if (storedPid == pid) {
          final purchases = data['purchases'] as Map<String, dynamic>?;
          if (purchases != null) {
            purchases.forEach((key, val) {
              if (val is bool && _purchaseMap.containsKey(key)) {
                _purchaseMap[key]!.value = val;
              }
            });
          }
        } else {
          // Terminal dihentikan dan dijalankan kembali -> reset pembelian ke default
          if (file.existsSync()) {
            file.deleteSync();
          }
        }
      }
    } catch (_) {}

    // Tambahkan listener untuk otomatis menyimpan jika ada perubahan status pembelian
    for (final entry in _purchaseMap.entries) {
      entry.value.addListener(_saveSessionStorage);
    }
  }

  static void _saveSessionStorage() {
    try {
      final file = _sessionFile;
      final purchasesMap = <String, bool>{};
      _purchaseMap.forEach((key, notifier) {
        purchasesMap[key] = notifier.value;
      });

      final data = {
        'pid': pid,
        'purchases': purchasesMap,
      };

      file.writeAsStringSync(jsonEncode(data));
    } catch (_) {}
  }

  // Method helper untuk mereset seluruh settingan ke default
  static void resetAll() {
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
