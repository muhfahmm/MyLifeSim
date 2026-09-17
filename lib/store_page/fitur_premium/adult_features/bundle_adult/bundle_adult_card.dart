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
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isUnlocked ? Colors.purpleAccent : Colors.pinkAccent.shade100,
              width: 1.5,
            ),
          ),
          color: isDark ? const Color(0xFF2D1F3D) : const Color(0xFFFFF0F5),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_user, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              const Text(
                                'Akses Penuh (18+)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.purpleAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'BUNDLE HEMAT',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Buka SEMUA kategori fitur 18+, inses, masturbasi & hubungan guru-murid sekaligus.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUnlocked ? Colors.grey : Colors.purple.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      isUnlocked ? '✔ TERBELI (AKSES PENUH 18+ AKTIF)' : 'Beli Bundle Full Access - Rp 199.000',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
