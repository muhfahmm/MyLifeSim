// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/bulutangkis/action_menu/pelatnas_turnamen/pelatnas_bulutangkis_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PelatnasBulutangkisPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PelatnasBulutangkisPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PelatnasBulutangkisPage> createState() => _PelatnasBulutangkisPageState();
}

class _PelatnasBulutangkisPageState extends State<PelatnasBulutangkisPage> {
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

  void _ikutiTurnamenBWF(String tournamentName) {
    final r = Random();
    final bool isChampion = r.nextBool();
    if (isChampion) {
      widget.character.money += 25000000;
      widget.character.popularity = (widget.character.popularity + 5).clamp(0, 100);
      setState(() {});
      widget.onRefresh();

      _showAlert(
        'JUARA $tournamentName! 🏆🏸',
        'Luar biasa! Kamu menembus babak final dan berhasil menjuarai $tournamentName!\n\n'
        '• Hadiah Tunai: Rp 25.000.000\n'
        '• Popularitas: +5%',
      );
    } else {
      _showAlert(
        'Runner Up / Semifinal 🥈',
        'Kamu tampil gigih hingga semifinal $tournamentName tetapi tersingkir dalam rubber game yang sengit.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelatnas & Turnamen BWF 🏸'),
        backgroundColor: Colors.teal.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.teal.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.teal, child: Text('🏸', style: TextStyle(fontSize: 20))),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status Pelatnas PBSI', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Atlet Utama Pelatnas 🏸', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
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
            child: Text('Jadwal Turnamen BWF World Tour 🌍', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          _buildTournamentCard('All England Open 🇬🇧', 'Super 1000 - Turnamen Tertua & Paling Gengsi', isDark),
          _buildTournamentCard('Indonesia Open 🇮🇩', 'Super 1000 - Istora Senayan Jakarta', isDark),
          _buildTournamentCard('BWF World Championship 🥇', 'Kejuaraan Dunia Bulutangkis', isDark),
        ],
      ),
    );
  }

  Widget _buildTournamentCard(String title, String desc, bool isDark) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.emoji_events, color: Colors.white, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white),
          onPressed: () => _ikutiTurnamenBWF(title),
          child: const Text('Tanding', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
