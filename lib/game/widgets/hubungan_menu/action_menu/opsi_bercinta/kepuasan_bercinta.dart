import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart';

class KepuasanBercintaHelper {
  /// Mengecek apakah pasangan bersedia bercinta berdasarkan tingkat kepuasan hubungan (0-100).
  static bool checkWillingness({
    required BuildContext context,
    required Character character,
    required String targetName,
    required String targetGender,
    required int satisfaction,
    required VoidCallback onRejected,
    required VoidCallback onAccepted,
  }) {
    final String myGender = character.gender.trim().toLowerCase();
    final String partnerGender = targetGender.trim().toLowerCase();
    final Random random = Random();

    final Map<String, dynamic> result = HubunganIntimLogic.checkInitialWillingness(
      myGender: myGender,
      partnerGender: partnerGender,
      satisfaction: satisfaction,
      random: random,
    );

    final bool isWilling = result['isWilling'] as bool;
    final String rejectReason = result['rejectReason'] as String;

    if (!isWilling) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.heart_broken, color: Colors.red),
              SizedBox(width: 8),
              Text('Ajakan Ditolak 💔', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            '$targetName $rejectReason Rawatlah hubunganmu terlebih dahulu!',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onRejected();
              },
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return false;
    } else {
      onAccepted();
      return true;
    }
  }
}

class MLEnjoymentModal {
  static void show({
    required BuildContext context,
    required Character character,
    required String partnerName,
    required String partnerRelation,
    required int relationshipValue,
    required VoidCallback onComplete,
    String? additionalText,
  }) {
    final Random random = Random();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Hitung tingkat kenikmatan secara dinamis
    int userEnjoyment = ((character.health * 0.3) + (character.happiness * 0.3) + (relationshipValue * 0.4)).round();
    userEnjoyment = (userEnjoyment + random.nextInt(21) - 10).clamp(10, 100);

    // Ganti character.looks menjadi character.appearance
    int partnerEnjoyment = ((relationshipValue * 0.6) + (character.appearance * 0.2) + 20).round();
    partnerEnjoyment = (partnerEnjoyment + random.nextInt(21) - 10).clamp(15, 100);

    String getDescription(int enjoyment) {
      if (enjoyment >= 85) return 'Sangat Memuaskan! 🔥😍';
      if (enjoyment >= 65) return 'Menyenangkan & Bergairah 😊';
      if (enjoyment >= 45) return 'Biasa Saja 🙂';
      if (enjoyment >= 25) return 'Kurang Bergairah 😐';
      return 'Sangat Buruk & Hambar 😟';
    }

    final String userDesc = getDescription(userEnjoyment);
    final String partnerDesc = getDescription(partnerEnjoyment);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.pink, size: 28),
              const SizedBox(width: 8),
              Text(
                'Hasil Hubungan Intim 💒',
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
                'Kalian baru saja menyelesaikan hubungan intim secara intim.',
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
                        color: Colors.pinkAccent,
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$userEnjoyment%',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.pinkAccent),
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
                        color: Colors.purpleAccent,
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$partnerEnjoyment%',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.purpleAccent),
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

              if (additionalText != null && additionalText.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
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
                'Lanjutkan',
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
