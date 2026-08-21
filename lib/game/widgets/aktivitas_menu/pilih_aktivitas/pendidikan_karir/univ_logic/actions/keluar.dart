// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/actions/keluar.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class KeluarActionPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const KeluarActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  void _keluarUniv(BuildContext context) {
    character.univClassmates.clear();
    character.univLecturers.clear();
    character.univMajor = null;
    character.happiness = (character.happiness - 20).clamp(0, 100);

    // Custom log
    character.inbox.add('🎓 Drop Out: Kamu memutuskan untuk drop out dari universitas pada usia ${character.age} tahun.');

    onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Drop Out Universitas 🛑',
      content: const Text('Kamu resmi keluar dari universitas. Sekarang kamu bukan lagi seorang mahasiswa. Kamu bisa melamar pekerjaan atau menikmati kebebasan tanpa kuliah!'),
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Pop the action page and the univ menu page to return to dashboard.
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
        title: const Text('Drop Out Universitas'),
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
                      'Peringatan Drop Out',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Meninggalkan perkuliahan secara sepihak berarti merelakan gelar akademikmu dan menutup peluang kerja profesional berstandar ijazah sarjana.',
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
              onPressed: () => _keluarUniv(context),
              child: const Text('Drop Out Sekarang 🚪', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali Kuliah'),
            ),
          ],
        ),
      ),
    );
  }
}
