// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/action_menu/pertandingan_statistik/career_history_renang_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class CareerHistoryRenangModal {
  static void show({
    required BuildContext context,
    required Character character,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final history = character.athleteSeasonStats;

    int totalGolds = 0;
    int totalMedals = 0;

    for (var item in history) {
      totalGolds += (item['goldMedals'] as num?)?.toInt() ?? 0;
      totalMedals += (item['totalMedals'] as num?)?.toInt() ?? 0;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                children: [
                  const Icon(Icons.history, color: Colors.blue, size: 26),
                  const SizedBox(width: 8),
                  Text(
                    'Riwayat Karir Renang 🏊‍♂️',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('$totalGolds 🥇', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
                        const Text('Medali Emas', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('$totalMedals 🏅', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                        const Text('Total Medali', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (history.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Belum ada riwayat musim renang.\nStatistik akan tercatat seiring bertambahnya usia karakter! ⏳',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 13),
                    ),
                  ),
                )
              else
                ...history.reversed.map((s) {
                  final int gold = (s['goldMedals'] as num?)?.toInt() ?? 0;
                  final int medals = (s['totalMedals'] as num?)?.toInt() ?? 0;
                  final int app = (s['appearances'] as num?)?.toInt() ?? 0;
                  final double r = (s['rating'] as num?)?.toDouble() ?? 7.0;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text('Usia ${s['age']} - ${s['team']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('$app Lomba • $gold Emas 🥇 | $medals Total Medali 🏅', style: const TextStyle(fontSize: 12)),
                      trailing: Text('${r.toStringAsFixed(1)} ⭐', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
