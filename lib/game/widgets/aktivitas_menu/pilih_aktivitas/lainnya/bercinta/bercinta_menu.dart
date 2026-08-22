// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/bercinta/bercinta_menu.dart
//
// Menu helper untuk aktivitas Bercinta dari menu Pilih Aktivitas.
// Placeholder — fitur ini akan dikembangkan lebih lanjut.
//
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class BercintaMenuHelper {
  /// Tampilkan menu Bercinta.
  static void showBercintaMenu(BuildContext context, Character character, VoidCallback onComplete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.pinkAccent),
            SizedBox(width: 8),
            Text('Bercinta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: const Text(
          'Fitur Bercinta sedang dalam pengembangan.\nNantikan pembaruan selanjutnya! 💕',
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
