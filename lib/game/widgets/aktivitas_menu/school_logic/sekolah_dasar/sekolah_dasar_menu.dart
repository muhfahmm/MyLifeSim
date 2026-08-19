// lib/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/sekolah_dasar_menu.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class SekolahDasarMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: 'Sekolah Dasar (SD) 🏫',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Kamu adalah murid Sekolah Dasar. Pilih aktivitas sekolahmu:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('📚', style: TextStyle(fontSize: 24)),
            title: const Text('Belajar dengan Giat', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Meningkatkan kecerdasan otakmu.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(6) + 5; // +5 to +10
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              onRefresh();
              
              DialogHelper.show(
                context: context,
                title: 'Belajar Giat',
                content: Text('Kamu memperhatikan penjelasan guru dengan fokus. Kecerdasanmu meningkat +$gain%!'),
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
            leading: const Text('🎒', style: TextStyle(fontSize: 24)),
            title: const Text('Cari Teman Baru', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Bermain bersama di halaman sekolah.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(6) + 5; // +5 to +10
              character.happiness = (character.happiness + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Teman Baru',
                content: Text('Kamu bermain petak umpet dan mendapatkan teman baru! Kebahagiaanmu meningkat +$gain%!'),
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
            leading: const Text('🧑🏫', style: TextStyle(fontSize: 24)),
            title: const Text('Tanya Pertanyaan ke Guru', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Menjawab rasa penasaranmu.'),
            onTap: () {
              Navigator.pop(context);
              int smartGain = random.nextInt(4) + 2;
              int karmaGain = random.nextInt(4) + 2;
              character.intelligence = (character.intelligence + smartGain).clamp(0, 100);
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Interaksi Guru',
                content: Text('Guru senang dengan rasa ingin tahumu dan menjawab pertanyaanmu dengan ramah. Kecerdasan +$smartGain%, Karma +$karmaGain%!'),
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
