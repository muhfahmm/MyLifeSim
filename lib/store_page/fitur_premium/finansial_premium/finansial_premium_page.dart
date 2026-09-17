// lib/store_page/fitur_premium/finansial_premium/finansial_premium_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';
import 'bundle_finansial_card.dart';
import 'investasi/investasi_page.dart';
import 'kemewahan/kemewahan_page.dart';

class FinansialPremiumPage extends StatefulWidget {
  final Character? character;

  const FinansialPremiumPage({super.key, this.character});

  @override
  State<FinansialPremiumPage> createState() => _FinansialPremiumPageState();
}

class _FinansialPremiumPageState extends State<FinansialPremiumPage> {
  void _simulatePurchase(String itemName, VoidCallback onPurchased) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _PurchaseSimulationDialog(itemName: itemName);
      },
    ).then((success) {
      if (success == true) {
        onPurchased();
      }
    });
  }

  Widget _buildItemCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String price,
    required bool isUnlocked,
    required VoidCallback onTap,
    required VoidCallback onOpen,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? Colors.green.shade400
              : (isDark ? Colors.grey.shade700 : color.withValues(alpha: 0.3)),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 10 : 14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: isMobile ? 24 : 30),
            ),
            SizedBox(width: isMobile ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (isUnlocked) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.check_circle, size: 16, color: Colors.green),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
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
            const SizedBox(width: 10),
            isUnlocked
                ? ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.green.shade900.withValues(alpha: 0.5) : Colors.green.shade100,
                      foregroundColor: isDark ? Colors.greenAccent : Colors.green.shade800,
                      disabledBackgroundColor: isDark ? Colors.green.shade900.withValues(alpha: 0.5) : Colors.green.shade100,
                      disabledForegroundColor: isDark ? Colors.greenAccent : Colors.green.shade800,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      elevation: 0,
                    ),
                    onPressed: null,
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: const Text('Aktif', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      elevation: 2,
                    ),
                    onPressed: onTap,
                    child: Text(
                      price,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Finansial Premium 💵',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: ValueListenableBuilder<bool>(
          valueListenable: GlobalSettings.isFinansialInvestasiUnlocked,
          builder: (context, isInvestasiUnlocked, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isFinansialKemewahanUnlocked,
              builder: (context, isKemewahanUnlocked, _) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Card Bundle Finansial Premium
                    BundleFinansialCard(
                      onPurchase: (itemName, onPurchased) => _simulatePurchase(itemName, onPurchased),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 10),
                      child: Text(
                        'PILIH KATEGORI FINANSIAL INDIVIDUAL:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.green.shade200 : Colors.green.shade900,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),

                    // Card 1: Investasi
                    _buildItemCard(
                      context: context,
                      title: 'Investasi 📈',
                      description: 'Akses portofolio pasar saham, properti komersial, dan obligasi internasional.',
                      icon: Icons.show_chart_rounded,
                      color: Colors.blue.shade600,
                      price: 'Rp 199.000',
                      isUnlocked: isInvestasiUnlocked,
                      onTap: () {
                        _simulatePurchase('Investasi (Finansial Premium)', () {
                          GlobalSettings.isFinansialInvestasiUnlocked.value = true;
                          GlobalSettings.saveSessionStorage();
                        });
                      },
                      onOpen: () {
                        if (widget.character == null) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InvestasiPage(character: widget.character!)),
                        );
                      },
                    ),

                    // Card 2: Kemewahan
                    _buildItemCard(
                      context: context,
                      title: 'Kemewahan 💎',
                      description: 'Koleksi perhiasan langka, jet pribadi, vila super mewah, dan karya seni dunia.',
                      icon: Icons.diamond_rounded,
                      color: Colors.purple.shade600,
                      price: 'Rp 249.000',
                      isUnlocked: isKemewahanUnlocked,
                      onTap: () {
                        _simulatePurchase('Kemewahan (Finansial Premium)', () {
                          GlobalSettings.isFinansialKemewahanUnlocked.value = true;
                          GlobalSettings.saveSessionStorage();
                        });
                      },
                      onOpen: () {
                        if (widget.character == null) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => KemewahanPage(character: widget.character!)),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PurchaseSimulationDialog extends StatefulWidget {
  final String itemName;

  const _PurchaseSimulationDialog({required this.itemName});

  @override
  State<_PurchaseSimulationDialog> createState() => _PurchaseSimulationDialogState();
}

class _PurchaseSimulationDialogState extends State<_PurchaseSimulationDialog> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _loading = false;
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
            if (_loading) ...[
              SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade700),
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
                'Fitur "${widget.itemName}" telah aktif.',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
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
