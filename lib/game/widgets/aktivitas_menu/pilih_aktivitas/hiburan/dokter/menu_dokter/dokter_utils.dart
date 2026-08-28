import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class DokterUtils {
  static String fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  static void updateStats(Character character, int healthGain, int happinessGain, int intelligenceGain) {
    character.health = (character.health + healthGain).clamp(0, 100);
    character.happiness = (character.happiness + happinessGain).clamp(0, 100);
    character.intelligence = (character.intelligence + intelligenceGain).clamp(0, 100);
  }

  static void showResultDialog(BuildContext context, String title, String msg, VoidCallback onComplete) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}