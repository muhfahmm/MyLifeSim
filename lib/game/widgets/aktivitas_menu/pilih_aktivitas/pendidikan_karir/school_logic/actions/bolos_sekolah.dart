// lib/game/widgets/aktivitas_menu/school_logic/actions/bolos_sekolah.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'dart:math';

class BolosSekolahActionPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const BolosSekolahActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  void _bolos(BuildContext context) {
    final success = Random().nextBool();

    if (success) {
      character.happiness = (character.happiness + 15).clamp(0, 100);
      character.intelligence = (character.intelligence - 8).clamp(0, 100);
      character.karma = (character.karma - 5).clamp(0, 100);
      onRefresh();
      _showOutcome(context, 'Berhasil Membolos! 🎉', 'Kamu membolos sekolah seharian dan bermain game di rental internet. Rasanya sangat bebas dan menyenangkan! (Kebahagiaan +15, Kecerdasan -8)');
    } else {
      character.happiness = (character.happiness - 15).clamp(0, 100);
      character.karma = (character.karma - 5).clamp(0, 100);
      
      // Reduce relationship with parents
      if (character.fatherRelationship != null) {
        character.fatherRelationship = (character.fatherRelationship! - 10).clamp(0, 100);
      }
      if (character.motherRelationship != null) {
        character.motherRelationship = (character.motherRelationship! - 10).clamp(0, 100);
      }

      onRefresh();
      _showOutcome(context, 'Ketahuan Membolos! 🚨', 'Kamu tertangkap basah oleh gurumu saat hendak melompati pagar sekolah. Sekolah melaporkannya ke orang tuamu, dan kamu dihukum berat di rumah! (Kebahagiaan -15, Hubungan Orang Tua Berkurang)');
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
        title: const Text('Bolos Sekolah'),
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
                      'Rencana Membolos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Menghindari jam pelajaran hari ini untuk bersenang-senang. Tindakan ini berisiko ketahuan oleh pihak sekolah atau orang tua.',
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
              child: const Text('Laksanakan Aksi Membolos! 🏃‍♂️💨', style: TextStyle(color: Colors.white, fontSize: 16)),
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
