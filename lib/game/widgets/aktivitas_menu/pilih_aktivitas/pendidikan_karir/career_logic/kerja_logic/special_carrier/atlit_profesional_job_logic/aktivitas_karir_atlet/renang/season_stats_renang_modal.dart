// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/renang/season_stats_renang_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class SeasonStatsRenangModal {
  static void show({
    required BuildContext context,
    required Character character,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final stats = character.currentAthleteStats ?? {};
        final int gold = (stats['goldMedals'] as num?)?.toInt() ?? 0;
        final int total = (stats['totalMedals'] as num?)?.toInt() ?? 0;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Statistik Musim Renang Saat Ini 🏊‍♂️', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.workspace_premium, color: Colors.amber),
                title: const Text('Medali Emas'),
                trailing: Text('$gold 🥇', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              ListTile(
                leading: const Icon(Icons.military_tech, color: Colors.blue),
                title: const Text('Total Medali (Emas/Perak/Perunggu)'),
                trailing: Text('$total 🏅', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }
}
