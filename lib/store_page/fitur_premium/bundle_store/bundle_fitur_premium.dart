import 'package:flutter/material.dart';
import 'dart:async';
import 'promo_twin_date_logic.dart';

class BundleFiturPremiumLogic {
  static const int item1Price = 199000;
  static const int item2Price = 249000;
  static const int item3Price = 49000;
  static const int item4Price = 129000;

  static const double baseDiscountRate = 0.15; // 15% base

  static double get effectiveDiscountRate => baseDiscountRate + PromoTwinDateLogic.getBonusDiscountRate();

  static int get originalTotalPrice => item1Price + item2Price + item3Price + item4Price;
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

  static bool isAllUnlocked({
    required bool premiumUnlocked,
    required bool godModeUnlocked,
    required bool removeAdsUnlocked,
    required bool immunityUnlocked,
  }) {
    return premiumUnlocked && godModeUnlocked && removeAdsUnlocked && immunityUnlocked;
  }
}

class BundleFiturPremiumCard extends StatefulWidget {
  final bool isUnlocked;
  final VoidCallback onPurchaseSuccess;

  const BundleFiturPremiumCard({
    super.key,
    required this.isUnlocked,
    required this.onPurchaseSuccess,
  });

  @override
  State<BundleFiturPremiumCard> createState() => _BundleFiturPremiumCardState();
}

class _BundleFiturPremiumCardState extends State<BundleFiturPremiumCard> {
  void _simulatePurchase(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PurchaseSimulationDialog(
        itemName: 'Paket Ultimate Fitur Premium (Hemat 15%)',
        onSuccess: () {
          widget.onPurchaseSuccess();
          if (mounted) setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 16,
        vertical: isMobile ? 4 : 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF4A148C), const Color(0xFF1A237E)]
              : [const Color(0xFFF3E5F5), const Color(0xFFE8EAF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: widget.isUnlocked ? Colors.green.shade400 : Colors.purple.shade400,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.isUnlocked ? Colors.green : Colors.purple).withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 10 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 10,
                    vertical: isMobile ? 3 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isUnlocked ? Colors.green.shade700 : Colors.purple.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.isUnlocked ? Icons.check_circle : Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: isMobile ? 12 : 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.isUnlocked ? 'SEMUA TERBUKA' : 'BUNDLE ULTIMATE (HEMAT 15%)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 10 : 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!widget.isUnlocked)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 6 : 8,
                      vertical: isMobile ? 2 : 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Text(
                      BundleFiturPremiumLogic.savingsStr,
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: isMobile ? 10 : 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 10),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.purple.shade900.withValues(alpha: 0.4) : Colors.purple.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.stars_rounded, color: Colors.purpleAccent, size: isMobile ? 20 : 24),
                ),
                SizedBox(width: isMobile ? 10 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buka Semua Fitur Premium',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.purple.shade200 : Colors.purple.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Akses 4 Fitur Sekaligus: Akses 18+, God Mode, Bebas Iklan, & Kekebalan Abadi!',
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 12,
                          color: isDark ? Colors.white70 : Colors.grey.shade800,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 12),
            const Divider(height: 1),
            SizedBox(height: isMobile ? 8 : 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.isUnlocked)
                      Text(
                        BundleFiturPremiumLogic.originalPriceStr,
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      widget.isUnlocked ? 'Semua Fitur Premium Aktif' : BundleFiturPremiumLogic.bundlePriceStr,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 17,
                        fontWeight: FontWeight.bold,
                        color: widget.isUnlocked ? Colors.green : (isDark ? Colors.purple.shade300 : Colors.purple.shade800),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isUnlocked ? Colors.green.shade600 : const Color(0xFF8A5A32),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 14,
                      vertical: isMobile ? 6 : 9,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: widget.isUnlocked ? 0 : 3,
                  ),
                  onPressed: widget.isUnlocked ? null : () => _simulatePurchase(context),
                  icon: Icon(
                    widget.isUnlocked ? Icons.check_rounded : Icons.shopping_bag_rounded,
                    size: isMobile ? 14 : 16,
                  ),
                  label: Text(
                    widget.isUnlocked ? 'Aktif' : 'Beli Paket Bundle',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseSimulationDialog extends StatefulWidget {
  final String itemName;
  final VoidCallback onSuccess;

  const _PurchaseSimulationDialog({
    required this.itemName,
    required this.onSuccess,
  });

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
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(_step == 0 ? 'Memproses Pembelian...' : 'Pembelian Berhasil! 🎉'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_step == 0) ...[
            const CircularProgressIndicator(color: Color(0xFF8A5A32)),
            const SizedBox(height: 16),
            Text('Menghubungkan ke Store untuk ${widget.itemName}...'),
          ] else ...[
            const Icon(Icons.stars_rounded, color: Colors.purpleAccent, size: 50),
            const SizedBox(height: 12),
            const Text(
              'Selamat! Seluruh Fitur Premium (Akses 18+, God Mode, Bebas Iklan, & Kekebalan Abadi) telah resmi aktif!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ],
      ),
      actions: [
        if (_step == 1)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A5A32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              widget.onSuccess();
              Navigator.pop(context);
            },
            child: const Text('Mantap!'),
          ),
      ],
    );
  }
}
