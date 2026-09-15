// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/renang/action_menu/olimpiade/olimpiade_renang_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class OlimpiadeRenangPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const OlimpiadeRenangPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<OlimpiadeRenangPage> createState() => _OlimpiadeRenangPageState();
}

class _OlimpiadeRenangPageState extends State<OlimpiadeRenangPage> {
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

  void _tandingRenang(String styleName) {
    final r = Random();
    final bool isGold = r.nextBool();
    if (isGold) {
      widget.character.money += 20000000;
      widget.character.popularity = (widget.character.popularity + 5).clamp(0, 100);
      setState(() {});
      widget.onRefresh();

      _showAlert(
        'MEDALI EMAS OLIMPIADE! 🥇🏊‍♂️',
        'Kamu memecahkan rekor waktu nasional dan meraih Medali Emas di nomor $styleName!\n\n'
        '• Bonus Negara: Rp 20.000.000\n'
        '• Popularitas: +5%',
      );
    } else {
      _showAlert(
        'Medali Perak 🥈',
        'Kamu finish selisih 0,05 detik di belakang perenang utama dan mengamankan Medali Perak.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kualifikasi Olimpiade & Rekor Renang 🏊‍♂️'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.pool, color: Colors.white)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tim Nasional Renang', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Perenang Olimpiade 🏊‍♂️', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
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
            child: Text('Nomor Perlombaan Utama 🏊‍♂️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          _buildSwimCard('100m Gaya Bebas (Freestyle) 🏊‍♂️', 'Nomor sprint paling bergengsi di dunia renang', isDark),
          _buildSwimCard('200m Gaya Kupu-kupu (Butterfly) 🦋', 'Daya tahan otot bahu dan stamina maksimal', isDark),
          _buildSwimCard('100m Gaya Punggung (Backstroke) 🏊‍♀️', 'Kecepatan pembalikan dinding dan posisi tubuh meluncur', isDark),
        ],
      ),
    );
  }

  Widget _buildSwimCard(String title, String desc, bool isDark) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.waves, color: Colors.white, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade800, foregroundColor: Colors.white),
          onPressed: () => _tandingRenang(title),
          child: const Text('Lomba', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
