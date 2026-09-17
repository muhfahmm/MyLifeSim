// lib/store_page/fitur_premium/assets_premium/bundle_assets_card.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';

class BundleAssetsCard extends StatelessWidget {
  final Function(String itemName, VoidCallback onPurchased) onPurchase;

  const BundleAssetsCard({
    super.key,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<bool>(
      valueListenable: GlobalSettings.isAssetsCasinoUnlocked,
      builder: (context, isCasino, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: GlobalSettings.isAssetsGarasiMobilUnlocked,
          builder: (context, isGarasiMobil, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isAssetsGarasiMotorUnlocked,
              builder: (context, isGarasiMotor, _) {
                final bool isAllUnlocked = isCasino && isGarasiMobil && isGarasiMotor;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF3E2B1B) : const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isAllUnlocked ? Colors.amber.shade400 : Colors.amber.shade700,
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pill 1: BUNDLE ASET (HEMAT 35%)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade800,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'PAKET BUNDLE ASET (HEMAT 35%)',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Pill 2: Hemat Rp 159.000
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF4A341A) : const Color(0xFFFFECB3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.shade600, width: 0.8),
                          ),
                          child: Text(
                            'Hemat Rp 159.000 (Potongan Spesial)',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.amber.shade200 : Colors.amber.shade900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Icon & Text Main
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade800,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Buka Semua Aset Premium',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dapatkan 3 Aset Sekaligus: Hiburan Casino VIP jackpot, Koleksi Garasi Mobil hypercar, & Garasi Motor superbike!',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      height: 1.35,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark ? Colors.amber.shade900 : Colors.amber.shade200,
                        ),
                        const SizedBox(height: 12),

                        // Bottom Action: Coret Price & Buy Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rp 457.000',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  'Rp 298.000',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.amberAccent : Colors.amber.shade900,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: isAllUnlocked
                                  ? null
                                  : () {
                                      onPurchase(
                                        'Paket Bundle Aset Premium',
                                        () {
                                          GlobalSettings.isAssetsCasinoUnlocked.value = true;
                                          GlobalSettings.isAssetsGarasiMobilUnlocked.value = true;
                                          GlobalSettings.isAssetsGarasiMotorUnlocked.value = true;
                                          GlobalSettings.saveSessionStorage();
                                        },
                                      );
                                    },
                              icon: Icon(
                                isAllUnlocked ? Icons.check : Icons.shopping_bag_rounded,
                                size: 16,
                              ),
                              label: Text(
                                isAllUnlocked ? 'Terbeli ✔' : 'Beli Paket Bundle',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isAllUnlocked ? Colors.grey : Colors.amber.shade800,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                elevation: 3,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
