// lib/game/widgets/aktivitas_menu/school_logic/aksi/aksi_ke_guru/guru_profile_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';

class GuruProfileScreen extends StatefulWidget {
  final Character character;
  final String guruName;
  final String guruGender;
  final int guruAge;
  final String guruRole;
  final VoidCallback onRefresh;

  const GuruProfileScreen({
    super.key,
    required this.character,
    required this.guruName,
    required this.guruGender,
    required this.guruAge,
    required this.guruRole,
    required this.onRefresh,
  });

  @override
  State<GuruProfileScreen> createState() => _GuruProfileScreenState();
}

class _GuruProfileScreenState extends State<GuruProfileScreen> {
  final Random random = Random();

  void _executeAction(String actionType) {
    int change = 0;
    String resultMsg = '';

    switch (actionType) {
      case 'cari_muka':
        change = random.nextInt(4) + 2;
        widget.character.karma = (widget.character.karma + change).clamp(0, 100);
        resultMsg = 'Kamu membantu ${widget.guruName} dengan tugas administrasi di ruangan. Guru terlihat senang. Karma +$change%!';
        break;
      case 'tanya':
        change = random.nextInt(3) + 2;
        widget.character.intelligence = (widget.character.intelligence + change).clamp(0, 100);
        resultMsg = 'Kamu bertanya kepada ${widget.guruName} tentang pelajaran yang kurang dipahami. Guru dengan sabar menjelaskan. Kecerdasan +$change%!';
        break;
      case 'berbincang':
        change = random.nextInt(4) + 2;
        widget.character.happiness = (widget.character.happiness + change).clamp(0, 100);
        resultMsg = 'Kamu berbincang santai dengan ${widget.guruName} tentang pengalaman masa kecil beliau. Guru terlihat senang menceritakan kisahnya. Kebahagiaan +$change%!';
        break;
      case 'bimbingan':
        int intGain = random.nextInt(5) + 3;
        int karmaGain = random.nextInt(3) + 1;
        widget.character.intelligence = (widget.character.intelligence + intGain).clamp(0, 100);
        widget.character.karma = (widget.character.karma + karmaGain).clamp(0, 100);
        resultMsg = '${widget.guruName} memberikan bimbingan khusus untuk membantu kamu memahami materi yang sulit. Kecerdasan +$intGain%, Karma +$karmaGain%!';
        break;
    }

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Aksi Selesai',
      content: Text(resultMsg),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Mengerti'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: widget.guruName,
      gender: widget.guruGender,
      age: widget.guruAge,
      happiness: 70,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.guruName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan Avatar dan Info
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.purple.shade100,
                    child: Image.network(
                      avatarUrl,
                      width: 96,
                      height: 96,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(widget.guruGender == 'Laki-laki' ? Icons.male : Icons.female,
                              size: 48, color: Colors.purple),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.guruName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.guruRole} | Umur: ${widget.guruAge} tahun',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Pilih Aksi Interaksi
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PILIH AKSI INTERAKSI',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  _buildActionCard(
                    icon: '🙇',
                    title: 'Cari Muka',
                    onTap: () => _executeAction('cari_muka'),
                  ),
                  _buildActionCard(
                    icon: '🙋',
                    title: 'Tanya Pertanyaan',
                    onTap: () => _executeAction('tanya'),
                  ),
                  _buildActionCard(
                    icon: '💬',
                    title: 'Berbincang Santai',
                    onTap: () => _executeAction('berbincang'),
                  ),
                  _buildActionCard(
                    icon: '📚',
                    title: 'Minta Bimbingan',
                    onTap: () => _executeAction('bimbingan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.grey.shade50,
      child: ListTile(
        leading: Text(icon, style: const TextStyle(fontSize: 24)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}
