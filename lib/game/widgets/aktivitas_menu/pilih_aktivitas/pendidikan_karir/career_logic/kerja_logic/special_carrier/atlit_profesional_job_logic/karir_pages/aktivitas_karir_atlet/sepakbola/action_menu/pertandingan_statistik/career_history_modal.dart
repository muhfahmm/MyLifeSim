// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/action_menu/pertandingan_statistik/career_history_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class CareerHistoryModal {
  static void show({
    required BuildContext context,
    required Character character,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final history = character.athleteSeasonStats;

    int totalAppearances = 0;
    int totalGoals = 0;
    int totalAssists = 0;
    double sumRating = 0.0;
    int countRating = 0;

    for (var item in history) {
      final app = item['appearances'];
      final g = item['goals'];
      final a = item['assists'];
      final r = item['rating'];

      if (app is int) {
        totalAppearances += app;
      } else if (app != null) {
        totalAppearances += int.tryParse(app.toString()) ?? 0;
      }

      if (g is int) {
        totalGoals += g;
      } else if (g != null) {
        totalGoals += int.tryParse(g.toString()) ?? 0;
      }

      if (a is int) {
        totalAssists += a;
      } else if (a != null) {
        totalAssists += int.tryParse(a.toString()) ?? 0;
      }

      if (r is num) {
        sumRating += r.toDouble();
        countRating++;
      } else if (r != null) {
        final parsedR = double.tryParse(r.toString());
        if (parsedR != null) {
          sumRating += parsedR;
          countRating++;
        }
      }
    }

    final double avgCareerRating = countRating > 0 ? (sumRating / countRating) : 0.0;
    final String avgRatingText = countRating > 0 ? '${avgCareerRating.toStringAsFixed(1)} ⭐' : '0.0 ⭐';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(ctx).size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history, color: Colors.purple, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    'Riwayat Karir & Statistik Musim 📜',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // CARD TOTAL KARIER KESELURUHAN
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? Colors.purple.shade700 : Colors.purple.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.workspace_premium, size: 16, color: Colors.purple),
                        const SizedBox(width: 6),
                        Text(
                          'TOTAL KARIR KESELURUHAN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTotalStatItem('Total Main', '$totalAppearances Laga', Icons.sports_soccer, Colors.blue, isDark),
                        _buildTotalStatItem('Total Gol', '$totalGoals ⚽', Icons.sports_score, Colors.green, isDark),
                        _buildTotalStatItem('Total Assist', '$totalAssists 👟', Icons.handshake, Colors.orange, isDark),
                        _buildTotalStatItem('Rating Karir', avgRatingText, Icons.star, Colors.amber, isDark),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (history.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Belum ada statistik musim lalu.\nStatistik otomatis berjalan saat kamu bertambah umur (1 tahun)! ⏳',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 13),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (ctx, index) {
                      final item = history[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: isDark ? Colors.grey.shade800 : Colors.purple.shade50.withValues(alpha: 0.5),
                        child: ListTile(
                          title: Text(
                            'Musim Usia ${item['age']} Tahun - ${item['team']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.purple),
                          ),
                          subtitle: Text(
                            '• Main: ${item['appearances']} Laga | Gol: ${item['goals']} ⚽ | Assist: ${item['assists']} 👟\n'
                            '• Performa Rating Rata-rata: ${item['rating']} / 10.0',
                            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildTotalStatItem(String label, String value, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey.shade700),
        ),
      ],
    );
  }
}
