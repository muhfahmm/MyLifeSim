// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/univ_menu_page.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'actions/belajar.dart';
import 'actions/kelas.dart';
import 'actions/dosen.dart';
import 'actions/pindah_universitas.dart';
import 'actions/bolos_kelas.dart';
import 'actions/keluar.dart';

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

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Pilih salah satu program studi yang ingin kamu tekuni:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        widget.character.univMajor = major;
                        widget.onRefresh();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Berhasil mendaftar di $major'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
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
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: Colors.indigo.shade100,
      checkmarkColor: Colors.indigo,
      labelStyle: TextStyle(
        color: isSelected ? Colors.indigo : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}

// ============================================================================
// HALAMAN UTAMA UNIVERSITAS (tidak berubah)
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

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final onRefresh = widget.onRefresh;
    if (character.univMajor == null) {
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
              const Icon(Icons.school, size: 80, color: Colors.indigo),
              const SizedBox(height: 24),
              const Text(
                'Belum Terdaftar di Universitas',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kamu saat ini belum menempuh pendidikan tinggi. Silakan pilih jurusan dan mendaftar kuliah untuk memulai aktivitas akademik.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
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
                label: const Text(
                  'Daftar Universitas Sekarang',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                child: const Text('Kembali'),
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Mahasiswa • Usia: ${character.age} tahun',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        character.univMajor!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.indigo.shade50,
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
                        ),
                        _buildHeaderStat(
                          'Kebahagiaan',
                          '${character.happiness}%',
                          Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Aktivitas Perkuliahan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
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
              page: BolosKelasActionPage(
                character: character,
                onRefresh: onRefresh,
              ),
            ),
            _buildMenuTile(
              context: context,
              icon: Icons.exit_to_app,
              color: Colors.black87,
              title: 'Keluar dari Universitas',
              subtitle: 'Memutuskan untuk drop out (putus kuliah)',
              page: KeluarActionPage(
                character: character,
                onRefresh: onRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
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
    required Widget page,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
          setState(() {});
        },
      ),
    );
  }
}