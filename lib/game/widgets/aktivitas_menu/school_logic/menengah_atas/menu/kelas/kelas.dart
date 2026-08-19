// lib/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/kelas/kelas.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class KelasMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '📖 Ruang Kelas (SMA)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pilih apa yang ingin kamu lakukan di kelas SMA:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('✏️', style: TextStyle(fontSize: 24)),
            title: const Text('Perhatikan Pelajaran', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mendengarkan materi kalkulus dan biokimia.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(6) + 4; // +4 to +9
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Perhatikan Pelajaran',
                content: Text('Kamu mengikuti pelajaran dengan penuh konsentrasi. Kecerdasanmu meningkat +$gain%!'),
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
