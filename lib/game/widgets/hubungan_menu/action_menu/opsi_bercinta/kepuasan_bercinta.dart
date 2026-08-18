import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

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
    final bool isHetero = myGender != partnerGender;

    bool isWilling = true;
    String rejectReason = '';

    if (isHetero) {
      // --- LOGIKA HETEROSEXUAL (LAKI DENGAN PEREMPUAN) ---
      final Random random = Random();
      final int roll = random.nextInt(100);

      if (satisfaction >= 60) {
        // 70% Peluang mau
        if (roll < 70) {
          isWilling = true;
        } else {
          isWilling = false;
          rejectReason = 'sedang tidak dalam mood yang baik meskipun hubungan kalian cukup dekat ($satisfaction%).';
        }
      } else if (satisfaction >= 50) {
        // 50% Peluang mau
        if (roll < 50) {
          isWilling = true;
        } else {
          isWilling = false;
          rejectReason = 'merasa hubungan kalian kurang hangat untuk melakukan itu ($satisfaction%).';
        }
      } else {
        // Di bawah 50% selalu menolak
        isWilling = false;
        rejectReason = 'menolak mentah-mentah karena tingkat kepuasan hubungannya terlalu rendah ($satisfaction%).';
      }
    } else {
      // --- LOGIKA NORMAL / SESAMA GENDER ---
      if (satisfaction <= 40) {
        isWilling = false;
        rejectReason = 'menolak ajakanmu untuk berhubungan intim karena tingkat kepuasan hubungannya saat ini terlalu rendah ($satisfaction%).';
      } else {
        isWilling = true;
      }
    }

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
