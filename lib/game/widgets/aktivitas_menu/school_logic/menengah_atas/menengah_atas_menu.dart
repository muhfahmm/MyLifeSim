// lib/game/widgets/aktivitas_menu/school_logic/menengah_atas/menengah_atas_menu.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class MenengahAtasMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: 'Menengah Atas (SMA) 🏫',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Kamu adalah murid Sekolah Menengah Atas. Pilih aktivitas sekolahmu:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('📚', style: TextStyle(fontSize: 24)),
            title: const Text('Belajar Lebih Keras', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mempersiapkan diri untuk ujian akhir nasional.'),
            onTap: () {
              Navigator.pop(context);
              int gain = random.nextInt(6) + 8; // +8 to +13
              character.intelligence = (character.intelligence + gain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Belajar Keras',
                content: Text('Kamu mengikuti bimbel tambahan dan belajar hingga malam. Kecerdasanmu meningkat +$gain%!'),
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
            leading: const Text('💖', style: TextStyle(fontSize: 24)),
            title: const Text('Dekati Teman Sekolah', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mencari hubungan asmara di sekolah.'),
            onTap: () {
              Navigator.pop(context);
              int relationshipGain = random.nextInt(6) + 5;
              character.happiness = (character.happiness + relationshipGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Dekati Teman',
                content: Text('Kamu mengobrol dekat dengan seseorang yang kamu sukai di kelas. Kebahagiaanmu meningkat +$relationshipGain%!'),
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
            leading: const Text('🚗', style: TextStyle(fontSize: 24)),
            title: const Text('Bolos Sekolah', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Keluar dari sekolah saat jam pelajaran.'),
            onTap: () {
              Navigator.pop(context);
              int smartLoss = random.nextInt(5) + 3;
              int karmaLoss = random.nextInt(5) + 3;
              int happyGain = random.nextInt(6) + 5;
              character.intelligence = (character.intelligence - smartLoss).clamp(0, 100);
              character.karma = (character.karma - karmaLoss).clamp(0, 100);
              character.happiness = (character.happiness + happyGain).clamp(0, 100);
              onRefresh();

              DialogHelper.show(
                context: context,
                title: 'Bolos Sekolah',
                content: Text('Kamu memanjat pagar belakang sekolah dan nongkrong di warnet. Kebahagiaan +$happyGain%, namun Kecerdasan -$smartLoss%, Karma -$karmaLoss%!'),
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
