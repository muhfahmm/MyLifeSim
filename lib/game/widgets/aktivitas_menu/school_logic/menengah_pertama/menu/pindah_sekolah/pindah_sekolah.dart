// lib/game/widgets/aktivitas_menu/school_logic/menengah_pertama/menu/pindah_sekolah/pindah_sekolah.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class PindahSekolahMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '🚌 Pindah Sekolah (SMP)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ajukan permohonan pindah sekolah ke orang tuamu:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('👨‍👩‍👦', style: TextStyle(fontSize: 24)),
            title: const Text('Kirim Pengajuan Pindah', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Minta dipindahkan karena bosan atau ingin suasana baru.'),
            onTap: () {
              Navigator.pop(context);
              bool disetujui = random.nextBool();
              if (disetujui) {
                character.happiness = (character.happiness + 5).clamp(0, 100);
                onRefresh();
                DialogHelper.show(
                  context: context,
                  title: 'Pindah Sekolah Berhasil',
                  content: const Text('Orang tuamu menyetujuinya. Kamu sekarang bersekolah di SMP favorit baru! (+5% Kebahagiaan)'),
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
                  title: 'Ditolak Orang Tua',
                  content: const Text('Orang tuamu menyuruhmu bertahan sampai lulus. (-5% Kebahagiaan)'),
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
