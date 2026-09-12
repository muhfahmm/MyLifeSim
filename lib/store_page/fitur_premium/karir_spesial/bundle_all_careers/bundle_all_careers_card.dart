// lib/store_page/fitur_premium/karir_spesial/bundle_all_careers/bundle_all_careers_card.dart

import 'package:flutter/material.dart';
import 'bundle_all_careers_logic.dart';
import 'dart:async';

class BundleAllCareersCard extends StatefulWidget {
  final VoidCallback? onPurchased;

  const BundleAllCareersCard({
    super.key,
    this.onPurchased,
  });

  @override
  State<BundleAllCareersCard> createState() => _BundleAllCareersCardState();
}

class _BundleAllCareersCardState extends State<BundleAllCareersCard> {
  void _simulatePurchase(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PurchaseSimulationDialog(
        itemName: 'Paket Bundle Semua Karir Spesial (Hemat 25%)',
        onSuccess: () {
          BundleAllCareersLogic.unlockAllCareers();
          if (mounted) setState(() {});
          if (widget.onPurchased != null) widget.onPurchased!();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isUnlocked = BundleAllCareersLogic.isAllCareersUnlocked;
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
              ? [const Color(0xFF3E2723), const Color(0xFF1B1B1B)]
              : [const Color(0xFFFFF8E1), const Color(0xFFFFF3E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isUnlocked ? Colors.green.shade400 : const Color(0xFFD97706),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isUnlocked ? Colors.green : Colors.amber).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 10 : 16),
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
                    color: isUnlocked ? Colors.green.shade700 : const Color(0xFFD97706),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUnlocked ? Icons.check_circle : Icons.local_fire_department,
                        color: Colors.white,
                        size: isMobile ? 12 : 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isUnlocked ? 'SUDAH AKTIF' : 'BUNDLE HEMAT 25%',
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
                if (!isUnlocked)
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
                      BundleAllCareersLogic.savingsStr,
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: isMobile ? 10 : 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 8 : 10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.amber.shade900.withValues(alpha: 0.4) : Colors.amber.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Text('👑', style: TextStyle(fontSize: isMobile ? 20 : 24)),
                ),
                SizedBox(width: isMobile ? 10 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buka Semua Karir Spesial',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 17,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.amber.shade200 : const Color(0xFF78350F),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Akses instan 13 cabang karir: Militer (AD, AL, AU), Politik, Pembisnis, Atlit, Aktor, Astronot, Model, Idol, & E-Sports!',
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 12,
                          color: isDark ? Colors.white70 : Colors.brown.shade700,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 14),
            const Divider(height: 1),
            SizedBox(height: isMobile ? 8 : 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUnlocked)
                      Text(
                        BundleAllCareersLogic.originalPriceStr,
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      isUnlocked ? 'Semua Karir Terbuka' : BundleAllCareersLogic.bundlePriceStr,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 18,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Colors.green : (isDark ? Colors.amber.shade300 : const Color(0xFFB45309)),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isUnlocked ? Colors.green.shade600 : const Color(0xFF8A5A32),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 16,
                      vertical: isMobile ? 6 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: isUnlocked ? 0 : 3,
                  ),
                  onPressed: isUnlocked ? null : () => _simulatePurchase(context),
                  icon: Icon(
                    isUnlocked ? Icons.check_rounded : Icons.shopping_bag_rounded,
                    size: isMobile ? 14 : 16,
                  ),
                  label: Text(
                    isUnlocked ? 'Aktif' : 'Beli Paket Bundle',
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 13,
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
            Text('Menghubungkan ke Google Play / App Store untuk ${widget.itemName}...'),
          ] else ...[
            const Icon(Icons.stars_rounded, color: Colors.amber, size: 50),
            const SizedBox(height: 12),
            const Text(
              'Selamat! Selamat menikmati akses penuh ke seluruh cabang Karir Spesial di MyLifeSim!',
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
