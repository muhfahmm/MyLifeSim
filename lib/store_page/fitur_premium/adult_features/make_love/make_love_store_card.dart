import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';

class MakeLoveStoreCard extends StatelessWidget {
  final Function(String itemName, VoidCallback onPurchased) onPurchase;

  const MakeLoveStoreCard({
    super.key,
    required this.onPurchase,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<bool>(
      valueListenable: GlobalSettings.isPremium,
      builder: (context, isFullPremium, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: GlobalSettings.isMakeLoveUnlocked,
          builder: (context, isCategoryUnlocked, _) {
            final bool isUnlocked = isFullPremium || isCategoryUnlocked;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: isUnlocked ? Colors.green.shade400 : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
              ),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.favorite, color: Colors.pink.shade700, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hubungan Dewasa & Sex (ML)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Gratis untuk usia >= 18 tahun. Membuka aksi hubungan intim (ML) sejak usia dini (10-17 tahun).',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? Colors.white60 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: isUnlocked
                          ? null
                          : () {
                              onPurchase('Hubungan Dewasa & Sex (ML)', () {
                                GlobalSettings.isMakeLoveUnlocked.value = true;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isUnlocked ? Colors.grey : Colors.pink.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isUnlocked ? 'Terbeli ✔' : 'Rp 89.000',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
