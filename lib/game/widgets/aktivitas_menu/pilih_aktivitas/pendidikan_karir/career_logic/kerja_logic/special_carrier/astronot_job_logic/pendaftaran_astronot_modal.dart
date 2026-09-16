// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/astronot_job_logic/pendaftaran_astronot_modal.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class PendaftaranAstronotModal {
  static void show(
    BuildContext context, {
    required Character character,
    required VoidCallback onRefresh,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> spaceAgencies = [
      {
        'agencyName': 'NASA (Badan Antariksa AS) 🇺🇸',
        'role': 'Astronot Trainee',
        'rank': 'Astronot Junior',
        'minHealth': 80,
        'minIntel': 75,
        'salary': 350000,
        'color': Colors.indigo,
        'icon': Icons.rocket_launch,
      },
      {
        'agencyName': 'ESA (Badan Antariksa Eropa) 🇪🇺',
        'role': 'Insinyur Misi Antariksa',
        'rank': 'Spesialis Misi',
        'minHealth': 75,
        'minIntel': 80,
        'salary': 320000,
        'color': Colors.blue,
        'icon': Icons.satellite_alt,
      },
      {
        'agencyName': 'JAXA (Badan Antariksa Jepang) 🇯🇵',
        'role': 'Spesialis Robotik Antariksa',
        'rank': 'Spesialis Muatan',
        'minHealth': 70,
        'minIntel': 85,
        'salary': 300000,
        'color': Colors.redAccent,
        'icon': Icons.precision_manufacturing,
      },
      {
        'agencyName': 'LAPAN / BRIN Antariksa 🇮🇩',
        'role': 'Peneliti & Pilot Roket',
        'rank': 'Pilot Antariksa',
        'minHealth': 70,
        'minIntel': 70,
        'salary': 150000,
        'color': Colors.deepOrange,
        'icon': Icons.airplanemode_active,
      },
    ];

    DialogHelper.show(
      context: context,
      title: 'Pendaftaran Rekrutmen Astronot 🚀',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lembaga antariksa luar negeri dan nasional membuka rekrutmen astronot baru! Pilih lembaga yang ingin kamu lamar:',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
          ),
          const SizedBox(height: 12),

          // KARTU SYARAT DIRI
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.indigo.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '❤️ Kesehatan: ${character.health}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: character.health >= 70 ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  '🧠 Kecerdasan: ${character.intelligence}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: character.intelligence >= 70 ? Colors.indigo : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          ...spaceAgencies.map((agency) {
            final int minH = agency['minHealth'] as int;
            final int minI = agency['minIntel'] as int;
            final bool isEligible = character.health >= minH && character.intelligence >= minI;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                leading: CircleAvatar(
                  backgroundColor: agency['color'] as Color,
                  radius: 18,
                  child: Icon(agency['icon'] as IconData, color: Colors.white, size: 18),
                ),
                title: Text(
                  agency['agencyName'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                subtitle: Text(
                  'Peran: ${agency['role']}\n'
                  'Gaji: ${CurrencySettings.format((agency['salary'] as int).toDouble())}\n'
                  'Min: Kesehatan $minH% • Kecerdasan $minI%',
                  style: TextStyle(fontSize: 10, color: isDark ? Colors.white70 : Colors.grey.shade700),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEligible ? (agency['color'] as Color) : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {
                    if (!isEligible) {
                      DialogHelper.show(
                        context: context,
                        title: 'Syarat Tidak Terpenuhi ⚠️',
                        content: Text(
                          'Kamu belum memenuhi kualifikasi rekrutmen ${agency['agencyName']}.\n\n'
                          '• Kesehatanmu: ${character.health}% (Min. $minH%)\n'
                          '• Kecerdasanmu: ${character.intelligence}% (Min. $minI%)',
                        ),
                      );
                      return;
                    }

                    Navigator.of(context, rootNavigator: true).pop();

                    final r = Random();
                    final bool isPassed = r.nextInt(100) < (character.health + character.intelligence) ~/ 2;

                    if (isPassed) {
                      // Tampilkan modal pilihan durasi kontrak (1 atau 2 tahun)
                      _showContractSelectionModal(
                        context,
                        character: character,
                        agencyName: agency['agencyName'] as String,
                        role: agency['role'] as String,
                        rank: agency['rank'] as String,
                        salary: agency['salary'] as int,
                        onRefresh: onRefresh,
                      );
                    } else {
                      DialogHelper.show(
                        context: context,
                        title: 'Seleksi Astronot Gagal 👨‍🚀',
                        content: Text(
                          'Tim penguji ${agency['agencyName']} memutuskan untuk belum menerima lamaranmu pada periode ini. Tingkatkan lagi kesehatan fisik dan kecerdasanmu.',
                        ),
                      );
                    }
                  },
                  child: const Text('Daftar', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  static void _showContractSelectionModal(
    BuildContext context, {
    required Character character,
    required String agencyName,
    required String role,
    required String rank,
    required int salary,
    required VoidCallback onRefresh,
  }) {
    DialogHelper.show(
      context: context,
      title: 'Diterima Sebagai Astronot! 🚀🌟',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat! Kamu lulus seleksi rekrutmen astronot di $agencyName!\n\n'
            '• Jabatan: $rank ($role)\n'
            '• Gaji Per Tahun: ${CurrencySettings.format(salary.toDouble())}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 14),
          const Text(
            'Pilih Durasi Kontrak Misi Antariksa:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.timer, size: 16),
                  label: const Text('1 Tahun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    _applyAstronotJob(character, agencyName, role, rank, salary, 1, onRefresh, context);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  icon: const Icon(Icons.stars, size: 16),
                  label: const Text('2 Tahun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    _applyAstronotJob(character, agencyName, role, rank, salary, 2, onRefresh, context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void _applyAstronotJob(
    Character character,
    String agencyName,
    String role,
    String rank,
    int salary,
    int contractYears,
    VoidCallback onRefresh,
    BuildContext context,
  ) {
    character.jobName = 'Astronot: $rank ($agencyName)';
    character.jobSalary = salary;
    character.contractYears = contractYears;
    character.popularity = (character.popularity + 10).clamp(0, 100);
    character.generateCoworkersIfEmpty();
    onRefresh();

    final pageContext = context;
    DialogHelper.show(
      context: pageContext,
      title: 'Kontrak Resmi Diteken! 👨‍🚀📜',
      content: Text(
        'Kamu resmi bergabung dengan $agencyName sebagai $rank!\n\n'
        '• Durasi Kontrak: $contractYears Tahun\n'
        '• Gaji Per Tahun: ${CurrencySettings.format(salary.toDouble())}\n'
        '• Popularitas: +10%',
      ),
      showCloseButton: false,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo.shade800,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Navigator.of(pageContext).popUntil((route) => route.settings.name == 'KerjaMenuScreen' || route.isFirst);
          },
          child: const Text('Oke', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
    );
  }
}
