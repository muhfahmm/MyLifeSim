// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/action_menu/trophy_room/trophy_room_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class TrophyRoomPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const TrophyRoomPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Hitung total gol dan assist untuk menghitung estimasi penghargaan
    int totalGoals = 0;
    for (var item in character.athleteSeasonStats) {
      totalGoals += (item['goals'] as num?)?.toInt() ?? 0;
    }
    final currentStats = character.currentAthleteStats;
    if (currentStats != null) {
      totalGoals += (currentStats['goals'] as num?)?.toInt() ?? 0;
    }

    final bool hasGoldenBoot = totalGoals >= 15;
    final bool hasBallonDor = totalGoals >= 30 && character.popularity >= 80;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lemari Trofi & Penghargaan 🏆'),
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // HEADER TROPHY ROOM
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.purple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.workspace_premium, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Koleksi Trofi Individu & Tim', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        Text(
                          'Lemari Kehormatan Atlet 👑',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.purple.shade900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // PENGHARGAAN INDIVIDU
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text('Penghargaan Individu ⭐', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),

          _buildTrophyItem(
            title: 'Ballon d\'Or / Pemain Terbaik Dunia 👑',
            desc: 'Diberikan kepada pemain dengan statistik paling luar biasa di dunia (Min. 30 gol & Pop 80%)',
            isUnlocked: hasBallonDor,
            icon: Icons.emoji_events,
            color: Colors.amber,
            isDark: isDark,
          ),

          _buildTrophyItem(
            title: 'Sepatu Emas / Golden Boot 👟',
            desc: 'Pencetak Gol Terbanyak Musim Ini (Min. 15 Gol)',
            isUnlocked: hasGoldenBoot,
            icon: Icons.sports_score,
            color: Colors.orange,
            isDark: isDark,
          ),

          _buildTrophyItem(
            title: 'Pemain Muda Terbaik Musim Ini 🌟',
            desc: 'Penghargaan untuk bakat muda di bawah 21 tahun',
            isUnlocked: character.age <= 21,
            icon: Icons.auto_awesome,
            color: Colors.blue,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildTrophyItem({
    required String title,
    required String desc,
    required bool isUnlocked,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isUnlocked ? color : (isDark ? Colors.grey.shade700 : Colors.grey.shade300)),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isUnlocked ? color.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
          child: Icon(icon, color: isUnlocked ? color : Colors.grey, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: isUnlocked ? (isDark ? Colors.white : Colors.black87) : Colors.grey,
          ),
        ),
        subtitle: Text(
          desc,
          style: TextStyle(fontSize: 11, color: isUnlocked ? (isDark ? Colors.white70 : Colors.grey.shade600) : Colors.grey.shade500),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isUnlocked ? Colors.green.shade100 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            isUnlocked ? 'Tercapai' : 'Terkunci',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isUnlocked ? Colors.green.shade900 : Colors.grey.shade700),
          ),
        ),
      ),
    );
  }
}
