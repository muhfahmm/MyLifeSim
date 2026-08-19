// lib/game/widgets/aktivitas_menu/school_logic/menengah_pertama/menu/belajar/belajar.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class BelajarMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '📚 Belajar Lebih Giat (SMP)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pilih metode belajar untuk meningkatkan nilaimu:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('📖', style: TextStyle(fontSize: 24)),
            title: const Text('Belajar Mandiri', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Belajar di kamar tanpa gangguan.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(5) + 4; // +4 to +8
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Belajar Mandiri',
                content: Text('Kamu meringkas catatan sekolah dan memahaminya dengan baik. Kecerdasan +$gain%!'),
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
