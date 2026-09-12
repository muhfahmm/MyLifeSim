// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/bulutangkis/action_menu/pertandingan_statistik/career_history_bulutangkis_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class CareerHistoryBulutangkisModal {
  static void show({
    required BuildContext context,
    required Character character,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final history = character.athleteSeasonStats;

    int totalTitles = 0;
    int totalRunnerUps = 0;

    for (var item in history) {
      totalTitles += (item['titles'] as num?)?.toInt() ?? 0;
      totalRunnerUps += (item['runnerUps'] as num?)?.toInt() ?? 0;
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
                  const Icon(Icons.history, color: Colors.teal, size: 26),
                  const SizedBox(width: 8),
                  Text(
                    'Riwayat Karir Bulutangkis 🏸',
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
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('$totalTitles 🏆', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
                        const Text('Gelar Juara 1', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('$totalRunnerUps 🥈', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueGrey)),
                        const Text('Runner Up', style: TextStyle(fontSize: 11, color: Colors.grey)),
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
                      'Belum ada riwayat musim bulutangkis.\nStatistik akan tercatat seiring bertambahnya usia karakter! ⏳',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 13),
                    ),
                  ),
                )
              else
                ...history.reversed.map((s) {
                  final int t = (s['titles'] as num?)?.toInt() ?? 0;
                  final int rUps = (s['runnerUps'] as num?)?.toInt() ?? 0;
                  final int app = (s['appearances'] as num?)?.toInt() ?? 0;
                  final double r = (s['rating'] as num?)?.toDouble() ?? 7.0;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text('Usia ${s['age']} - ${s['team']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text('$app Turnamen • $t Juara 1 🏆 | $rUps Runner Up 🥈', style: const TextStyle(fontSize: 12)),
                      trailing: Text('${r.toStringAsFixed(1)} ⭐', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
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
