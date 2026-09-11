// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/kerja_menu.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'dart:math';
import 'actions/rekan_kerja.dart';
import 'actions/bekerja_keras.dart';
import 'actions/murid_kerja.dart';
import 'idol_logic/idol_menu.dart';
import 'database_nama_pekerjaan.dart';
import 'esport_logic/proplayer/esport_roster_page.dart';
import 'esport_logic/esport_activities_page.dart';
import 'pekerjaan_umum_logic/pekerjaan_umum_menu.dart';
import 'pekerjaan_profesional_logic/pekerjaan_profesional_menu.dart';
import 'special_carrier/pekerjaan_spesial_menu.dart';
import 'special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/sepakbola_logic/logika_usia_rekan_tim.dart';
import 'special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/atlit_activities_page.dart';
import 'special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/balap/atlit_activities_page.dart';
import 'special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/basket/atlit_activities_page.dart';
import 'special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/bulutangkis/atlit_activities_page.dart';
import 'special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/catur/atlit_activities_page.dart';
import 'special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/atlit_activities_page.dart';
import 'special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/tenis/atlit_activities_page.dart';
import 'special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/tinju_mma/atlit_activities_page.dart';

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

  Widget _buildAthleteActivitiesPage(Character character) {
    void refresh() {
      if (mounted) setState(() {});
      widget.onRefresh();
    }

    final String job = character.jobName ?? '';
    if (job.contains('Sepakbola') || job.contains('Striker') || job.contains('Gelandang') || job.contains('Bek') || job.contains('Kiper')) {
      return AtlitActivitiesPage(character: character, onRefresh: refresh);
    } else if (job.contains('Pebalap')) {
      return AtlitBalapActivitiesPage(character: character, onRefresh: refresh);
    } else if (job.contains('Basket') || job.contains('Point Guard') || job.contains('Shooting Guard') || job.contains('Center')) {
      return AtlitBasketActivitiesPage(character: character, onRefresh: refresh);
    } else if (job.contains('Bulutangkis')) {
      return AtlitBulutangkisActivitiesPage(character: character, onRefresh: refresh);
    } else if (job.contains('Catur')) {
      return AtlitCaturActivitiesPage(character: character, onRefresh: refresh);
    } else if (job.contains('Renang')) {
      return AtlitRenangActivitiesPage(character: character, onRefresh: refresh);
    } else if (job.contains('Petenis')) {
      return AtlitTenisActivitiesPage(character: character, onRefresh: refresh);
    } else if (job.contains('MMA') || job.contains('Petinju')) {
      return AtlitTinjuMmaActivitiesPage(character: character, onRefresh: refresh);
    }
    return AtlitActivitiesPage(character: character, onRefresh: refresh);
  }

  Future<void> _generateCoworkersIfEmpty() async {
    if (widget.character.maleFirstNames == null || widget.character.maleFirstNames!.isEmpty) {
      await widget.character.updateLocationNamesData();
    }
    final random = Random();
    final String job = widget.character.jobName ?? '';
    final bool isEsport = job.startsWith('Pro Player Esport') || job.startsWith('Brand Ambassador Esport') || job.startsWith('Talent Esports');

    final String currentLoc = widget.character.location.isNotEmpty ? widget.character.location : (widget.character.birthCountry ?? 'Indonesia');
    final String birthLoc = widget.character.birthCountry ?? 'Indonesia';
    final bool isAbroad = currentLoc.toLowerCase() != birthLoc.toLowerCase();

    String getRandomName(String gender) {
      final bool useLocalName = random.nextDouble() < (isAbroad ? 0.85 : 0.85);
      List<String> firstList = [];
      List<String> lastList = [];
      if (useLocalName) {
        firstList = gender == 'Laki-laki'
            ? (widget.character.maleFirstNames != null && widget.character.maleFirstNames!.isNotEmpty
                ? widget.character.maleFirstNames!
                : Character.globalMaleFirstNames)
            : (widget.character.femaleFirstNames != null && widget.character.femaleFirstNames!.isNotEmpty
                ? widget.character.femaleFirstNames!
                : Character.globalFemaleFirstNames);
        lastList = widget.character.lastNames != null && widget.character.lastNames!.isNotEmpty
            ? widget.character.lastNames!
            : Character.globalLastNames;
      } else {
        firstList = gender == 'Laki-laki' ? Character.globalMaleFirstNames : Character.globalFemaleFirstNames;
        lastList = Character.globalLastNames;
      }
      if (firstList.isEmpty) {
        firstList = gender == 'Laki-laki'
            ? (widget.character.maleFirstNames ?? Character.globalMaleFirstNames)
            : (widget.character.femaleFirstNames ?? Character.globalFemaleFirstNames);
      }
      if (lastList.isEmpty) {
        lastList = widget.character.lastNames ?? Character.globalLastNames;
      }
      final f = firstList.isNotEmpty ? firstList[random.nextInt(firstList.length)] : (gender == 'Laki-laki' ? 'Alex' : 'Emma');
      final l = lastList.isNotEmpty ? lastList[random.nextInt(lastList.length)] : 'Smith';
      return '$f $l';
    }

    if (widget.character.supervisor == null) {
      String gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
      if (isEsport) {
        gender = random.nextDouble() < 0.95 ? 'Laki-laki' : 'Perempuan';
      }
      final name = getRandomName(gender);
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

    final bool isAthlete = job.contains('Sepakbola') ||
        job.contains('Basket') ||
        job.contains('Pemain') ||
        job.contains('Striker') ||
        job.contains('Gelandang') ||
        job.contains('Bek') ||
        job.contains('Kiper') ||
        job.contains('Point Guard') ||
        job.contains('Shooting Guard') ||
        job.contains('Center') ||
        job.contains('Pebalap') ||
        job.contains('Petenis') ||
        job.contains('MMA') ||
        job.contains('Petinju') ||
        job.contains('Renang');

    if (isAthlete) {
      // Tentukan jumlah pemain utama & cadangan
      final bool isSoccer = job.contains('Sepakbola') || job.contains('Striker') || job.contains('Gelandang') || job.contains('Bek') || job.contains('Kiper');
      final bool isBasketball = job.contains('Guard') || job.contains('Center');

      final int mainTeamCount = isSoccer ? 10 : (isBasketball ? 4 : 4);
      final int subTeamCount = isSoccer ? (7 + random.nextInt(4)) : (isBasketball ? (5 + random.nextInt(4)) : (3 + random.nextInt(3)));
      final String teamGender = widget.character.gender; // Gender disesuaikan dengan tim/kategori user
      final int userAge = widget.character.age;
      final String userTeamCategory = LogikaUsiaRekanTim.getKategoriTimBerdasarkanUsia(
        usia: userAge,
        rand: random,
      );

      // Generate Tim Utama / Tim Kelompok Usia User
      for (int i = 0; i < mainTeamCount; i++) {
        final name = getRandomName(teamGender);
        final ageVal = LogikaUsiaRekanTim.generateUsiaRekanTim(userAge: userAge, rand: random);
        final double sexRoll = random.nextDouble();
        final String coworkerSexuality = sexRoll < 0.80 ? 'Heteroseksual' : (sexRoll < 0.90 ? 'Homoseksual' : 'Biseksual');

        widget.character.coworkers.add({
          'name': name,
          'gender': teamGender,
          'relationship': (45 + random.nextInt(21)).toString(),
          'age': ageVal.toString(),
          'isDeceased': 'false',
          'sexuality': coworkerSexuality,
          'intelligence': (40 + random.nextInt(51)).toString(),
          'teamCategory': userTeamCategory,
          'role': 'Pemain Utama',
        });
      }

      // Generate Tim Cadangan
      for (int i = 0; i < subTeamCount; i++) {
        final name = getRandomName(teamGender);
        final ageVal = LogikaUsiaRekanTim.generateUsiaRekanTim(userAge: userAge, rand: random);
        final double sexRoll = random.nextDouble();
        final String coworkerSexuality = sexRoll < 0.80 ? 'Heteroseksual' : (sexRoll < 0.90 ? 'Homoseksual' : 'Biseksual');

        widget.character.coworkers.add({
          'name': name,
          'gender': teamGender,
          'relationship': (35 + random.nextInt(21)).toString(),
          'age': ageVal.toString(),
          'isDeceased': 'false',
          'sexuality': coworkerSexuality,
          'intelligence': (35 + random.nextInt(51)).toString(),
          'teamCategory': '$userTeamCategory (Cadangan)',
          'role': 'Pemain Cadangan',
        });
      }
      return;
    }

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

      final name = getRandomName(gender);
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

    final String jobTitle = character.jobName ?? '';
    final bool isAthlete = jobTitle.contains('Sepakbola') ||
        jobTitle.contains('Basket') ||
        jobTitle.contains('Pemain') ||
        jobTitle.contains('Striker') ||
        jobTitle.contains('Gelandang') ||
        jobTitle.contains('Bek') ||
        jobTitle.contains('Kiper') ||
        jobTitle.contains('Point Guard') ||
        jobTitle.contains('Shooting Guard') ||
        jobTitle.contains('Center') ||
        jobTitle.contains('Pebalap') ||
        jobTitle.contains('Petenis') ||
        jobTitle.contains('MMA') ||
        jobTitle.contains('Petinju') ||
        jobTitle.contains('Renang');

    String positionName = jobTitle;
    String teamBaseName = '';
    if (jobTitle.contains(' - ')) {
      final parts = jobTitle.split(' - ');
      positionName = parts[0].trim();
      teamBaseName = parts[1].trim();
    }

    String formattedTeamName = teamBaseName;
    if (isAthlete && teamBaseName.isNotEmpty) {
      final String ageTeamCategory = LogikaUsiaRekanTim.getKategoriTimBerdasarkanUsia(usia: character.age);
      if (ageTeamCategory != 'Tim Utama') {
        final String uSuffix = ageTeamCategory.replaceAll('Tim ', '');
        formattedTeamName = '$teamBaseName $uSuffix';
      }
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
              const SizedBox(height: 6),
              if (isAthlete && teamBaseName.isNotEmpty) ...[
                Text(
                  formattedTeamName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Posisi: $positionName',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tim: $formattedTeamName',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gaji: ${CurrencySettings.format(character.jobSalary!)}/tahun',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.greenAccent : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  character.jobName!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Gaji: ${CurrencySettings.format(character.jobSalary!)}/tahun',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
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

      final bool isAthlete = jobTitle.contains('Sepakbola') ||
          jobTitle.contains('Basket') ||
          jobTitle.contains('Pemain') ||
          jobTitle.contains('Striker') ||
          jobTitle.contains('Gelandang') ||
          jobTitle.contains('Bek') ||
          jobTitle.contains('Kiper') ||
          jobTitle.contains('Point Guard') ||
          jobTitle.contains('Shooting Guard') ||
          jobTitle.contains('Center') ||
          jobTitle.contains('Pebalap') ||
          jobTitle.contains('Petenis') ||
          jobTitle.contains('MMA') ||
          jobTitle.contains('Petinju') ||
          jobTitle.contains('Renang');

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
            if (isAthlete)
              _buildMenuTile(
                context: context,
                icon: Icons.sports_soccer,
                color: Colors.green.shade700,
                title: 'Aktivitas Karir Atlet ⚽🏆',
                subtitle: 'Latihan, Pertandingan, Kontrak, Media & Hubungan Tim',
                page: _buildAthleteActivitiesPage(character),
              ),
            if (!isAthlete)
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
              title: isAthlete ? 'Rekan Tim' : 'Rekan Kerja',
              subtitle: isAthlete ? 'Berinteraksi dengan rekan tim & pelatih' : 'Berinteraksi dengan rekan sekerja',
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
            minAge: 18,
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
            minAge: 18,
            page: PekerjaanProfesionalMenuScreen(
              character: character,
              onRefresh: () {
                if (mounted) setState(() {});
                widget.onRefresh();
              },
            ),
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.star_outline,
            color: Colors.amber.shade800,
            title: 'Karir Spesial (Militer & Politik) 🌟',
            subtitle: 'Pilihan karir khusus militer dan jalur kepemimpinan politik',
            minAge: 6,
            page: PekerjaanSpesialMenuScreen(
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
    int minAge = 0,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int currentAge = widget.character.age;
    final bool isUnlocked = currentAge >= minAge;
    final Color effectiveColor = isUnlocked ? color : Colors.grey;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      color: isUnlocked
          ? (isDark ? Colors.grey.shade800 : null)
          : (isDark ? Colors.grey.shade900.withValues(alpha: 0.5) : Colors.grey.shade100),
      child: ListTile(
        leading: Icon(icon, color: effectiveColor, size: 28),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? (isDark ? Colors.white : Colors.black87) : Colors.grey.shade600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isUnlocked ? (isDark ? Colors.white60 : Colors.grey) : Colors.grey.shade500,
          ),
        ),
        trailing: Icon(
          isUnlocked ? Icons.arrow_forward_ios : Icons.lock_outline,
          size: isUnlocked ? 14 : 16,
          color: isUnlocked ? (isDark ? Colors.white54 : Colors.grey) : Colors.grey.shade500,
        ),
        onTap: () {
          if (!isUnlocked) {
            DialogHelper.show(
              context: context,
              title: 'Akses Dibatasi',
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🔒', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Kamu harus berusia minimal $minAge tahun untuk membuka lowongan pekerjaan ini.',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFFB74D)),
                    ),
                    child: Row(
                      children: [
                        const Text('⚠️', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Text(
                          'Usia saat ini: $currentAge tahun',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
            return;
          }
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