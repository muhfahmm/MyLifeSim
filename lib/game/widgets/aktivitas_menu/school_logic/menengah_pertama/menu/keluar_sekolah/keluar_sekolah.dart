// lib/game/widgets/aktivitas_menu/school_logic/menengah_pertama/menu/keluar_sekolah/keluar_sekolah.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class KeluarSekolahMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '🚪 Keluar Sekolah (SMP)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Apakah kamu serius ingin putus sekolah dari SMP?',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('🚪', style: TextStyle(fontSize: 24)),
            title: const Text('Putus Sekolah', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Berhenti sekolah secara permanen.'),
            onTap: () {
              Navigator.pop(context);
              int intLoss = random.nextInt(8) + 6;
              int karmaLoss = random.nextInt(8) + 6;
              character.intelligence = (character.intelligence - intLoss).clamp(0, 100);
              character.karma = (character.karma - karmaLoss).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Putus Sekolah',
                content: Text('Kamu memutuskan keluar dari SMP. Orang tuamu sangat marah. Kecerdasan -$intLoss%, Karma -$karmaLoss%!'),
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
