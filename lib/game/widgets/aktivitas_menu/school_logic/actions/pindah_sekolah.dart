// lib/game/widgets/aktivitas_menu/school_logic/actions/pindah_sekolah.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'dart:math';

class PindahSekolahActionPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PindahSekolahActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  void _pindahSekolah(BuildContext context, String type) {
    if (type == 'Swasta') {
      // Ask parents
      final parentRel = ((character.fatherRelationship ?? 50) + (character.motherRelationship ?? 50)) ~/ 2;
      final success = Random().nextInt(100) < parentRel;

      if (success) {
        character.happiness = (character.happiness + 15).clamp(0, 100);
        character.intelligence = (character.intelligence + 10).clamp(0, 100);
        character.classmates.clear(); // Generate new classmates
        onRefresh();
        _showOutcome(context, 'Permintaan Disetujui!', 'Orang tuamu menyetujui permintaanmu untuk pindah ke Sekolah Swasta Unggulan! Kebahagiaan dan Kecerdasanmu meningkat.');
      } else {
        character.happiness = (character.happiness - 10).clamp(0, 100);
        onRefresh();
        _showOutcome(context, 'Permintaan Ditolak', 'Orang tuamu menolak memindahkanmu ke Sekolah Swasta karena biayanya yang mahal. Kebahagiaanmu berkurang.');
      }
    } else {
      // Public school
      character.classmates.clear(); // Generate new classmates
      character.happiness = (character.happiness + 5).clamp(0, 100);
      onRefresh();
      _showOutcome(context, 'Pindah Sekolah Negeri', 'Kamu berhasil pindah ke Sekolah Negeri baru. Kamu bersiap-siap bertemu dengan teman sekelas baru.');
    }
  }

  void _showOutcome(BuildContext context, String title, String content) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(content),
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context); // Go back to school menu
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
        title: const Text('Pindah Sekolah'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.blueGrey,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.swap_horiz, size: 48, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Pindah ke Sekolah Lain',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Apakah kamu merasa tidak cocok dengan sekolah saat ini? Pilih tipe sekolah baru yang ingin kamu masuki.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
              icon: const Icon(Icons.school, color: Colors.white),
              label: const Text('Pindah ke Sekolah Negeri (Gratis)', style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () => _pindahSekolah(context, 'Negeri'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.purple,
              ),
              icon: const Icon(Icons.star, color: Colors.white),
              label: const Text('Pindah ke Sekolah Swasta (Minta Orang Tua)', style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () => _pindahSekolah(context, 'Swasta'),
            ),
          ],
        ),
      ),
    );
  }
}
