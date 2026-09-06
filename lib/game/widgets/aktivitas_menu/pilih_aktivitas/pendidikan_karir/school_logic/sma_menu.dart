// lib/game/widgets/aktivitas_menu/school_logic/sma_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class SmaMenu {
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
                          'Sekolah Menengah Atas (SMA) 🏫✨',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Masa SMA adalah masa terindah sekaligus krusial untuk persiapan masa depanmu. Apa tindakanmu?',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      
                      // Menu Belajar Lebih Giat
                      ListTile(
                        leading: const Icon(Icons.menu_book, color: Colors.purple),
                        title: const Text('Belajar Lebih Giat', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Meningkatkan nilai rapor untuk seleksi kuliah'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.intelligence = (character.intelligence + 9).clamp(0, 100);
                          character.happiness = (character.happiness - 4).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Belajar Giat', 'Kamu menghabiskan malam untuk belajar persiapan ujian nasional. Nilaimu meningkat pesat!');
                        },
                      ),
                      const Divider(),

                      // Menu Bersosialisasi / Nongkrong
                      ListTile(
                        leading: const Icon(Icons.local_cafe, color: Colors.amber),
                        title: const Text('Nongkrong bersama Teman', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Pergi ke kafe atau kantin sepulang sekolah'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.happiness = (character.happiness + 8).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Nongkrong SMA', 'Kamu nongkrong sepulang sekolah, bercerita tentang masa depan bersama sahabat terdekat. Kebahagiaanmu meningkat!');
                        },
                      ),
                      const Divider(),

                      // Menu Cari Pacar
                      ListTile(
                        leading: const Icon(Icons.favorite, color: Colors.pink),
                        title: const Text('Cari Pacar', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Mencari pasangan cinta monyet di SMA'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          if (character.partner != null) {
                            _showResultDialog(parentContext, 'Hubungan', 'Kamu sudah memiliki pasangan (${character.partner!['name']})!');
                          } else {
                            character.happiness = (character.happiness + 10).clamp(0, 100);
                            character.partner = {
                              'name': 'Teman SMA',
                              'relationship': '70',
                              'gender': character.gender == 'Laki-laki' ? 'Perempuan' : 'Laki-laki',
                              'age': character.age.toString(),
                              'relation': 'Pacar',
                              'isDeceased': 'false'
                            };
                            onRefresh();
                            _showResultDialog(parentContext, 'Cinta Monyet', 'Kamu memberanikan diri menyatakan cinta pada teman sekelasmu dan dia menerimanya! Kamu sekarang resmi berpacaran.');
                          }
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
