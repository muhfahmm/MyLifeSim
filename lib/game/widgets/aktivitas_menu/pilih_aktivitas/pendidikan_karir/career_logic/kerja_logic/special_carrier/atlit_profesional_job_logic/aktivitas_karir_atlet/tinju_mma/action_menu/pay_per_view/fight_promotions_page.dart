// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/tinju_mma/action_menu/pay_per_view/fight_promotions_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class FightPromotionsPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const FightPromotionsPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<FightPromotionsPage> createState() => _FightPromotionsPageState();
}

class _FightPromotionsPageState extends State<FightPromotionsPage> {
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

  void _lagaPPV(String fightTitle, int basePay) {
    final r = Random();
    final bool isKO = r.nextBool();
    if (isKO) {
      widget.character.money += basePay;
      widget.character.popularity = (widget.character.popularity + 8).clamp(0, 100);
      setState(() {});
      widget.onRefresh();

      _showAlert(
        'KNOCKOUT WIN! 🥊💥',
        'Kamu merobohkan lawan di ronde ke-3 dengan KO spektakuler pada laga $fightTitle!\n\n'
        '• Fight Purse & PPV Share: Rp ${basePay.toString()}\n'
        '• Popularitas: +8%',
      );
    } else {
      _showAlert(
        'Kekalahan Tipis Split Decision 🥊',
        'Pertarungan sengit 5 ronde berakhir dengan kekalahan angka split decision yang kontroversial.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PPV Fight Night & Sabuk Juara 🥊'),
        backgroundColor: Colors.red.shade900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.red.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.sports_mma, color: Colors.white)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Divisi Sabuk Juara', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Petarung Kelas Dunia 🥊🔥', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
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
            child: Text('Laga Utama Pay-Per-View (PPV) 🥊', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          _buildFightCard('UFC World Championship Main Event 🥊', 'Laga perebutan sabuk juara dunia UFC', 40000000, isDark),
          _buildFightCard('WBC Heavyweight Title Fight 💥', 'Laga sabuk juara dunia tinju WBC di Las Vegas', 50000000, isDark),
          _buildFightCard('ONE Championship Main Card 🌏', 'Laga utama MMA Asia di Singapura', 20000000, isDark),
        ],
      ),
    );
  }

  Widget _buildFightCard(String title, String desc, int pay, bool isDark) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.local_fire_department, color: Colors.white, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
          onPressed: () => _lagaPPV(title, pay),
          child: const Text('Bertarung', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
