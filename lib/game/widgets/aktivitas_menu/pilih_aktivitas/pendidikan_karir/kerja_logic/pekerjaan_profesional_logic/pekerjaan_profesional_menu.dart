// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/pekerjaan_profesional_logic/pekerjaan_profesional_menu.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../database_nama_pekerjaan.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/daftar_negara.dart';



class PekerjaanProfesionalMenuScreen extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PekerjaanProfesionalMenuScreen({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PekerjaanProfesionalMenuScreen> createState() => _PekerjaanProfesionalMenuScreenState();
}

class _PekerjaanProfesionalMenuScreenState extends State<PekerjaanProfesionalMenuScreen> {
  List<Map<String, dynamic>> _jobs = [];
  String _searchQuery = '';
  double _salaryMultiplier = 1.0;
  String _currentMajorsStr = '';
  bool _isUnivGraduated = false;

  @override
  void initState() {
    super.initState();
    _salaryMultiplier = getCountrySalaryMultiplier(widget.character.location);
    _isUnivGraduated = widget.character.isUnivGraduated;
    final baseMajor = _getBaseMajor(widget.character.univMajor);
    _currentMajorsStr = widget.character.graduatedMajors.isNotEmpty
        ? widget.character.graduatedMajors.join(", ")
        : (baseMajor ?? "Belum lulus / Tidak ada");

    _updateJobList();
  }

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
    if (character.bypassDegreeRequirement) return true;
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

  String _formatAllowedMajors(List<String> majors) {
    if (majors.isEmpty) return 'Tidak ada spesifikasi jurusan';
    if (majors.length == 1) return majors.first;
    if (majors.length == 2) return '${majors[0]} atau ${majors[1]}';
    return '${majors.sublist(0, majors.length - 1).join(', ')}, atau ${majors.last}';
  }

  void _updateJobList() {
    List<Map<String, dynamic>> allJobs = JobDatabase.availableJobs
        .where((j) => j['category'] == 'Profesional' || j['category'] == 'Prestise')
        .toList();

    allJobs.addAll([
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
    ]);

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

    final allowed = _getAllowedMajors(job['title']);
    if (!_hasMatchingMajor(character, allowed)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gelar Tidak Sesuai 🎓'),
          content: Text(
            'Posisi ${job['title']} membutuhkan gelar sarjana yang sesuai.\n\n'
            'Gelar/Jurusan yang diterima:\n'
            '• ${allowed.join("\n• ")}\n\n'
            'Jurusanmu: $_currentMajorsStr.',
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

    final String finalTitle = job['title'];
    final double salaryMult = getCountrySalaryMultiplier(character.location);
    final int finalSalary = (job['salary'] * salaryMult).round();

    setState(() {
      character.setJob(finalTitle, finalSalary);
    });
    widget.onRefresh();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lamaran Diterima! 🎉💼'),
        content: Text(
          'Selamat! Kamu resmi bekerja sebagai $finalTitle dengan gaji \$$finalSalary/tahun.\n\nGaji akan dibayarkan setiap kali kamu bertambah umur.',
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
        title: const Text('Pekerjaan Profesional 🎓'),
        backgroundColor: Colors.indigo.shade700,
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
                hintText: 'Cari Pekerjaan Profesional...',
                hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                filled: true,
                fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.indigo, width: 2),
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
                final allowed = _getAllowedMajors(job['title']);
                final meetsGelar = _hasMatchingMajor(character, allowed);
                final canApply = meetsIntel && meetsGelar;

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
                        if (character.bypassDegreeRequirement)
                          Text(
                            '🔓 Syarat Gelar Sarjana Dibebaskan (God Mode)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.greenAccent : Colors.green.shade700,
                            ),
                          )
                        else if (!_isUnivGraduated)
                          Text(
                            '⚠️ Membutuhkan gelar Sarjana (S1) di bidang: ${_formatAllowedMajors(allowed)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.orangeAccent : Colors.orange,
                            ),
                          )
                        else if (!meetsGelar)
                          Text(
                            '⚠️ Gelar tidak sesuai. Dibutuhkan: ${_formatAllowedMajors(allowed)}.\nJurusanmu saat ini: $_currentMajorsStr.',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.orangeAccent : Colors.orange,
                            ),
                          ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canApply ? Colors.green.shade600 : Colors.grey.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (!canApply) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                !meetsIntel
                                    ? 'Kecerdasan ${character.intelligence}% < ${job['minIntel']}%'
                                    : (!_isUnivGraduated
                                        ? 'Butuh gelar Sarjana S1 di bidang: ${_formatAllowedMajors(allowed)}'
                                        : 'Jurusan Anda tidak sesuai. Dibutuhkan: ${_formatAllowedMajors(allowed)}. Jurusanmu: $_currentMajorsStr.'),
                              ),
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
                          if (!canApply) ...[
                            const Icon(Icons.lock, size: 14, color: Colors.white70),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            canApply ? 'Lamar' : 'Terkunci',
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
