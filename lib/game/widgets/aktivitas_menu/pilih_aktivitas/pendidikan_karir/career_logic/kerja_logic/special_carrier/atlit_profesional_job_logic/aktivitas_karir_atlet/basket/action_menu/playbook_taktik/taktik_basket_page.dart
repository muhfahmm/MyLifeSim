// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/basket/action_menu/playbook_taktik/taktik_basket_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class TaktikBasketPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const TaktikBasketPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<TaktikBasketPage> createState() => _TaktikBasketPageState();
}

class _TaktikBasketPageState extends State<TaktikBasketPage> {
  String _currentPlaybook = 'Pick & Roll Heavy 🏀';

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

  void _latihanPlaybook() {
    final r = Random();
    final int gain = r.nextInt(3) + 2;
    widget.character.intelligence = (widget.character.intelligence + gain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Simulasi Playbook Basket 🏀',
      'Kamu melatih eksekusi rotasi Pick & Roll dan 3-point spacing bersama pelatih!\n\n'
      '• Visi Permainan & Inteligensi: +$gain',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playbook & Taktik Basket 🏀'),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.sports_basketball, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gaya Skema Utama Basket', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        Text(_currentPlaybook, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.orange.shade900)),
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
            child: Text('Pilih Strategi Playbook ⚙️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          _buildPlayCard('Pick & Roll Heavy 🏀', 'Skema ulasan layar tinggi dan umpan cepat ke dalam paint area', Icons.swap_calls, Colors.orange),
          _buildPlayCard('Pace & Space 3-Pointer 🎯', 'Buka ruang luar garis 3 angka dan tembak cepat', Icons.gps_fixed, Colors.blue),
          _buildPlayCard('Isolation Star Ball 👑', 'Fokus menyerang 1v1 dengan keahlian ball handling individu', Icons.person, Colors.purple),
          _buildPlayCard('Full Court Press & Fastbreak ⚡', 'Pertahanan ketat seluruh lapangan dan umpan balik kilat', Icons.bolt, Colors.red),

          const SizedBox(height: 16),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.fitness_center, color: Colors.white, size: 20)),
              title: const Text('Simulasi & Review Video Playbook 📹', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Pelajari skema pertahanan zone & man-to-man lawan (+Inteligensi)', style: TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: _latihanPlaybook,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayCard(String title, String desc, IconData icon, Color color) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isSelected = _currentPlaybook == title;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? color : (isDark ? Colors.grey.shade700 : Colors.grey.shade300), width: isSelected ? 2 : 1),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), child: Icon(icon, color: color, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: isSelected ? Icon(Icons.check_circle, color: color, size: 20) : null,
        onTap: () => setState(() => _currentPlaybook = title),
      ),
    );
  }
}
