// lib/game/widgets/aktivitas_menu/school_logic/menengah_pertama/menengah_pertama_menu.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class MenengahPertamaMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: 'Menengah Pertama (SMP) 🏫',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Kamu adalah murid Sekolah Menengah Pertama. Pilih aktivitas sekolahmu:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('📚', style: TextStyle(fontSize: 24)),
            title: const Text('Belajar Lebih Giat', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mempersiapkan diri untuk ujian.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(6) + 6; // +6 to +11
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Belajar Giat',
                content: Text('Kamu meringkas materi pelajaran di perpustakaan. Kecerdasanmu meningkat +$gain%!'),
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
            leading: const Text('🏀', style: TextStyle(fontSize: 24)),
            title: const Text('Ikut Ekstrakurikuler', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Bergabung dengan klub olahraga atau seni.'),
            onTap: () {
              Navigator.pop(context);
              int healthGain = random.nextInt(6) + 5;
              int happyGain = random.nextInt(6) + 5;
              character.health = (character.health + healthGain).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Ekstrakurikuler',
                content: Text('Kamu aktif mengikuti latihan klub olahraga sekolah. Kesehatan +$healthGain%, Kebahagiaan +$happyGain%!'),
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
            leading: const Text('💬', style: TextStyle(fontSize: 24)),
            title: const Text('Nongkrong & Mengobrol', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Bercerita dengan teman-teman sekelas.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(6) + 8; // +8 to +13
              character.happiness = (character.happiness + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Nongkrong bersama Teman',
                content: Text('Kamu mengobrol santai dan tertawa bersama teman-teman di kantin. Kebahagiaanmu meningkat +$gain%!'),
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
