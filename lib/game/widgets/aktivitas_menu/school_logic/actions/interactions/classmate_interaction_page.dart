// lib/game/widgets/aktivitas_menu/school_logic/actions/interactions/classmate_interaction_page.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/siswa_siswi/student_romance_logic.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/siswa_siswa/siswa_siswa_logic.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/siswi_siswi/siswi_siswi_logic.dart';
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
              setState(() {}); // Refresh current screen
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
                        'Teman Sekelas • Umur: $age tahun • Seksualitas: $sexuality • Hubungan: $rel%',
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

            if (StudentRomanceLogic.shouldShowRomanceButtons(
              userAge: widget.character.age,
              classmateAge: age,
            )) ...[
              // Aksi 1: Bercinta / Make Love
              _buildActionTile(
                icon: Icons.favorite,
                color: Colors.pink,
                title: 'Bercinta / Make Love',
                onTap: () {
                  final userGen = widget.character.gender;
                  final mateGen = gender;
                  if (userGen == 'Laki-laki' && mateGen == 'Laki-laki') {
                    SiswaSiswaLogic.bercinta(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  } else if (userGen == 'Perempuan' && mateGen == 'Perempuan') {
                    SiswiSiswiLogic.bercinta(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  } else {
                    StudentRomanceLogic.bercinta(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  }
                },
              ),
              // Aksi 2: Ajak Pacaran
              _buildActionTile(
                icon: Icons.favorite_border,
                color: Colors.redAccent,
                title: 'Ajak Pacaran',
                onTap: () {
                  final userGen = widget.character.gender;
                  final mateGen = gender;
                  if (userGen == 'Laki-laki' && mateGen == 'Laki-laki') {
                    SiswaSiswaLogic.ajakPacaran(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  } else if (userGen == 'Perempuan' && mateGen == 'Perempuan') {
                    SiswiSiswiLogic.ajakPacaran(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  } else {
                    StudentRomanceLogic.ajakPacaran(
                      context: context,
                      character: widget.character,
                      classmate: widget.classmate,
                      onRefresh: widget.onRefresh,
                      showOutcome: (title, desc) => _showOutcome(title, desc),
                    );
                  }
                },
              ),
            ],

            // Aksi 3: Berteman
            _buildActionTile(
              icon: Icons.group_add,
              color: Colors.teal,
              title: 'Berteman',
              onTap: () {
                final change = 5 + Random().nextInt(11);
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Berteman', 'Kamu mengajak $name untuk berteman dan dia merespon dengan hangat! Hubungan kalian meningkat!');
              },
            ),

            // Aksi 2: Berikan Pujian
            _buildActionTile(
              icon: Icons.thumb_up,
              color: Colors.blueAccent,
              title: 'Berikan Pujian',
              onTap: () {
                final change = 5 + Random().nextInt(6);
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Pujian', 'Kamu memuji penampilan $name. Dia tersenyum dan terlihat sangat senang!');
              },
            ),

            // Aksi 3: Percakapan (Mengobrol)
            _buildActionTile(
              icon: Icons.chat_bubble_outline,
              color: Colors.blue,
              title: 'Percakapan',
              onTap: () {
                final change = 5 + Random().nextInt(11);
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Percakapan', 'Kamu mengobrol seru dengan $name tentang game kesukaan kalian. Hubungan kalian meningkat!');
              },
            ),

            // Aksi 4: Menggoda
            _buildActionTile(
              icon: Icons.favorite_border,
              color: Colors.pink,
              title: 'Menggoda',
              onTap: () {
                final int chance = Random().nextInt(100);
                if (chance < 30) {
                  // Gagal menggoda
                  final change = 5 + Random().nextInt(11);
                  widget.classmate['relationship'] = (rel - change).clamp(0, 100).toString();
                  widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Gagal Menggoda', 'Kamu mencoba menggoda $name tetapi dia merasa tidak nyaman dan menjauh. Hubungan menurun!');
                } else {
                  final change = 5 + Random().nextInt(11);
                  widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                  widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Menggoda Berhasil', 'Kamu menggoda $name dengan cara yang lucu dan dia tersipu! Hubungan meningkat!');
                }
              },
            ),

            // Aksi 5: Berikan Hadiah
            _buildActionTile(
              icon: Icons.card_giftcard,
              color: Colors.purple,
              title: 'Berikan Hadiah',
              onTap: () {
                if (widget.character.money < 20) {
                  _showOutcome('Uang Tidak Cukup', 'Kamu tidak punya uang untuk membeli hadiah. Kumpulkan uang terlebih dahulu!');
                  return;
                }
                final change = 10 + Random().nextInt(16);
                widget.character.money -= 20;
                widget.classmate['relationship'] = (rel + change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Hadiah Diberikan', 'Kamu memberikan hadiah kecil kepada $name. Dia sangat terharu dan berterima kasih! Hubungan meningkat pesat!');
              },
            ),

            // Aksi 6: Hina
            _buildActionTile(
              icon: Icons.sentiment_very_dissatisfied,
              color: Colors.red,
              title: 'Hina',
              onTap: () {
                final change = 10 + Random().nextInt(16);
                widget.classmate['relationship'] = (rel - change).clamp(0, 100).toString();
                widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
                widget.character.karma = (widget.character.karma - 5).clamp(0, 100);
                widget.onRefresh();
                _showOutcome('Menghina', 'Kamu mengucapkan kata-kata kasar kepada $name. Dia terlihat sangat tersinggung dan hubungan memburuk!');
              },
            ),

            // Aksi 7: Buat Keributan (Ajak Berkelahi)
            _buildActionTile(
              icon: Icons.gavel,
              color: Colors.orange,
              title: 'Buat Keributan',
              onTap: () {
                final win = Random().nextBool();
                final relChange = 20 + Random().nextInt(21);
                if (win) {
                  widget.classmate['relationship'] = (rel - relChange).clamp(0, 100).toString();
                  widget.character.health = (widget.character.health - 5).clamp(0, 100);
                  widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Keributan', 'Kamu terlibat perkelahian dengan $name karena adu mulut dan kamu berhasil memenangkannya! Namun tubuhmu sedikit memar.');
                } else {
                  widget.classmate['relationship'] = (rel - relChange).clamp(0, 100).toString();
                  widget.character.health = (widget.character.health - 15).clamp(0, 100);
                  widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
                  widget.onRefresh();
                  _showOutcome('Kalah Keributan', 'Kamu berkelahi dengan $name dan kalah telak. Kamu menderita memar parah dan merasa sangat malu!');
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