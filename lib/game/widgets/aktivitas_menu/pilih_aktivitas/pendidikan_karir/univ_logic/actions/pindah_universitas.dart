// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/actions/pindah_universitas.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'dart:math';

class PindahUnivActionPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PindahUnivActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  void _pindahUniv(BuildContext context, String type) {
    if (type == 'Swasta') {
      final parentRel = ((character.fatherRelationship ?? 50) + (character.motherRelationship ?? 50)) ~/ 2;
      final bool success = Random().nextInt(100) < parentRel;

      if (success) {
        character.happiness = (character.happiness + 15).clamp(0, 100);
        character.intelligence = (character.intelligence + 10).clamp(0, 100);
        character.univClassmates.clear(); // Clear to regenerate new classmates
        character.univLecturers.clear();
        onRefresh();
        _showOutcome(context, 'Mutasi Universitas Swasta Disetujui!', 'Orang tuamu menyetujui biaya mutasi ke Universitas Swasta Kelas Dunia! Kebahagiaan dan Kecerdasanmu meningkat.');
      } else {
        character.happiness = (character.happiness - 10).clamp(0, 100);
        onRefresh();
        _showOutcome(context, 'Mutasi Ditolak', 'Orang tuamu menolak memindahkanmu ke Universitas Swasta karena biayanya yang sangat tinggi. Kebahagiaanmu berkurang.');
      }
    } else {
      if (character.intelligence >= 60) {
        character.univClassmates.clear();
        character.univLecturers.clear();
        character.happiness = (character.happiness + 5).clamp(0, 100);
        onRefresh();
        _showOutcome(context, 'Mutasi Universitas Negeri Sukses', 'Berkat kecerdasanmu yang mumpuni, kamu berhasil mutasi ke Universitas Negeri baru pilihanmu.');
      } else {
        character.happiness = (character.happiness - 8).clamp(0, 100);
        onRefresh();
        _showOutcome(context, 'Mutasi Ditolak 🚫', 'Lamaran mutasi kamu ke Universitas Negeri ditolak karena IPK dan kecerdasanmu tidak memenuhi kriteria minimal.');
      }
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
              Navigator.pop(context); // Go back to university menu
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
        title: const Text('Pindah Universitas'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.indigo,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.swap_horiz, size: 48, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Pindah ke Universitas Lain',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Mengajukan transfer mahasiswa/mutasi jika kamu merasa lingkungan akademik di kampus saat ini kurang mendukung.',
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
                backgroundColor: Colors.blue.shade700,
              ),
              icon: const Icon(Icons.school, color: Colors.white),
              label: const Text('Pindah ke Universitas Negeri (Butuh Kecerdasan 60%+)', style: TextStyle(color: Colors.white, fontSize: 15)),
              onPressed: () => _pindahUniv(context, 'Negeri'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.purple.shade700,
              ),
              icon: const Icon(Icons.star, color: Colors.white),
              label: const Text('Pindah ke Universitas Swasta (Minta Dukungan Ortu)', style: TextStyle(color: Colors.white, fontSize: 15)),
              onPressed: () => _pindahUniv(context, 'Swasta'),
            ),
          ],
        ),
      ),
    );
  }
}
