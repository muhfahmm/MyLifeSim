// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/renang/tim_tertarik_renang_modal.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class TimTertarikRenangModal {
  static void show({
    required BuildContext context,
    required Character character,
    required VoidCallback onDone,
  }) {
    final List<Map<String, dynamic>> clubs = [
      {'name': 'Klub Renang Tirta Utama', 'offer': 55000000, 'contract': 3},
      {'name': 'Akuatik Nasional Club', 'offer': 65000000, 'contract': 2},
      {'name': 'Pacific Swimming Club', 'offer': 75000000, 'contract': 4},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Klub Renang Tertarik 🏊‍♂️',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...clubs.map(
              (c) => ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.pool, color: Colors.white, size: 20)),
                title: Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Gaji: ${CurrencySettings.format(c['offer'] as int)}/thn (${c['contract']} thn)'),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pop(ctx);
                    character.jobName = 'Perenang Utama - ${c['name']}';
                    character.jobSalary = c['offer'] as int;
                    character.athleteContractYears = c['contract'] as int;
                    character.lastContractSignedAge = character.age;
                    character.inbox.add('🏊‍♂️ Kamu resmi bergabung dengan ${c['name']}!');
                    onDone();
                  },
                  child: const Text('Pindah'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
