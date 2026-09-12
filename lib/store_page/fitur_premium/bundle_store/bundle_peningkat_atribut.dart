import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'dart:async';
import 'promo_twin_date_logic.dart';

class BundlePeningkatAtributLogic {
  static const int item1Price = 25000;
  static const int item2Price = 35000;
  static const int item3Price = 45000;

  static const double baseDiscountRate = 0.10; // 10% base

  static double get effectiveDiscountRate => baseDiscountRate + PromoTwinDateLogic.getBonusDiscountRate();

  static int get originalTotalPrice => item1Price + item2Price + item3Price;
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

  static void applyAllBoosters(Character? character) {
    if (character != null) {
      character.health = 100;
      character.happiness = 100;
      character.intelligence = 100;
    }
  }
}

class BundlePeningkatAtributCard extends StatefulWidget {
  final Character? character;
  final bool isUnlocked;
  final VoidCallback onPurchaseSuccess;

  const BundlePeningkatAtributCard({
    super.key,
    required this.character,
    this.isUnlocked = false,
    required this.onPurchaseSuccess,
  });

  @override
  State<BundlePeningkatAtributCard> createState() => _BundlePeningkatAtributCardState();
}

class _BundlePeningkatAtributCardState extends State<BundlePeningkatAtributCard> {
  void _simulatePurchase(BuildContext context) {
    if (widget.character == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membutuhkan karakter aktif untuk menggunakan item ini!')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PurchaseSimulationDialog(
        itemName: 'Paket Bundle Peningkat Atribut Max (Hemat 10%)',
        onSuccess: () {
          BundlePeningkatAtributLogic.applyAllBoosters(widget.character);
          widget.onPurchaseSuccess();
          if (mounted) setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1B5E20), const Color(0xFF0D47A1)]
              : [const Color(0xFFE8F5E9), const Color(0xFFE3F2FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: widget.isUnlocked ? Colors.green.shade400 : Colors.teal.shade400,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.isUnlocked ? Colors.green : Colors.teal).withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.isUnlocked ? Colors.green.shade700 : Colors.teal.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.isUnlocked ? Icons.check_circle : Icons.bolt_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.isUnlocked ? 'SUDAH MAX (100%)' : 'PAKET COMBO ATRIBUT 100%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!widget.isUnlocked)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Text(
                      BundlePeningkatAtributLogic.savingsStr,
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.teal.shade900.withValues(alpha: 0.4) : Colors.teal.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.tealAccent, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paket Atribut Max Instan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.teal.shade200 : Colors.teal.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Memulihkan Kesehatan (100%), Kebahagiaan (100%), & Kecerdasan (100%) sekaligus!',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.isUnlocked)
                      Text(
                        BundlePeningkatAtributLogic.originalPriceStr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      widget.isUnlocked ? 'Semua Atribut Max (100%)' : BundlePeningkatAtributLogic.bundlePriceStr,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: widget.isUnlocked ? Colors.green : (isDark ? Colors.teal.shade300 : Colors.teal.shade800),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isUnlocked ? Colors.green.shade600 : const Color(0xFF8A5A32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: widget.isUnlocked ? 0 : 3,
                  ),
                  onPressed: widget.isUnlocked ? null : () => _simulatePurchase(context),
                  icon: Icon(widget.isUnlocked ? Icons.check_rounded : Icons.shopping_bag_rounded, size: 16),
                  label: Text(
                    widget.isUnlocked ? 'Aktif' : 'Beli Combo Atribut',
                    style: const TextStyle(
                      fontSize: 12,
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
            const Icon(Icons.favorite, color: Colors.redAccent, size: 50),
            const SizedBox(height: 12),
            const Text(
              'Selamat! Kesehatan, Kebahagiaan, dan Kecerdasan karaktermu kini 100% penuh!',
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
            child: const Text('Luar Biasa!'),
          ),
      ],
    );
  }
}
