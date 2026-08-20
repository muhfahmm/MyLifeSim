// lib/game/widgets/aktivitas_menu/school_logic/actions/interactions/teacher_interaction_page.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'dart:math';

class TeacherInteractionPage extends StatefulWidget {
  final Map<String, String> teacher;
  final String role;
  final Character character;
  final VoidCallback onRefresh;

  const TeacherInteractionPage({
    super.key,
    required this.teacher,
    required this.role,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<TeacherInteractionPage> createState() => _TeacherInteractionPageState();
}

class _TeacherInteractionPageState extends State<TeacherInteractionPage> {
  void _showOutcome(String title, String content) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(content),
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context); // Go back to teachers list
            },
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.teacher['name']!;
    final gender = widget.teacher['gender']!;
    final int rel = int.tryParse(widget.teacher['relationship'] ?? '50') ?? 50;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Profile Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        AvatarGenerator.getDeterministicAvatarUrl(name, gender, happiness: rel),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.role} • Hubungan: $rel%',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: rel / 100.0,
                        color: rel > 70 ? Colors.green : (rel > 40 ? Colors.orange : Colors.red),
                        backgroundColor: Colors.grey.shade200,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'PILIH AKSI INTERAKSI',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),

            // Aksi 1: Belajar Giat
            _buildActionTile(
              icon: Icons.menu_book,
              color: Colors.indigo,
              title: 'Belajar Giat',
              onTap: () {
                final change = 6 + Random().nextInt(10);
                widget.teacher['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.intelligence = (widget.character.intelligence + 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Belajar Giat', 'Kamu menunjukkan antusiasme yang tinggi di kelas. $name terkesan dengan ketekunanmu!');
              },
            ),

            // Aksi 2: Cari Muka (Puji)
            _buildActionTile(
              icon: Icons.thumb_up_alt_outlined,
              color: Colors.teal,
              title: 'Cari Muka (Puji)',
              onTap: () {
                final success = Random().nextBool();
                if (success) {
                  final change = 8 + Random().nextInt(11);
                  widget.teacher['relationship'] = (rel + change).clamp(0, 100).toString();
                  widget.onRefresh();
                  _showOutcome('Cari Muka', 'Kamu memuji gaya mengajar $name. Dia tersenyum bangga dan menyukaimu!');
                } else {
                  final change = 5 + Random().nextInt(11);
                  widget.teacher['relationship'] = (rel - change).clamp(0, 100).toString();
                  widget.onRefresh();
                  _showOutcome('Cari Muka Gagal', 'Kamu mencoba memuji $name, tapi dia tahu kamu hanya berpura-pura dan menegurmu!');
                }
              },
            ),

            // Aksi 3: Menghina
            _buildActionTile(
              icon: Icons.sentiment_very_dissatisfied,
              color: Colors.red,
              title: 'Menghina',
              onTap: () {
                final change = 15 + Random().nextInt(16);
                widget.teacher['relationship'] = (rel - change).clamp(0, 100).toString();
                widget.character.karma = (widget.character.karma - 5).clamp(0, 100);
                widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Menghina Guru', 'Kamu mengejek cara berpakaian $name. Dia sangat marah dan kamu dihukum berdiri di depan kelas!');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 26),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
