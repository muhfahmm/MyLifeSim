// lib/game/widgets/aktivitas_menu/school_logic/actions/interactions/teacher_interaction_page.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
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
    final int age = int.tryParse(widget.teacher['age'] ?? '40') ?? 40;
    final int rel = int.tryParse(widget.teacher['relationship'] ?? '50') ?? 50;
    final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: gender,
      age: age,
      happiness: rel,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Profile Card
            Card(
              elevation: 0,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    () {
                      final String sexuality = widget.teacher['sexuality'] ?? 'Heteroseksual';
                      return Text(
                        '${widget.role} • Seksualitas: $sexuality • Hubungan: $rel%',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      );
                    }(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Tingkat Kepuasan: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: rel / 100.0,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                rel > 70 ? Colors.green : (rel > 40 ? Colors.amber : Colors.red),
                              ),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$rel%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: rel > 70 ? Colors.green : (rel > 40 ? Colors.amber : Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'PILIH AKSI INTERAKSI',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0),
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
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
