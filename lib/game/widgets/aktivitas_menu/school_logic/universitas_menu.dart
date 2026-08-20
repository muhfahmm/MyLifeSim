// lib/game/widgets/aktivitas_menu/school_logic/universitas_menu.dart

import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class UniversitasMenu {
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
                          'Universitas (Kuliah) 🎓🏛️',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Menempuh pendidikan tinggi untuk mempersiapkan karir profesional. Apa yang ingin kamu lakukan di kampus hari ini?',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      
                      // Menu Belajar Lebih Giat
                      ListTile(
                        leading: const Icon(Icons.menu_book, color: Colors.indigo),
                        title: const Text('Belajar Lebih Giat', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Meningkatkan IPK dan pemahaman materi kuliah'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.intelligence = (character.intelligence + 10).clamp(0, 100);
                          character.happiness = (character.happiness - 5).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Belajar Giat', 'Kamu rajin membaca jurnal ilmiah dan mengerjakan tugas kuliah tepat waktu. IPK-mu diproyeksikan sangat baik!');
                        },
                      ),
                      const Divider(),

                      // Menu Ikut Organisasi Kampus (BEM / Hima)
                      ListTile(
                        leading: const Icon(Icons.group, color: Colors.teal),
                        title: const Text('Ikut Organisasi Kampus', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Menjadi pengurus BEM atau Himpunan Mahasiswa'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.happiness = (character.happiness + 7).clamp(0, 100);
                          character.karma = (character.karma + 4).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Organisasi Kampus', 'Kamu bergabung ke BEM dan aktif berkontribusi dalam kepanitiaan acara sosial. Kamu mendapatkan banyak relasi dan pengalaman kepemimpinan!');
                        },
                      ),
                      const Divider(),

                      // Drop Out
                      ListTile(
                        leading: const Icon(Icons.exit_to_app, color: Colors.red),
                        title: const Text('Keluar dari Universitas (Drop Out)', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Berhenti kuliah untuk langsung bekerja atau bersantai'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                        onTap: () {
                          Navigator.pop(context);
                          character.happiness = (character.happiness - 10).clamp(0, 100);
                          onRefresh();
                          _showResultDialog(parentContext, 'Drop Out', 'Kamu memutuskan untuk drop out dari universitas. Sekarang kamu siap untuk mencari pekerjaan penuh waktu.');
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
