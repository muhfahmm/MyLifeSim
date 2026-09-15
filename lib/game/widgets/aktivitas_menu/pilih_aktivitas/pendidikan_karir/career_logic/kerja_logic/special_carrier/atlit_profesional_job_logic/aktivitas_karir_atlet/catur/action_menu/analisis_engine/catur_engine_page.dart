// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/catur/action_menu/analisis_engine/catur_engine_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class CaturEnginePage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const CaturEnginePage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<CaturEnginePage> createState() => _CaturEnginePageState();
}

class _CaturEnginePageState extends State<CaturEnginePage> {
  String _favoriteOpening = 'Ruy Lopez Opening ♟️';

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

  void _analisisStockfish() {
    final r = Random();
    final int gain = r.nextInt(4) + 2;
    widget.character.intelligence = (widget.character.intelligence + gain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Analisis Engine Stockfish 🖥️♟️',
      'Kamu membedah 50 variasi taktik pertengahan babak dan endgame menggunakan Supercomputer Engine!\n\n'
      '• Inteligensi Catur: +$gain',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analisis Stockfish & Pembukaan Catur ♟️'),
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.brown.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Colors.brown, child: Text('♟️', style: TextStyle(fontSize: 20))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Repertoar Pembukaan Catur', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        Text(_favoriteOpening, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.brown.shade900)),
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
            child: Text('Repertoar Pembukaan Putih & Hitam ♟️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          _buildOpeningCard('Ruy Lopez Opening ♟️', '1.e4 e5 2.Nf3 Nc6 3.Bb5 - Pembukaan klasik paling solid', Colors.brown),
          _buildOpeningCard('Sicilian Defense (Najdorf) ⚡', '1.e4 c5 - Pertahanan agresif paling mematikan untuk hitam', Colors.deepOrange),
          _buildOpeningCard('Queen\'s Gambit Declined 👑', '1.d4 d5 2.c4 - Penguasaan pusat papan dengan tekanan konstan', Colors.purple),

          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.brown, child: Icon(Icons.computer, color: Colors.white, size: 20)),
              title: const Text('Riset Komputer Stockfish Engine 🖥️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Temukan langkah taktis tercepat (+Inteligensi)', style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: _analisisStockfish,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningCard(String title, String desc, Color color) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSelected = _favoriteOpening == title;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? color : (isDark ? Colors.grey.shade700 : Colors.grey.shade300), width: isSelected ? 2 : 1),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), child: Icon(Icons.extension, color: color, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: isSelected ? Icon(Icons.check_circle, color: color, size: 20) : null,
        onTap: () => setState(() => _favoriteOpening = title),
      ),
    );
  }
}
