// lib/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/belajar/belajar.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class BelajarMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '📚 Belajar Lebih Giat (SD)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Bagaimana cara kamu belajar giat hari ini?',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('✍️', style: TextStyle(fontSize: 24)),
            title: const Text('Kerjakan PR', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Menyelesaikan pekerjaan rumah tepat waktu.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(4) + 4; // +4 to +7
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              character.karma = (character.karma + 2).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Kerjakan PR',
                content: Text('Kamu menyelesaikan PR matematika dengan benar. Kecerdasan +$gain%, Karma +2%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),
          ListTile(
            leading: const Text('📖', style: TextStyle(fontSize: 24)),
            title: const Text('Membaca Buku di Perpustakaan', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mencari buku pengetahuan baru.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(5) + 3;
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Membaca Buku',
                content: Text('Kamu membaca ensiklopedia dinosaurus dan sains. Kecerdasanmu meningkat +$gain%!'),
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
