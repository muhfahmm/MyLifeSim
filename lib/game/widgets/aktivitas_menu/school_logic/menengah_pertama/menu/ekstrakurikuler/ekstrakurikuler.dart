// lib/game/widgets/aktivitas_menu/school_logic/menengah_pertama/menu/ekstrakurikuler/ekstrakurikuler.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class EkstrakurikulerMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '🏀 Ekstrakurikuler (SMP)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ikuti kegiatan ekstrakurikuler di SMP:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('🏀', style: TextStyle(fontSize: 24)),
            title: const Text('Klub Basket', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Melatih fisik dan kerja sama tim.'),
            onTap: () {
              Navigator.pop(context);
              int healthGain = random.nextInt(5) + 4; // +4 to +8
              int happyGain = random.nextInt(5) + 4;
              character.health = (character.health + healthGain).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Klub Basket',
                content: Text('Kamu memenangkan pertandingan persahabatan antar kelas! Kesehatan +$healthGain%, Kebahagiaan +$happyGain%!'),
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
