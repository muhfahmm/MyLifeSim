// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/pekerjaan_umum_logic/pekerjaan_umum_activities_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import '../actions/rekan_kerja.dart';
import '../actions/bekerja_keras.dart';
import 'dart:math';

class PekerjaanUmumActivitiesPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PekerjaanUmumActivitiesPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PekerjaanUmumActivitiesPage> createState() => _PekerjaanUmumActivitiesPageState();
}

class _PekerjaanUmumActivitiesPageState extends State<PekerjaanUmumActivitiesPage> {
  final Random _random = Random();

  void _doOvertime() {
    final character = widget.character;
    if (character.health < 15) {
      DialogHelper.show(
        context: context,
        title: 'Kondisi Fisik Menurun 😴',
        content: const Text(
          'Kesehatan dan kondisi fisikmu tidak cukup untuk mengambil jam lembur! Istirahatlah terlebih dahulu.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
      );
      return;
    }

    final int bonusPay = ((character.jobSalary ?? 500) * 0.08).round() + 50 + _random.nextInt(100);
    setState(() {
      character.health = (character.health - 10).clamp(0, 100);
      character.happiness = (character.happiness - 5).clamp(0, 100);
      character.discipline = (character.discipline + 4).clamp(0, 100);
      character.money += bonusPay;
    });

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Jam Lembur Selesai ⏱️💰',
      content: Text(
        'Kamu telah menyelesaikan shift lembur kerja tambahan dengan tekun!\n\n'
        '• Bonus Lembur Tunai: ${CurrencySettings.format(bonusPay)}\n'
        '• Kedisiplinan: +4%\n'
        '• Kesehatan: -10%\n'
        '• Kebahagiaan: -5%',
        style: const TextStyle(fontSize: 13, height: 1.4),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Mantap!'),
        ),
      ],
    );
  }

  void _takeCoffeeBreak() {
    final character = widget.character;
    setState(() {
      character.health = (character.health + 15).clamp(0, 100);
      character.happiness = (character.happiness + 10).clamp(0, 100);
    });

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Istirahat Kopi & Lounge ☕✨',
      content: const Text(
        'Kamu menikmati segelas kopi hangat dan camilan lezat di ruang istirahat kantor bersama rekan kerja!\n\n'
        '• Kesehatan: +15%\n'
        '• Kebahagiaan: +10%',
        style: TextStyle(fontSize: 13, height: 1.4),
      ),
    );
  }

  void _askRaiseOrPromotion() {
    final character = widget.character;
    final double performance = ((character.discipline + character.happiness) / 2);

    if (performance < 65) {
      DialogHelper.show(
        context: context,
        title: 'Pengajuan Ditolak 🚫',
        content: Text(
          'Atasan menilai indeks performa kerjamu (${performance.round()}%) belum mencukupi untuk kenaikan gaji atau promosi jabatan.\n\n'
          'Tingkatkan performa kerjamu hingga minimal 65%!',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
      );
      return;
    }

    final int currentSalary = character.jobSalary ?? 500;
    final int raiseAmount = (currentSalary * 0.15).round() + 100;
    final int newSalary = currentSalary + raiseAmount;

    setState(() {
      character.jobSalary = newSalary;
      character.happiness = (character.happiness + 15).clamp(0, 100);
    });

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Pengajuan Gaji Disetujui! 🎉📈',
      content: Text(
        'Selamat! Berkat kedisiplinan dan performa kerjamu yang solid (${performance.round()}%), atasan menyetujui kenaikan gaji!\n\n'
        '• Gaji Lama: ${CurrencySettings.format(currentSalary)}/tahun\n'
        '• Gaji Baru: ${CurrencySettings.format(newSalary)}/tahun (+15%)\n'
        '• Kebahagiaan: +15%',
        style: const TextStyle(fontSize: 13, height: 1.4),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Terima Kasih!'),
        ),
      ],
    );
  }

  void _jobTraining() {
    final character = widget.character;
    const int cost = 200;

    if (character.money < cost) {
      DialogHelper.show(
        context: context,
        title: 'Uang Tidak Cukup 💸',
        content: Text(
          'Kamu membutuhkan saldo sebesar ${CurrencySettings.format(cost)} untuk mendaftar modul pelatihan keterampilan kerja.',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
      );
      return;
    }

    setState(() {
      character.money -= cost;
      character.intelligence = (character.intelligence + 4).clamp(0, 100);
      character.discipline = (character.discipline + 6).clamp(0, 100);
    });

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Pelatihan Keterampilan Selesai 🎓⚡',
      content: Text(
        'Kamu berhasil menyelesaikan modul pelatihan keterampilan operasional!\n\n'
        '• Biaya Kursus: ${CurrencySettings.format(cost)}\n'
        '• Kecerdasan: +4%\n'
        '• Kedisiplinan: +6%',
        style: const TextStyle(fontSize: 13, height: 1.4),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Bagus!'),
        ),
      ],
    );
  }

  void _showEvaluationReport() {
    final character = widget.character;
    final double performance = ((character.discipline + character.happiness) / 2);

    String grade = 'C (Cukup)';
    Color color = Colors.orange;
    int bonus = 0;

    if (performance >= 85) {
      grade = 'S (Sangat Baik)';
      color = Colors.green;
      bonus = ((character.jobSalary ?? 500) * 0.20).round();
    } else if (performance >= 70) {
      grade = 'A (Baik)';
      color = Colors.blue;
      bonus = ((character.jobSalary ?? 500) * 0.10).round();
    } else if (performance < 50) {
      grade = 'D (Kurang)';
      color = Colors.red;
    }

    DialogHelper.show(
      context: context,
      title: 'Evaluasi Kinerja Tahun Ini 📜',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Posisi Pekerjaan: ${character.jobName ?? "Karyawan"}', style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          Text('Skor Performa Kerja: ${performance.round()}%', style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text('Nilai Evaluasi: ', style: TextStyle(fontSize: 13)),
              Text(
                grade,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (bonus > 0) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎁 Bonus Tahunan: ${CurrencySettings.format(bonus)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green.shade800),
                  ),
                  const SizedBox(height: 4),
                  const Text('Bonus telah dicairkan ke saldo tabunganmu!', style: TextStyle(fontSize: 11.5, color: Colors.black87)),
                ],
              ),
            ),
          ] else ...[
            const Text(
              'Tingkatkan performamu hingga minimal 70% untuk mengklaim bonus tahunan dari manajemen!',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ]
        ],
      ),
      actions: [
        if (bonus > 0)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                character.money += bonus;
              });
              widget.onRefresh();
              Navigator.pop(context);
            },
            child: const Text('Klaim Bonus'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  void _resign() {
    DialogHelper.show(
      context: context,
      title: 'Resign Pekerjaan 🚪',
      content: Text(
        'Apakah kamu yakin ingin mengundurkan diri dari pekerjaanmu sebagai ${widget.character.jobName}?',
        style: const TextStyle(fontSize: 13, height: 1.4),
      ),
      showCloseButton: false,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              widget.character.resignJob();
            });
            widget.onRefresh();
          },
          child: const Text('Ya, Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final character = widget.character;
    final double performance = ((character.discipline + character.happiness) / 2).clamp(0, 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karir Pekerjaan Umum 💼', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF4F6F8),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Header Custom Modern
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E3A3A), const Color(0xFF0F2323)]
                    : [Colors.teal.shade700, Colors.teal.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              character.jobName ?? 'Karyawan Umum',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gaji: ${CurrencySettings.format(character.jobSalary ?? 500)} / tahun',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Progress Bar Performa
                  Row(
                    children: [
                      const Text(
                        'Performa Kerja',
                        style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${performance.round()}%',
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: performance / 100,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        performance > 75
                            ? Colors.tealAccent
                            : performance > 45
                                ? Colors.amberAccent
                                : Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Pilih Aktivitas Pekerjaan Umum:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 12),

          // Standard Full-Width List Tiles
          _buildActivityButton(
            context: context,
            icon: Icons.trending_up,
            color: Colors.teal,
            title: 'Bekerja Lebih Giat',
            desc: 'Meningkatkan performa kerja dan hubungan dengan atasan.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => BekerjaKerasActionPage(
                    character: character,
                    onRefresh: () {
                      if (mounted) setState(() {});
                      widget.onRefresh();
                    },
                  ),
                ),
              );
            },
          ),
          _buildActivityButton(
            context: context,
            icon: Icons.group,
            color: Colors.orange,
            title: 'Rekan Kerja & Atasan 👥',
            desc: 'Berinteraksi dan membangun hubungan baik dengan rekan sekerja & bos.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => RekanKerjaPage(
                    character: character,
                    onRefresh: () {
                      if (mounted) setState(() {});
                      widget.onRefresh();
                    },
                  ),
                ),
              );
            },
          ),
          _buildActivityButton(
            context: context,
            icon: Icons.access_time_filled,
            color: Colors.blue,
            title: 'Tugas & Lembur ⏱️',
            desc: 'Mengambil shift lembur ekstra untuk memperoleh bonus uang tunai.',
            onTap: _doOvertime,
          ),
          _buildActivityButton(
            context: context,
            icon: Icons.price_check,
            color: Colors.green,
            title: 'Minta Naikan Gaji 💵',
            desc: 'Negosiasikan kenaikan gaji & posisi baru berdasarkan performa kerjamu.',
            onTap: _askRaiseOrPromotion,
          ),
          _buildActivityButton(
            context: context,
            icon: Icons.school,
            color: Colors.purple,
            title: 'Pelatihan Keterampilan Kerja 📚',
            desc: 'Mengikuti modul pelatihan untuk meningkatkan kecerdasan & kedisiplinan.',
            onTap: _jobTraining,
          ),
          _buildActivityButton(
            context: context,
            icon: Icons.local_cafe,
            color: Colors.brown,
            title: 'Istirahat Kopi & Lounge ☕',
            desc: 'Bersantai sejenak di ruang istirahat untuk memulihkan kesehatan & mood.',
            onTap: _takeCoffeeBreak,
          ),
          _buildActivityButton(
            context: context,
            icon: Icons.assessment,
            color: Colors.indigo,
            title: 'Evaluasi Kinerja & Bonus Tahunan 📜',
            desc: 'Melihat rapor evaluasi tahunan dan mengklaim bonus tunai dari atasan.',
            onTap: _showEvaluationReport,
          ),

          _buildActivityButton(
            context: context,
            icon: Icons.exit_to_app,
            color: Colors.red,
            title: 'Resign / Keluar Kerja',
            desc: 'Berhenti bekerja dari pekerjaan umum saat ini',
            onTap: _resign,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            desc,
            style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
