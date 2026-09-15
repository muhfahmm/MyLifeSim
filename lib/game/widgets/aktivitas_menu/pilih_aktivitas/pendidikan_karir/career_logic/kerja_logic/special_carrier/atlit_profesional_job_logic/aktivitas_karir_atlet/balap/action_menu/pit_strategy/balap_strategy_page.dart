// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/balap/action_menu/pit_strategy/balap_strategy_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class BalapStrategyPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const BalapStrategyPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<BalapStrategyPage> createState() => _BalapStrategyPageState();
}

class _BalapStrategyPageState extends State<BalapStrategyPage> {
  String _tyreChoice = 'Ban Soft (Kecepatan Tinggi, Aus Cepat) 🏎️';

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

  void _simulasiKualifikasi() {
    final r = Random();
    final int gridPos = r.nextInt(5) + 1;
    _showAlert(
      'Kualifikasi Sesi Balap ⏱️🏎️',
      'Kamu mencatatkan waktu lap fantastis! Kamu mengamankan posisi Start Grid P$gridPos untuk balapan utama besok!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pit Strategy & Aerodinamis 🏎️'),
        backgroundColor: Colors.red.shade800,
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.speed, color: Colors.white)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Setelan Senjata Balap', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        Text(_tyreChoice, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.red.shade900)),
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
            child: Text('Pilihan Senyawa Ban 🏎️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          _buildTyreCard('Ban Soft (Kecepatan Tinggi, Aus Cepat) 🏎️', 'Merah - Grip maksimal untuk kualifikasi & lap cepat awal', Colors.red),
          _buildTyreCard('Ban Medium (Seimbang) 🟡', 'Kuning - Perpaduan daya tahan dan kecepatan stabil', Colors.amber.shade800),
          _buildTyreCard('Ban Hard (Tahan Lama) ⚪', 'Putih - Daya tahan maksimal untuk strategi pit stop minimal', Colors.blueGrey),

          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.timer, color: Colors.white, size: 20)),
              title: const Text('Jalani Sesi Kualifikasi Lap ⏱️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Rebut Pole Position di posisi grid terdepan', style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: _simulasiKualifikasi,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTyreCard(String title, String desc, Color color) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSelected = _tyreChoice == title;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? color : (isDark ? Colors.grey.shade700 : Colors.grey.shade300), width: isSelected ? 2 : 1),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), child: Icon(Icons.tire_repair, color: color, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: isSelected ? Icon(Icons.check_circle, color: color, size: 20) : null,
        onTap: () => setState(() => _tyreChoice = title),
      ),
    );
  }
}
