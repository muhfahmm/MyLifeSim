// lib/game/widgets/store_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
// IMPOR FILE BARU
import 'package:mylifesim/store_page/fitur_premium/adult_features/akses_18plus_page.dart'; 
import 'package:mylifesim/store_page/fitur_premium/god_mode/god_mode_page.dart';
import 'package:mylifesim/store_page/fitur_premium/top_up_page/top_up_page.dart';

class StorePage extends StatefulWidget {
  final Character? character;
  final VoidCallback? onPurchaseCompleted;

  const StorePage({
    super.key,
    this.character,
    this.onPurchaseCompleted,
  });

  static bool get isGodModeUnlocked => _StorePageState._godModeUnlocked;
  static set isGodModeUnlocked(bool value) => _StorePageState._godModeUnlocked = value;

  static bool get isImmunityUnlocked => _StorePageState._immunityUnlocked;
  static set isImmunityUnlocked(bool value) => _StorePageState._immunityUnlocked = value;

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  static bool _godModeUnlocked = false;
  static bool _removeAdsUnlocked = false;
  static bool _premiumUnlocked = false;
  static bool _immunityUnlocked = false;

  void _showNoCharacterMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anda belum memiliki karakter. Buat karakter terlebih dahulu!'),
        backgroundColor: Colors.orange,
      ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('Berhasil membeli: $itemName!'),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
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
    VoidCallback? onActiveTap, // PARAMETER BARU
  }) {
    final bool isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconBgColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              isUnlocked
                  ? InkWell(
                      onTap: onActiveTap, // JIKA DIKLIK, BUKA HALAMAN
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right, size: 16, color: isDark ? Colors.greenAccent : Colors.green.shade700),
                          ],
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: onTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
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
                          price,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
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
    final bool isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
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

            // --- SEKSI FITUR PREMIUM ---
            _buildSectionHeader('Fitur Premium', isDark),
            _buildStoreItem(
              icon: Icons.verified_user,
              iconBgColor: Colors.purple.shade600,
              title: 'Premium Akses Penuh (18+)',
              description: 'Membuka semua fitur 18+, inses, masturbasi, dan hubungan guru-murid.',
              price: 'Rp 49.000',
              isUnlocked: _premiumUnlocked,
              onTap: () {
                _simulatePurchase('Premium Akses Penuh (18+)', () {
                  _premiumUnlocked = true;
                  GlobalSettings.isPremium.value = true;
                });
              },
              // TAMBAHKAN NAVIGASI INI
              onActiveTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Akses18PlusPage()),
                );
              },
            ),
            _buildStoreItem(
              icon: Icons.flash_on_rounded,
              iconBgColor: Colors.amber.shade700,
              title: 'God Mode',
              description: 'Kustomisasi penuh atribut karakter kapan saja!',
              price: 'Rp 79.000',
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
                      builder: (context) => GodModePage(character: character!),
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
              price: 'Rp 19.000',
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
              price: 'Rp 29.000',
              isUnlocked: _immunityUnlocked,
              onTap: () {
                _simulatePurchase('Kekebalan Abadi (Bebas Penyakit)', () {
                  _immunityUnlocked = true;
                });
              },
            ),

            // --- SEKSI PENINGKAT ATRIBUT ---
            _buildSectionHeader('Peningkat Atribut Instan', isDark),
            _buildStoreItem(
              icon: Icons.favorite_rounded,
              iconBgColor: Colors.red.shade400,
              title: 'Serum Kesehatan Super',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Memulihkan kesehatan karakter menjadi 100% secara instan.',
              price: 'Rp 15.000',
              onTap: () {
                if (character == null) return _showNoCharacterMessage();
                _simulatePurchase('Serum Kesehatan Super', () {
                  character.health = 100;
                });
              },
            ),
            _buildStoreItem(
              icon: Icons.emoji_emotions_rounded,
              iconBgColor: Colors.green.shade500,
              title: 'Pil Kebahagiaan Abadi',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Memaksimalkan level kebahagiaan karakter Anda menjadi 100%.',
              price: 'Rp 15.000',
              onTap: () {
                if (character == null) return _showNoCharacterMessage();
                _simulatePurchase('Pil Kebahagiaan Abadi', () {
                  character.happiness = 100;
                });
              },
            ),
            _buildStoreItem(
              icon: Icons.psychology_rounded,
              iconBgColor: Colors.blue.shade500,
              title: 'Serum Kecerdasan Instan',
              description: character == null ? 'Membutuhkan karakter aktif' : 'Meningkatkan kecerdasan karakter Anda menjadi 100%.',
              price: 'Rp 15.000',
              onTap: () {
                if (character == null) return _showNoCharacterMessage();
                _simulatePurchase('Serum Kecerdasan Instan', () {
                  character.intelligence = 100;
                });
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
    final bool isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return Dialog(
      backgroundColor: isDark ? Colors.grey.shade900 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_step == 0) ...[
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8A5A32))),
              const SizedBox(height: 20),
              Text('Menghubungkan ke App Store...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 8),
              Text('Memproses pembelian "${widget.itemName}"', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 12), textAlign: TextAlign.center),
            ] else ...[
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text('Pembayaran Berhasil!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 8),
              Text('Item "${widget.itemName}" telah ditambahkan.', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 13), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8A5A32), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(120, 44)),
                child: const Text('Mantap'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}