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

          // 1. Pramuka (Siaga/Penggalang)
          ListTile(
            leading: const Text('camping', style: TextStyle(fontSize: 24)),
            title: const Text('Pramuka (Siaga/Penggalang)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Melatih kemandirian, kerja sama tim, dan cinta alam.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 3;
              int happyGain = random.nextInt(4) + 3;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Pramuka',
                content: Text('Kamu belajar memasang tenda dan membuat api unggun! Karma +$karmaGain%, Kebahagiaan +$happyGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 2. Seni Rupa & Musik
          ListTile(
            leading: const Text('🎨', style: TextStyle(fontSize: 24)),
            title: const Text('Seni Rupa & Musik', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Menggambar, melukis, atau bermain alat musik sederhana.'),
            onTap: () {
              Navigator.pop(context);
              int happyGain = random.nextInt(5) + 4;
              int appGain = random.nextInt(3) + 2;
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              character.appearance = (character.appearance + appGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Seni Rupa & Musik',
                content: Text('Kamu membuat lukisan pemandangan dan menyanyikan lagu. Kebahagiaan +$happyGain%, Penampilan +$appGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 3. Olahraga (Sepak Bola/Bulu Tangkis)
          ListTile(
            leading: const Text('⚽', style: TextStyle(fontSize: 24)),
            title: const Text('Olahraga (Sepak Bola/Bulu Tangkis)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Melatih fisik dan kelincahan.'),
            onTap: () {
              Navigator.pop(context);
              int healthGain = random.nextInt(5) + 4;
              character.health = (character.health + healthGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Olahraga',
                content: Text('Kamu bermain sepak bola bersama teman-teman! Kesehatan +$healthGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 4. Paskibra
          ListTile(
            leading: const Text('🚩', style: TextStyle(fontSize: 24)),
            title: const Text('Paskibra', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Melatih kedisiplinan dan baris-berbaris.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 3;
              int appGain = random.nextInt(3) + 2;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              character.appearance = (character.appearance + appGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Paskibra',
                content: Text('Kamu berlatih baris-berbaris dengan disiplin tinggi! Karma +$karmaGain%, Penampilan +$appGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 5. PMR (Palang Merah Remaja) Mula
          ListTile(
            leading: const Text('✚', style: TextStyle(fontSize: 24)),
            title: const Text('PMR (Palang Merah Remaja)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Pengenalan dasar pertolongan pertama dan kepedulian sosial.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(5) + 4;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'PMR',
                content: Text('Kamu belajar memberikan pertolongan pertama pada luka ringan. Karma +$karmaGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 6. Robotika / Coding Dasar
          ListTile(
            leading: const Text('🤖', style: TextStyle(fontSize: 24)),
            title: const Text('Robotika / Coding Dasar', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Pengenalan logika pemrograman dan permainan edukasi teknologi.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(5) + 4;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Robotika / Coding',
                content: Text('Kamu membuat robot sederhana dari karton dan belajar logika programming! Kecerdasan +$intGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 7. Renang
          ListTile(
            leading: const Text('🏊', style: TextStyle(fontSize: 24)),
            title: const Text('Renang', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Melatih seluruh otot tubuh.'),
            onTap: () {
              Navigator.pop(context);
              int healthGain = random.nextInt(5) + 4;
              character.health = (character.health + healthGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Renang',
                content: Text('Kamu berenang sejauh 25 meter! Kesehatan +$healthGain%!'),
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
