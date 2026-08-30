// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/univ_menu_page.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';
import 'actions/belajar.dart';
import 'actions/kelas.dart';
import 'actions/dosen.dart';
import 'actions/pindah_universitas.dart';

// ============================================================================
// HALAMAN PILIH JURUSAN (tanpa emoji, pakai ikon)
// ============================================================================
class UnivMajorSelectionPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const UnivMajorSelectionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<UnivMajorSelectionPage> createState() =>
      _UnivMajorSelectionPageState();
}

class _UnivMajorSelectionPageState extends State<UnivMajorSelectionPage> {
  // Daftar jurusan tanpa emoji
  static const Map<String, List<String>> _categoryMajors = {
    'STEM & TEKNIK': [
      'Teknik Informatika',
      'Sistem Informasi',
      'Teknik Sipil',
      'Teknik Elektro',
      'Teknik Mesin',
      'Teknik Kimia',
      'Arsitektur',
    ],
    'KESEHATAN': [
      'Kedokteran',
      'Kedokteran Gigi',
      'Farmasi',
      'Keperawatan',
      'Gizi & Ilmu Pangan',
    ],
    'BISNIS & EKONOMI': [
      'Manajemen',
      'Akuntansi',
      'Ekonomi Pembangunan',
      'Perbankan & Keuangan',
      'Pemasaran Digital',
    ],
    'HUKUM & SOSIAL': [
      'Hukum',
      'Hubungan Internasional',
      'Ilmu Komunikasi',
      'Psikologi',
      'Administrasi Publik',
      'Kriminologi',
    ],
    'PENDIDIKAN & BAHASA': [
      'Sastra & Bahasa',
      'Pendidikan / PGSD',
      'Pendidikan Agama Islam',
    ],
    'KREATIF & SENI': [
      'Desain Komunikasi Visual (DKV)',
      'Desain Mode',
      'Film & Televisi',
      'Seni Musik',
    ],
    'PERTANIAN & LAINNYA': [
      'Agroteknologi',
      'Manajemen Perhotelan',
    ],
  };

  static final List<String> _categories = _categoryMajors.keys.toList();
  String? _selectedCategory;
  final ScrollController _scrollController = ScrollController();

  List<String> get _filteredMajors {
    if (_selectedCategory == null) {
      return _categoryMajors.values.expand((list) => list).toList();
    } else {
      return _categoryMajors[_selectedCategory] ?? [];
    }
  }

  // ---------- Mapping jurusan ke ikon ----------
  IconData _getIconForMajor(String major) {
    switch (major) {
      case 'Teknik Informatika':
        return Icons.computer;
      case 'Sistem Informasi':
        return Icons.storage;
      case 'Teknik Sipil':
        return Icons.architecture;
      case 'Teknik Elektro':
        return Icons.electrical_services;
      case 'Teknik Mesin':
        return Icons.settings;
      case 'Teknik Kimia':
        return Icons.science;
      case 'Arsitektur':
        return Icons.architecture;
      case 'Kedokteran':
        return Icons.health_and_safety;
      case 'Kedokteran Gigi':
        return Icons.medical_services;
      case 'Farmasi':
        return Icons.medical_services;
      case 'Keperawatan':
        return Icons.local_hospital;
      case 'Gizi & Ilmu Pangan':
        return Icons.restaurant;
      case 'Manajemen':
        return Icons.business;
      case 'Akuntansi':
        return Icons.calculate;
      case 'Ekonomi Pembangunan':
        return Icons.trending_up;
      case 'Perbankan & Keuangan':
        return Icons.account_balance;
      case 'Pemasaran Digital':
        return Icons.ads_click;
      case 'Hukum':
        return Icons.gavel;
      case 'Hubungan Internasional':
        return Icons.public;
      case 'Ilmu Komunikasi':
        return Icons.record_voice_over;
      case 'Psikologi':
        return Icons.psychology;
      case 'Administrasi Publik':
        return Icons.account_balance;
      case 'Kriminologi':
        return Icons.security;
      case 'Sastra & Bahasa':
        return Icons.book;
      case 'Pendidikan / PGSD':
        return Icons.school;
      case 'Pendidikan Agama Islam':
        return Icons.mosque;
      case 'Desain Komunikasi Visual (DKV)':
        return Icons.brush;
      case 'Desain Mode':
        return Icons.style;
      case 'Film & Televisi':
        return Icons.movie;
      case 'Seni Musik':
        return Icons.music_note;
      case 'Agroteknologi':
        return Icons.agriculture;
      case 'Manajemen Perhotelan':
        return Icons.hotel;
      default:
        return Icons.school;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showAdmissionPathways(BuildContext context, String major) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Pendaftaran: $major 🎓',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          'Pilih jalur pendaftaran universitas yang ingin kamu ambil:',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.account_balance),
                label: const Text('Universitas Negeri (Tes Seleksi)', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _tryNegeri(context, major);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.business),
                label: const Text('Universitas Swasta (Mandiri)', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _trySwasta(context, major);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.stars),
                label: const Text('Beasiswa Berprestasi', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _tryBeasiswa(context, major);
                },
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Batal', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey)),
          ),
        ],
      ),
    );
  }

  String _determineCurrentRegisterLevel() {
    final history = widget.character.educationHistory;
    if (history['S1'] != 'Lulus') return 'S1';
    if (history['S2'] != 'Lulus') return 'S2';
    if (history['S3'] != 'Lulus') return 'S3';
    return 'Complete';
  }

  void _tryNegeri(BuildContext context, String major) {
    if (widget.character.intelligence >= 60) {
      final String level = _determineCurrentRegisterLevel();
      widget.character.univMajor = '$major ($level - Negeri)';
      widget.character.educationHistory[level] = 'Belum Lulus';
      widget.character.currentUnivStudyYears = 0;
      widget.onRefresh();
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Lolos Seleksi Negeri! 🎉'),
          content: Text('Selamat! Kamu berhasil lolos tes masuk Universitas Negeri untuk jenjang $level dengan jurusan $major.'),
          actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Gagal Tes Masuk 🚫'),
          content: const Text('Kecerdasanmu tidak mencukupi untuk lolos tes masuk Universitas Negeri. Coba jalur lain atau tingkatkan kecerdasanmu!'),
          actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );
    }
  }

  void _trySwasta(BuildContext context, String major) {
    final parentRel = ((widget.character.fatherRelationship ?? 50) + (widget.character.motherRelationship ?? 50)) ~/ 2;
    final bool success = Random().nextInt(100) < parentRel;

    if (success) {
      final String level = _determineCurrentRegisterLevel();
      widget.character.univMajor = '$major ($level - Swasta)';
      widget.character.educationHistory[level] = 'Belum Lulus';
      widget.character.currentUnivStudyYears = 0;
      widget.onRefresh();
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Pendaftaran Disetujui! 💸'),
          content: Text('Orang tuamu menyetujui biaya pendaftaran kuliah di Universitas Swasta untuk jenjang $level dengan jurusan $major.'),
          actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Permintaan Ditolak 🚫'),
          content: const Text('Orang tuamu menolak membiayaimu masuk Universitas Swasta karena keterbatasan finansial.'),
          actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );
    }
  }

  void _tryBeasiswa(BuildContext context, String major) {
    if (widget.character.intelligence >= 90) {
      final isLuarNegeri = Random().nextInt(100) < 20;
      final type = isLuarNegeri ? 'Luar Negeri' : 'Dalam Negeri';
      final String level = _determineCurrentRegisterLevel();
      widget.character.univMajor = '$major ($level - Beasiswa $type)';
      widget.character.educationHistory[level] = 'Belum Lulus';
      widget.character.currentUnivStudyYears = 0;
      widget.onRefresh();
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Beasiswa Diterima! 🌟'),
          content: Text('Selamat! Lamaran beasiswamu disetujui. Kamu kuliah di $type gratis sepenuhnya untuk jenjang $level dengan jurusan $major.'),
          actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Beasiswa Ditolak 🚫'),
          content: const Text('Lamaran beasiswa ditolak karena kecerdasanmu berada di bawah 90%. Beasiswa hanya diberikan untuk siswa berprestasi tinggi.'),
          actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Jurusan Universitas 🎓'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryFilter(),
            const SizedBox(height: 16),
            Text(
              'Pilih salah satu program studi yang ingin kamu tekuni:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredMajors.length,
                itemBuilder: (context, index) {
                  final major = _filteredMajors[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        _getIconForMajor(major),
                        color: Colors.indigo,
                      ),
                      title: Text(
                        major,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.white54 : Colors.black54),
                      onTap: () {
                        _showAdmissionPathways(context, major);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Filter horizontal dengan panah ----------
  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 28),
            onPressed: () => _scrollBy(-100),
            splashRadius: 20,
          ),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildFilterChip(
                    label: 'Semua',
                    isSelected: _selectedCategory == null,
                    onTap: () {
                      setState(() => _selectedCategory = null);
                    },
                  );
                }
                final category = _categories[index - 1];
                return _buildFilterChip(
                  label: category,
                  isSelected: _selectedCategory == category,
                  onTap: () {
                    setState(() => _selectedCategory = category);
                  },
                );
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 28),
            onPressed: () => _scrollBy(100),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  void _scrollBy(double offset) {
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? (isDark ? Colors.white : Colors.indigo)
              : (isDark ? Colors.white70 : Colors.grey.shade700),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
      selectedColor: isDark ? Colors.indigo.shade700 : Colors.indigo.shade100,
      checkmarkColor: isDark ? Colors.white : Colors.indigo,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}

// ============================================================================
// HALAMAN UTAMA UNIVERSITAS
// ============================================================================
class UnivMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const UnivMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<UnivMenuPage> createState() => _UnivMenuPageState();
}

class _UnivMenuPageState extends State<UnivMenuPage> {
  String _determineCurrentRegisterLevel() {
    final history = widget.character.educationHistory;
    if (history['S1'] != 'Lulus') return 'S1';
    if (history['S2'] != 'Lulus') return 'S2';
    if (history['S3'] != 'Lulus') return 'S3';
    return 'Complete';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;
    final onRefresh = widget.onRefresh;
    final String level = _determineCurrentRegisterLevel();
    if (character.univMajor == null) {
      if (level == 'Complete') {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Universitas (Kuliah) 🎓'),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.verified, size: 80, color: Colors.amber),
                const SizedBox(height: 24),
                Text(
                  'Pendidikan Selesai! 🎉',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Kamu telah berhasil menyelesaikan semua jenjang pendidikan tinggi hingga S3 Doktoral. Tidak ada lagi jenjang pendidikan formal lanjutan untuk diambil.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Kembali',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('Daftar Kuliah ($level) 🎓'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.school, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),
              Text(
                'Belum Terdaftar di Universitas ($level)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Kamu saat ini belum menempuh pendidikan tinggi jenjang $level. Silakan pilih jurusan dan mendaftar kuliah untuk memulai aktivitas akademik.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.app_registration),
                label: Text(
                  'Daftar Jenjang $level Sekarang',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UnivMajorSelectionPage(
                        character: character,
                        onRefresh: onRefresh,
                      ),
                    ),
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Kembali',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    const Color themeColor = Colors.indigo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universitas (Kuliah) 🎓'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.indigoAccent,
                      child: Icon(Icons.school, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      character.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      'Mahasiswa • Usia: ${character.age} tahun',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        character.univMajor!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      backgroundColor: isDark ? Colors.indigo.shade900 : Colors.indigo.shade50,
                      avatar: const Icon(
                        Icons.verified,
                        size: 16,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeaderStat(
                          'Kecerdasan',
                          '${character.intelligence}%',
                          Colors.blue,
                          isDark,
                        ),
                        _buildHeaderStat(
                          'Kebahagiaan',
                          '${character.happiness}%',
                          Colors.green,
                          isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aktivitas Perkuliahan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 12),
            _buildMenuTile(
              context: context,
              icon: Icons.menu_book,
              color: Colors.indigo,
              title: 'Belajar Lebih Giat',
              subtitle: 'Meningkatkan IPK dan pemahaman materi kuliah',
              page: BelajarActionPage(
                character: character,
                onRefresh: onRefresh,
              ),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.group,
              color: Colors.orange,
              title: 'Kelas',
              subtitle: 'Berinteraksi dengan rekan mahasiswa sekelas',
              page: KelasActionPage(
                character: character,
                onRefresh: onRefresh,
              ),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.person,
              color: Colors.teal,
              title: 'Dosen',
              subtitle: 'Daftar dosen pengajar dan pembimbing akademik',
              page: DosenActionPage(
                character: character,
                onRefresh: onRefresh,
              ),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.swap_horiz,
              color: Colors.blue,
              title: 'Pindah Universitas',
              subtitle: 'Mengajukan mutasi atau transfer ke kampus lain',
              page: PindahUnivActionPage(
                character: character,
                onRefresh: onRefresh,
              ),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.directions_run,
              color: Colors.redAccent,
              title: 'Bolos Kelas',
              subtitle: 'Meninggalkan sesi kuliah hari ini',
              onTap: () => _showBolosDialog(context),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.exit_to_app,
              color: Colors.black87,
              title: 'Keluar dari Universitas',
              subtitle: 'Memutuskan untuk drop out (putus kuliah)',
              onTap: () => _showKeluarDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showBolosDialog(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Rencana Bolos Kuliah 🏃‍♂️',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          'Apakah kamu yakin ingin membolos kuliah hari ini? '
          'Tindakan ini berisiko ketahuan dosen dan merusak reputasi absensimu.',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Batal',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(dialogContext);
              _executeBolosKelas(context);
            },
            child: const Text('Bolos Kuliah', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _executeBolosKelas(BuildContext context) {
    final character = widget.character;
    final bool success = Random().nextBool();

    if (success) {
      character.happiness = (character.happiness + 15).clamp(0, 100);
      character.intelligence = (character.intelligence - 8).clamp(0, 100);
      character.discipline = (character.discipline - 2).clamp(0, 100);
      character.karma = (character.karma - 4).clamp(0, 100);
      widget.onRefresh();
      _showOutcomeDialog(context, 'Berhasil Membolos! 🎮☕', 'Kamu memutuskan bolos kuliah dan bersantai di kafe dekat kampus bersama mahasiswa lain. Rasanya sangat rileks! (Kebahagiaan +15, Kecerdasan -8, Disiplin -2)');
    } else {
      character.happiness = (character.happiness - 12).clamp(0, 100);
      character.discipline = (character.discipline - 2).clamp(0, 100);
      character.karma = (character.karma - 3).clamp(0, 100);
      
      for (var doc in character.univLecturers) {
        final int r = int.tryParse(doc['relationship'] ?? '50') ?? 50;
        doc['relationship'] = (r - 10).clamp(0, 100).toString();
      }

      widget.onRefresh();
      _showOutcomeDialog(context, 'Ketahuan Titip Absen! 🚨', 'Dosen melakukan presensi manual mendadak. Kamu ketahuan menitipkan absen (titip absen/TA). Dosen menandaimu dan reputasimu di kampus anjlok! (Kebahagiaan -12, Disiplin -2, Hubungan Dosen Berkurang)');
    }
  }

  void _showKeluarDialog(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Peringatan Drop Out 🚪',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          'Meninggalkan perkuliahan secara sepihak berarti merelakan gelar akademikmu dan menutup peluang kerja profesional berstandar ijazah sarjana. '
          'Apakah kamu yakin ingin drop out kuliah sekarang?',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Batal',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(dialogContext);
              _executeKeluarUniv(context);
            },
            child: const Text('Drop Out Sekarang', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _executeKeluarUniv(BuildContext context) {
    final character = widget.character;
    character.univClassmates.clear();
    character.univLecturers.clear();
    character.univMajor = null;
    String currentStage = 'S1';
    if (character.educationHistory['S2'] == 'Belum Lulus') {
      currentStage = 'S2';
    } else if (character.educationHistory['S3'] == 'Belum Lulus') {
      currentStage = 'S3';
    }
    character.educationHistory[currentStage] = 'Putus Sekolah';
    character.happiness = (character.happiness - 20).clamp(0, 100);
    character.inbox.add('🎓 Drop Out: Kamu memutuskan untuk drop out dari universitas pada usia ${character.age} tahun.');
    widget.onRefresh();
    setState(() {});

    _showOutcomeDialog(context, 'Drop Out Universitas 🛑', 'Kamu resmi keluar dari universitas. Sekarang kamu bukan lagi seorang mahasiswa. Kamu bisa melamar pekerjaan atau menikmati kebebasan tanpa kuliah!');
  }

  void _showOutcomeDialog(BuildContext context, String title, String content) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          content,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(
              'OK',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
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
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? Colors.white54 : Colors.grey,
        ),
        onTap: () async {
          if (onTap != null) {
            onTap();
          } else if (page != null) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
            setState(() {});
          }
        },
      ),
    );
  }
}