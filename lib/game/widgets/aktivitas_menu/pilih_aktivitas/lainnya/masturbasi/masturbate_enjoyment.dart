import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class MasturbateEnjoymentModal {
  static void show({
    required BuildContext context,
    required Character character,
    required String fantasyPartner,
    required bool isMutual,
    String partnerName = '',
    String partnerRelation = '',
    required VoidCallback onComplete,
    String? additionalText,
  }) {
    final Random random = Random();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Hitung tingkat kenikmatan secara dinamis
    int userEnjoyment = ((character.health * 0.4) + (character.happiness * 0.4) + 15).round();
    userEnjoyment = (userEnjoyment + random.nextInt(21) - 10).clamp(10, 100);

    int partnerEnjoyment = 0;
    if (isMutual) {
      partnerEnjoyment = (50 + random.nextInt(41) - 10).clamp(15, 100);
    }

    String getDescription(int enjoyment) {
      if (enjoyment >= 85) return 'Sangat Puas & Rileks! 💦🔥';
      if (enjoyment >= 65) return 'Cukup Menyenangkan & Melepas Stres 😊';
      if (enjoyment >= 45) return 'Biasa Saja 🙂';
      if (enjoyment >= 25) return 'Kurang Memuaskan 😐';
      return 'Buruk & Hambar 😟';
    }

    final String userDesc = getDescription(userEnjoyment);
    final String partnerDesc = isMutual ? getDescription(partnerEnjoyment) : '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.amber, size: 28),
              const SizedBox(width: 8),
              Text(
                isMutual ? 'Hasil Masturbasi Bersama 💦' : 'Hasil Masturbasi 💦',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMutual 
                  ? 'Kamu dan $partnerRelation ($partnerName) baru saja melakukan masturbasi bersama.'
                  : 'Kamu baru saja selesai melakukan masturbasi (Fokus: $fantasyPartner).',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),

              // Bar Kenikmatan User
              Text(
                'Kenikmatan Kamu:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: userEnjoyment / 100.0,
                        backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        color: Colors.amber,
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$userEnjoyment%',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.amber),
                  ),
                ],
              ),
              Text(
                userDesc,
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),

              if (isMutual) ...[
                const SizedBox(height: 16),
                // Bar Kenikmatan Pasangan
                Text(
                  'Kenikmatan $partnerRelation ($partnerName):',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: partnerEnjoyment / 100.0,
                          backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          color: Colors.orangeAccent,
                          minHeight: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$partnerEnjoyment%',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.orangeAccent),
                    ),
                  ],
                ),
                Text(
                  partnerDesc,
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
              ],

              if (additionalText != null && additionalText.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  ),
                  child: Text(
                    additionalText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.blue.shade200 : Colors.blue.shade800,
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                onComplete();
              },
              child: Text(
                'Mengerti',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.blueAccent : Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
