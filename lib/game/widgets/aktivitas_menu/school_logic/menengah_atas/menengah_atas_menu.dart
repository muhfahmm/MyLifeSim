// lib/game/widgets/aktivitas_menu/school_logic/menengah_atas/menengah_atas_menu.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

// Import submenus from folders
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/kelas/kelas.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/belajar/belajar.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/ekstrakurikuler/ekstrakurikuler.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/pindah_sekolah/pindah_sekolah.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/keluar_sekolah/keluar_sekolah.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/guru/guru.dart';

class MenengahAtasMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
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
            subtitle: const Text('Mempersiapkan diri untuk ujian akhir nasional.'),
            onTap: () {
              Navigator.pop(context);
              BelajarMenu.showMenu(context, character, onRefresh);
            },
          ),

          // 3. Ikut Ekstrakurikuler
          ListTile(
            leading: const Text('🎯', style: TextStyle(fontSize: 24)),
            title: const Text('Ikut Ekstrakurikuler', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Bergabung dengan klub olahraga atau seni.'),
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