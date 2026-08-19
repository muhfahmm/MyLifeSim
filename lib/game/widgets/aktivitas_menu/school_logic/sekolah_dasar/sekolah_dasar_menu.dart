// lib/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/sekolah_dasar_menu.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

// Import submenus from folders
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/kelas/kelas.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/belajar/belajar.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/ekstrakurikuler/ekstrakurikuler.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/pindah_sekolah/pindah_sekolah.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/keluar_sekolah/keluar_sekolah.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/sekolah_dasar/menu/guru/guru.dart';

class SekolahDasarMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
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

          // 1. Kelas
          ListTile(
            leading: const Text('📖', style: TextStyle(fontSize: 24)),
            title: const Text('Kelas', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mengikuti pelajaran di dalam kelas.'),
            onTap: () {
              Navigator.pop(context);
              KelasMenu.showMenu(context, character, onRefresh);
            },
          ),

          // 2. Belajar Lebih Giat
          ListTile(
            leading: const Text('📚', style: TextStyle(fontSize: 24)),
            title: const Text('Belajar Lebih Giat', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Meningkatkan kecerdasan otakmu.'),
            onTap: () {
              Navigator.pop(context);
              BelajarMenu.showMenu(context, character, onRefresh);
            },
          ),

          // 3. Ikut Ekstrakurikuler
          ListTile(
            leading: const Text('🎨', style: TextStyle(fontSize: 24)),
            title: const Text('Ikut Ekstrakurikuler', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Bergabung dengan klub seni atau olahraga.'),
            onTap: () {
              Navigator.pop(context);
              EkstrakurikulerMenu.showMenu(context, character, onRefresh);
            },
          ),

          // 4. Guru
          ListTile(
            leading: const Text('🧑‍🏫', style: TextStyle(fontSize: 24)),
            title: const Text('Guru', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Berinteraksi dengan para guru sekolah.'),
            onTap: () {
              Navigator.pop(context);
              GuruMenu.showMenu(context, character, onRefresh);
            },
          ),

          // 5. Pindah Sekolah
          ListTile(
            leading: const Text('🚌', style: TextStyle(fontSize: 24)),
            title: const Text('Pindah Sekolah', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Mencari suasana belajar yang baru.'),
            onTap: () {
              Navigator.pop(context);
              PindahSekolahMenu.showMenu(context, character, onRefresh);
            },
          ),

          // 6. Keluar Sekolah
          ListTile(
            leading: const Text('🚪', style: TextStyle(fontSize: 24)),
            title: const Text('Keluar Sekolah', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Berhenti dari sekolah.'),
            onTap: () {
              Navigator.pop(context);
              KeluarSekolahMenu.showMenu(context, character, onRefresh);
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