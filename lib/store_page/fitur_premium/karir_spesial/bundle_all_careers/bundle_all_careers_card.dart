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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_step == 0) ...[
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFFD97706),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Memproses Pembelian...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Menghubungkan ke Google Play / App Store untuk ${widget.itemName}...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: subtextColor,
              ),
            ),
          ] else ...[
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.stars_rounded, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 18),
            Text(
              'Pembelian Berhasil! 🎉',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Selamat! Selamat menikmati akses penuh ke seluruh cabang Karir Spesial di MyLifeSim!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: subtextColor,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  widget.onSuccess();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Mantap!',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.5),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
