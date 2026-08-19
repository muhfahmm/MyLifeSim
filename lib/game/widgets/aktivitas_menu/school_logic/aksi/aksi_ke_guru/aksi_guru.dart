// lib/game/widgets/aktivitas_menu/school_logic/aksi/aksi_ke_guru/aksi_guru.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class AksiGuruMenu {
  static void showMenu(
    BuildContext context,
    Character character,
    String guruName,
    String guruRole,
    VoidCallback onRefresh,
  ) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: 'Pilih Aksi Interaksi',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Apa yang ingin kamu lakukan dengan $guruName ($guruRole)?',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),

          // 1. Cari Muka
          ListTile(
            leading: const Text('🙇', style: TextStyle(fontSize: 24)),
            title: const Text('Cari Muka', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Membantu guru atau melakukan tugas khusus.'),
            onTap: () {
              Navigator.pop(context);
              int karmaGain = random.nextInt(4) + 2;
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Cari Muka',
                content: Text('Kamu membantu $guruName dengan tugas administrasi di ruangan. Guru terlihat senang. Karma +$karmaGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 2. Tanya Pertanyaan
          ListTile(
            leading: const Text('🙋', style: TextStyle(fontSize: 24)),
            title: const Text('Tanya Pertanyaan', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Bertanya tentang pelajaran atau kehidupan.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(3) + 2;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Tanya Pertanyaan',
                content: Text('Kamu bertanya kepada $guruName tentang pelajaran yang kurang dipahami. Guru dengan sabar menjelaskan. Kecerdasan +$intGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 3. Berbincang Santai
          ListTile(
            leading: const Text('💬', style: TextStyle(fontSize: 24)),
            title: const Text('Berbincang Santai', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mengobrol tentang hal-hal umum atau pengalaman pribadi.'),
            onTap: () {
              Navigator.pop(context);
              int happyGain = random.nextInt(4) + 2;
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Berbincang Santai',
                content: Text('Kamu berbincang santai dengan $guruName tentang pengalaman masa kecil beliau. Guru terlihat senang menceritakan kisahnya. Kebahagiaan +$happyGain%!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Mengerti'),
                  ),
                ],
              );
            },
          ),

          // 4. Minta Bimbingan
          ListTile(
            leading: const Text('📚', style: TextStyle(fontSize: 24)),
            title: const Text('Minta Bimbingan', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Meminta bimbingan khusus untuk meningkatkan prestasi.'),
            onTap: () {
              Navigator.pop(context);
              int intGain = random.nextInt(5) + 3;
              int karmaGain = random.nextInt(3) + 1;
              character.intelligence = (character.intelligence + intGain).clamp(0, 100);
              character.karma = (character.karma + karmaGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Minta Bimbingan',
                content: Text('$guruName memberikan bimbingan khusus untuk membantu kamu memahami materi yang sulit. Kecerdasan +$intGain%, Karma +$karmaGain%!'),
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
