import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class BekerjaKerasActionPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const BekerjaKerasActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<BekerjaKerasActionPage> createState() => _BekerjaKerasActionPageState();
}

class _BekerjaKerasActionPageState extends State<BekerjaKerasActionPage> {
  void _lakukanKerjaKeras(String tipe, int stressCost) {
    setState(() {
      widget.character.happiness = (widget.character.happiness - stressCost).clamp(0, 100);
      // Improve relationship with random coworker by a bit!
      if (widget.character.coworkers.isNotEmpty) {
        final random = Random();
        final idx = random.nextInt(widget.character.coworkers.length);
        final cm = widget.character.coworkers[idx];
        int currentRel = int.tryParse(cm['relationship'] ?? '50') ?? 50;
        cm['relationship'] = (currentRel + random.nextInt(5) + 3).clamp(0, 100).toString();
      }
    });
    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Bekerja Lebih Giat 💼🚀',
      content: Text(
        'Kamu bekerja keras dengan metode "$tipe". Hubunganmu dengan atasan dan rekan kerja semakin membaik! '
        'Namun kebahagiaanmu sedikit menurun -$stressCost% karena kelelahan lembur.',
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
        title: const Text('Bekerja Lebih Giat'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 0,
            color: Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.green.shade100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.trending_up, size: 48, color: Colors.green),
                  const SizedBox(height: 12),
                  const Text(
                    'Bekerja Lebih Giat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pekerjaan: ${widget.character.jobName ?? "Tidak ada"}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Menunjukkan performa kerja yang luar biasa akan membantu mempercepat promosi jabatan dan meningkatkan bonus gaji tahunan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'PILIH METODE KERJA LEBIH GIAT',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0),
          ),
          const SizedBox(height: 12),

          _buildMethodCard(
            icon: Icons.timer,
            color: Colors.blue,
            title: 'Lembur Menyelesaikan Project',
            subtitle: 'Menyelesaikan deadline pekerjaan tepat waktu',
            gain: 'Meningkatkan Hubungan Kerja',
            onTap: () => _lakukanKerjaKeras('Lembur Menyelesaikan Project', 2),
          ),

          _buildMethodCard(
            icon: Icons.lightbulb,
            color: Colors.teal,
            title: 'Memberikan Ide Inovatif',
            subtitle: 'Mengusulkan strategi baru untuk kemajuan tim',
            gain: 'Meningkatkan Hubungan Kerja',
            onTap: () => _lakukanKerjaKeras('Memberikan Ide Inovatif', 3),
          ),

          _buildMethodCard(
            icon: Icons.help_outline,
            color: Colors.orange,
            title: 'Membantu Project Rekan Kerja',
            subtitle: 'Membantu menyelesaikan kendala tugas rekan satu tim',
            gain: 'Meningkatkan Hubungan Kerja',
            onTap: () => _lakukanKerjaKeras('Membantu Project Rekan Kerja', 4),
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
