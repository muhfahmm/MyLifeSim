// lib/game/widgets/aktivitas_menu/school_logic/actions/keluar_sekolah.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class KeluarSekolahActionPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const KeluarSekolahActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  void _keluarSekolah(BuildContext context) {
    character.classmates.clear();
    character.sdTeachers.clear();
    character.smpTeachers.clear();
    character.smaTeachers.clear();
    character.headmaster = null;
    character.bkTeacher = null;
    character.happiness = (character.happiness - 20).clamp(0, 100);
    
    // Custom log
    character.inbox.add('🎓 Keluar Sekolah: Kamu memutuskan untuk putus sekolah di usia ${character.age} tahun.');
    
    onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Putus Sekolah 🛑',
      content: const Text('Kamu resmi keluar dari sekolah. Sekarang kamu tidak memiliki kewajiban sekolah lagi, namun mencari pekerjaan tanpa ijazah akan menjadi lebih menantang!'),
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Pop the redirect page, and pop the activity menu bottom sheet as well if needed.
              // Just pop twice to return to the main screen.
              Navigator.of(context).pop(); 
            },
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keluar Sekolah'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.black87,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 48, color: Colors.amber),
                    SizedBox(height: 12),
                    Text(
                      'Peringatan Putus Sekolah',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Keluar dari sekolah secara sepihak akan menutup aksesmu ke pendidikan formal tingkat lanjut dan membatasi opsi karir berkualitas di masa depan.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.black,
              ),
              onPressed: () => _keluarSekolah(context),
              child: const Text('Keluar Sekolah Sekarang 🚪', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali Belajar'),
            ),
          ],
        ),
      ),
    );
  }
}
