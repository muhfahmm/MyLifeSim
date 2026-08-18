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
