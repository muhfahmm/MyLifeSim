// lib/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/kelas/kelas.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class KelasMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '📖 Ruang Kelas (SD)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Pilih apa yang ingin kamu lakukan di dalam kelas:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('✏️', style: TextStyle(fontSize: 24)),
            title: const Text('Perhatikan Pelajaran', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mendengarkan penjelasan guru.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(4) + 3; // +3 to +6
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Perhatikan Pelajaran',
                content: Text('Kamu fokus mencatat pelajaran di papan tulis. Kecerdasanmu meningkat +$gain%!'),
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
            leading: const Text('🙋‍♂️', style: TextStyle(fontSize: 24)),
            title: const Text('Aktif Bertanya', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Menjawab atau mengajukan pertanyaan.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(3) + 2;
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              character.karma = (character.karma + 2).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Aktif Bertanya',
                content: Text('Guru terkesan dengan keaktifanmu di kelas. Kecerdasan +$gain%, Karma +2%!'),
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
            leading: const Text('💤', style: TextStyle(fontSize: 24)),
            title: const Text('Tidur di Kelas', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Tidur saat guru sedang menerangkan.'),
            onTap: () {
              Navigator.pop(context);
              int intLoss = random.nextInt(3) + 2;
              int karmaLoss = random.nextInt(3) + 2;
              int healthGain = random.nextInt(3) + 2;
              character.intelligence = (character.intelligence - intLoss).clamp(0, 100);
              character.karma = (character.karma - karmaLoss).clamp(0, 100);
              character.health = (character.health + healthGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Tidur di Kelas',
                content: Text('Kamu ketahuan tertidur dan dihukum berdiri di depan kelas! Kecerdasan -$intLoss%, Karma -$karmaLoss%, Energi/Kesehatan +$healthGain%'),
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
