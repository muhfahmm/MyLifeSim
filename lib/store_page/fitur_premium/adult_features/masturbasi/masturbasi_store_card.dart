import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/settings/global_settings.dart';

class MasturbasiStoreCard extends StatelessWidget {
  final Function(String itemName, VoidCallback onPurchased) onPurchase;

  const MasturbasiStoreCard({
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
          valueListenable: GlobalSettings.isMasturbationUnlocked,
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
                        color: Colors.orange.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.self_improvement, color: Colors.orange.shade800, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fitur Masturbasi 🔞',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Membuka aksi Masturbasi Mandiri & Masturbasi Bersama NPC.',
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
                              onPurchase('Fitur Masturbasi', () {
                                GlobalSettings.isMasturbationUnlocked.value = true;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isUnlocked ? Colors.grey : Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isUnlocked ? 'Terbeli ✔' : 'Rp 219.000',
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
