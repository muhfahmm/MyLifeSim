// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/actions/belajar.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class BelajarActionPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const BelajarActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<BelajarActionPage> createState() => _BelajarActionPageState();
}

class _BelajarActionPageState extends State<BelajarActionPage> {
  final Random _random = Random();

  void _lakukanBelajar(String tipe, int intGain, int stressCost) {
    int finalIntGain = intGain;
    if (widget.character.discipline > 70) {
      finalIntGain = (intGain * 1.5).round();
    }
    setState(() {
      widget.character.intelligence = (widget.character.intelligence + finalIntGain).clamp(0, 100);
      widget.character.happiness = (widget.character.happiness - stressCost).clamp(0, 100);
    });
    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Belajar Kuliah Sukses 📚🎓',
      content: Text(
        'Kamu belajar dengan metode "$tipe". Kecerdasan akademismu meningkat +$intGain%! '
        'Namun kebahagiaanmu sedikit menurun -$stressCost% karena penat memikirkan IPK.',
      ),
      actions: [
        Builder(
          builder: (dialogContext) => TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Mengerti'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Lebih Giat (Kuliah)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 0,
            color: isDark ? Colors.grey.shade800 : Colors.indigo.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.indigo.shade100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.menu_book, size: 48, color: Colors.indigo),
                  const SizedBox(height: 12),
                  const Text(
                    'Pusat Belajar Universitas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kecerdasan saat ini: ${widget.character.intelligence}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Belajar giat di kampus akan membantumu mendapatkan IPK tinggi dan mempermudah karir profesional setelah lulus.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'PILIH METODE BELAJAR KULIAH',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),

          _buildMethodCard(
            icon: Icons.book,
            color: Colors.blue,
            title: 'Membaca Jurnal & E-Book',
            subtitle: 'Membaca literatur dan jurnal ilmiah terakreditasi',
            gain: 'Kecerdasan +3%',
            onTap: () => _lakukanBelajar('Membaca Jurnal & E-Book', 3, 1),
          ),

          _buildMethodCard(
            icon: Icons.edit_note,
            color: Colors.teal,
            title: 'Mengerjakan Tugas & Praktikum',
            subtitle: 'Menyelesaikan laporan praktikum dan tugas dosen',
            gain: 'Kecerdasan +5%',
            onTap: () => _lakukanBelajar('Mengerjakan Tugas & Praktikum', 5, 2),
          ),

          _buildMethodCard(
            icon: Icons.groups,
            color: Colors.orange,
            title: 'Kerja Kelompok / Diskusi Kelas',
            subtitle: 'Berdiskusi materi presentasi kuliah bersama kelompok',
            gain: 'Kecerdasan +6%',
            onTap: () => _lakukanBelajar('Kerja Kelompok / Diskusi Kelas', 6, 3),
          ),

          _buildMethodCard(
            icon: Icons.school,
            color: Colors.purple,
            title: 'Mengikuti Seminar & Webinar',
            subtitle: 'Mengikuti pelatihan profesional tambahan di luar kelas',
            gain: 'Kecerdasan +8%',
            onTap: () => _lakukanBelajar('Mengikuti Seminar & Webinar', 8, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String gain,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
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
          '$subtitle\n($gain)',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        isThreeLine: true,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: isDark ? Colors.white54 : Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}