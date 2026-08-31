// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/kerja_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';
import 'actions/rekan_kerja.dart';
import 'actions/bekerja_keras.dart';
import 'actions/murid_kerja.dart';
import 'idol_logic/idol_manager.dart';
import 'idol_logic/idol_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/daftar_negara.dart';
import 'database_nama_pekerjaan.dart';
import 'esport_logic/tim_esport.dart';
import 'esport_logic/BA/ba_esport_percentage.dart';
import 'esport_logic/proplayer/pro_player_percentage.dart';
import 'esport_logic/talent/talent_esport_percentage.dart';
import 'esport_logic/proplayer/esport_roster_page.dart';
import 'esport_logic/esport_activities_page.dart';

// ============================================================
// EXTENSION untuk menambahkan isUnivGraduated ke Character
// ============================================================
extension CharacterExtension on Character {
  bool get isUnivGraduated {
    if (educationHistory['S1'] == 'Lulus' ||
        educationHistory['S2'] == 'Lulus' ||
        educationHistory['S3'] == 'Lulus') {
      return true;
    }
    if (univMajor != null && age >= 22) return true;
    return false;
  }
}

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
  String _searchQuery = '';

  // ============================================================
  // FUNGSI UTAMA
  String? _getBaseMajor(String? fullMajor) {
    if (fullMajor == null) return null;
    return fullMajor.split(' (').first;
  }

  List<String> _getAllowedMajors(String jobTitle) {
    switch (jobTitle) {
      // STEM & TEKNIK
      case 'Junior Software Engineer':
      case 'Network Engineer':
        return ['Teknik Informatika', 'Sistem Informasi', 'Teknik Elektro'];
      case 'Data Analyst':
        return ['Teknik Informatika', 'Sistem Informasi', 'Akuntansi', 'Ekonomi Pembangunan', 'Manajemen'];
      case 'Civil Engineer':
        return ['Teknik Sipil'];
      case 'Mechanical Engineer':
        return ['Teknik Mesin'];
      case 'Electrical Engineer':
        return ['Teknik Elektro'];
      case 'Chemical Engineer':
        return ['Teknik Kimia'];
      case 'Architect':
      case 'Arsitek Senior':
        return ['Arsitektur'];

      // KESEHATAN
      case 'Dokter Umum':
      case 'Dokter Spesialis':
        return ['Kedokteran'];
      case 'Dokter Gigi':
        return ['Kedokteran Gigi'];
      case 'Apoteker':
        return ['Farmasi'];
      case 'Perawat':
        return ['Keperawatan'];
      case 'Ahli Gizi':
        return ['Gizi & Ilmu Pangan'];

      // BISNIS & EKONOMI
      case 'Manajer Keuangan':
        return ['Manajemen', 'Akuntansi', 'Perbankan & Keuangan'];
      case 'Akuntan':
        return ['Akuntansi'];
      case 'Analis Ekonomi':
        return ['Ekonomi Pembangunan', 'Akuntansi', 'Perbankan & Keuangan'];
      case 'Bankir':
        return ['Perbankan & Keuangan', 'Akuntansi', 'Manajemen'];
      case 'Marketing Specialist':
        return ['Pemasaran Digital', 'Manajemen', 'Ilmu Komunikasi'];
      case 'CEO Startup':
        return ['Manajemen', 'Akuntansi', 'Teknik Informatika', 'Sistem Informasi', 'Ekonomi Pembangunan'];
      case 'Konsultan Manajemen':
        return ['Manajemen', 'Akuntansi', 'Ekonomi Pembangunan', 'Perbankan & Keuangan'];

      // HUKUM & SOSIAL
      case 'Pengacara':
      case 'Pengacara Senior':
      case 'Jaksa':
        return ['Hukum'];
      case 'Diplomat':
        return ['Hubungan Internasional', 'Hukum'];
      case 'Jurnalis':
        return ['Ilmu Komunikasi', 'Sastra & Bahasa'];
      case 'Psikolog':
        return ['Psikologi'];
      case 'Pegawai Negeri Sipil (PNS)':
        return ['Administrasi Publik', 'Hukum', 'Hubungan Internasional', 'Ekonomi Pembangunan'];

      // PENDIDIKAN & BAHASA
      case 'Guru SD':
        return ['Pendidikan / PGSD', 'Pendidikan Agama'];
      case 'Guru SMP':
      case 'Guru SMA':
      case 'Dosen':
        return ['Pendidikan / PGSD', 'Pendidikan Agama', 'Sastra & Bahasa', 'Hukum', 'Kedokteran', 'Teknik Informatika'];
      case 'Penerjemah':
        return ['Sastra & Bahasa', 'Hubungan Internasional'];
      case 'Penulis':
        return ['Sastra & Bahasa', 'Ilmu Komunikasi', 'Pendidikan / PGSD'];

      // KREATIF & SENI
      case 'Desainer Grafis':
        return ['Desain Komunikasi Visual (DKV)'];
      case 'Desainer Mode':
        return ['Desain Mode'];
      case 'Sutradara Film':
        return ['Film & Televisi'];
      case 'Produser Musik':
        return ['Seni Musik'];
      case 'Seniman':
        return ['Desain Komunikasi Visual (DKV)', 'Desain Mode', 'Film & Televisi', 'Seni Musik'];

      // PERTANIAN & LAINNYA
      case 'Agronom':
        return ['Agroteknologi'];
      case 'Manajer Hotel':
        return ['Manajemen Perhotelan', 'Manajemen'];

      // LAINNYA
      case 'Pilot':
        return ['Teknik Elektro', 'Teknik Mesin', 'Teknik Sipil', 'Teknik Kimia', 'Teknik Informatika', 'Sistem Informasi', 'Arsitektur', 'Kedokteran'];

      // STAF IDOL
      case 'General Manager Idol':
      case 'Deputy General Manager Idol':
        return ['Manajemen', 'Akuntansi', 'Ilmu Komunikasi'];

      default:
        return [];
    }
  }

  bool _hasMatchingMajor(Character character, List<String> allowed) {
    if (!character.isUnivGraduated) return false;

    final hasLulus = character.educationHistory['S1'] == 'Lulus' ||
                     character.educationHistory['S2'] == 'Lulus' ||
                     character.educationHistory['S3'] == 'Lulus';
    if (hasLulus && character.graduatedMajors.isEmpty) {
      return true;
    }

    for (final major in character.graduatedMajors) {
      if (allowed.contains(major)) return true;
    }
    final baseMajor = _getBaseMajor(character.univMajor);
    if (baseMajor != null && allowed.contains(baseMajor)) {
      return true;
    }
    return false;
  }

  void _applyJob(Map<String, dynamic> job) {
    if (job['title'] == 'Idol (Trainee)') {
      if (widget.character.hasGraduatedIdol) {
        if (widget.character.age < 18) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Lamaran Ditolak 🚫'),
              content: Text(
                'Kamu sudah pernah melangsungkan kelulusan (graduation) sebagai JKT48 Idol.\n\n'
                'Untuk bekerja kembali di manajemen sebagai Staf, kamu harus berusia minimal 18 tahun!\n'
                '(Usiamu saat ini: ${widget.character.age} tahun)',
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
      if (widget.character.health < 80 || widget.character.discipline < 75) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lamaran Ditolak 🚫'),
            content: Text(
              'Persyaratan menjadi Idol tidak terpenuhi.\n\n'
              '• Kesehatan minimal: 80% (Kesehatanmu: ${widget.character.health}%)\n'
              '• Kedisiplinan minimal: 75% (Kedisiplinanmu: ${widget.character.discipline}%)',
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
    } else if (widget.character.intelligence < (job['minIntel'] ?? 0)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lamaran Ditolak 🚫'),
          content: Text(
            'Kecerdasanmu (${widget.character.intelligence}%) kurang mencukupi untuk posisi ${job['title']}. Minimal ${job['minIntel']}%.',
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

    if (job['category'] == 'Profesional' || job['category'] == 'Prestise') {
      final allowed = _getAllowedMajors(job['title']);
      if (!_hasMatchingMajor(widget.character, allowed)) {
        final baseMajor = _getBaseMajor(widget.character.univMajor);
        final currentMajors = widget.character.graduatedMajors.isNotEmpty 
            ? widget.character.graduatedMajors.join(", ") 
            : (baseMajor ?? "Belum lulus / Tidak ada");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gelar Tidak Sesuai 🎓'),
            content: Text(
              'Posisi ${job['title']} membutuhkan gelar sarjana yang sesuai.\n\n'
              'Gelar/Jurusan yang diterima:\n'
              '• ${allowed.join("\n• ")}\n\n'
              'Jurusanmu: $currentMajors.',
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

    if (job['title'] == 'Brand Ambassador Esport') {
      final double chance = BaEsportPercentage.getApplyChance(widget.character.gender, hasIdolHistory: widget.character.hasIdolHistory);
      if (Random().nextDouble() > chance) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lamaran Ditolak 🚫'),
            content: const Text(
              'Tim E-Sport merasa profilmu kurang cocok untuk menjadi Brand Ambassador mereka saat ini. Coba lamar pekerjaan lain!',
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

    if (job['title'] == 'Pro Player Esport') {
      final double chance = ProPlayerPercentage.getApplyChance(widget.character.gender, widget.character.specialTalent);
      if (Random().nextDouble() > chance) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lamaran Ditolak 🚫'),
            content: const Text(
              'Tim E-Sport merasa kemampuan gaming kamu belum memenuhi standar untuk masuk ke roster utama Pro Player saat ini.',
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

    if (job['title'] == 'Talent Esports') {
      final double chance = TalentEsportPercentage.getApplyChance(widget.character.gender, hasIdolHistory: widget.character.hasIdolHistory);
      if (Random().nextDouble() > chance) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Lamaran Ditolak 🚫'),
            content: const Text(
              'Tim E-Sport merasa profilmu kurang cocok untuk menjadi Talent konten mereka saat ini. Coba lamar pekerjaan lain!',
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

    final isGraduatedRedirect = (job['title'] == 'Idol (Trainee)' && widget.character.hasGraduatedIdol);
    String finalTitle = isGraduatedRedirect ? 'Staf Operasional Idol' : job['title'];
    
    String teamText = '';
    if (job['title'] == 'Brand Ambassador Esport' || job['title'] == 'Pro Player Esport' || job['title'] == 'Talent Esports') {
      final String randomTeam = EsportsTeams.list[Random().nextInt(EsportsTeams.list.length)];
      finalTitle = '${job['title']} ($randomTeam)';
      teamText = ' untuk tim $randomTeam';
    }

    final int baseSalary = isGraduatedRedirect ? 500 : job['salary'];
    final double salaryMult = getCountrySalaryMultiplier(widget.character.location);
    final int finalSalary = (baseSalary * salaryMult).round();

    setState(() {
      widget.character.setJob(finalTitle, finalSalary);
      if (finalTitle == 'Idol (Trainee)' || widget.character.isIdolStaff) {
        IdolManager.initializeTraineeTeam(widget.character);
      }
    });
    widget.onRefresh();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lamaran Diterima! 🎉💼'),
        content: Text(
          isGraduatedRedirect
              ? 'Karena kamu sudah pernah melangsungkan kelulusan (graduation) sebagai Idol, manajemen memutuskan untuk merekrutmu sebagai Staf Operasional Idol dengan gaji \$500/tahun!'
              : 'Selamat! Kamu resmi bekerja sebagai $finalTitle$teamText dengan gaji \$$finalSalary/tahun.\n\nGaji akan dibayarkan setiap kali kamu bertambah umur.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Luar Biasa!'),
          ),
        ],
      ),
    );
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
          ageVal = 22 + random.nextInt(9); // 22-30 (20%)
        } else if (roll < 0.60) {
          ageVal = 31 + random.nextInt(10); // 31-40 (40%)
        } else if (roll < 0.90) {
          ageVal = 41 + random.nextInt(10); // 41-50 (30%)
        } else {
          ageVal = 51 + random.nextInt(10); // 51-60 (10%)
        }
      } else if (job.startsWith('Talent Esports')) {
        ageVal = 13 + random.nextInt(6); // 13-18
      } else if (job.startsWith('Brand Ambassador Esport')) {
        ageVal = 15 + random.nextInt(9); // 15-23
      } else if (job.startsWith('Pro Player Esport')) {
        ageVal = 13 + random.nextInt(13); // 13-25
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

      // Tentukan seksualitas coworker secara acak (realistis)
      final double sexRoll = random.nextDouble();
      String coworkerSexuality;
      if (sexRoll < 0.80) {
        coworkerSexuality = 'Heteroseksual'; // 80% hetero
      } else if (sexRoll < 0.90) {
        coworkerSexuality = 'Homoseksual'; // 10% gay/lesbian
      } else {
        coworkerSexuality = 'Biseksual'; // 10% biseksual
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

  List<Map<String, dynamic>> _getFilteredJobsList(Character character) {
    final age = character.age;
    final gender = character.gender;

    List<Map<String, dynamic>> jobs = [];

    if (age < 18) {
      if (gender == 'Perempuan' && age >= 12) {
        jobs.add({
          'title': 'Idol (Trainee)',
          'salary': 667 + Random().nextInt(667),
          'minIntel': 0,
          'category': 'Khusus',
          'desc': 'Bergabunglah dengan grup trainee Idol baru',
          'icon': Icons.music_note,
          'color': Colors.pink,
        });
      }

      for (final job in _availableJobs) {
        if (job['title'] == 'Pro Player Esport' && age >= 13) {
          jobs.add(job);
        }
        if (job['title'] == 'Brand Ambassador Esport' && age >= 15) {
          jobs.add(job);
        }
        if (job['title'] == 'Talent Esports' && age >= 13) {
          jobs.add(job);
        }
      }
    } else {
      jobs = List.from(_availableJobs);

      jobs.addAll([
        {
          'title': 'General Manager Idol',
          'salary': 5000,
          'minIntel': 75,
          'category': 'Profesional',
          'desc': 'Memimpin operasional dan strategi grup Idol',
          'icon': Icons.manage_accounts,
          'color': Colors.purple,
        },
        {
          'title': 'Deputy General Manager Idol',
          'salary': 3500,
          'minIntel': 65,
          'category': 'Profesional',
          'desc': 'Membantu General Manager mengelola grup',
          'icon': Icons.supervisor_account,
          'color': Colors.indigo,
        },
        {
          'title': 'Staf Operasional Idol',
          'salary': 500,
          'minIntel': 30,
          'category': 'Dasar',
          'desc': 'Mengurus kebutuhan panggung dan member Idol',
          'icon': Icons.run_circle,
          'color': Colors.blueGrey,
        }
      ]);
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      jobs = jobs.where((j) {
        final title = (j['title'] as String).toLowerCase();
        final desc = (j['desc'] as String).toLowerCase();
        return title.contains(query) || desc.contains(query);
      }).toList();
    }

    return jobs;
  }

  // ============================================================
  // HELPER: MEMFORMAT DAFTAR JURUSAN MENJADI KALIMAT YANG RAPI
  // ============================================================
  String _formatAllowedMajors(List<String> majors) {
    if (majors.isEmpty) return 'Tidak ada spesifikasi jurusan';
    if (majors.length == 1) return majors.first;
    if (majors.length == 2) return '${majors[0]} atau ${majors[1]}';
    return '${majors.sublist(0, majors.length - 1).join(', ')}, atau ${majors.last}';
  }

  // ============================================================
  // UI
  // ============================================================
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

    if (hasJob) {
      _generateCoworkersIfEmpty();
    }

    String currentCategory = '';
    if (hasJob) {
      final job = _availableJobs.firstWhere(
        (j) => j['title'] == character.jobName,
        orElse: () => {},
      );
      currentCategory = job['category'] ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan & Karir 💼'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Info Status Pekerjaan
            Card(
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
                      // ========== BAR PERFORMA KERJA ==========
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.trending_up, size: 16, color: Colors.blue),
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
                              color: ((character.discipline + character.happiness) / 2) > 70
                                  ? Colors.green
                                  : ((character.discipline + character.happiness) / 2) > 40
                                      ? Colors.amber
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      // ==========================================
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
            ),
            const SizedBox(height: 24),

            if (hasJob) ...[
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
              (() {
                final String jobTitle = character.jobName ?? '';
                final bool isTeacher = jobTitle.startsWith('Guru');
                if (!isTeacher) return const SizedBox.shrink();
                
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _buildMenuTile(
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
                );
              })(),
              (() {
                final String jName = character.jobName ?? '';
                final bool isBA = jName.startsWith('Brand Ambassador Esport');
                final bool isTalent = jName.startsWith('Talent Esports');
                final bool isPro = jName.startsWith('Pro Player Esport');
                String team = '';
                if (jName.contains('(') && jName.contains(')')) {
                  team = jName.substring(jName.indexOf('(') + 1, jName.indexOf(')'));
                }

                final List<Widget> extraTiles = [];

                if (isBA || isPro || isTalent) {
                  extraTiles.add(
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
                  );
                }

                if (isTalent) {
                  extraTiles.add(
                    _buildMenuTile(
                      context: context,
                      icon: Icons.trending_up,
                      color: Colors.amber,
                      title: 'Minta Naik Menjadi BA 🌟',
                      subtitle: 'Ajukan permohonan promosi menjadi Brand Ambassador',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Ajukan Promosi BA 🌟'),
                            content: const Text('Apakah kamu yakin ingin mengajukan promosi dari Talent menjadi Brand Ambassador Esport?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  final int ageVal = character.age;
                                  double chance = 0.20;
                                  if (ageVal >= 13 && ageVal <= 16) {
                                    chance = 0.30;
                                  } else if (ageVal >= 17 && ageVal <= 18) {
                                    chance = 0.40;
                                  } else if (ageVal >= 19 && ageVal <= 23) {
                                    chance = 0.60;
                                  }
                                  
                                  final bool isSuccess = Random().nextDouble() < chance;
                                  if (isSuccess) {
                                    setState(() {
                                      character.setJob('Brand Ambassador Esport ($team)', 2500);
                                    });
                                    widget.onRefresh();
                                    showDialog(
                                      context: context,
                                      builder: (c) => AlertDialog(
                                        title: const Text('Promosi Diterima! 🎉'),
                                        content: Text('Selamat! Manajemen menyetujui pengajuan promosi kamu menjadi Brand Ambassador Esport ($team) dengan gaji \$2500/tahun!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(c),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    if (character.supervisor != null) {
                                      final currentRel = int.tryParse(character.supervisor!['relationship'] ?? '50') ?? 50;
                                      character.supervisor!['relationship'] = (currentRel - 10).clamp(0, 100).toString();
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (c) => AlertDialog(
                                        title: const Text('Promosi Ditolak 🚫'),
                                        content: const Text('Manajemen menolak pengajuanmu dan merasa kinerjamu saat ini masih belum cukup untuk menjadi Brand Ambassador.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(c),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Ajukan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                if (isBA) {
                  extraTiles.add(
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
                  );
                } else if (isPro) {
                  extraTiles.add(
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
                  );
                }

                if (extraTiles.isEmpty) return const SizedBox.shrink();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: extraTiles,
                );
              }()),
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Cari Lowongan Pekerjaan...',
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
              Text(
                'Lowongan Pekerjaan Tersedia',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 12),
              (() {
                final filteredJobsList = _getFilteredJobsList(character);
                final nonDegreeJobs = filteredJobsList.where((j) => j['category'] != 'Profesional' && j['category'] != 'Prestise').toList();
                final degreeJobs = filteredJobsList.where((j) => j['category'] == 'Profesional' || j['category'] == 'Prestise').toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.green.shade900 : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDark ? Colors.green.shade700 : Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.work_outline, size: 16, color: isDark ? Colors.greenAccent : Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Pekerjaan Umum (Tidak Butuh Gelar)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.greenAccent : Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...nonDegreeJobs.map((job) => _buildJobCard(job, character)),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.indigo.shade900 : Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDark ? Colors.indigo.shade700 : Colors.indigo.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.school_outlined, size: 16, color: isDark ? Colors.indigoAccent : Colors.indigo.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Pekerjaan Profesional (Butuh Gelar Sarjana)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.indigoAccent : Colors.indigo.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...degreeJobs.map((job) => _buildJobCard(job, character)),
                  ],
                );
              }()),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // WIDGET KARTU PEKERJAAN (DENGAN DETAIL GELAR YANG JELAS)
  // ============================================================
  Widget _buildJobCard(Map<String, dynamic> job, Character character) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final meetsIntel = character.intelligence >= job['minIntel'];
    final requiresGelar = job['category'] == 'Profesional' || job['category'] == 'Prestise';
    final allowed = _getAllowedMajors(job['title']);
    final meetsGelar = requiresGelar ? _hasMatchingMajor(character, allowed) : true;
    final canApply = meetsIntel && meetsGelar;

    // Dapatkan jurusan pengguna saat ini untuk ditampilkan sebagai perbandingan
    final baseMajor = _getBaseMajor(character.univMajor);
    final currentMajors = character.graduatedMajors.isNotEmpty 
        ? character.graduatedMajors.join(", ") 
        : (baseMajor ?? "Belum lulus / Tidak ada");

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
              'Gaji: \$${(job['salary'] * getCountrySalaryMultiplier(character.location)).round()}/tahun • ${job['category']}',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
            Text(
              job['desc'],
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.grey,
              ),
            ),
            // --- LOGIKA PERSYARATAN GELAR YANG DIPERBAHARUI ---
            if (requiresGelar) ...[
              if (!character.isUnivGraduated)
                // Kasus 1: Belum lulus sama sekali
                Text(
                  '⚠️ Membutuhkan gelar Sarjana (S1) di bidang: ${_formatAllowedMajors(allowed)}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.orangeAccent : Colors.orange,
                  ),
                )
              else if (!meetsGelar)
                // Kasus 2: Sudah lulus tapi jurusan salah
                Text(
                  '⚠️ Gelar tidak sesuai. Dibutuhkan: ${_formatAllowedMajors(allowed)}.\nJurusanmu saat ini: $currentMajors.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.orangeAccent : Colors.orange,
                  ),
                ),
            ],
            // ------------------------------------------------------
          ],
        ),
        trailing: Icon(
          canApply ? Icons.arrow_forward_ios : Icons.lock,
          size: 14,
          color: canApply
              ? (isDark ? Colors.white54 : Colors.grey)
              : Colors.red,
        ),
        onTap: () {
          if (!canApply) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  !meetsIntel
                      ? 'Kecerdasan ${character.intelligence}% < ${job['minIntel']}%'
                      : (!character.isUnivGraduated
                          ? 'Butuh gelar Sarjana S1 di bidang: ${_formatAllowedMajors(allowed)}'
                          : 'Jurusan Anda tidak sesuai. Dibutuhkan: ${_formatAllowedMajors(allowed)}. Jurusanmu: $currentMajors.'),
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          _applyJob(job);
        },
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