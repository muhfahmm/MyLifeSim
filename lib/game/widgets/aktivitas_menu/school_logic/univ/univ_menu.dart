// lib/game/widgets/aktivitas_menu/school_logic/univ/univ_menu.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class UniversitasMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: 'Universitas 🎓',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Kamu adalah seorang mahasiswa di Universitas. Pilih aktivitas kampusmu:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('📚', style: TextStyle(fontSize: 24)),
            title: const Text('Belajar Giat & Hadiri Kuliah', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Meningkatkan pemahaman akademismu.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(6) + 10; // +10 to +15
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Hadiri Kuliah',
                content: Text('Kamu mengikuti semua kelas dan membuat catatan lengkap. Kecerdasanmu meningkat +$gain%!'),
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
            leading: const Text('🎓', style: TextStyle(fontSize: 24)),
            title: const Text('Kerjakan Tugas Akhir / Skripsi', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mempersiapkan kelulusanmu.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(6) + 8;
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Mengerjakan Skripsi',
                content: Text('Kamu meneliti data di laboratorium dan menulis skripsi. Kecerdasan +$gain%!'),
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
            leading: const Text('🥳', style: TextStyle(fontSize: 24)),
            title: const Text('Pesta Mahasiswa', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Bersenang-senang bersama anak kuliah lainnya.'),
            onTap: () {
              Navigator.pop(context);
              int happyGain = random.nextInt(11) + 10;
              int moneyLoss = 20;
              
              if (character.money < moneyLoss) {
                DialogHelper.show(
                  context: context,
                  title: 'Uang Tidak Cukup',
                  content: const Text('Kamu tidak memiliki cukup uang (\$20) untuk bergabung ke pesta.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Kembali'),
                    ),
                  ],
                );
              } else {
                character.money -= moneyLoss;
                character.happiness = (character.happiness + happyGain).clamp(0, 100);
                onRefresh();

                DialogHelper.show(
                  context: context,
                  title: 'Bergabung di Pesta',
                  content: Text('Kamu menari dan minum bersama teman-teman semalaman. Kebahagiaan +$happyGain%, Uang -\$$moneyLoss!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Mengerti'),
                    ),
                  ],
                );
              }
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
