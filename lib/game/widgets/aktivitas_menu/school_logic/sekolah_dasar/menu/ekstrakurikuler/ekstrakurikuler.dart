// lib/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/ekstrakurikuler/ekstrakurikuler.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class EkstrakurikulerMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '🎨 Ekstrakurikuler (SD)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pilih kegiatan klub yang ingin kamu ikuti:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('⚽', style: TextStyle(fontSize: 24)),
            title: const Text('Klub Sepak Bola', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Latihan fisik bersama teman-teman.'),
            onTap: () {
              Navigator.pop(context);
              int healthGain = random.nextInt(4) + 4; // +4 to +7
              int happyGain = random.nextInt(4) + 3;
              character.health = (character.health + healthGain).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Klub Sepak Bola',
                content: Text('Kamu mencetak gol dalam latihan sepak bola! Kesehatan +$healthGain%, Kebahagiaan +$happyGain%!'),
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
            leading: const Text('🎨', style: TextStyle(fontSize: 24)),
            title: const Text('Klub Menggambar', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mengasah kreativitas seni visual.'),
            onTap: () {
              Navigator.pop(context);
              int happyGain = random.nextInt(5) + 5;
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Klub Menggambar',
                content: Text('Kamu membuat lukisan pemandangan indah. Kebahagiaanmu meningkat +$happyGain%!'),
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
