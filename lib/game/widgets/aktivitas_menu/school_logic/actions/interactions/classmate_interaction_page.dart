// lib/game/widgets/aktivitas_menu/school_logic/actions/interactions/classmate_interaction_page.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'dart:math';

class ClassmateInteractionPage extends StatefulWidget {
  final Map<String, String> classmate;
  final Character character;
  final VoidCallback onRefresh;

  const ClassmateInteractionPage({
    super.key,
    required this.classmate,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<ClassmateInteractionPage> createState() => _ClassmateInteractionPageState();
}

class _ClassmateInteractionPageState extends State<ClassmateInteractionPage> {
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
              Navigator.pop(context); // Go back to classmates list
            },
            child: const Text('OK'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.classmate['name']!;
    final gender = widget.classmate['gender']!;
    final int age = int.tryParse(widget.classmate['age'] ?? '0') ?? widget.character.age;
    final int rel = int.tryParse(widget.classmate['relationship'] ?? '50') ?? 50;
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
                      final String sexuality = widget.classmate['sexuality'] ?? 'Heteroseksual';
                      return Text(
                        'Teman Sekelas • Seksualitas: $sexuality • Hubungan: $rel%',
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

            // Aksi 1: Mengobrol
            _buildActionTile(
              icon: Icons.chat_bubble_outline,
              color: Colors.blue,
              title: 'Mengobrol',
              onTap: () {
                final change = 5 + Random().nextInt(11);
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Mengobrol', 'Kamu mengobrol seru dengan $name tentang game kesukaan kalian. Hubungan kalian meningkat!');
              },
            ),

            // Aksi 2: Bermain Bersama
            _buildActionTile(
              icon: Icons.sports_esports_outlined,
              color: Colors.green,
              title: 'Bermain Bersama',
              onTap: () {
                final change = 8 + Random().nextInt(11);
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness + 8).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Bermain Bersama', 'Kamu bermain game online bersama $name selama istirahat. Menyenangkan sekali!');
              },
            ),

            // Aksi 3: Jahili
            _buildActionTile(
              icon: Icons.sentiment_very_satisfied,
              color: Colors.orange,
              title: 'Jahili',
              onTap: () {
                final success = Random().nextBool();
                if (success) {
                  widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
                  widget.character.karma = (widget.character.karma - 3).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Menjahili', 'Kamu menaruh lem mainan di kursi $name. Dia kaget saat duduk dan semua orang tertawa!');
                } else {
                  final change = 10 + Random().nextInt(11);
                  widget.classmate['relationship'] = (rel - change).clamp(0, 100).toString();
                  widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Gagal Menjahili', 'Kamu mencoba menjahili $name, tapi kamu malah ketahuan dan dimarahi olehnya!');
                }
              },
            ),

            // Aksi 4: Ajak Berkelahi
            _buildActionTile(
              icon: Icons.gavel,
              color: Colors.red,
              title: 'Ajak Berkelahi',
              onTap: () {
                final win = Random().nextBool();
                final relChange = 20 + Random().nextInt(21);
                if (win) {
                  widget.classmate['relationship'] = (rel - relChange).clamp(0, 100).toString();
                  widget.character.health = (widget.character.health - 5).clamp(0, 100);
                  widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Berkelahi', 'Kamu berkelahi dengan $name karena adu mulut dan kamu memenangkan perkelahian tersebut! Namun tubuhmu sedikit memar.');
                } else {
                  widget.classmate['relationship'] = (rel - relChange).clamp(0, 100).toString();
                  widget.character.health = (widget.character.health - 15).clamp(0, 100);
                  widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Kalah Berkelahi', 'Kamu berkelahi dengan $name and kalah telak. Kamu menderita memar parah dan merasa sangat malu!');
                }
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
