// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/pekerjaan_part_time_logic/part_time_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'database_part_time.dart';

class PartTimeMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PartTimeMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PartTimeMenuPage> createState() => _PartTimeMenuPageState();
}

class _PartTimeMenuPageState extends State<PartTimeMenuPage> {
  void _applyPartTimeJob(Map<String, dynamic> job) {
    final int minIntel = job['minIntel'] ?? 0;
    if (widget.character.intelligence < minIntel) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Persyaratan Tidak Cukup'),
          content: Text('Pekerjaan "${job['title']}" membutuhkan kecerdasan minimal $minIntel%. Kecerdasanmu saat ini: ${widget.character.intelligence}%.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
      return;
    }

    final int salary = (job['salary'] as num).toInt();
    setState(() {
      widget.character.partTimeJobName = job['title'];
      widget.character.partTimeJobSalary = salary;
      widget.character.inbox.add('⏱️ Pekerjaan Part-Time: Kamu mulai bekerja paruh waktu sebagai "${job['title']}" dengan gaji \$$salary/tahun!');
    });

    widget.onRefresh();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(job['icon'] as IconData, color: job['color'] as Color),
            const SizedBox(width: 8),
            const Text('Diterima Bekerja! 🎉'),
          ],
        ),
        content: Text('Selamat! Kamu resmi diterima sebagai "${job['title']}" secara Part-Time dengan tambahan penghasilan \$$salary/tahun.'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Mulai Bekerja'),
          ),
        ],
      ),
    );
  }

  void _quitPartTimeJob() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Berhenti Kerja Part-Time'),
        content: Text('Apakah kamu yakin ingin berhenti dari pekerjaan part-time "${widget.character.partTimeJobName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                widget.character.inbox.add('⏱️ Kamu berhenti dari pekerjaan part-time "${widget.character.partTimeJobName}".');
                widget.character.partTimeJobName = null;
                widget.character.partTimeJobSalary = null;
              });
              widget.onRefresh();
            },
            child: const Text('Berhenti'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final jobs = PartTimeJobDatabase.availablePartTimeJobs;
    final bool hasPartTime = widget.character.partTimeJobName != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pekerjaan Part-Time ⏱️', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00695C), Color(0xFF004D40)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Banner Pekerjaan Part-Time Aktif Saat Ini
            if (hasPartTime)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade800, Colors.teal.shade900],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.shade900.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_filled_rounded, color: Colors.amber, size: 36),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pekerjaan Part-Time Saat Ini', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                            widget.character.partTimeJobName!,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Gaji Tambahan: \$${widget.character.partTimeJobSalary}/tahun',
                            style: const TextStyle(color: Colors.amberAccent, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.redAccent, size: 28),
                      tooltip: 'Berhenti Kerja Part-Time',
                      onPressed: _quitPartTimeJob,
                    ),
                  ],
                ),
              ),

            Text(
              'DAFTAR PEKERJAAN PART-TIME TERSEDIA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white60 : Colors.grey.shade700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),

            ...jobs.map((job) {
              final IconData icon = job['icon'] as IconData;
              final Color color = job['color'] as Color;
              final int salary = (job['salary'] as num).toInt();
              final int minIntel = job['minIntel'] ?? 0;
              final bool isCurrent = widget.character.partTimeJobName == job['title'];
              final bool isEligible = widget.character.intelligence >= minIntel;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                color: isCurrent ? (isDark ? Colors.teal.shade900 : Colors.teal.shade50) : (isDark ? Colors.grey.shade800 : Colors.white),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 28),
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
                      const SizedBox(height: 4),
                      Text(
                        job['desc'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gaji: \$$salary/tahun',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal, fontSize: 13),
                      ),
                    ],
                  ),
                  trailing: isCurrent
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Bekerja', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEligible ? Colors.teal.shade700 : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => _applyPartTimeJob(job),
                          child: const Text('Lamar', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
