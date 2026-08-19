// lib/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/belajar/belajar.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class BelajarMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '📚 Belajar Lebih Giat (SMA)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Bagaimana cara kamu belajar untuk persiapan ujian akhir?',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('📖', style: TextStyle(fontSize: 24)),
            title: const Text('Belajar Lebih Giat', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mengulang semua materi ujian nasional.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(6) + 6; // +6 to +11
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Belajar Giat',
                content: Text('Kamu mengikuti bimbel tambahan dan belajar hingga malam. Kecerdasan +$gain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kembali'),
        ),
      ],
    );
  }
}
