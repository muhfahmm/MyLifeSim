// lib/game/widgets/aktivitas_menu/school_logic/sd_menu.dart

import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class SdMenu {
  static void showMenu(BuildContext parentContext, Character character, VoidCallback onRefresh) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          'Sekolah Dasar (SD) 🎒',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Pendidikan adalah pondasi masa depanmu. Apa yang ingin kamu lakukan di Sekolah Dasar hari ini?',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      
                      // Menu Belajar Lebih Giat
                      ListTile(
                        leading: const Icon(Icons.menu_book, color: Colors.blue),
                        title: const Text('Belajar Lebih Giat', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Meningkatkan fokus belajar di kelas'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.intelligence = (character.intelligence + 8).clamp(0, 100);
                          character.happiness = (character.happiness - 2).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Belajar Giat', 'Kamu mendengarkan penjelasan guru dengan seksama. Kecerdasanmu meningkat!');
                        },
                      ),
                      const Divider(),

                      // Menu Cari Teman Baru
                      ListTile(
                        leading: const Icon(Icons.group_add, color: Colors.orange),
                        title: const Text('Cari Teman Baru', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Berinteraksi dan mencari teman bermain'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.happiness = (character.happiness + 5).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Mencari Teman', 'Kamu bermain petak umpet saat istirahat dan mendapatkan teman baru! Kebahagiaanmu meningkat.');
                        },
                      ),
                      const Divider(),

                      // Menu Bolos Kelas
                      ListTile(
                        leading: const Icon(Icons.directions_run, color: Colors.red),
                        title: const Text('Bolos Kelas', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Pergi ke kantin atau bermain di luar jam pelajaran'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.happiness = (character.happiness + 10).clamp(0, 100);
                          character.intelligence = (character.intelligence - 5).clamp(0, 100);
                          character.karma = (character.karma - 5).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Bolos Sekolah', 'Kamu membolos kelas dan asyik jajan di kantin belakang sekolah. Rasanya seru tapi gurumu mungkin akan curiga!');
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void _showResultDialog(BuildContext context, String title, String message) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(message),
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        )
      ],
    );
  }
}
