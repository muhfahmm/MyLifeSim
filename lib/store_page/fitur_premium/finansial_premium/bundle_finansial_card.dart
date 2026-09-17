// lib/store_page/fitur_premium/finansial_premium/bundle_finansial_card.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';

class BundleFinansialCard extends StatelessWidget {
  final Function(String itemName, VoidCallback onPurchased) onPurchase;

  const BundleFinansialCard({
    super.key,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<bool>(
      valueListenable: GlobalSettings.isFinansialUangTunaiUnlocked,
      builder: (context, isUangTunai, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: GlobalSettings.isFinansialInvestasiUnlocked,
          builder: (context, isInvestasi, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: GlobalSettings.isFinansialKemewahanUnlocked,
              builder: (context, isKemewahan, _) {
                final bool isAllUnlocked = isUangTunai && isInvestasi && isKemewahan;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1B3E26) : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isAllUnlocked ? Colors.green.shade400 : Colors.green.shade600,
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pill 1: BUNDLE FINANSIAL (HEMAT 35%)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade800,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stars_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'PAKET BUNDLE FINANSIAL (HEMAT 35%)',
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

                        // Pill 2: Hemat Rp 200.000
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2E4A1A) : const Color(0xFFDCEDC8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade400, width: 0.8),
                          ),
                          child: Text(
                            'Hemat Rp 200.000 (Potongan Spesial)',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.green.shade200 : Colors.green.shade900,
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
                                color: Colors.green.shade700,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Buka Semua Finansial Premium',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Dapatkan 3 Fitur Sekaligus: Modal Uang Tunai tak terbatas, Portofolio Investasi Saham/Properti, & Barang Kemewahan Super VIP!',
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
                          color: isDark ? Colors.green.shade800 : Colors.green.shade200,
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
                                  'Rp 597.000',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  'Rp 397.000',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.greenAccent : Colors.green.shade800,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: isAllUnlocked
                                  ? null
                                  : () {
                                      onPurchase(
                                        'Paket Bundle Finansial Premium',
                                        () {
                                          GlobalSettings.isFinansialUangTunaiUnlocked.value = true;
                                          GlobalSettings.isFinansialInvestasiUnlocked.value = true;
                                          GlobalSettings.isFinansialKemewahanUnlocked.value = true;
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
                                backgroundColor: isAllUnlocked ? Colors.grey : Colors.green.shade700,
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
