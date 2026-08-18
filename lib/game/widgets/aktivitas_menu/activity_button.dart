// lib/game/widgets/activity_button.dart
import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/masturbate.dart';

class ActivityButton extends StatelessWidget {
  final Character character;
  final bool isAlive;
  final VoidCallback onWork;
  final VoidCallback onStudy;
  final VoidCallback onExercise;
  final VoidCallback onRefresh;

  const ActivityButton({
    super.key,
    required this.character,
    required this.isAlive,
    required this.onWork,
    required this.onStudy,
    required this.onExercise,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (!isAlive) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Karakter sudah meninggal!')),
          );
          return;
        }
        DialogHelper.show(
          context: context,
          title: 'Pilih Aktivitas',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Bekerja'),
                onTap: () {
                  Navigator.pop(context);
                  onWork(); // Panggil callback ke index.dart
                },
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Belajar'),
                onTap: () {
                  Navigator.pop(context);
                  onStudy();
                },
              ),
              ListTile(
                leading: const Icon(Icons.fitness_center),
                title: const Text('Olahraga'),
                onTap: () {
                  Navigator.pop(context);
                  onExercise();
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
                title: const Text('Masturbasi (Fantasi)'),
                onTap: () {
                  Navigator.pop(context);
                  MasturbasiHelper.showMasturbationMenu(context, character, onRefresh);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.withOpacity(0.2),
        foregroundColor: Colors.purple,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.purple, width: 1.5),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_run, size: 28),
          SizedBox(height: 4),
          Text(
            'Aktivitas',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.purple),
          ),
        ],
      ),
    );
  }
}