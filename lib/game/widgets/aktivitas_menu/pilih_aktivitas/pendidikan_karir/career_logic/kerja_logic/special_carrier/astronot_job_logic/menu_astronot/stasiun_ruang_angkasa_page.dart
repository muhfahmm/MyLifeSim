// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/astronot_job_logic/menu_astronot/stasiun_ruang_angkasa_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class StasiunRuangAngkasaPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const StasiunRuangAngkasaPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<StasiunRuangAngkasaPage> createState() => _StasiunRuangAngkasaPageState();
}

class _StasiunRuangAngkasaPageState extends State<StasiunRuangAngkasaPage> {
  final List<Map<String, dynamic>> _stationActivities = [
    {
      'title': 'Riset Tanaman di Mikro-Gravitasi 🌿',
      'desc': 'Menanam sayuran eksperimental di laboratorium ruang angkasa.',
      'icon': Icons.eco,
      'color': Colors.green,
      'action': (Character c) {
        c.intelligence = (c.intelligence + 3).clamp(0, 100);
        return 'Eksperimen tanamanmu tumbuh subur di kondisi Zero-G! (Kecerdasan +3%)';
      }
    },
    {
      'title': 'Eksperimen Fisika & Biomedis 🧬',
      'desc': 'Meneliti reaksi materi fisika dan sel dalam lingkungan radiasi antariksa.',
      'icon': Icons.science,
      'color': Colors.purple,
      'action': (Character c) {
        c.intelligence = (c.intelligence + 4).clamp(0, 100);
        return 'Hasil laboratorium biomedismu diterbitkan di jurnal sains antariksa! (Kecerdasan +4%)';
      }
    },
    {
      'title': 'Pemeliharaan Soliter & Navigasi Modul 🔧',
      'desc': 'Memeriksa kebersihan sistem filter oksigen & komputasi penerbangan.',
      'icon': Icons.build,
      'color': Colors.blueGrey,
      'action': (Character c) {
        c.discipline = (c.discipline + 3).clamp(0, 100);
        return 'Sistem stasiun antariksa berjalan 100% stabil berkat perawatanmu! (Disiplin +3%)';
      }
    },
    {
      'title': 'Komunikasi Video Live dengan Bumi 📺',
      'desc': 'Melakukan wawancara edukasi interaktif bersama pelajar di Bumi.',
      'icon': Icons.live_tv,
      'color': Colors.redAccent,
      'action': (Character c) {
        c.popularity = (c.popularity + 5).clamp(0, 100);
        return 'Siaran langsungmu menginspirasi jutaan generasi muda di seluruh dunia! (Popularitas +5%)';
      }
    },
  ];

  void _runActivity(Map<String, dynamic> activity) {
    final String resMsg = (activity['action'] as String Function(Character))(widget.character);
    setState(() {});
    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Aktivitas Stasiun Selesai 🛰️',
      content: Text(resMsg, style: const TextStyle(fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stasiun Luar Angkasa (ISS) 🛰️'),
        backgroundColor: Colors.teal.shade900,
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.space_dashboard, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Modul Laboratorium Orbit', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        const SizedBox(height: 2),
                        Text(
                          'Kecerdasan: ${widget.character.intelligence}% 🧠 • Disiplin: ${widget.character.discipline}% 🛡️',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.teal.shade900),
                        ),
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
            child: Text(
              'Riset & Operasi Harian ISS 🧪',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87),
            ),
          ),

          ..._stationActivities.map((activity) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
              ),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: activity['color'] as Color,
                          child: Icon(activity['icon'] as IconData, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            activity['title'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activity['desc'] as String,
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: activity['color'] as Color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.science_rounded, size: 18),
                        label: const Text('Jalankan Riset & Operasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        onPressed: () => _runActivity(activity),
                      ),
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
