// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/love/love_menu.dart
//
// Placeholder untuk menu Love (Cinta).
// Fitur ini akan dikembangkan lebih lanjut.
//
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class LoveMenuHelper {
  /// Tampilkan menu Love (Cinta) untuk mengekspresikan perasaan cinta.
  static void showLoveMenu(BuildContext context, Character character, VoidCallback onComplete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Love (Cinta)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: const Text(
          'Fitur Love (Cinta) sedang dalam pengembangan.\nNantikan pembaruan selanjutnya! 💕',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
