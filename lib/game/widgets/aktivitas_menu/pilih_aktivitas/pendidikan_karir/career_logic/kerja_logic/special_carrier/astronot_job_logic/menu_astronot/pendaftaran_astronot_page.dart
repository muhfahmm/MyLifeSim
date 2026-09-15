// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/astronot_job_logic/menu_astronot/pendaftaran_astronot_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class PendaftaranAstronotPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PendaftaranAstronotPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PendaftaranAstronotPage> createState() => _PendaftaranAstronotPageState();
}

class _PendaftaranAstronotPageState extends State<PendaftaranAstronotPage> {
  final List<Map<String, dynamic>> _spaceAgencies = [
    {
      'agencyName': 'NASA (Badan Antariksa AS) 🇺🇸',
      'role': 'Astronot Trainee',
      'rank': 'Astronot Junior',
      'minHealth': 80,
      'minIntel': 75,
      'salary': 350000,
      'color': Colors.indigo,
      'icon': Icons.rocket_launch,
      'desc': 'Lembaga penerbangan antariksa terkemuka dunia dengan misi ekspedisi antar-planet.',
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
      'desc': 'Konsorsium antariksa Uni Eropa dengan fokus pada riset laboratorium stasiun luar angkasa.',
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
      'desc': 'Fokus pada riset robotik antariksa canggih dan eksperimen kargo ruang hampa.',
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
      'desc': 'Badan penerbangan & keantariksaan nasional untuk penguasaan roket & satelit.',
    },
  ];

  void _applyAstronotJob(Map<String, dynamic> agency) {
    widget.character.jobName = 'Astronot: ${agency['rank']} (${agency['agencyName']})';
    widget.character.jobSalary = agency['salary'] as int;
    widget.character.contractYears = null;
    widget.character.popularity = (widget.character.popularity + 10).clamp(0, 100);
    widget.character.generateCoworkersIfEmpty();
    setState(() {});
    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Diterima Sebagai Astronot! 👨‍🚀🌟',
      content: Text(
        'Selamat! Kamu resmi bergabung dengan ${agency['agencyName']} sebagai ${agency['rank']}!\n\n'
        '• Jabatan: ${agency['rank']}\n'
        '• Gaji Per Tahun: ${CurrencySettings.format((agency['salary'] as int).toDouble())}\n'
        '• Popularitas Dunia: +10%',
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
            Navigator.of(context, rootNavigator: true).pop(); // Tutup modal notification
            Navigator.of(context).pop(); // Kembali ke halaman utama AstronotMenuPage
          },
          child: const Text('Oke', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekrutmen Astronot 🚀'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // HEADER KARTU KUALIFIKASI
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.badge_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kualifikasi Diri Karakter', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        const SizedBox(height: 2),
                        Text(
                          'Kesehatan: ${widget.character.health}% ❤️ • Kecerdasan: ${widget.character.intelligence}% 🧠',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.indigo.shade900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text(
              'Lembaga Antariksa Terbuka 🌍',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87),
            ),
          ),

          ..._spaceAgencies.map((agency) {
            final int minH = agency['minHealth'] as int;
            final int minI = agency['minIntel'] as int;
            final bool isEligible = widget.character.health >= minH && widget.character.intelligence >= minI;

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
              ),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: agency['color'] as Color,
                          child: Icon(agency['icon'] as IconData, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                agency['agencyName'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                agency['role'] as String,
                                style: TextStyle(fontSize: 12, color: agency['color'] as Color, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      agency['desc'] as String,
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gaji: ${CurrencySettings.format((agency['salary'] as int).toDouble())} /thn',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                          Text(
                            'Min: ${minH}% HP • ${minI}% IQ',
                            style: TextStyle(fontSize: 10, color: isEligible ? Colors.blue : Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEligible ? (agency['color'] as Color) : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.send_rounded, size: 16),
                        label: const Text('Kirim Lamaran Rekrutmen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        onPressed: () {
                          if (!isEligible) {
                            DialogHelper.show(
                              context: context,
                              title: 'Syarat Tidak Terpenuhi ⚠️',
                              content: Text(
                                'Kamu belum memenuhi kualifikasi rekrutmen ${agency['agencyName']}.\n\n'
                                '• Kesehatanmu: ${widget.character.health}% (Min. $minH%)\n'
                                '• Kecerdasanmu: ${widget.character.intelligence}% (Min. $minI%)',
                              ),
                            );
                            return;
                          }

                          final r = Random();
                          final bool isPassed = r.nextInt(100) < (widget.character.health + widget.character.intelligence) ~/ 2;

                          if (isPassed) {
                            _applyAstronotJob(agency);
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
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
