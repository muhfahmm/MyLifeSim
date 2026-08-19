// lib/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/keluar_sekolah/keluar_sekolah.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class KeluarSekolahMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '🚪 Keluar Sekolah (SD)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Keluar dari sekolah dasar memiliki konsekuensi besar bagi masa depanmu. Yakin?',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('⚠️', style: TextStyle(fontSize: 24)),
            title: const Text('Keluar Secara Sepihak', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Berhenti masuk sekolah selamanya.'),
            onTap: () {
              Navigator.pop(context);
              
              int intLoss = random.nextInt(10) + 10; // -10 to -19
              int karmaLoss = random.nextInt(10) + 10;
              character.intelligence = (character.intelligence - intLoss).clamp(0, 100);
              character.karma = (character.karma - karmaLoss).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Keluar Sekolah',
                content: Text('Kamu secara resmi berhenti bersekolah. Kamu menghabiskan waktu bermain di jalanan. Kecerdasan -$intLoss%, Karma -$karmaLoss%!'),
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
