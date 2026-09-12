// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/tim_tertarik_modal.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/daftar_negara.dart';
import '../../daftar_tim/database_tim_olahraga.dart';
import 'sepakbola_logic/gaji_pemain_sepakbola.dart';
import 'sepakbola_logic/logika_pemain_sepakbola.dart';

class TimTertarikModal {
  /// Menampilkan modal daftar klub-klub lain yang tertarik merekrut pemain
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
    final String currentJob = widget.character.jobName ?? 'Pemain Sepakbola - Klub';
    String currentTeamName = '';
    String currentPosTitle = 'Striker';
    if (currentJob.contains(' - ')) {
      final parts = currentJob.split(' - ');
      currentPosTitle = parts.first.trim();
      currentTeamName = parts.last.trim();
    } else {
      currentPosTitle = currentJob;
    }

    // 1. Hitung rata-rata rating karir
    double totalRatingSum = 0.0;
    int ratingCount = 0;
    for (var s in widget.character.athleteSeasonStats) {
      final r = s['rating'];
      if (r is num) {
        totalRatingSum += r.toDouble();
        ratingCount++;
      } else if (r != null) {
        final parsedR = double.tryParse(r.toString());
        if (parsedR != null) {
          totalRatingSum += parsedR;
          ratingCount++;
        }
      }
    }
    final double avgRating = ratingCount > 0 ? (totalRatingSum / ratingCount) : 7.0;

    // 2. Tentukan jumlah tim & base chance berdasarkan usia
    final int age = widget.character.age;
    int minTeams = 2;
    int maxTeams = 3;
    int baseChance = 60;

    if (age >= 13 && age <= 16) {
      minTeams = 1;
      maxTeams = 2;
      baseChance = 50;
    } else if (age >= 17 && age <= 21) {
      minTeams = 2;
      maxTeams = 3;
      baseChance = 60;
    } else if (age >= 22 && age <= 27) {
      minTeams = 4;
      maxTeams = 6;
      baseChance = 70;
    } else if (age >= 28 && age <= 30) {
      minTeams = 2;
      maxTeams = 3;
      baseChance = 60;
    } else if (age >= 31) {
      minTeams = 1;
      maxTeams = 2;
      baseChance = 50;
    }

    // Bonus/penyesuaian berdasarkan performa (avg rating)
    // Rating 8.0+ menambah +10%, Rating <6.0 mengurangi -10%
    final double ratingBonus = (avgRating - 7.0) * 10;
    final int finalChance = (baseChance + ratingBonus).round().clamp(10, 95);

    // Hitung jumlah tim yang akan ditampilkan
    final int targetCount = minTeams + Random().nextInt((maxTeams - minTeams) + 1);

    final allTeams = TimOlahragaDatabase.getTeamsBySport('sepakbola');
    final otherTeams = allTeams.where((t) => (t['name'] ?? '').toLowerCase() != currentTeamName.toLowerCase()).toList();
    otherTeams.shuffle(Random(widget.character.age * 13 + currentJob.hashCode));

    final double multiplier = getCountrySalaryMultiplier(widget.character.location);
    final selectedTeams = otherTeams.take(targetCount).toList();

    _interestedTeams = selectedTeams.map((team) {
      final validYears = LogikaPemainSepakbola.getOpsiDurasiKontrak(widget.character.age);
      final int contractYears = validYears[Random().nextInt(validYears.length)];
      final int baseSalary = GajiPemainSepakbolaLogic.hitungGajiBerdasarkanUsia(
        usia: widget.character.age,
        rand: Random(team['name'].hashCode + widget.character.age),
      );
      final int finalSalary = (baseSalary * multiplier).round();

      return {
        'teamName': team['name'] ?? 'Klub Sepakbola',
        'league': team['league'] ?? 'Liga Profesional',
        'origin': team['origin'] ?? 'Internasional',
        'positionTitle': currentPosTitle,
        'contractYears': contractYears,
        'salary': finalSalary,
        'chance': finalChance,
      };
    }).toList();
  }

  void _acceptOffer(Map<String, dynamic> offer) {
    String roleName = offer['positionTitle'] as String? ?? 'Pemain Sepakbola';
    final String rUpper = roleName.toUpperCase();
    if (rUpper == 'ST' ||
        rUpper == 'LW' ||
        rUpper == 'RW' ||
        rUpper == 'CAM' ||
        rUpper == 'CM' ||
        rUpper == 'CDM' ||
        rUpper == 'CB' ||
        rUpper == 'LB' ||
        rUpper == 'RB' ||
        rUpper == 'GK' ||
        roleName.contains('Striker') ||
        roleName.contains('Gelandang') ||
        roleName.contains('Bek') ||
        roleName.contains('Kiper')) {
      roleName = 'Pemain Sepakbola';
    }
    final String fullJobTitle = "$roleName - ${offer['teamName']}";
    final int salary = offer['salary'] as int;
    final int years = offer['contractYears'] as int;

    widget.character.setJob(fullJobTitle, salary);
    widget.character.athleteContractYears = years;
    widget.character.lastContractSignedAge = widget.character.age;

    final String inboxMsg = '📝 Kamu telah bergabung dengan ${offer['teamName']} (${offer['league']}) dengan kontrak $years tahun bernilai ${CurrencySettings.format(salary)}/tahun!';
    widget.character.inbox.add(inboxMsg);

    Navigator.pop(context); // Tutup dialog tim tertarik

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.sports_soccer, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Resmi Bergabung! 🎉', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: Text(
          'Selamat! Kamu resmi menandatangani kontrak dengan ${offer['teamName']} (${offer['league']}) selama $years tahun dengan gaji ${CurrencySettings.format(salary)}/tahun.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDone();
            },
            child: const Text('Mantap! 🏆', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        title: const Row(
          children: [
            Icon(Icons.swap_horiz_rounded, color: Colors.blue, size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Klub Lain Yang Tertarik ⚽',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Berikut adalah klub-klub lain yang memantau performamu dan bersedia memberikan tawaran kontrak baru:',
                  style: TextStyle(fontSize: 13, height: 1.3),
                ),
                const SizedBox(height: 14),
                ..._interestedTeams.map((offer) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade300.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                offer['teamName'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                offer['league'],
                                style: TextStyle(fontSize: 11, color: Colors.blue.shade900, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '• Posisi: ${offer['positionTitle']}',
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.black87),
                        ),
                        Text(
                          '• Durasi: ${offer['contractYears']} Tahun',
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.black87),
                        ),
                        Text(
                          '• Peluang Tertarik: ${offer['chance']}%',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
                        ),
                        Text(
                          '• Gaji: ${CurrencySettings.format(offer['salary'])} / tahun',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            onPressed: () => _acceptOffer(offer),
                            icon: const Icon(Icons.check_circle_outline, size: 16),
                            label: const Text('Tanda Tangan Kontrak', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDone();
            },
            child: const Text('Batal / Kembali', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
