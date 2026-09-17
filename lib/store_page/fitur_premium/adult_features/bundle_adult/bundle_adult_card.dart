import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';

class BundleAdultCard extends StatelessWidget {
  final Function(String itemName, VoidCallback onPurchased) onPurchase;

  const BundleAdultCard({
    super.key,
    required onPurchase,
  }) : onPurchase = onPurchase;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<bool>(
      valueListenable: GlobalSettings.isPremium,
      builder: (context, isUnlocked, _) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C1B3E) : const Color(0xFFF6EEFA),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isUnlocked ? Colors.purpleAccent : const Color(0xFFAB47BC),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Pill 1: BUNDLE ADULT (HEMAT 38%)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B1FA2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'BUNDLE ADULT 18+ (HEMAT 38%)',
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

                // Top Pill 2: Hemat Rp 367.000 (38%)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF4A1A2C) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300, width: 0.8),
                  ),
                  child: Text(
                    'Hemat Rp 367.000 (38%)',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.red.shade200 : Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Main Title & Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF4A1E6D) : const Color(0xFFE1BEE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.star, color: Color(0xFF8E24AA), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buka Semua Fitur 18+',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.purple.shade100 : const Color(0xFF4A148C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Akses 4 Fitur Dewasa Sekaligus: Fitur Masturbasi, Hubungan Dewasa (ML), Hubungan Inses (Keluarga), & Hubungan Guru & Atasan!',
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

                // Divider Line
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? Colors.purple.shade900 : Colors.purple.shade100,
                ),
                const SizedBox(height: 12),

                // Bottom Section: Coret Price + Current Price & Beli Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rp 966.000',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Rp 599.000',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.purple.shade200 : const Color(0xFF6A1B9A),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: isUnlocked
                          ? null
                          : () {
                              onPurchase(
                                'Paket Bundle Akses Penuh (18+)',
                                () {
                                  GlobalSettings.isPremium.value = true;
                                },
                              );
                            },
                      icon: Icon(
                        isUnlocked ? Icons.check : Icons.shopping_bag,
                        size: 16,
                      ),
                      label: Text(
                        isUnlocked ? 'Terbeli' : 'Beli Paket Bundle',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isUnlocked ? Colors.grey : const Color(0xFF8D4E2A),
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
  }
}
