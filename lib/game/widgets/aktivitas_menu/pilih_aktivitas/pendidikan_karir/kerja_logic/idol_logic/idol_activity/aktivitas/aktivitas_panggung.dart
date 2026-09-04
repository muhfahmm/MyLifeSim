import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class AktivitasPanggungPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AktivitasPanggungPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AktivitasPanggungPage> createState() => _AktivitasPanggungPageState();
}

class _AktivitasPanggungPageState extends State<AktivitasPanggungPage> {
  void _lakukanLatihanKeras(String tipe, int stressCost, int disciplineGain) {
    setState(() {
      widget.character.happiness = (widget.character.happiness - stressCost).clamp(0, 100);
      widget.character.discipline = (widget.character.discipline + disciplineGain).clamp(0, 100);
      
      // Improve relationship with a random member
      final sourceList = widget.character.jobName == 'Idol (Main Performer)'
          ? widget.character.idolMainMembers
          : widget.character.idolTrainees;
      if (sourceList.isNotEmpty) {
        final rand = Random();
        final idx = rand.nextInt(sourceList.length);
        final member = sourceList[idx];
        int currentRel = int.tryParse(member['relationship'] ?? '50') ?? 50;
        member['relationship'] = (currentRel + rand.nextInt(5) + 3).clamp(0, 100).toString();
      }
    });
    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Latihan & Penampilan 🎤✨',
      content: Text(
        'Kamu melakukan "$tipe". Kemampuan panggung dan kedisiplinanmu meningkat (Kedisiplinan: ${widget.character.discipline}%).\n'
        'Hubungan dengan rekan satu grup juga membaik! Kebahagiaanmu berkurang -$stressCost% karena lelah.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Luar Biasa!'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivitas Panggung & Latihan 🎭'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildActionCard(
            title: 'Latihan Vokal & Koreografi 💃',
            desc: 'Tingkatkan kedisiplinan dan teknik panggung (Disiplin +5%, Kebahagiaan -3%)',
            onTap: () => _lakukanLatihanKeras('Latihan Vokal & Koreografi', 3, 5),
          ),
          _buildActionCard(
            title: 'Pertunjukan Teater 🎭',
            desc: 'Tampil langsung di hadapan fans (Disiplin +8%, Kebahagiaan -5%)',
            onTap: () => _lakukanLatihanKeras('Pertunjukan Teater', 5, 8),
          ),
          _buildActionCard(
            title: 'Promosi Media Sosial 📱',
            desc: 'Berbagi foto dan menyapa fans secara daring (Disiplin +3%, Kebahagiaan -2%)',
            onTap: () => _lakukanLatihanKeras('Promosi Media Sosial', 2, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.pink.shade700 : Colors.pink.shade100.withOpacity(0.5),
        ),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          desc,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.grey,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isDark ? Colors.white54 : Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}