// lib/game/widgets/aktivitas_menu/school_logic/actions/belajar.dart
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
    final int discGain = (intGain / 1.5).ceil();
    setState(() {
      widget.character.intelligence = (widget.character.intelligence + intGain).clamp(0, 100);
      widget.character.discipline = (widget.character.discipline + discGain).clamp(0, 100);
      widget.character.happiness = (widget.character.happiness - stressCost).clamp(0, 100);
    });
    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Belajar Sukses 📚',
      content: Text(
        'Kamu belajar dengan metode "$tipe". Kecerdasanmu meningkat +$intGain% dan Kedisiplinanmu meningkat +$discGain%! '
        'Namun kebahagiaanmu sedikit menurun -$stressCost% karena lelah belajar.',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Lebih Giat'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Card Info
          Card(
            elevation: 0,
            color: Colors.indigo.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.indigo.shade100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.menu_book, size: 48, color: Colors.indigo),
                  const SizedBox(height: 12),
                  const Text(
                    'Pusat Belajar Mandiri',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kecerdasan saat ini: ${widget.character.intelligence}%',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Belajar giat secara mandiri akan membantumu mendapatkan nilai bagus dan masa depan yang cerah.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'PILIH METODE BELAJAR',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0),
          ),
          const SizedBox(height: 12),

          // Metode 1: Membaca Buku
          _buildMethodCard(
            icon: Icons.book,
            color: Colors.blue,
            title: 'Membaca Buku Perpustakaan',
            subtitle: 'Membaca buku teks sekolah di perpustakaan',
            gain: 'Kecerdasan +3%, Kedisiplinan +2%',
            onTap: () => _lakukanBelajar('Membaca Buku Perpustakaan', 3, 1),
          ),

          // Metode 2: Mengerjakan PR
          _buildMethodCard(
            icon: Icons.edit_note,
            color: Colors.teal,
            title: 'Mengerjakan PR & Latihan',
            subtitle: 'Menyelesaikan semua pekerjaan rumah tepat waktu',
            gain: 'Kecerdasan +5%, Kedisiplinan +4%',
            onTap: () => _lakukanBelajar('Mengerjakan PR & Latihan', 5, 2),
          ),

          // Metode 3: Belajar Kelompok
          _buildMethodCard(
            icon: Icons.groups,
            color: Colors.orange,
            title: 'Belajar Kelompok / Diskusi',
            subtitle: 'Berbagi materi pelajaran dengan teman sekelas',
            gain: 'Kecerdasan +6%, Kedisiplinan +4%',
            onTap: () => _lakukanBelajar('Belajar Kelompok / Diskusi', 6, 3),
          ),

          // Metode 4: Les Privat
          _buildMethodCard(
            icon: Icons.school,
            color: Colors.purple,
            title: 'Mengikuti Les Tambahan',
            subtitle: 'Bimbingan intensif materi ujian sekolah',
            gain: 'Kecerdasan +8%, Kedisiplinan +6%',
            onTap: () => _lakukanBelajar('Mengikuti Les Tambahan', 8, 4),
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$subtitle\n($gain)'),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
