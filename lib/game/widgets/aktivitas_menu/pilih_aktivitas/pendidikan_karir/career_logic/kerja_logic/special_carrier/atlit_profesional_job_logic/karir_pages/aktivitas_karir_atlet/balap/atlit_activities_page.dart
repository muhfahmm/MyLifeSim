// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/daftar_tim/balap/aktivitas_karir_atlet/atlit_activities_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class AtlitBalapActivitiesPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AtlitBalapActivitiesPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivitas Pebalap 🏎️'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 72,
                color: isDark ? Colors.amberAccent : Colors.orange,
              ),
              const SizedBox(height: 20),
              Text(
                'Halaman sedang dalam pengembangan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Fitur aktivitas karir untuk cabang olahraga balap akan segera hadir.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
