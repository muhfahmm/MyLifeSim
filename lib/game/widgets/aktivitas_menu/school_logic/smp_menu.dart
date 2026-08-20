// lib/game/widgets/aktivitas_menu/school_logic/smp_menu.dart

import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class SmpMenu {
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
                          'Sekolah Menengah Pertama (SMP) 🏫',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Masa-masa remaja awal telah dimulai. Apa yang ingin kamu lakukan hari ini?',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      
                      // Menu Belajar Lebih Giat
                      ListTile(
                        leading: const Icon(Icons.menu_book, color: Colors.blueAccent),
                        title: const Text('Belajar Lebih Giat', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Mempersiapkan diri menghadapi ujian'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.intelligence = (character.intelligence + 7).clamp(0, 100);
                          character.happiness = (character.happiness - 3).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Belajar Giat', 'Kamu membuat catatan belajar yang rapi dan rajin bertanya kepada guru. Kecerdasanmu meningkat!');
                        },
                      ),
                      const Divider(),

                      // Menu Ikut Ekstrakurikuler
                      ListTile(
                        leading: const Icon(Icons.sports_soccer, color: Colors.green),
                        title: const Text('Ikut Ekstrakurikuler', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Bergabung dengan klub sepak bola atau musik'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.happiness = (character.happiness + 7).clamp(0, 100);
                          character.health = (character.health + 5).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Ekstrakurikuler', 'Kamu bergabung ke klub olahraga sekolah dan berlatih dengan bersemangat. Tubuhmu terasa segar dan kamu sangat senang!');
                        },
                      ),
                      const Divider(),

                      // Menu Iseng / Jahili Teman
                      ListTile(
                        leading: const Icon(Icons.sentiment_very_satisfied, color: Colors.orange),
                        title: const Text('Jahili Teman', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Melakukan lelucon iseng kepada teman sekelas'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.happiness = (character.happiness + 5).clamp(0, 100);
                          character.karma = (character.karma - 3).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Menjahili Teman', 'Kamu menyembunyikan kotak pensil temanmu. Reaksinya yang panik membuatmu tertawa, tetapi karma mu sedikit berkurang!');
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
