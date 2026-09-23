// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/aktor_film_job_logic/menu_aktor/festival_penghargaan_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

import 'package:mylifesim/game/widgets/dialog_helper.dart';

class FestivalPenghargaanPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const FestivalPenghargaanPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<FestivalPenghargaanPage> createState() => _FestivalPenghargaanPageState();
}

class _FestivalPenghargaanPageState extends State<FestivalPenghargaanPage> {
  void _showAlert(String title, String desc) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(desc, style: const TextStyle(fontSize: 13)),
    );
  }

  void _hadiriRedCarpet(String festivalName, int minPop) {
    if (widget.character.popularity < minPop) {
      _showAlert(
        'Undangan Terbatas',
        'Festival $festivalName hanya mengundang aktor papan atas dengan minimal Popularitas $minPop%.\n'
        'Popularitasmu saat ini: ${widget.character.popularity}%.',
      );
      return;
    }

    final r = Random();
    final bool isWon = r.nextBool();
    if (isWon) {
      widget.character.popularity = (widget.character.popularity + 7).clamp(0, 100);
      widget.character.followers += 5000;
      setState(() {});
      widget.onRefresh();

      _showAlert(
        'MENANG PENGHARGAAN AKTOR TERBAIK! 🏆🎬',
        'Nama kamu dipanggil sebagai pemenang Piala Aktor Utama Terbaik di $festivalName!\n\n'
        '• Popularitas: +7%\n'
        '• Penggemar Sosmed: +5.000 Followers',
      );
    } else {
      _showAlert(
        'Masuk Nominasi Resmi 🌹',
        'Kamu melenggang anggun di Red Carpet $festivalName dan berhasil meraih penghargaan nominasi aktor berbakat.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Red Carpet & Festival Film 🏆'),
        backgroundColor: Colors.amber.shade900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.emoji_events, color: Colors.white)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Penghargaan & Reputasi Perfilman', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        Text('Popularitas: ${widget.character.popularity}% ⭐', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.amber.shade900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text('Festival Film & Gala Penghargaan 🏆', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          _buildFestivalCard('Academy Awards (Oscar) 🏆', 'Malam Gala Penghargaan Tertinggi Perfilman Dunia', 70, isDark),
          _buildFestivalCard('Cannes Film Festival 🇫🇷', 'Festival Film Internasional Terbaik di Prancis', 50, isDark),
          _buildFestivalCard('Festival Film Indonesia (Piala Citra) 🇮🇩', 'Ajang Puncak Perfilman Nasional', 30, isDark),
        ],
      ),
    );
  }

  Widget _buildFestivalCard(String title, String desc, int minPop, bool isDark) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.workspace_premium, color: Colors.white, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text('$desc\nMin. Popularitas $minPop%', style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade900, foregroundColor: Colors.white),
          onPressed: () => _hadiriRedCarpet(title, minPop),
          child: const Text('Red Carpet', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
