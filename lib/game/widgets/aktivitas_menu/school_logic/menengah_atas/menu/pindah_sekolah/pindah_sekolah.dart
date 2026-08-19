// lib/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/pindah_sekolah/pindah_sekolah.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class PindahSekolahMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    final Random random = Random();

    DialogHelper.show(
      context: context,
      title: '🚌 Pindah Sekolah (SMA)',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ajukan permohonan pindah sekolah menengah atas:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Text('👨‍👩‍👦', style: TextStyle(fontSize: 24)),
            title: const Text('Kirim Pengajuan Pindah', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Pindah ke SMA lain demi kenyamanan belajar.'),
            onTap: () {
              Navigator.pop(context);
              bool disetujui = random.nextBool();
              if (disetujui) {
                character.happiness = (character.happiness + 5).clamp(0, 100);
                onRefresh();
                DialogHelper.show(
                  context: context,
                  title: 'Pindah Sekolah Berhasil',
                  content: const Text('Pengajuan disetujui! Kamu resmi pindah ke SMA favorit baru di kota. (+5% Kebahagiaan)'),
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
                  content: const Text('Orang tuamu menyuruhmu fokus belajar di SMA sekarang dan tidak merepotkan. (-5% Kebahagiaan)'),
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
