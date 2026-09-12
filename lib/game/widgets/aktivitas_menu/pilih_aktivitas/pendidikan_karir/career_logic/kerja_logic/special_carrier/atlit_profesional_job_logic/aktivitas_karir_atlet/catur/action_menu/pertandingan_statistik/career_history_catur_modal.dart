// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/catur/action_menu/pertandingan_statistik/career_history_catur_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class CareerHistoryCaturModal {
  static void show({
    required BuildContext context,
    required Character character,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final history = character.athleteSeasonStats;

    int totalWins = 0;
    int totalDraws = 0;
    int totalLosses = 0;

    for (var item in history) {
      totalWins += (item['wins'] as num?)?.toInt() ?? 0;
      totalDraws += (item['draws'] as num?)?.toInt() ?? 0;
      totalLosses += (item['losses'] as num?)?.toInt() ?? 0;
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
                  const Icon(Icons.history, color: Colors.deepPurple, size: 26),
                  const SizedBox(width: 8),
                  Text(
                    'Riwayat Karir Catur ♟️',
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
                  color: Colors.deepPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('$totalWins 🏆', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                        const Text('Menang', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('$totalDraws 🤝', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange)),
                        const Text('Seri', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('$totalLosses ❌', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red)),
                        const Text('Kalah', style: TextStyle(fontSize: 11, color: Colors.grey)),
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
                      'Belum ada riwayat musim catur.\nStatistik akan tercatat seiring bertambahnya usia karakter! ⏳',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 13),
                    ),
                  ),
                )
              else
                ...history.reversed.map((s) {
                  final int w = (s['wins'] as num?)?.toInt() ?? 0;
                  final int d = (s['draws'] as num?)?.toInt() ?? 0;
                  final int l = (s['losses'] as num?)?.toInt() ?? 0;
                  final int app = (s['appearances'] as num?)?.toInt() ?? 0;
                  final double r = (s['rating'] as num?)?.toDouble() ?? 7.5;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text('Usia ${s['age']} - ${s['team']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('$app Game • $w Menang | $d Seri | $l Kalah', style: const TextStyle(fontSize: 12)),
                      trailing: Text('${r.toStringAsFixed(1)} ⭐', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
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
