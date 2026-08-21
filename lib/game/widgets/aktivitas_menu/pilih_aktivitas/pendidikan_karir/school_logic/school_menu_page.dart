// lib/game/widgets/aktivitas_menu/school_logic/school_menu_page.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'actions/belajar.dart';
import 'actions/kelas.dart';
import 'actions/guru.dart';
import 'actions/pindah_sekolah.dart';
import 'actions/bolos_sekolah.dart';
import 'actions/keluar_sekolah.dart';

class SchoolMenuPage extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const SchoolMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final int age = character.age;
    String schoolType = 'Sekolah';
    Color themeColor = Colors.blue;

    if (age >= 6 && age <= 11) {
      schoolType = 'Sekolah Dasar (SD)';
      themeColor = Colors.blue;
    } else if (age >= 12 && age <= 14) {
      schoolType = 'Sekolah Menengah Pertama (SMP)';
      themeColor = Colors.blueAccent;
    } else if (age >= 15 && age <= 17) {
      schoolType = 'Sekolah Menengah Atas (SMA)';
      themeColor = Colors.purple;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(schoolType),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Card - Detail Sekolah
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: themeColor.withOpacity(0.1),
                      child: Icon(Icons.school, size: 40, color: themeColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      character.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Pelajar • Usia: ${character.age} tahun',
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
              'Aktivitas Sekolah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 12),

            // Pilihan Menu 1: Belajar Lebih Giat
            _buildMenuTile(
              context: context,
              icon: Icons.menu_book,
              color: Colors.indigo,
              title: 'Belajar Lebih Giat',
              subtitle: 'Tingkatkan fokus dan kecerdasan belajarmu',
              page: BelajarActionPage(character: character, onRefresh: onRefresh),
            ),

            // Pilihan Menu 2: Kelas
            _buildMenuTile(
              context: context,
              icon: Icons.group,
              color: Colors.orange,
              title: 'Kelas',
              subtitle: 'Berinteraksi dengan teman sekelas',
              page: KelasActionPage(character: character, onRefresh: onRefresh),
            ),

            // Pilihan Menu 2: Guru
            _buildMenuTile(
              context: context,
              icon: Icons.person,
              color: Colors.teal,
              title: 'Guru',
              subtitle: 'Daftar guru pengajar dan staf sekolah',
              page: GuruActionPage(character: character, onRefresh: onRefresh),
            ),

            // Pilihan Menu 3: Pindah Sekolah
            _buildMenuTile(
              context: context,
              icon: Icons.swap_horiz,
              color: Colors.blue,
              title: 'Pindah Sekolah',
              subtitle: 'Mengajukan pindah ke sekolah lain',
              page: PindahSekolahActionPage(character: character, onRefresh: onRefresh),
            ),

            // Pilihan Menu 4: Bolos Sekolah
            _buildMenuTile(
              context: context,
              icon: Icons.directions_run,
              color: Colors.redAccent,
              title: 'Bolos Sekolah',
              subtitle: 'Skip sekolah hari ini untuk main',
              page: BolosSekolahActionPage(character: character, onRefresh: onRefresh),
            ),

            // Pilihan Menu 5: Keluar Sekolah
            _buildMenuTile(
              context: context,
              icon: Icons.exit_to_app,
              color: Colors.black87,
              title: 'Keluar Sekolah',
              subtitle: 'Putus sekolah secara mandiri',
              page: KeluarSekolahActionPage(character: character, onRefresh: onRefresh),
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
