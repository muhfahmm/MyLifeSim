// lib/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/ekstrakurikuler/ekstrakurikuler.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class EkstrakurikulerMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '🎯 Ekstrakurikuler (SMA)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ikuti klub ekstrakurikuler di SMA:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('🎯', style: TextStyle(fontSize: 24)),
            title: const Text('Ikut Ekstrakurikuler', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Klub kesenian atau olahraga sekolah.'),
            onTap: () {
              Navigator.pop(context);
              int healthGain = random.nextInt(6) + 4;
              int happyGain = random.nextInt(6) + 4;
              character.health = (character.health + healthGain).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Ekstrakurikuler',
                content: Text('Kamu bergabung dengan klub seni dan mengembangkan bakatmu! Kesehatan +$healthGain%, Kebahagiaan +$happyGain%!'),
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
