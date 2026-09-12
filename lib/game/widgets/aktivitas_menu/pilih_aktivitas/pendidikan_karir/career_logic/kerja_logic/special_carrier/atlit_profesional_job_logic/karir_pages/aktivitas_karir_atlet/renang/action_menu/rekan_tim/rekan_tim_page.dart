// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/action_menu/rekan_tim/rekan_tim_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class RekanTimRenangPage extends StatelessWidget {
  final Character character;

  const RekanTimRenangPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekan Tim & Pelatih Renang 🏊‍♂️'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: character.coworkers.length,
        itemBuilder: (context, index) {
          final c = character.coworkers[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, color: Colors.blue),
              ),
              title: Text(c['name']?.toString() ?? 'Rekan Tim', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${c['jobTitle'] ?? 'Perenang'} • Usia: ${c['age'] ?? '-'} thn'),
            ),
          );
        },
      ),
    );
  }
}
