// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/pekerjaan_umum_logic/pekerjaan_umum_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';
import '../database_nama_pekerjaan.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/daftar_negara.dart';
import '../idol_logic/idol_manager.dart';
import '../esport_logic/tim_esport.dart';
import '../esport_logic/BA/ba_esport_percentage.dart';
import '../esport_logic/proplayer/pro_player_percentage.dart';
import '../esport_logic/talent/talent_esport_percentage.dart';

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
    List<Map<String, dynamic>> allJobs = [];

    if (age < 18) {
      if (gender == 'Perempuan' && age >= 12) {
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

      for (final job in JobDatabase.availableJobs) {
        if (job['category'] == 'Profesional' || job['category'] == 'Prestise') continue;

        if (job['title'] == 'Pro Player Esport' && age >= 13) {
          allJobs.add(job);
        }
        if (job['title'] == 'Brand Ambassador Esport' && age >= 15) {
          allJobs.add(job);
        }
        if (job['title'] == 'Talent Esports' && age >= 13) {
          allJobs.add(job);
        }
      }
    } else {
      allJobs = JobDatabase.availableJobs
          .where((j) => j['category'] != 'Profesional' && j['category'] != 'Prestise')
          .toList();

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

    if (job['title'] == 'Idol (Trainee)') {
      if (character.hasGraduatedIdol) {
        if (character.age < 18) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Lamaran Ditolak 🚫'),
              content: Text(
                'Kamu sudah pernah melangsungkan kelulusan (graduation) sebagai JKT48 Idol.\n\n'
                'Untuk bekerja kembali di manajemen sebagai Staf, kamu harus berusia minimal 18 tahun!\n'
                '(Usiamu saat ini: ${character.age} tahun)',
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
      }
      if (character.health < 80 || character.discipline < 75) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lamaran Ditolak 🚫'),
            content: Text(
              'Persyaratan menjadi Idol tidak terpenuhi.\n\n'
              '• Kesehatan minimal: 80% (Kesehatanmu: ${character.health}%)\n'
              '• Kedisiplinan minimal: 75% (Kedisiplinanmu: ${character.discipline}%)',
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
    } else if (character.intelligence < (job['minIntel'] ?? 0)) {
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

    if (job['title'] == 'Brand Ambassador Esport') {
      final double chance = BaEsportPercentage.getApplyChance(character.gender, hasIdolHistory: character.hasIdolHistory);
      if (Random().nextDouble() > chance) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lamaran Ditolak 🚫'),
            content: const Text('Tim E-Sport merasa profilmu kurang cocok untuk menjadi Brand Ambassador mereka saat ini.'),
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
    }

    if (job['title'] == 'Pro Player Esport') {
      final double chance = ProPlayerPercentage.getApplyChance(character.gender, character.specialTalent);
      if (Random().nextDouble() > chance) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lamaran Ditolak 🚫'),
            content: const Text('Tim E-Sport merasa kemampuan gaming kamu belum memenuhi standar untuk masuk ke roster utama.'),
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
    }

    if (job['title'] == 'Talent Esports') {
      final double chance = TalentEsportPercentage.getApplyChance(character.gender, hasIdolHistory: character.hasIdolHistory);
      if (Random().nextDouble() > chance) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lamaran Ditolak 🚫'),
            content: const Text('Tim E-Sport merasa profilmu kurang cocok untuk menjadi Talent konten mereka saat ini.'),
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
    }

    final isGraduatedRedirect = (job['title'] == 'Idol (Trainee)' && character.hasGraduatedIdol);
    String finalTitle = isGraduatedRedirect ? 'Staf Operasional Idol' : job['title'];

    String teamText = '';
    if (job['title'] == 'Brand Ambassador Esport' || job['title'] == 'Pro Player Esport' || job['title'] == 'Talent Esports') {
      final String randomTeam = EsportsTeams.list[Random().nextInt(EsportsTeams.list.length)];
      finalTitle = '${job['title']} ($randomTeam)';
      teamText = ' untuk tim $randomTeam';
    }

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
              ? 'Karena kamu sudah pernah melangsungkan kelulusan sebagai Idol, manajemen merekrutmu sebagai Staf Operasional Idol dengan gaji \$500/tahun!'
              : 'Selamat! Kamu resmi bekerja sebagai $finalTitle$teamText dengan gaji \$$finalSalary/tahun.',
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

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                  ),
                  color: isDark ? Colors.grey.shade800 : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: job['color'].withValues(alpha: 0.1),
                      child: Icon(job['icon'], color: job['color']),
                    ),
                    title: Text(
                      job['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gaji: \$${(job['salary'] * _salaryMultiplier).round()}/tahun • ${job['category']}',
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                        ),
                        Text(
                          job['desc'],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: meetsIntel ? Colors.green.shade600 : Colors.grey.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                            const Icon(Icons.lock, size: 14, color: Colors.white70),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            meetsIntel ? 'Lamar' : 'Terkunci',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
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
