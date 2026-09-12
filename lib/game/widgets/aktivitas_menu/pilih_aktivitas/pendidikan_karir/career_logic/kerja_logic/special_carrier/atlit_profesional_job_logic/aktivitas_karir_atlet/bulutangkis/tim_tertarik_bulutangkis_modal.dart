// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/bulutangkis/tim_tertarik_bulutangkis_modal.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import '../../daftar_tim/database_tim_olahraga.dart';
import 'bulutangkis_logic/gaji_pemain_bulutangkis.dart';
import 'bulutangkis_logic/logika_pemain_bulutangkis.dart';

class TimTertarikBulutangkisModal {
  static void show({
    required BuildContext context,
    required Character character,
    required VoidCallback onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _TimTertarikDialog(
        character: character,
        onDone: onDone,
      ),
    );
  }
}

class _TimTertarikDialog extends StatefulWidget {
  final Character character;
  final VoidCallback onDone;

  const _TimTertarikDialog({
    required this.character,
    required this.onDone,
  });

  @override
  State<_TimTertarikDialog> createState() => _TimTertarikDialogState();
}

class _TimTertarikDialogState extends State<_TimTertarikDialog> {
  late List<Map<String, dynamic>> _interestedTeams;

  @override
  void initState() {
    super.initState();
    _generateInterestedTeams();
  }

  void _generateInterestedTeams() {
    final String currentJob = widget.character.jobName ?? 'Pebulutangkis - Klub Bulutangkis';
    String currentTeamName = '';
    String currentPosTitle = 'Pebulutangkis Utama';
    if (currentJob.contains(' - ')) {
      final parts = currentJob.split(' - ');
      currentPosTitle = parts.first.trim();
      currentTeamName = parts.last.trim();
    }

    final rand = Random();
    final allTeams = TimOlahragaDatabase.getTeamsBySport('Bulutangkis');
    final availableTeams = allTeams.isNotEmpty ? allTeams : [
      {'name': 'PB Jaya Raya'},
      {'name': 'PB Djarum'},
      {'name': 'PB Exist'},
      {'name': 'PB Tangkas'},
    ];

    final otherTeams = availableTeams.where((t) => (t['name'] ?? '') != currentTeamName).toList();
    otherTeams.shuffle(rand);

    final selected = otherTeams.take(3).toList();
    _interestedTeams = selected.map((t) {
      final int offeredSalary = GajiPemainBulutangkisLogic.hitungGajiBerdasarkanUsia(
        usia: widget.character.age,
        rand: rand,
      );
      final validYears = LogikaPemainBulutangkis.getOpsiDurasiKontrak(widget.character.age);
      final int years = validYears[rand.nextInt(validYears.length)];

      return {
        'teamName': t['name'] ?? 'Klub Bulutangkis',
        'offeredSalary': offeredSalary,
        'offeredYears': years,
        'posTitle': currentPosTitle,
      };
    }).toList();
  }

  void _acceptOffer(Map<String, dynamic> item) {
    final String teamName = item['teamName'];
    final int salary = item['offeredSalary'];
    final int years = item['offeredYears'];
    final String posTitle = item['posTitle'];

    widget.character.jobName = '$posTitle - $teamName';
    widget.character.jobSalary = salary;
    widget.character.athleteContractYears = years;
    widget.character.lastContractSignedAge = widget.character.age;
    widget.character.inbox.add('🏸 Kamu resmi bergabung dengan $teamName selama $years tahun dengan gaji ${CurrencySettings.format(salary)}/tahun.');

    Navigator.pop(context);
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.swap_horiz, color: Colors.teal, size: 26),
          SizedBox(width: 8),
          Text('Klub Bulutangkis Tertarik 🏸', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _interestedTeams.map((item) {
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(item['teamName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(
                    'Durasi: ${item['offeredYears']} Tahun • Gaji: ${CurrencySettings.format(item['offeredSalary'])}/thn',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade800, foregroundColor: Colors.white),
                    onPressed: () => _acceptOffer(item),
                    child: const Text('Gabung', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tolak Semua', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}
