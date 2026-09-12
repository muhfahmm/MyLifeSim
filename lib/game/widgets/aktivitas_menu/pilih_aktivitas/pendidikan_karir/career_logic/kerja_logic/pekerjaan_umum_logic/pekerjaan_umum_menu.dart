// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/pekerjaan_umum_logic/pekerjaan_umum_menu.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'dart:math';
import '../database_nama_pekerjaan.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/daftar_negara.dart';
import '../special_carrier/idol_logic/idol_manager.dart';
import '../special_carrier/idol_logic/syarat_ketentuan_idol_modal.dart';

class PekerjaanUmumMenuScreen extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PekerjaanUmumMenuScreen({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PekerjaanUmumMenuScreen> createState() => _PekerjaanUmumMenuScreenState();
}

class _PekerjaanUmumMenuScreenState extends State<PekerjaanUmumMenuScreen> {
  List<Map<String, dynamic>> _jobs = [];
  String _searchQuery = '';
  double _salaryMultiplier = 1.0;

  @override
  void initState() {
    super.initState();
    _salaryMultiplier = getCountrySalaryMultiplier(widget.character.location);
    _updateJobList();
  }

  void _updateJobList() {
    final age = widget.character.age;
    final gender = widget.character.gender;
    List<Map<String, dynamic>> allJobs = JobDatabase.availableJobs
        .where((j) => j['category'] != 'Profesional' && j['category'] != 'Prestise')
        .toList();

    if (gender == 'Perempuan' && age >= 12 && age < 18) {
      allJobs.add({
        'title': 'Idol (Trainee)',
        'salary': 667 + Random().nextInt(667),
        'minIntel': 0,
        'category': 'Khusus',
        'desc': 'Bergabunglah dengan grup trainee Idol baru',
        'icon': Icons.music_note,
        'color': Colors.pink,
      });
    }

    if (age >= 18) {
      allJobs.add({
        'title': 'Staf Operasional Idol',
        'salary': 500,
        'minIntel': 30,
        'category': 'Dasar',
        'desc': 'Mengurus kebutuhan panggung dan member Idol',
        'icon': Icons.run_circle,
        'color': Colors.blueGrey,
      });
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      allJobs = allJobs.where((j) {
        final title = (j['title'] as String).toLowerCase();
        final desc = (j['desc'] as String).toLowerCase();
        return title.contains(query) || desc.contains(query);
      }).toList();
    }

    setState(() {
      _jobs = allJobs;
    });
  }

  void _applyJob(Map<String, dynamic> job) {
    final character = widget.character;

    if (job['title'] == 'Idol (Trainee)' || job['title'] == 'Staf Operasional Idol') {
      SyaratKetentuanIdolModal.show(
        context: context,
        character: character,
        onRefresh: widget.onRefresh,
      );
      return;
    }

    if (character.intelligence < (job['minIntel'] ?? 0)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lamaran Ditolak 🚫'),
          content: Text(
            'Kecerdasanmu (${character.intelligence}%) kurang mencukupi untuk posisi ${job['title']}. Minimal ${job['minIntel']}%.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final isGraduatedRedirect = (job['title'] == 'Idol (Trainee)' && character.hasGraduatedIdol);
    String finalTitle = isGraduatedRedirect ? 'Staf Operasional Idol' : job['title'];
    String teamText = '';

    final int baseSalary = isGraduatedRedirect ? 500 : job['salary'];
    final double salaryMult = getCountrySalaryMultiplier(character.location);
    final int finalSalary = (baseSalary * salaryMult).round();

    setState(() {
      character.setJob(finalTitle, finalSalary);
      if (finalTitle == 'Idol (Trainee)' || character.isIdolStaff) {
        IdolManager.initializeTraineeTeam(character);
      }
    });
    widget.onRefresh();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lamaran Diterima! 🎉💼'),
        content: Text(
          isGraduatedRedirect
              ? 'Karena kamu sudah pernah melangsungkan kelulusan sebagai Idol, manajemen merekrutmu sebagai Staf Operasional Idol dengan gaji ${CurrencySettings.format(500)}/tahun!'
              : 'Selamat! Kamu resmi bekerja sebagai $finalTitle$teamText dengan gaji ${CurrencySettings.format(finalSalary)}/tahun.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // kembali ke menu utama pekerjaan
            },
            child: const Text('Luar Biasa!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan Umum 💼'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) {
                _searchQuery = val;
                _updateJobList();
              },
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Cari Pekerjaan Umum...',
                hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                filled: true,
                fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _jobs.length,
              itemBuilder: (context, index) {
                final job = _jobs[index];
                final meetsIntel = character.intelligence >= (job['minIntel'] ?? 0);

                final bool isMobile = MediaQuery.of(context).size.width < 600;

                return Card(
                  elevation: 0,
                  margin: EdgeInsets.only(bottom: isMobile ? 6 : 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  color: isDark ? Colors.grey.shade800 : null,
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 10 : 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: isMobile ? 18 : 20,
                          backgroundColor: job['color'].withValues(alpha: 0.1),
                          child: Icon(job['icon'], color: job['color'], size: isMobile ? 20 : 24),
                        ),
                        SizedBox(width: isMobile ? 10 : 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['title'],
                                style: TextStyle(
                                  fontSize: isMobile ? 13 : 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Gaji: ${CurrencySettings.format((job['salary'] * _salaryMultiplier).round())}/tahun • ${job['category']}',
                                style: TextStyle(
                                  fontSize: isMobile ? 11 : 12,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                              Text(
                                job['desc'],
                                style: TextStyle(
                                  fontSize: isMobile ? 10.5 : 11.5,
                                  color: isDark ? Colors.white60 : Colors.grey,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: meetsIntel ? Colors.green.shade600 : Colors.grey.shade700,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 10 : 14,
                              vertical: isMobile ? 6 : 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            if (!meetsIntel) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Kecerdasan ${character.intelligence}% < ${job['minIntel']}%'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            _applyJob(job);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!meetsIntel) ...[
                                Icon(Icons.lock, size: isMobile ? 12 : 14, color: Colors.white70),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                meetsIntel ? 'Lamar' : 'Terkunci',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 11 : 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
