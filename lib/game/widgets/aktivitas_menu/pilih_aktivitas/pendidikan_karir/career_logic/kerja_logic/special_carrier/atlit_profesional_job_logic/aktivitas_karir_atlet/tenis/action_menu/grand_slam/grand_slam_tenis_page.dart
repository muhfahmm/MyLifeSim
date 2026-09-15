// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/tenis/action_menu/grand_slam/grand_slam_tenis_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class GrandSlamTenisPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const GrandSlamTenisPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<GrandSlamTenisPage> createState() => _GrandSlamTenisPageState();
}

class _GrandSlamTenisPageState extends State<GrandSlamTenisPage> {
  void _showAlert(String title, String desc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(desc, style: const TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _tandingGrandSlam(String slamName) {
    final r = Random();
    final bool isWon = r.nextBool();
    if (isWon) {
      widget.character.money += 35000000;
      widget.character.popularity = (widget.character.popularity + 6).clamp(0, 100);
      setState(() {});
      widget.onRefresh();

      _showAlert(
        'JUARA GRAND SLAM! 🏆🎾',
        'Luar biasa! Kamu memenangkan tie-break set kelima dan mengangkat trofi $slamName!\n\n'
        '• Prize Money: Rp 35.000.000\n'
        '• Popularitas: +6%',
      );
    } else {
      _showAlert(
        'Tersingkir di Perempat Final 🎾',
        'Kamu berjuang sengit dalam rally panjang tetapi harus mengakui keunggulan lawan di babak perempat final $slamName.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Turnamen Grand Slam Tenis 🎾'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.sports_tennis, color: Colors.white)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Peringkat Dunia ATP / WTA', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Petenis Pro Top Ranking 🎾', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
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
            child: Text('4 Turnamen Utama Grand Slam 🌍', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          _buildSlamCard('Wimbledon Championship 🇬🇧', 'Lapangan Rumput Terbuka London', isDark),
          _buildSlamCard('Roland Garros (French Open) 🇫🇷', 'Lapangan Tanah Liat Merah Paris', isDark),
          _buildSlamCard('US Open Championship 🇺🇸', 'Lapangan Keras Flushing Meadows New York', isDark),
          _buildSlamCard('Australian Open 🇦🇺', 'Lapangan Keras Melbourne Park', isDark),
        ],
      ),
    );
  }

  Widget _buildSlamCard(String title, String desc, bool isDark) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.emoji_events, color: Colors.white, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
          onPressed: () => _tandingGrandSlam(title),
          child: const Text('Tanding', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
