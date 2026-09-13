// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/pekerjaan_part_time_logic/part_time_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
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
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: const Color(0xFF1E1E2C),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 2),
                  ),
                  child: const Icon(Icons.psychology_rounded, color: Colors.amber, size: 36),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Persyaratan Tidak Cukup',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                    children: [
                      const TextSpan(text: 'Pekerjaan '),
                      TextSpan(text: '"${job['title']}"', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      const TextSpan(text: ' membutuhkan kecerdasan minimal '),
                      TextSpan(text: '$minIntel%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amberAccent)),
                      const TextSpan(text: '.\n\nKecerdasanmu saat ini: '),
                      TextSpan(text: '${widget.character.intelligence}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      return;
    }

    final int salary = (job['salary'] as num).toInt();
    setState(() {
      widget.character.partTimeJobName = job['title'];
      widget.character.partTimeJobSalary = salary;
      widget.character.inbox.add('⏱️ Pekerjaan Part-Time: Kamu mulai bekerja paruh waktu sebagai "${job['title']}" dengan gaji ${CurrencySettings.format(salary)}/tahun!');
    });

    widget.onRefresh();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFF1E1E2C),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (job['color'] as Color).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: (job['color'] as Color).withValues(alpha: 0.4), width: 2),
                ),
                child: Icon(job['icon'] as IconData, color: job['color'] as Color, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Diterima Bekerja! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                  children: [
                    const TextSpan(text: 'Selamat! Kamu resmi diterima sebagai '),
                    TextSpan(text: '"${job['title']}"', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    const TextSpan(text: ' secara Part-Time dengan tambahan penghasilan '),
                    TextSpan(text: '${CurrencySettings.format(salary)}/tahun', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Mulai Bekerja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _quitPartTimeJob() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFF1E1E2C),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 2),
                ),
                child: const Icon(Icons.exit_to_app_rounded, color: Colors.redAccent, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Berhenti Kerja Part-Time',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                  children: [
                    const TextSpan(text: 'Apakah kamu yakin ingin berhenti dari pekerjaan part-time '),
                    TextSpan(text: '"${widget.character.partTimeJobName}"', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    const TextSpan(text: '?'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        setState(() {
                          widget.character.inbox.add('⏱️ Kamu berhenti dari pekerjaan part-time "${widget.character.partTimeJobName}".');
                          widget.character.partTimeJobName = null;
                          widget.character.partTimeJobSalary = null;
                        });
                        widget.onRefresh();
                      },
                      child: const Text('Berhenti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isMobile = MediaQuery.of(context).size.width < 600;
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
          padding: EdgeInsets.all(isMobile ? 10 : 16),
          children: [
            // Banner Pekerjaan Part-Time Aktif Saat Ini
            if (hasPartTime)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(isMobile ? 12 : 16),
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
                    Icon(Icons.access_time_filled_rounded, color: Colors.amber, size: isMobile ? 28 : 36),
                    SizedBox(width: isMobile ? 10 : 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pekerjaan Part-Time Saat Ini', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(
                            widget.character.partTimeJobName!,
                            style: TextStyle(color: Colors.white, fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Gaji Tambahan: \$${widget.character.partTimeJobSalary}/tahun',
                            style: TextStyle(color: Colors.amberAccent, fontSize: isMobile ? 11.5 : 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.redAccent, size: isMobile ? 24 : 28),
                      tooltip: 'Berhenti Kerja Part-Time',
                      onPressed: _quitPartTimeJob,
                    ),
                  ],
                ),
              ),

            Text(
              'DAFTAR PEKERJAAN PART-TIME TERSEDIA',
              style: TextStyle(
                fontSize: isMobile ? 11 : 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white60 : Colors.grey.shade700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 10),

            ...jobs.map((job) {
              final IconData icon = job['icon'] as IconData;
              final Color color = job['color'] as Color;
              final int salary = (job['salary'] as num).toInt();
              final int minIntel = job['minIntel'] ?? 0;
              final bool isCurrent = widget.character.partTimeJobName == job['title'];
              final bool isEligible = widget.character.intelligence >= minIntel;

              return Card(
                margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                color: isCurrent ? (isDark ? Colors.teal.shade900 : Colors.teal.shade50) : (isDark ? Colors.grey.shade800 : Colors.white),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 10 : 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isMobile ? 8 : 10),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: isMobile ? 22 : 28),
                      ),
                      SizedBox(width: isMobile ? 10 : 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job['title'],
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 15,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              job['desc'],
                              style: TextStyle(
                                fontSize: isMobile ? 11 : 12,
                                color: isDark ? Colors.white70 : Colors.grey.shade600,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gaji: ${CurrencySettings.format(salary)}/tahun',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                fontSize: isMobile ? 11.5 : 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      isCurrent
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 8 : 10,
                                vertical: isMobile ? 4 : 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Bekerja',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 11 : 12,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isEligible ? Colors.teal.shade700 : Colors.grey,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 10 : 14,
                                  vertical: isMobile ? 6 : 8,
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => _applyPartTimeJob(job),
                              child: Text(
                                'Lamar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 11.5 : 13,
                                ),
                              ),
                            ),
                    ],
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
