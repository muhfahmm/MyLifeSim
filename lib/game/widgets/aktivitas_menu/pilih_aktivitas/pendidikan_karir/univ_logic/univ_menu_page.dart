// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/univ_menu_page.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'actions/belajar.dart';
import 'actions/kelas.dart';
import 'actions/dosen.dart';
import 'actions/pindah_universitas.dart';
import 'actions/bolos_kelas.dart';
import 'actions/keluar.dart';

class UnivMenuPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const UnivMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  void _showUnivMajorSelectionFromPage(BuildContext context) {
    final List<String> majors = [
      'Teknik Informatika 💻',
      'Kedokteran 🩺',
      'Hukum ⚖️',
      'Akuntansi 📊',
      'Sastra & Bahasa 📚'
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pilih Jurusan Universitas 🎓', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Pilih salah satu program studi / jurusan yang ingin kamu tekuni:'),
        actions: majors.map((major) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade50,
                foregroundColor: Colors.indigo,
                elevation: 0,
              ),
              onPressed: () {
                character.univMajor = major;
                onRefresh();
                Navigator.pop(dialogContext);
                showDialog(
                  context: context,
                  builder: (alertContext) => AlertDialog(
                    title: const Text('Pendaftaran Berhasil! 🎉'),
                    content: Text('Selamat! Kamu resmi diterima di Universitas untuk program studi $major.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(alertContext);
                          // trigger rebuild
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UnivMenuPage(
                                character: character,
                                onRefresh: onRefresh,
                              ),
                            ),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(major, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        )).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.app_registration),
                label: const Text('Daftar Universitas Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: () {
                  _showUnivMajorSelectionFromPage(context);
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
            // Header Card - Detail Kampus
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Mahasiswa • Usia: ${character.age} tahun',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeaderStat('Kecerdasan', '${character.intelligence}%', Colors.blue),
                        _buildHeaderStat('Kebahagiaan', '${character.happiness}%', Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Aktivitas Perkuliahan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),

            // Pilihan Menu 1: Belajar Lebih Giat
            _buildMenuTile(
              context: context,
              icon: Icons.menu_book,
              color: Colors.indigo,
              title: 'Belajar Lebih Giat',
              subtitle: 'Meningkatkan IPK dan pemahaman materi kuliah',
              page: BelajarActionPage(character: character, onRefresh: onRefresh),
            ),

            // Pilihan Menu 2: Kelas (Mahasiswa)
            _buildMenuTile(
              context: context,
              icon: Icons.group,
              color: Colors.orange,
              title: 'Kelas',
              subtitle: 'Berinteraksi dengan rekan mahasiswa sekelas',
              page: KelasActionPage(character: character, onRefresh: onRefresh),
            ),

            // Pilihan Menu 3: Dosen
            _buildMenuTile(
              context: context,
              icon: Icons.person,
              color: Colors.teal,
              title: 'Dosen',
              subtitle: 'Daftar dosen pengajar dan pembimbing akademik',
              page: DosenActionPage(character: character, onRefresh: onRefresh),
            ),

            // Pilihan Menu 4: Pindah Universitas
            _buildMenuTile(
              context: context,
              icon: Icons.swap_horiz,
              color: Colors.blue,
              title: 'Pindah Universitas',
              subtitle: 'Mengajukan mutasi atau transfer ke kampus lain',
              page: PindahUnivActionPage(character: character, onRefresh: onRefresh),
            ),

            // Pilihan Menu 5: Bolos Kelas
            _buildMenuTile(
              context: context,
              icon: Icons.directions_run,
              color: Colors.redAccent,
              title: 'Bolos Kelas',
              subtitle: 'Meninggalkan sesi kuliah hari ini',
              page: BolosKelasActionPage(character: character, onRefresh: onRefresh),
            ),

            // Pilihan Menu 6: Keluar / Drop Out
            _buildMenuTile(
              context: context,
              icon: Icons.exit_to_app,
              color: Colors.black87,
              title: 'Keluar dari Universitas',
              subtitle: 'Memutuskan untuk drop out (putus kuliah)',
              page: KeluarActionPage(character: character, onRefresh: onRefresh),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}
