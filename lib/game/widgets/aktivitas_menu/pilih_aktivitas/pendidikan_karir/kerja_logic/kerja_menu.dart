// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/kerja_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';
import 'actions/rekan_kerja.dart';
import 'actions/bekerja_keras.dart';
import 'actions/murid_kerja.dart';
import 'idol_logic/idol_menu.dart';
import 'database_nama_pekerjaan.dart';
import 'esport_logic/proplayer/esport_roster_page.dart';
import 'esport_logic/esport_activities_page.dart';
import 'pekerjaan_umum_menu.dart';
import 'pekerjaan_profesional_menu.dart';

class KerjaMenuScreen extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const KerjaMenuScreen({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  static final List<Map<String, dynamic>> availableJobs = JobDatabase.availableJobs;

  @override
  State<KerjaMenuScreen> createState() => _KerjaMenuScreenState();
}

class _KerjaMenuScreenState extends State<KerjaMenuScreen> {
  List<Map<String, dynamic>> get _availableJobs => KerjaMenuScreen.availableJobs;

  @override
  void initState() {
    super.initState();
    if (widget.character.jobName != null) {
      _generateCoworkersIfEmpty();
    }
  }

  void _generateCoworkersIfEmpty() {
    final random = Random();
    final String job = widget.character.jobName ?? '';
    final bool isEsport = job.startsWith('Pro Player Esport') || job.startsWith('Brand Ambassador Esport') || job.startsWith('Talent Esports');

    if (widget.character.supervisor == null) {
      String gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
      if (isEsport) {
        gender = random.nextDouble() < 0.95 ? 'Laki-laki' : 'Perempuan';
      }
      final firstList = gender == 'Laki-laki'
          ? (widget.character.maleFirstNames != null && widget.character.maleFirstNames!.isNotEmpty
              ? widget.character.maleFirstNames!
              : Character.globalMaleFirstNames)
          : (widget.character.femaleFirstNames != null && widget.character.femaleFirstNames!.isNotEmpty
              ? widget.character.femaleFirstNames!
              : Character.globalFemaleFirstNames);
      final lastList = widget.character.lastNames != null && widget.character.lastNames!.isNotEmpty
          ? widget.character.lastNames!
          : Character.globalLastNames;
      final name = '${firstList[random.nextInt(firstList.length)]} ${lastList[random.nextInt(lastList.length)]}';
      final ageVal = 30 + random.nextInt(31);
      String? subject;
      if (job.startsWith('Guru SD')) {
        subject = ['Pendidikan Agama', 'Bahasa Indonesia', 'Matematika', 'PJOK', 'Seni Budaya', 'IPA', 'IPS', 'PPKn', 'Informatika'][random.nextInt(9)];
      } else if (job.startsWith('Guru SMP')) {
        subject = ['Matematika', 'IPA', 'Bahasa Indonesia', 'Bahasa Inggris', 'Pendidikan Agama', 'PPKn', 'IPS', 'Seni Budaya', 'PJOK', 'Informatika'][random.nextInt(10)];
      } else if (job.startsWith('Guru SMA')) {
        subject = ['Matematika', 'Bahasa Indonesia', 'Bahasa Inggris', 'Fisika', 'Kimia', 'Biologi', 'Sejarah', 'Geografi', 'Sosiologi', 'Ekonomi', 'Pendidikan Agama', 'PPKn', 'PJOK', 'Seni Budaya'][random.nextInt(14)];
      }

      widget.character.supervisor = {
        'name': name,
        'gender': gender,
        'relationship': (40 + random.nextInt(21)).toString(),
        'age': ageVal.toString(),
        'isDeceased': 'false',
        'sexuality': 'Heteroseksual',
        'intelligence': (50 + random.nextInt(41)).toString(),
        if (subject != null) 'subject': subject,
      };
    }

    if (widget.character.coworkers.isNotEmpty) return;

    final bool isProPlayer = job.startsWith('Pro Player Esport');
    final bool isBAOrTalent = job.startsWith('Brand Ambassador Esport') || job.startsWith('Talent Esports');

    int count = 5 + random.nextInt(6);
    if (isProPlayer) {
      count = 3 + random.nextInt(3);
    } else if (isBAOrTalent) {
      count = 10 + random.nextInt(6);
    }

    for (int i = 0; i < count; i++) {
      String gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
      if (isBAOrTalent) {
        gender = random.nextDouble() < 0.85 ? 'Perempuan' : 'Laki-laki';
      }

      final firstList = gender == 'Laki-laki'
          ? (widget.character.maleFirstNames != null && widget.character.maleFirstNames!.isNotEmpty
              ? widget.character.maleFirstNames!
              : Character.globalMaleFirstNames)
          : (widget.character.femaleFirstNames != null && widget.character.femaleFirstNames!.isNotEmpty
              ? widget.character.femaleFirstNames!
              : Character.globalFemaleFirstNames);
      final lastList = widget.character.lastNames != null && widget.character.lastNames!.isNotEmpty
          ? widget.character.lastNames!
          : Character.globalLastNames;
      final name = '${firstList[random.nextInt(firstList.length)]} ${lastList[random.nextInt(lastList.length)]}';
      int ageVal = 20 + random.nextInt(41);
      if (job.startsWith('Guru')) {
        final double roll = random.nextDouble();
        if (roll < 0.20) {
          ageVal = 22 + random.nextInt(9);
        } else if (roll < 0.60) {
          ageVal = 31 + random.nextInt(10);
        } else if (roll < 0.90) {
          ageVal = 41 + random.nextInt(10);
        } else {
          ageVal = 51 + random.nextInt(10);
        }
      } else if (job.startsWith('Talent Esports')) {
        ageVal = 13 + random.nextInt(6);
      } else if (job.startsWith('Brand Ambassador Esport')) {
        ageVal = 15 + random.nextInt(9);
      } else if (job.startsWith('Pro Player Esport')) {
        ageVal = 13 + random.nextInt(13);
      }
      String coworkerRole = isProPlayer 
          ? 'Pro Player' 
          : (job.startsWith('Brand Ambassador Esport') ? 'Brand Ambassador' : 'Talent Esports');
      String? subject;
      if (job.startsWith('Guru SD')) {
        coworkerRole = 'Guru';
        subject = ['Pendidikan Agama', 'Bahasa Indonesia', 'Matematika', 'PJOK', 'Seni Budaya', 'IPA', 'IPS', 'PPKn', 'Informatika'][random.nextInt(9)];
      } else if (job.startsWith('Guru SMP')) {
        coworkerRole = 'Guru';
        subject = ['Matematika', 'IPA', 'Bahasa Indonesia', 'Bahasa Inggris', 'Pendidikan Agama', 'PPKn', 'IPS', 'Seni Budaya', 'PJOK', 'Informatika'][random.nextInt(10)];
      } else if (job.startsWith('Guru SMA')) {
        coworkerRole = 'Guru';
        subject = ['Matematika', 'Bahasa Indonesia', 'Bahasa Inggris', 'Fisika', 'Kimia', 'Biologi', 'Sejarah', 'Geografi', 'Sosiologi', 'Ekonomi', 'Pendidikan Agama', 'PPKn', 'PJOK', 'Seni Budaya'][random.nextInt(14)];
      }

      final double sexRoll = random.nextDouble();
      String coworkerSexuality;
      if (sexRoll < 0.80) {
        coworkerSexuality = 'Heteroseksual';
      } else if (sexRoll < 0.90) {
        coworkerSexuality = 'Homoseksual';
      } else {
        coworkerSexuality = 'Biseksual';
      }

      widget.character.coworkers.add({
        'name': name,
        'gender': gender,
        'relationship': (40 + random.nextInt(21)).toString(),
        'age': ageVal.toString(),
        'isDeceased': 'false',
        'sexuality': coworkerSexuality,
        'intelligence': (30 + random.nextInt(61)).toString(),
        'role': coworkerRole,
        if (subject != null) 'subject': subject,
      });
    }
  }

  void _resign() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resign Pekerjaan'),
        content: Text('Apakah kamu yakin ingin keluar dari pekerjaanmu sebagai ${widget.character.jobName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                widget.character.resignJob();
              });
              widget.onRefresh();
            },
            child: const Text('Ya, Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;

    if (character.isIdolRelated) {
      return IdolMenuScreen(
        character: character,
        onRefresh: () {
          if (mounted) setState(() {});
          widget.onRefresh();
        },
      );
    }
    final hasJob = character.jobName != null;

    String currentCategory = '';
    if (hasJob) {
      final job = _availableJobs.firstWhere(
        (j) => j['title'] == character.jobName,
        orElse: () => {},
      );
      currentCategory = job['category'] ?? '';
    }

    final Widget headerCard = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: hasJob ? Colors.green.shade50 : Colors.grey.shade100,
              child: Icon(
                hasJob ? Icons.badge : Icons.work_off,
                size: 32,
                color: hasJob ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hasJob ? 'Pekerjaan Saat Ini:' : 'Belum Memiliki Pekerjaan',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            if (hasJob) ...[
              const SizedBox(height: 4),
              Text(
                character.jobName!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Gaji: \$${character.jobSalary}/tahun',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.trending_up, size: 16, color: Colors.blue),
                  const SizedBox(width: 6),
                  Text(
                    'Performa Kerja: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ((character.discipline + character.happiness) / 2) / 100,
                        minHeight: 8,
                        backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ((character.discipline + character.happiness) / 2) > 70
                              ? Colors.green
                              : ((character.discipline + character.happiness) / 2) > 40
                                  ? Colors.amber
                                  : Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${((character.discipline + character.happiness) / 2).round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
              if (currentCategory == 'Profesional' || currentCategory == 'Prestise') ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Karir Profesional ⭐',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _resign,
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Resign / Keluar Kerja'),
              ),
            ],
          ],
        ),
      ),
    );

    if (hasJob) {
      final String jobTitle = character.jobName ?? '';
      final bool isTeacher = jobTitle.startsWith('Guru');
      final bool isBA = jobTitle.startsWith('Brand Ambassador Esport');
      final bool isTalent = jobTitle.startsWith('Talent Esports');
      final bool isPro = jobTitle.startsWith('Pro Player Esport');
      String team = '';
      if (jobTitle.contains('(') && jobTitle.contains(')')) {
        team = jobTitle.substring(jobTitle.indexOf('(') + 1, jobTitle.indexOf(')'));
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Pekerjaan & Karir 💼'),
          backgroundColor: Colors.green.shade700,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            headerCard,
            const SizedBox(height: 24),
            Text(
              'Aktivitas Pekerjaan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12),
            _buildMenuTile(
              context: context,
              icon: Icons.trending_up,
              color: Colors.green,
              title: 'Bekerja Lebih Giat',
              subtitle: 'Meningkatkan performa kerja dan hubungan dengan atasan',
              page: BekerjaKerasActionPage(
                character: character,
                onRefresh: () {
                  if (mounted) setState(() {});
                  widget.onRefresh();
                },
              ),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.group,
              color: Colors.orange,
              title: 'Rekan Kerja',
              subtitle: 'Berinteraksi dengan rekan sekerja',
              page: RekanKerjaPage(
                character: character,
                onRefresh: () {
                  if (mounted) setState(() {});
                  widget.onRefresh();
                },
              ),
            ),
            if (isTeacher)
              _buildMenuTile(
                context: context,
                icon: Icons.school,
                color: Colors.indigo,
                title: 'Murid & Wali Kelas',
                subtitle: 'Berinteraksi dengan murid didik dan wali kelas',
                page: MuridKerjaPage(
                  character: character,
                  onRefresh: () {
                    if (mounted) setState(() {});
                    widget.onRefresh();
                  },
                ),
              ),
            if (isBA || isPro || isTalent)
              _buildMenuTile(
                context: context,
                icon: Icons.sports_esports,
                color: Colors.indigo,
                title: 'Aktivitas Esports 🎮',
                subtitle: 'Latihan, turnamen, sponsor, dan interaksi karir esport',
                page: EsportActivitiesPage(
                  character: character,
                  onRefresh: () {
                    if (mounted) setState(() {});
                    widget.onRefresh();
                  },
                ),
              ),
            if (isBA)
              _buildMenuTile(
                context: context,
                icon: Icons.view_carousel,
                color: Colors.blue,
                title: 'Lihat Divisi',
                subtitle: 'Melihat divisi & roster pro player tim E-Sport',
                page: EsportRosterPage(
                  teamName: team,
                  isViewingBA: false,
                  character: character,
                  onRefresh: () {
                    if (mounted) setState(() {});
                    widget.onRefresh();
                  },
                ),
              ),
            if (isPro)
              _buildMenuTile(
                context: context,
                icon: Icons.star,
                color: Colors.pinkAccent,
                title: 'Lihat Brand Ambassador',
                subtitle: 'Melihat daftar Brand Ambassador tim E-Sport',
                page: EsportRosterPage(
                  teamName: team,
                  isViewingBA: true,
                  character: character,
                  onRefresh: () {
                    if (mounted) setState(() {});
                    widget.onRefresh();
                  },
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan & Karir 💼'),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          headerCard,
          const SizedBox(height: 24),
          Text(
            'Lowongan Pekerjaan Tersedia',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuTile(
            context: context,
            icon: Icons.work_outline,
            color: Colors.green,
            title: 'Pekerjaan Umum (Tidak Butuh Gelar)',
            subtitle: 'Lowongan kerja dasar tanpa syarat lulusan universitas',
            page: PekerjaanUmumMenuScreen(
              character: character,
              onRefresh: () {
                if (mounted) setState(() {});
                widget.onRefresh();
              },
            ),
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.school_outlined,
            color: Colors.indigo,
            title: 'Pekerjaan Profesional (Butuh Gelar Sarjana)',
            subtitle: 'Lowongan posisi spesialis & eksekutif lulusan universitas',
            page: PekerjaanProfesionalMenuScreen(
              character: character,
              onRefresh: () {
                if (mounted) setState(() {});
                widget.onRefresh();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    Widget? page,
    VoidCallback? onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      color: isDark ? Colors.grey.shade800 : null,
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.grey,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isDark ? Colors.white54 : Colors.grey,
        ),
        onTap: () {
          if (page != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => page));
          } else if (onTap != null) {
            onTap();
          }
        },
      ),
    );
  }
}