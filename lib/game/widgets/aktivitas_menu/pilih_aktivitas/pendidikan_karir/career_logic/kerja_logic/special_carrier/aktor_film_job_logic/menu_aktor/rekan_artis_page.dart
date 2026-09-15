// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/aktor_film_job_logic/menu_aktor/rekan_artis_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

import 'package:mylifesim/game/widgets/dialog_helper.dart';

class RekanArtisPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const RekanArtisPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<RekanArtisPage> createState() => _RekanArtisPageState();
}

class _RekanArtisPageState extends State<RekanArtisPage> {
  @override
  void initState() {
    super.initState();
    if (widget.character.coworkers.isEmpty) {
      widget.character.generateCoworkersIfEmpty();
    }
  }

  int _getRelVal(dynamic val) {
    if (val == null) return 50;
    if (val is int) return val;
    if (val is String) return int.tryParse(val) ?? 50;
    return 50;
  }

  void _interaksiRekan(Map<String, dynamic> coworker, String actionName) {
    final r = Random();
    final int gain = r.nextInt(5) + 3;
    final int currentRel = _getRelVal(coworker['relationship']);
    final int newRel = (currentRel + gain).clamp(0, 100);
    coworker['relationship'] = newRel.toString();
    setState(() {});
    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: '$actionName Bersama ${coworker['name']} 🎭',
      content: Text('Interaksimu bersama ${coworker['name']} (${coworker['role'] ?? coworker['title'] ?? 'Co-Star'}) berlangsung hangat!\n\n• Hubungan Rekan: +$gain%'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final coworkers = widget.character.coworkers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Co-Star, Sutradara & Kru 👥🎬'),
        backgroundColor: Colors.purple.shade900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.purple.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.groups, color: Colors.white)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tim Perfilman & Skuad Set', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Text('Rekan Akting & Kru Produksi 🎬', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purple)),
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
            child: Text('Daftar Rekan Artis & Sutradara 👥', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          if (coworkers.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Belum ada rekan tim perfilman.')))
          else
            ...coworkers.map((cw) {
              final int rel = _getRelVal(cw['relationship']);
              final String roleTitle = cw['role'] ?? cw['title'] ?? 'Co-Star';
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                color: isDark ? Colors.grey.shade800 : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.person, color: Colors.white)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cw['name'] ?? 'Rekan Artis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                                Text('$roleTitle • Hubungan: $rel%', style: const TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.chat, size: 14),
                            label: const Text('Diskusi Dialog', style: TextStyle(fontSize: 11)),
                            onPressed: () => _interaksiRekan(cw, 'Diskusi Naskah Dialog'),
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.coffee, size: 14),
                            label: const Text('Ngopi di Set', style: TextStyle(fontSize: 11)),
                            onPressed: () => _interaksiRekan(cw, 'Minum Kopi di Rest Area'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
