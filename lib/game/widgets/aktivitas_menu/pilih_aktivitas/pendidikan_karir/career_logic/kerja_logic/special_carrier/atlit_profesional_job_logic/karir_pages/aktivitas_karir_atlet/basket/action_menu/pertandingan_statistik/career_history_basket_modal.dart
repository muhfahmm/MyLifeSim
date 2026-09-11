// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/basket/action_menu/pertandingan_statistik/career_history_basket_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class CareerHistoryBasketModal {
  static void show({
    required BuildContext context,
    required Character character,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final history = character.athleteSeasonStats;

    int totalPoints = 0;
    int totalRebounds = 0;
    int totalAssists = 0;

    for (var item in history) {
      totalPoints += (item['points'] as num?)?.toInt() ?? (item['goals'] as num?)?.toInt() ?? 0;
      totalRebounds += (item['rebounds'] as num?)?.toInt() ?? 0;
      totalAssists += (item['assists'] as num?)?.toInt() ?? 0;
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
                  const Icon(Icons.history, color: Colors.orange, size: 26),
                  const SizedBox(width: 8),
                  Text(
                    'Riwayat Karir Basket 📜',
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
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('$totalPoints Pts', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange)),
                        const Text('Total Poin', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('$totalRebounds Reb', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown)),
                        const Text('Total Rebound', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('$totalAssists Ast', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange)),
                        const Text('Total Assist', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...history.reversed.map((s) {
                final int pts = (s['points'] as num?)?.toInt() ?? (s['goals'] as num?)?.toInt() ?? 0;
                final int reb = (s['rebounds'] as num?)?.toInt() ?? 0;
                final int ast = (s['assists'] as num?)?.toInt() ?? 0;
                final int app = (s['appearances'] as num?)?.toInt() ?? 0;
                final double r = (s['rating'] as num?)?.toDouble() ?? 7.0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text('Usia ${s['age']} - ${s['team']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('$app Laga • $pts Pts | $reb Reb | $ast Ast', style: const TextStyle(fontSize: 12)),
                    trailing: Text('${r.toStringAsFixed(1)} ⭐', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
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
