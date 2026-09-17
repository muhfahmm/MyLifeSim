// lib/game/widgets/store_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
// IMPOR FILE BARU
import 'package:mylifesim/store_page/fitur_premium/adult_features/adult_features_store_page.dart';
import 'package:mylifesim/store_page/fitur_premium/finansial_premium/finansial_premium_page.dart';
import 'package:mylifesim/store_page/fitur_premium/assets_premium/assets_premium_page.dart';
import 'package:mylifesim/store_page/fitur_premium/god_mode/god_mode_page.dart';
import 'package:mylifesim/store_page/fitur_premium/top_up_page/top_up_page.dart';
import 'package:mylifesim/store_page/fitur_premium/karir_spesial/karir_spesial_page.dart';
import 'package:mylifesim/store_page/fitur_premium/skip_usia/skip_usia_page.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/obat_obatan/obat_obatan_menu.dart';
import 'fitur_premium/bundle_store/bundle_fitur_premium.dart';
import 'fitur_premium/bundle_store/bundle_peningkat_atribut.dart';
import 'fitur_premium/bundle_store/promo_twin_date_logic.dart';

class StorePage extends StatefulWidget {
  final Character? character;
  final VoidCallback? onPurchaseCompleted;

  const StorePage({
    super.key,
    this.character,
    this.onPurchaseCompleted,
  });

  static bool get isGodModeUnlocked => GlobalSettings.isGodModeUnlocked.value;
  static set isGodModeUnlocked(bool value) => GlobalSettings.isGodModeUnlocked.value = value;

  static bool get isRemoveAdsUnlocked => GlobalSettings.isRemoveAdsUnlocked.value;
  static set isRemoveAdsUnlocked(bool value) => GlobalSettings.isRemoveAdsUnlocked.value = value;

  static bool get isPremiumUnlocked => GlobalSettings.isPremium.value;
  static set isPremiumUnlocked(bool value) => GlobalSettings.isPremium.value = value;

  static bool get isImmunityUnlocked => GlobalSettings.isImmunityUnlocked.value;
  static set isImmunityUnlocked(bool value) => GlobalSettings.isImmunityUnlocked.value = value;

  static bool get isSpecialCareerUnlocked => GlobalSettings.isSpecialCareerUnlocked.value;
  static set isSpecialCareerUnlocked(bool value) => GlobalSettings.isSpecialCareerUnlocked.value = value;

  static bool get isSkipUsiaUnlocked => GlobalSettings.isSkipUsiaUnlocked.value;
  static set isSkipUsiaUnlocked(bool value) => GlobalSettings.isSkipUsiaUnlocked.value = value;

  static bool get isMataSehatUnlocked => GlobalSettings.isMataSehatUnlocked.value;
  static set isMataSehatUnlocked(bool value) => GlobalSettings.isMataSehatUnlocked.value = value;

  static bool get isObatObatanUnlocked => GlobalSettings.isObatObatanUnlocked.value;
  static set isObatObatanUnlocked(bool value) => GlobalSettings.isObatObatanUnlocked.value = value;

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  static bool get _godModeUnlocked => GlobalSettings.isGodModeUnlocked.value;
  static set _godModeUnlocked(bool value) => GlobalSettings.isGodModeUnlocked.value = value;

  static bool get _removeAdsUnlocked => GlobalSettings.isRemoveAdsUnlocked.value;
  static set _removeAdsUnlocked(bool value) => GlobalSettings.isRemoveAdsUnlocked.value = value;

  static bool get _premiumUnlocked => GlobalSettings.isPremium.value;
  static set _premiumUnlocked(bool value) => GlobalSettings.isPremium.value = value;

  static bool get _immunityUnlocked => GlobalSettings.isImmunityUnlocked.value;
  static set _immunityUnlocked(bool value) => GlobalSettings.isImmunityUnlocked.value = value;

  static bool get _specialCareerUnlocked => GlobalSettings.isSpecialCareerUnlocked.value;

  static bool get _skipUsiaUnlocked => GlobalSettings.isSkipUsiaUnlocked.value;
  static set _skipUsiaUnlocked(bool value) => GlobalSettings.isSkipUsiaUnlocked.value = value;

  static bool get _mataSehatUnlocked => GlobalSettings.isMataSehatUnlocked.value;
  static set _mataSehatUnlocked(bool value) => GlobalSettings.isMataSehatUnlocked.value = value;

  static bool get _obatObatanUnlocked => GlobalSettings.isObatObatanUnlocked.value;
  static set _obatObatanUnlocked(bool value) => GlobalSettings.isObatObatanUnlocked.value = value;

  void _showNoCharacterMessage() {
    DialogHelper.show(
      context: context,
      title: 'Perhatian',
      content: const Text('Anda belum memiliki karakter. Buat karakter terlebih dahulu!'),
    );
  }

  void _simulatePurchase(String itemName, VoidCallback action) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _PurchaseSimulationDialog(itemName: itemName);
      },
    ).then((success) {
      if (success == true) {
        if (!mounted) return;
        action();
        widget.onPurchaseCompleted?.call();
        setState(() {});
      }
    });
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.blueGrey.shade200 : Colors.blueGrey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // --- MODIFIKASI HELPER _buildStoreItem ---
  Widget _buildStoreItem({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String description,
    required String price,
    required VoidCallback onTap,
    bool isUnlocked = false,
    VoidCallback? onActiveTap,
    String? buttonLabel,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 16,
        vertical: isMobile ? 4 : 6,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey.shade800, Colors.grey.shade900]
                : [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 10.0 : 16.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  color: iconBgColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconBgColor, size: isMobile ? 22 : 28),
              ),
              SizedBox(width: isMobile ? 10 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 12,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: isMobile ? 8 : 12),
              isUnlocked
                  ? InkWell(
                      onTap: onActiveTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 12,
                          vertical: isMobile ? 6 : 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.green.shade900.withValues(alpha: 0.5) : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isDark ? Colors.green.shade600 : Colors.green.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Aktif',
                              style: TextStyle(
                                color: isDark ? Colors.greenAccent : Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: isMobile ? 11 : 13,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(Icons.chevron_right, size: isMobile ? 14 : 16, color: isDark ? Colors.greenAccent : Colors.green.shade700),
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 10 : 16,
                          vertical: isMobile ? 6 : 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5C3C10), Color(0xFF8A5A32)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5C3C10).withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Text(
                          buttonLabel ?? price,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 11.5 : 13,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko MyLifeSim', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5C3C10), Color(0xFF8A5A32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            // --- HEADER DEKORATIF / STATUS ---
            if (character != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade700, Colors.amber.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.shade900.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Keuangan Karakter Anda', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                            '\$${character.money.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFB45309),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        elevation: 3,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TopUpPage(character: character),
                          ),
                        ).then((_) => setState(() {}));
                      },
                      icon: const Icon(Icons.add_circle_rounded, size: 18, color: Color(0xFFD97706)),
                      label: const Text('TOP UP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFB45309))),
                    ),
                  ],
                ),
              ),

            if (PromoTwinDateLogic.isTwinDate())
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFFFF6F00)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepOrange.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        PromoTwinDateLogic.getPromoBannerText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // --- SEKSI FITUR PREMIUM ---
            _buildSectionHeader('Fitur Premium', isDark),
            BundleFiturPremiumCard(
              isUnlocked: BundleFiturPremiumLogic.isAllUnlocked(
                premiumUnlocked: _premiumUnlocked,
                godModeUnlocked: _godModeUnlocked,
                removeAdsUnlocked: _removeAdsUnlocked,
                immunityUnlocked: _immunityUnlocked,
                skipUsiaUnlocked: _skipUsiaUnlocked || GlobalSettings.isSkipUsiaUnlocked.value,
                mataSehatUnlocked: _mataSehatUnlocked || GlobalSettings.isMataSehatUnlocked.value,
              ),
              onPurchaseSuccess: () {
                setState(() {
                  _premiumUnlocked = true;
                  _godModeUnlocked = true;
                  _removeAdsUnlocked = true;
                  _immunityUnlocked = true;
                  _skipUsiaUnlocked = true;
                  _mataSehatUnlocked = true;
                  GlobalSettings.isPremium.value = true;
                  GlobalSettings.isSkipUsiaUnlocked.value = true;
                  GlobalSettings.isMataSehatUnlocked.value = true;
                });
                if (widget.onPurchaseCompleted != null) widget.onPurchaseCompleted!();
              },
            ),
            _buildStoreItem(
              icon: Icons.account_balance_wallet_rounded,
              iconBgColor: Colors.green.shade700,
              title: 'Finansial Premium 💵',
              description: 'Akses menu portofolio investasi dan koleksi kemewahan.',
              price: 'Pilih Fitur ➔',
              isUnlocked: GlobalSettings.isFinansialInvestasiUnlocked.value &&
                  GlobalSettings.isFinansialKemewahanUnlocked.value,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FinansialPremiumPage(character: character)),
                ).then((_) => setState(() {}));
              },
              onActiveTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FinansialPremiumPage(character: character)),
                ).then((_) => setState(() {}));
              },
            ),
            _buildStoreItem(
              icon: Icons.account_balance_rounded,
              iconBgColor: Colors.amber.shade800,
              title: 'Aset Premium 🏛️',
              description: 'Akses menu hiburan Casino, Garasi Mobil impian, dan Garasi Motor superbike.',
              price: 'Pilih Fitur ➔',
              isUnlocked: GlobalSettings.isAssetsCasinoUnlocked.value &&
                  GlobalSettings.isAssetsGarasiMobilUnlocked.value &&
                  GlobalSettings.isAssetsGarasiMotorUnlocked.value,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssetsPremiumPage(character: character)),
                ).then((_) => setState(() {}));
              },
              onActiveTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssetsPremiumPage(character: character)),
                ).then((_) => setState(() {}));
              },
            ),
            _buildStoreItem(
              icon: Icons.verified_user,
              iconBgColor: Colors.purple.shade600,
              title: 'Fitur Dewasa (18+) 🔞',
              description: 'Buka menu pilihan fitur 18+, inses, masturbasi, dan hubungan guru-murid.',
              price: 'Pilih Fitur ➔',
              isUnlocked: _premiumUnlocked,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdultFeaturesStorePage()),
                );
              },
              onActiveTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdultFeaturesStorePage()),
                );
              },
            ),
            _buildStoreItem(
              icon: Icons.flash_on_rounded,
              iconBgColor: Colors.amber.shade700,
              title: 'God Mode',
              description: 'Kustomisasi penuh atribut karakter kapan saja!',
              price: 'Rp 249.000',
              isUnlocked: _godModeUnlocked,
              onTap: () {
                _simulatePurchase('God Mode', () {
                  _godModeUnlocked = true;
                  if (character != null) {
                    character.health = 100;
                    character.happiness = 100;
                    character.intelligence = 100;
                    character.discipline = 100;
                  }
                });
              },
              onActiveTap: () {
                if (character != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GodModePage(character: character),
                    ),
                  );
                } else {
                  _showNoCharacterMessage();
                }
              },
            ),
            _buildStoreItem(
              icon: Icons.block_rounded,
              iconBgColor: Colors.red.shade600,
              title: 'Bebas Iklan',
              description: 'Bermain nyaman tanpa gangguan iklan pop-up.',
              price: 'Rp 49.000',
              isUnlocked: _removeAdsUnlocked,
              onTap: () {
                _simulatePurchase('Bebas Iklan', () {
                  _removeAdsUnlocked = true;
                });
              },
            ),
            _buildStoreItem(
              icon: Icons.health_and_safety_rounded,
              iconBgColor: Colors.teal.shade600,
              title: 'Kekebalan Abadi (Bebas Penyakit)',
              description: 'Karakter dan seluruh anggota keluarga menjadi kebal 100% dari segala penyakit selamanya.',
              price: 'Rp 129.000',
              isUnlocked: _immunityUnlocked,
              onTap: () {
                _simulatePurchase('Kekebalan Abadi (Bebas Penyakit)', () {
                  _immunityUnlocked = true;
                });
              },
            ),
            _buildStoreItem(
              icon: Icons.fast_forward_rounded,
              iconBgColor: Colors.purple.shade600,
              title: 'Fast Forward Usia (Lompat Usia Instan)',
              description: 'Lompat langsung ke usia berapa pun yang kamu inginkan secara instan tanpa menunggu!',
              price: 'Rp 149.000',
              isUnlocked: _skipUsiaUnlocked || GlobalSettings.isSkipUsiaUnlocked.value,
              onTap: () {
                _simulatePurchase('Fast Forward Usia (Lompat Usia Instan)', () {
                  _skipUsiaUnlocked = true;
                  GlobalSettings.isSkipUsiaUnlocked.value = true;
                });
              },
              onActiveTap: () {
                if (character != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SkipUsiaPage(
                        character: character,
                        onAgeChanged: () => setState(() {}),
                      ),
                    ),
                  );
                } else {
                  _showNoCharacterMessage();
                }
              },
            ),
            _buildStoreItem(
              icon: Icons.remove_red_eye_rounded,
              iconBgColor: Colors.cyan.shade600,
              title: 'Mata Sehat Abadi (Bebas Tes Mata)',
              description: 'Menjamin mata karakter 100% sehat selamanya, terhindar dari mata minus/silinder, dan bebas tes mata!',
              price: 'Rp 99.000',
              isUnlocked: _mataSehatUnlocked || GlobalSettings.isMataSehatUnlocked.value,
              onTap: () {
                _simulatePurchase('Mata Sehat Abadi (Bebas Tes Mata)', () {
                  _mataSehatUnlocked = true;
                  GlobalSettings.isMataSehatUnlocked.value = true;
                });
              },
            ),
            _buildStoreItem(
              icon: Icons.medication_rounded,
              iconBgColor: Colors.purple.shade700,
              title: 'Akses Obat-obatan (18+)',
              description: 'Membuka menu khusus konsumsi obat-obatan & zat penenang untuk karakter berusia minimal 18 tahun.',
              price: 'Rp 79.000',
              isUnlocked: _obatObatanUnlocked || GlobalSettings.isObatObatanUnlocked.value,
              onTap: () {
                _simulatePurchase('Akses Obat-obatan (18+)', () {
                  _obatObatanUnlocked = true;
                  GlobalSettings.isObatObatanUnlocked.value = true;
                });
              },
              onActiveTap: () {
                if (character != null && character.age >= 18) {
                  ObatObatanMenuHelper.showObatObatanMenu(context, character, () {});
                } else if (character != null && character.age < 18) {
                  DialogHelper.show(
                    context: context,
                    title: 'Akses Dibatasi 🔒',
                    content: const Text('Kamu harus berusia minimal 18 tahun untuk mengakses menu ini.'),
                  );
                } else {
                  _showNoCharacterMessage();
                }
              },
            ),

            // --- SEKSI PENINGKAT ATRIBUT ---
            _buildSectionHeader('Peningkat Atribut Instan', isDark),
            BundlePeningkatAtributCard(
              character: character,
              isUnlocked: character != null &&
                  (character.isHealthLocked || character.health >= 100) &&
                  (character.isHappinessLocked || character.happiness >= 100) &&
                  (character.isIntelligenceLocked || character.intelligence >= 100) &&
                  (character.isDisciplineLocked || character.discipline >= 100),
              onPurchaseSuccess: () {
                setState(() {});
                if (widget.onPurchaseCompleted != null) widget.onPurchaseCompleted!();
              },
            ),
            _buildStoreItem(
              icon: Icons.favorite_rounded,
              iconBgColor: Colors.red.shade400,
              title: 'Serum Kesehatan Super',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Memulihkan & mengunci kesehatan karakter menjadi 100% terus tanpa bisa turun!',
              price: 'Rp 25.000',
              isUnlocked: character != null && (character.isHealthLocked || character.health >= 100),
              onTap: () {
                if (character == null) return _showNoCharacterMessage();
                _simulatePurchase('Serum Kesehatan Super', () {
                  character.health = 100;
                  character.isHealthLocked = true;
                });
              },
            ),
            _buildStoreItem(
              icon: Icons.emoji_emotions_rounded,
              iconBgColor: Colors.green.shade500,
              title: 'Pil Kebahagiaan Abadi',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Memaksimalkan & mengunci kebahagiaan karakter menjadi 100% terus tanpa bisa turun!',
              price: 'Rp 35.000',
              isUnlocked: character != null && (character.isHappinessLocked || character.happiness >= 100),
              onTap: () {
                if (character == null) return _showNoCharacterMessage();
                _simulatePurchase('Pil Kebahagiaan Abadi', () {
                  character.happiness = 100;
                  character.isHappinessLocked = true;
                });
              },
            ),
            _buildStoreItem(
              icon: Icons.psychology_rounded,
              iconBgColor: Colors.blue.shade500,
              title: 'Serum Kecerdasan Instan',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Meningkatkan & mengunci kecerdasan karakter menjadi 100% terus tanpa bisa turun!',
              price: 'Rp 45.000',
              isUnlocked: character != null && (character.isIntelligenceLocked || character.intelligence >= 100),
              onTap: () {
                if (character == null) return _showNoCharacterMessage();
                _simulatePurchase('Serum Kecerdasan Instan', () {
                  character.intelligence = 100;
                  character.isIntelligenceLocked = true;
                });
              },
            ),
            _buildStoreItem(
              icon: Icons.fitness_center_rounded,
              iconBgColor: Colors.amber.shade700,
              title: 'Eliksir Kedisiplinan Instan',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Meningkatkan & mengunci kedisiplinan karakter menjadi 100% terus tanpa bisa turun!',
              price: 'Rp 40.000',
              isUnlocked: character != null && (character.isDisciplineLocked || character.discipline >= 100),
              onTap: () {
                if (character == null) return _showNoCharacterMessage();
                _simulatePurchase('Eliksir Kedisiplinan Instan', () {
                  character.discipline = 100;
                  character.isDisciplineLocked = true;
                });
              },
            ),

            // --- SEKSI PEKERJAAN ---
            _buildSectionHeader('Pekerjaan', isDark),
            _buildStoreItem(
              icon: Icons.star_rounded,
              iconBgColor: Colors.amber.shade800,
              title: 'Karir Spesial',
              description: 'Membuka jalur karir spesial: Militer, Politik, Pembisnis, Atlit, Aktor, Astronot, Model, Idol, E-Sports.',
              price: 'Mulai Rp 99.000',
              buttonLabel: 'Lihat Fitur',
              isUnlocked: _specialCareerUnlocked,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KarirSpesialPage()),
                );
              },
              onActiveTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KarirSpesialPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseSimulationDialog extends StatefulWidget {
  final String itemName;
  const _PurchaseSimulationDialog({required this.itemName});

  @override
  State<_PurchaseSimulationDialog> createState() => __PurchaseSimulationDialogState();
}

class __PurchaseSimulationDialogState extends State<_PurchaseSimulationDialog> {
  int _step = 0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _step = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dialogWidth = (screenWidth - 32).clamp(280.0, 400.0);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_step == 0) ...[
              const SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8A5A32)),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Menghubungkan ke App Store...',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Memproses pembelian "${widget.itemName}"',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 56),
              const SizedBox(height: 14),
              Text(
                'Pembayaran Berhasil!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: isDark ? Colors.white : Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.itemName.contains('Serum Kesehatan')
                    ? 'Item "${widget.itemName}" telah ditambahkan. Bar Kesehatan Anda kini 100 terus tanpa bisa turun!'
                    : widget.itemName.contains('Pil Kebahagiaan')
                        ? 'Item "${widget.itemName}" telah ditambahkan. Bar Kebahagiaan Anda kini 100 terus tanpa bisa turun!'
                        : widget.itemName.contains('Serum Kecerdasan')
                            ? 'Item "${widget.itemName}" telah ditambahkan. Bar Kecerdasan Anda kini 100 terus tanpa bisa turun!'
                            : widget.itemName.contains('Combo Atribut') || widget.itemName.contains('Bundle')
                                ? 'Item "${widget.itemName}" telah ditambahkan. Semua bar status (Kesehatan, Kebahagiaan, Kecerdasan) kini 100 terus tanpa bisa turun!'
                                : 'Item "${widget.itemName}" telah ditambahkan.',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A5A32),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                  elevation: 2,
                ),
                child: const Text('Mantap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
