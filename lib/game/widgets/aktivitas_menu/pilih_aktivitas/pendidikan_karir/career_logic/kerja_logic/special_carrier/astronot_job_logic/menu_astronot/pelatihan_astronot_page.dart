// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/astronot_job_logic/menu_astronot/pelatihan_astronot_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class PelatihanAstronotPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PelatihanAstronotPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PelatihanAstronotPage> createState() => _PelatihanAstronotPageState();
}

class _PelatihanAstronotPageState extends State<PelatihanAstronotPage> {
  final List<Map<String, dynamic>> _trainingPrograms = [
    {
      'title': 'Simulasi Gravitasi Nol (Zero-G) 🛰️',
      'desc': 'Latihan adaptasi melayang dalam atmosfer mikro-gravitasi menggunakan pesawat parabolik.',
      'statBonus': '+Kesehatan & Stabilitas Tubuh',
      'icon': Icons.blur_circular,
      'color': Colors.indigo,
      'action': (Character c) {
        c.health = (c.health + 4).clamp(0, 100);
        c.happiness = (c.happiness + 2).clamp(0, 100);
        return 'Tubuhmu berhasil menyesuaikan diri dengan simulasi Zero-G tanpa mual! (Kesehatan +4%)';
      }
    },
    {
      'title': 'Uji Mesin Sentrifugal G-Force Tinggi 🌀',
      'desc': 'Melatih ketahanan fisik dari tekanan g-force tinggi roket luncur hingga 9G.',
      'statBonus': '+Ketahanan Fisik Ekstrem',
      'icon': Icons.speed,
      'color': Colors.deepPurple,
      'action': (Character c) {
        c.health = (c.health + 5).clamp(0, 100);
        c.willpower = (c.willpower + 3).clamp(0, 100);
        return 'Kamu mampu menahan g-force hingga 9G saat berputar di mesin sentrifugal! (Kesehatan +5%)';
      }
    },
    {
      'title': 'Simulasi Baju Antariksa di Dalam Air 🌊',
      'desc': 'Latihan spacewalk (EVA) di kolam selam raksasa laboratorium laboratorium antariksa.',
      'statBonus': '+Kecerdasan & Keterampilan EVA',
      'icon': Icons.pool,
      'color': Colors.teal,
      'action': (Character c) {
        c.intelligence = (c.intelligence + 3).clamp(0, 100);
        c.discipline = (c.discipline + 2).clamp(0, 100);
        return 'Kamu berhasil menyelesaikan perbaikan modul stasiun antariksa simulasi di bawah air! (Kecerdasan +3%)';
      }
    },
    {
      'title': 'Simulasi Kedaruratan & Pendaratan Darurat 🚨',
      'desc': 'Latihan bertahan hidup jika kapsul mendarat di hutan belantara atau lautan lepas.',
      'statBonus': '+Disiplin & Tekad Bertahan Hidup',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.orange,
      'action': (Character c) {
        c.discipline = (c.discipline + 4).clamp(0, 100);
        c.willpower = (c.willpower + 4).clamp(0, 100);
        return 'Timmu sukses menyalakan suar darurat dan bertahan hidup di medan ekstrem! (Tekad +4%)';
      }
    },
  ];

  void _runTraining(Map<String, dynamic> program) {
    final String resMsg = (program['action'] as String Function(Character))(widget.character);
    setState(() {});
    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Latihan Selesai! 💪🚀',
      content: Text(resMsg, style: const TextStyle(fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Pelatihan Kosmonot 🌀'),
        backgroundColor: Colors.deepPurple.shade900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.deepPurple.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.fitness_center, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fisik & Stamina Astronot', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        const SizedBox(height: 2),
                        Text(
                          'Kesehatan: ${widget.character.health}% ❤️ • Disiplin: ${widget.character.discipline}% 🛡️',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.deepPurple.shade900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text(
              'Program Latihan Simulasi Antariksa 🏋️‍♂️',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87),
            ),
          ),

          ..._trainingPrograms.map((program) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
              ),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: program['color'] as Color,
                          child: Icon(program['icon'] as IconData, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            program['title'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      program['desc'] as String,
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (program['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Bonus: ${program['statBonus']}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: program['color'] as Color),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: program['color'] as Color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: const Text('Jalankan Sesi Latihan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        onPressed: () => _runTraining(program),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
