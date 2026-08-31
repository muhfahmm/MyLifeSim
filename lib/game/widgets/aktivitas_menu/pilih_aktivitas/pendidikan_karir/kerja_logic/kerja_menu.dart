// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/kerja_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';
import 'actions/rekan_kerja.dart';
import 'actions/bekerja_keras.dart';
import 'idol_logic/idol_manager.dart';
import 'idol_logic/idol_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/daftar_negara.dart';
import 'database_nama_pekerjaan.dart';
import 'esport_logic/tim_esport.dart';
import 'esport_logic/ba_esport_percentage.dart';
import 'esport_logic/pro_player_percentage.dart';
import 'esport_logic/talent_esport_percentage.dart';
import 'esport_logic/esport_roster_page.dart';
import 'esport_logic/esport_activities_page.dart';
// ============================================================
// EXTENSION untuk menambahkan isUnivGraduated ke Character
// ============================================================
extension CharacterExtension on Character {
  bool get isUnivGraduated {
    // Cek riwayat kelulusan pendidikan tinggi
    if (educationHistory['S1'] == 'Lulus' ||
        educationHistory['S2'] == 'Lulus' ||
        educationHistory['S3'] == 'Lulus') {
      return true;
    }
    // Fallback jika sedang kuliah dan sudah mencapai umur kelulusan (>= 22)
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

  // ============================================================
  // DAFTAR PEKERJAAN (LENGKAP DENGAN KATEGORI & SYARAT)
  // ============================================================
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
        return ['Pendidikan / PGSD', 'Pendidikan Agama Islam'];
      case 'Guru SMP':
      case 'Guru SMA':
      case 'Dosen':
        return ['Pendidikan / PGSD', 'Pendidikan Agama Islam', 'Sastra & Bahasa', 'Hukum', 'Kedokteran', 'Teknik Informatika'];
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

    // Fallback: jika educationHistory sudah Lulus tapi graduatedMajors kosong (save game lama)
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

  // ============================================================
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
              '• Kesehatan minimal: 80% (Kesehantanmu: ${widget.character.health}%)\n'
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

    // Cek jika pekerjaan membutuhkan gelar
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

    // Cek persentase khusus untuk BA Esport
    if (job['title'] == 'Brand Ambassador Esport') {
      final double chance = BaEsportPercentage.getApplyChance(widget.character.gender);
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

    // Cek persentase khusus untuk Pro Player Esport
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

    // Cek persentase khusus untuk Talent Esports
    if (job['title'] == 'Talent Esports') {
      final double chance = TalentEsportPercentage.getApplyChance(widget.character.gender);
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

    // Lamaran diterima
    setState(() {
      widget.character.jobName = finalTitle;
      widget.character.jobSalary = finalSalary;
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
    if (widget.character.supervisor == null) {
      final gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
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
      widget.character.supervisor = {
        'name': name,
        'gender': gender,
        'relationship': (40 + random.nextInt(21)).toString(),
        'age': ageVal.toString(),
        'isDeceased': 'false',
        'sexuality': 'Heteroseksual',
        'intelligence': (50 + random.nextInt(41)).toString(),
      };
    }

    if (widget.character.coworkers.isNotEmpty) return;

    final String job = widget.character.jobName ?? '';
    final bool isProPlayer = job.startsWith('Pro Player Esport');
    final bool isBAOrTalent = job.startsWith('Brand Ambassador Esport') || job.startsWith('Talent Esports');

    int count = 5 + random.nextInt(6);
    if (isProPlayer) {
      count = 3 + random.nextInt(3); // 3-5 pro player coworkers
    } else if (isBAOrTalent) {
      count = 10 + random.nextInt(6); // 10-15 BA/Talent coworkers
    }

    for (int i = 0; i < count; i++) {
      String gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
      if (isBAOrTalent) {
        gender = random.nextDouble() < 0.85 ? 'Perempuan' : 'Laki-laki'; // Mostly female for BA/Talent
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
      final ageVal = 20 + random.nextInt(41);
      widget.character.coworkers.add({
        'name': name,
        'gender': gender,
        'relationship': (40 + random.nextInt(21)).toString(),
        'age': ageVal.toString(),
        'isDeceased': 'false',
        'sexuality': 'Heteroseksual',
        'intelligence': (30 + random.nextInt(61)).toString(),
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
                widget.character.jobName = null;
                widget.character.jobSalary = null;
                widget.character.coworkers.clear();
                widget.character.supervisor = null;
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
      // Under 18: Hanya tampilkan pekerjaan anak muda/remaja yang sesuai kriteria usia
      if (gender == 'Perempuan' && age >= 12) {
        jobs.add({
          'title': 'Idol (Trainee)',
          // 10M - 20M IDR -> $667 to $1,333 USD
          'salary': 667 + Random().nextInt(667),
          'minIntel': 0,
          'category': 'Khusus',
          'desc': 'Bergabunglah dengan grup trainee Idol baru',
          'icon': Icons.music_note,
          'color': Colors.pink,
        });
      }

      // Ambil pekerjaan E-Sport dari database jika usia mencukupi
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
      // Lainnya (Usia >= 18): Mulai dengan semua pekerjaan standar
      jobs = List.from(_availableJobs);

      // Tambahkan posisi staf manajemen Idol
      jobs.addAll([
        {
          'title': 'General Manager Idol',
          'salary': 5000, // $5,000 USD (50M-100M IDR)
          'minIntel': 75,
          'category': 'Profesional',
          'desc': 'Memimpin operasional dan strategi grup Idol',
          'icon': Icons.manage_accounts,
          'color': Colors.purple,
        },
        {
          'title': 'Deputy General Manager Idol',
          'salary': 3500, // $3,500 USD (40M-75M IDR)
          'minIntel': 65,
          'category': 'Profesional',
          'desc': 'Membantu General Manager mengelola grup',
          'icon': Icons.supervisor_account,
          'color': Colors.indigo,
        },
        {
          'title': 'Staf Operasional Idol',
          'salary': 500, // $500 USD (5M-10M IDR)
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
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
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

    // Cari kategori pekerjaan saat ini (untuk badge)
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
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    if (hasJob) ...[
                      const SizedBox(height: 4),
                      Text(
                        character.jobName!,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gaji: \$${character.jobSalary}/tahun',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      if (currentCategory == 'Profesional' || currentCategory == 'Prestise') ...[
                        const SizedBox(height: 4),
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

            // Daftar Lowongan Pekerjaan vs Daftar Rekan Kerja
            if (hasJob) ...[
              const Text(
                'Aktivitas Pekerjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
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
                  style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Cari Lowongan Pekerjaan...',
                    hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.green),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.grey.shade100,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const Text(
                'Lowongan Pekerjaan Tersedia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
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
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.work_outline, size: 16, color: Colors.green.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Pekerjaan Umum (Tidak Butuh Gelar)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green.shade800),
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
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.indigo.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.school_outlined, size: 16, color: Colors.indigo.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Pekerjaan Profesional (Butuh Gelar Sarjana)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
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

  Widget _buildJobCard(Map<String, dynamic> job, Character character) {
    final meetsIntel = character.intelligence >= job['minIntel'];
    final requiresGelar = job['category'] == 'Profesional' || job['category'] == 'Prestise';
    final allowed = _getAllowedMajors(job['title']);
    final meetsGelar = requiresGelar
        ? _hasMatchingMajor(character, allowed)
        : true;
    final canApply = meetsIntel && meetsGelar;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: job['color'].withOpacity(0.1),
          child: Icon(job['icon'], color: job['color']),
        ),
        title: Text(job['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gaji: \$${(job['salary'] * getCountrySalaryMultiplier(character.location)).round()}/tahun • ${job['category']}'),
            Text(
              job['desc'],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (requiresGelar) ...[
              if (!character.isUnivGraduated)
                const Text('⚠️ Membutuhkan gelar sarjana', style: TextStyle(fontSize: 11, color: Colors.orange))
              else if (!meetsGelar)
                Text('⚠️ Butuh Gelar: ${allowed.join(", ")}', style: const TextStyle(fontSize: 11, color: Colors.orange))
            ],
          ],
        ),
        trailing: Icon(
          canApply ? Icons.arrow_forward_ios : Icons.lock,
          size: 14,
          color: canApply ? Colors.grey : Colors.red,
        ),
        onTap: () {
          if (!canApply) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  !meetsIntel
                      ? 'Kecerdasan ${character.intelligence}% < ${job['minIntel']}%'
                      : (!character.isUnivGraduated
                          ? 'Butuh gelar sarjana untuk posisi ini'
                          : 'Jurusan Anda tidak sesuai. Butuh: ${allowed.join(", ")}'),
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
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