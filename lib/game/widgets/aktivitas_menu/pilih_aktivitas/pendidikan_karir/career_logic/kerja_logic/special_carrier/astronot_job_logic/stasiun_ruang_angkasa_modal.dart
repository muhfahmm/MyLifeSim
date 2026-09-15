// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/astronot_job_logic/stasiun_ruang_angkasa_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class StasiunRuangAngkasaModal {
  static void show(
    BuildContext context, {
    required Character character,
    required VoidCallback onRefresh,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> stationActivities = [
      {
        'title': 'Riset Tanaman di Mikro-Gravitasi 🌿',
        'desc': 'Menanam sayuran eksperimental di laboratorium ruang angkasa',
        'icon': Icons.eco,
        'color': Colors.green,
        'action': () {
          character.intelligence = (character.intelligence + 3).clamp(0, 100);
          return 'Eksperimen tanamanmu tumbuh subur di kondisi Zero-G! (Kecerdasan +3%)';
        }
      },
      {
        'title': 'Eksperimen Fisika & Biomedis 🧬',
        'desc': 'Meneliti reaksi materi fisika dan sel dalam lingkungan radiasi antariksa',
        'icon': Icons.science,
        'color': Colors.purple,
        'action': () {
          character.intelligence = (character.intelligence + 4).clamp(0, 100);
          return 'Hasil laboratorium biomedismu diterbitkan di jurnal sains antariksa! (Kecerdasan +4%)';
        }
      },
      {
        'title': 'Pemeliharaan Soliter & Navigasi Modul 🔧',
        'desc': 'Memeriksa kebersihan sistem filter oksigen & komputasi penerbangan',
        'icon': Icons.build,
        'color': Colors.blueGrey,
        'action': () {
          character.discipline = (character.discipline + 3).clamp(0, 100);
          return 'Sistem stasiun antariksa berjalan 100% stabil berkat perawatanmu! (Disiplin +3%)';
        }
      },
      {
        'title': 'Komunikasi Video Live dengan Bumi 📺',
        'desc': 'Melakukan wawancara edukasi interaktif bersama pelajar di Bumi',
        'icon': Icons.live_tv,
        'color': Colors.redAccent,
        'action': () {
          character.popularity = (character.popularity + 5).clamp(0, 100);
          return 'Siaran langsungmu menginspirasi jutaan generasi muda di seluruh dunia! (Popularitas +5%)';
        }
      },
    ];

    DialogHelper.show(
      context: context,
      title: 'Stasiun Luar Angkasa (ISS Base) 🛰️✨',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktivitas harian astronot di dalam laboratorium modul orbit bumi:',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
          ),
          const SizedBox(height: 12),
          ...stationActivities.map((activity) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                leading: CircleAvatar(
                  backgroundColor: activity['color'] as Color,
                  radius: 18,
                  child: Icon(activity['icon'] as IconData, color: Colors.white, size: 18),
                ),
                title: Text(
                  activity['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                subtitle: Text(
                  activity['desc'] as String,
                  style: TextStyle(fontSize: 10, color: isDark ? Colors.white70 : Colors.grey.shade700),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activity['color'] as Color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    final String resMsg = (activity['action'] as String Function())();
                    onRefresh();

                    DialogHelper.show(
                      context: context,
                      title: 'Aktivitas Stasiun Selesai 🛰️',
                      content: Text(resMsg),
                    );
                  },
                  child: const Text('Jalankan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
