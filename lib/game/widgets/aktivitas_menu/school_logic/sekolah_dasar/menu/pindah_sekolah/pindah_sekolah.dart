// lib/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/pindah_sekolah/pindah_sekolah.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class PindahSekolahMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '🚌 Pindah Sekolah (SD)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Apakah kamu yakin ingin mengajukan pindah sekolah kepada orang tuamu?',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('👨‍👩‍👦', style: TextStyle(fontSize: 24)),
            title: const Text('Minta Izin Orang Tua', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Memohon dipindahkan ke SD lain.'),
            onTap: () {
              Navigator.pop(context);
              
              bool disetujui = random.nextBool();
              if (disetujui) {
                character.happiness = (character.happiness + 8).clamp(0, 100);
                onRefresh();
                DialogHelper.show(
                  context: context,
                  title: 'Permohonan Disetujui',
                  content: const Text('Orang tuamu menyetujuinya dan mengurus pendaftaran di SD baru yang lebih menyenangkan! (+8% Kebahagiaan)'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Mengerti'),
                    ),
                  ],
                );
              } else {
                character.happiness = (character.happiness - 5).clamp(0, 100);
                onRefresh();
                DialogHelper.show(
                  context: context,
                  title: 'Permohonan Ditolak',
                  content: const Text('Orang tuamu menolak dan memintamu tetap belajar di sekolah yang sekarang. (-5% Kebahagiaan)'),
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
