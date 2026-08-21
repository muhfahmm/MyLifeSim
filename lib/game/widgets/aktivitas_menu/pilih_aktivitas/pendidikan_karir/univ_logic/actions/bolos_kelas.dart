// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/actions/bolos_kelas.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'dart:math';

class BolosKelasActionPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const BolosKelasActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  void _bolos(BuildContext context) {
    final bool success = Random().nextBool();

    if (success) {
      character.happiness = (character.happiness + 15).clamp(0, 100);
      character.intelligence = (character.intelligence - 8).clamp(0, 100);
      character.karma = (character.karma - 4).clamp(0, 100);
      onRefresh();
      _showOutcome(context, 'Berhasil Membolos! 🎮☕', 'Kamu memutuskan bolos kuliah dan bersantai di kafe dekat kampus bersama mahasiswa lain. Rasanya sangat rileks! (Kebahagiaan +15, Kecerdasan -8)');
    } else {
      character.happiness = (character.happiness - 12).clamp(0, 100);
      character.karma = (character.karma - 3).clamp(0, 100);

      // Reduce relationship with university lecturers
      for (var doc in character.univLecturers) {
        final int r = int.tryParse(doc['relationship'] ?? '50') ?? 50;
        doc['relationship'] = (r - 10).clamp(0, 100).toString();
      }

      onRefresh();
      _showOutcome(context, 'Ketahuan Titip Absen! 🚨', 'Dosen melakukan presensi manual mendadak. Kamu ketahuan menitipkan absen (titip absen/TA). Dosen menandaimu dan reputasimu di kampus anjlok! (Kebahagiaan -12, Hubungan Dosen Berkurang)');
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
        title: const Text('Bolos Kelas Kuliah'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              color: Colors.redAccent,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.directions_run, size: 48, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Rencana Bolos Kuliah',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Menghindari jam kuliah hari ini untuk tidur, nongkrong di kantin, atau main game. Berisiko ketahuan dosen dan merusak absensi.',
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
                backgroundColor: Colors.red,
              ),
              onPressed: () => _bolos(context),
              child: const Text('Laksanakan Aksi Membolos! 🚶‍♂️☕', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batalkan Rencana'),
            ),
          ],
        ),
      ),
    );
  }
}
