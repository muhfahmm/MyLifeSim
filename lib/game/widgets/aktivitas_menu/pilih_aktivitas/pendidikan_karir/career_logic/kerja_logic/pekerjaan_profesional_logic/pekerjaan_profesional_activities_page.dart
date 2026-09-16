// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/pekerjaan_profesional_logic/pekerjaan_profesional_activities_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import '../actions/rekan_kerja.dart';
import '../actions/bekerja_keras.dart';
import 'dart:math';

class PekerjaanProfesionalActivitiesPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PekerjaanProfesionalActivitiesPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PekerjaanProfesionalActivitiesPage> createState() => _PekerjaanProfesionalActivitiesPageState();
}

class _PekerjaanProfesionalActivitiesPageState extends State<PekerjaanProfesionalActivitiesPage> {
  final Random _random = Random();

  void _executeSpecialProject() {
    final character = widget.character;
    if (character.health < 15) {
      DialogHelper.show(
        context: context,
        title: 'Kondisi Fisik Menurun ⚡',
        content: const Text(
          'Kesehatan dan kondisi fisikmu tidak mencukupi untuk menangani proyek eksekutif bermuatan tinggi! Istirahatlah terlebih dahulu.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
      );
      return;
    }

    final bool isSuccess = _random.nextDouble() < 0.80;
    final int projectBonus = ((character.jobSalary ?? 2000) * 0.15).round() + 500 + _random.nextInt(1500);

    setState(() {
      character.health = (character.health - 15).clamp(0, 100);
      character.discipline = (character.discipline + 5).clamp(0, 100);
      character.intelligence = (character.intelligence + 3).clamp(0, 100);
      if (isSuccess) {
        character.money += projectBonus;
        character.happiness = (character.happiness + 10).clamp(0, 100);
      } else {
        character.happiness = (character.happiness - 10).clamp(0, 100);
      }
    });

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: isSuccess ? 'Proyek Eksekutif Sukses! 💼⭐' : 'Proyek Bermasalah ⚠️',
      content: Text(
        isSuccess
            ? 'Kamu berhasil menangani klien eksekutif dengan hasil yang sangat memuaskan!\n\n'
              '• Bonus Proyek: ${CurrencySettings.format(projectBonus)}\n'
              '• Kecerdasan: +3%\n'
              '• Kedisiplinan: +5%\n'
              '• Kebahagiaan: +10%'
            : 'Terjadi sedikit kendala teknis pada proyek, namun kamu berhasil menyelesaikannya dengan usaha ekstra.\n\n'
              '• Kesehatan: -15%\n'
              '• Kebahagiaan: -10%',
        style: const TextStyle(fontSize: 13, height: 1.4),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo.shade800,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Lanjutkan'),
        ),
      ],
    );
  }

  void _attendProfessionalSeminar() {
    final character = widget.character;
    const int cost = 500;

    if (character.money < cost) {
      DialogHelper.show(
        context: context,
        title: 'Uang Tidak Cukup 💸',
        content: Text(
          'Kamu membutuhkan saldo sebesar ${CurrencySettings.format(cost)} untuk mendaftar seminar & lisensi sertifikasi profesional.',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
      );
      return;
    }

    setState(() {
      character.money -= cost;
      character.intelligence = (character.intelligence + 8).clamp(0, 100);
      character.discipline = (character.discipline + 6).clamp(0, 100);
      character.happiness = (character.happiness + 5).clamp(0, 100);
    });

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Seminar & Sertifikasi Selesai 🏆📜',
      content: Text(
        'Kamu mempresentasikan kertas kerja dan meraih sertifikasi kompetensi industri profesional!\n\n'
        '• Biaya Seminar: ${CurrencySettings.format(cost)}\n'
        '• Kecerdasan: +8%\n'
        '• Kedisiplinan: +6%\n'
        '• Kebahagiaan: +5%',
        style: const TextStyle(fontSize: 13, height: 1.4),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Luar Biasa!'),
        ),
      ],
    );
  }

  void _negotiateCompensation() {
    final character = widget.character;
    final double performance = ((character.discipline + character.happiness) / 2);

    if (performance < 70) {
      DialogHelper.show(
        context: context,
        title: 'Negosiasi Ditolak 🚫',
        content: Text(
          'Dewan Direksi menilai indeks performa kerjamu (${performance.round()}%) belum memenuhi ambang batas promosi profesional (minimal 70%).\n\n'
          'Tingkatkan reputasi & kedisiplinan kerjamu!',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
      );
      return;
    }

    final int currentSalary = character.jobSalary ?? 2000;
    final int raiseAmount = (currentSalary * 0.20).round() + 500;
    final int newSalary = currentSalary + raiseAmount;

    setState(() {
      character.jobSalary = newSalary;
      character.happiness = (character.happiness + 20).clamp(0, 100);
    });

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Negosiasi Kompensasi Disetujui! 🥂💎',
      content: Text(
        'Direksi menyetujui kenaikan kompensasi & paket benefit eksekutif profesionalmu!\n\n'
        '• Gaji Lama: ${CurrencySettings.format(currentSalary)}/tahun\n'
        '• Gaji Baru: ${CurrencySettings.format(newSalary)}/tahun (+20%)\n'
        '• Kebahagiaan: +20%',
        style: const TextStyle(fontSize: 13, height: 1.4),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade800,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Terima Kasih!'),
        ),
      ],
    );
  }

  void _executiveLoungeBreak() {
    final character = widget.character;
    setState(() {
      character.health = (character.health + 15).clamp(0, 100);
      character.happiness = (character.happiness + 15).clamp(0, 100);
    });

    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Executive Lounge Break ☕🥂',
      content: const Text(
        'Kamu menikmati hidangan berkelas dan berdiskusi di Executive Lounge bersama kolega & pimpinan perusahaan!\n\n'
        '• Kesehatan: +15%\n'
        '• Kebahagiaan: +15%',
        style: TextStyle(fontSize: 13, height: 1.4),
      ),
    );
  }

  void _showCareerAudit() {
    final character = widget.character;
    final double performance = ((character.discipline + character.happiness) / 2).clamp(0, 100);

    String rank = 'Senior Specialist';
    Color rankColor = Colors.indigo;
    int bonus = 0;

    if (performance >= 88) {
      rank = 'Executive Director';
      rankColor = Colors.amber.shade700;
      bonus = ((character.jobSalary ?? 2000) * 0.30).round();
    } else if (performance >= 72) {
      rank = 'Principal Associate';
      rankColor = Colors.purple;
      bonus = ((character.jobSalary ?? 2000) * 0.18).round();
    } else if (performance < 55) {
      rank = 'Junior Associate';
      rankColor = Colors.grey;
    }

    DialogHelper.show(
      context: context,
      title: 'Audit & Portofolio Karir 🏆',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profesi Profesional: ${character.jobName ?? "Profesional"}', style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          Text('Indeks Performa & Reputasi: ${performance.round()}%', style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text('Level Jabatan: ', style: TextStyle(fontSize: 13)),
              Text(
                rank,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: rankColor),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (bonus > 0) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💎 Deviden & Bonus Eksekutif: ${CurrencySettings.format(bonus)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.indigo.shade900),
                  ),
                  const SizedBox(height: 4),
                  const Text('Bonus direksi telah ditambahkan ke asetmu!', style: TextStyle(fontSize: 11.5, color: Colors.black87)),
                ],
              ),
            ),
          ] else ...[
            const Text(
              'Tingkatkan reputasi hingga minimal 72% untuk mendapatkan pembagian deviden eksekutif dari Dewan Direksi!',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ]
        ],
      ),
      actions: [
        if (bonus > 0)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                character.money += bonus;
              });
              widget.onRefresh();
              Navigator.pop(context);
            },
            child: const Text('Klaim Deviden'),
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
      title: 'Resign Karir Profesional 🚪',
      content: Text(
        'Apakah kamu yakin ingin mengundurkan diri dari perusahaan/firma sebagai ${widget.character.jobName}?',
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
          child: const Text('Ya, Resign', style: TextStyle(fontWeight: FontWeight.bold)),
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
        title: const Text('Karir Pekerjaan Profesional 💎', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF4F5F9),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Header Custom Premium/Eksekutif
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1A1C2E), const Color(0xFF0F101A)]
                    : [Colors.indigo.shade800, const Color(0xFF1E1E38)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.withValues(alpha: 0.3),
                  blurRadius: 12,
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
                          color: Colors.amber.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber.withValues(alpha: 0.4), width: 1.5),
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          size: 32,
                          color: Colors.amberAccent,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              character.jobName ?? 'Profesional Eksekutif',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Kompensasi: ${CurrencySettings.format(character.jobSalary ?? 2000)} / tahun',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Progress Bar Indeks Reputasi & Performa
                  Row(
                    children: [
                      const Text(
                        'Indeks Performa & Reputasi',
                        style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${performance.round()}%',
                        style: const TextStyle(fontSize: 12, color: Colors.amberAccent, fontWeight: FontWeight.bold),
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
                            ? Colors.amberAccent
                            : performance > 45
                                ? Colors.lightBlueAccent
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
            'Pilih Aktivitas Karir Profesional:',
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
            color: Colors.indigo,
            title: 'Kerja & Riset Intensif',
            desc: 'Meningkatkan performa kerja dan indeks reputasi industri profesional.',
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
            icon: Icons.groups_rounded,
            color: Colors.purple,
            title: 'Kolega & Direksi Perusahaan 👥',
            desc: 'Membangun relasi eksekutif dengan kolega sejawat & anggota dewan direksi.',
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
            icon: Icons.card_travel,
            color: Colors.blue,
            title: 'Proyek & Klien Eksekutif 💼',
            desc: 'Menangani klien eksekutif bernilai tinggi untuk mendapatkan bonus finansial besar.',
            onTap: _executeSpecialProject,
          ),
          _buildActivityButton(
            context: context,
            icon: Icons.monetization_on,
            color: Colors.amber.shade800,
            title: 'Negosiasi Gaji & Kompensasi 💎',
            desc: 'Negosiasikan paket deviden & kompensasi baru dengan Dewan Direksi.',
            onTap: _negotiateCompensation,
          ),
          _buildActivityButton(
            context: context,
            icon: Icons.school,
            color: Colors.deepPurple,
            title: 'Sertifikasi & Lisensi Industri 🎓',
            desc: 'Mengikuti seminar nasional/internasional & ujian lisensi kompetensi.',
            onTap: _attendProfessionalSeminar,
          ),
          _buildActivityButton(
            context: context,
            icon: Icons.local_bar,
            color: Colors.teal,
            title: 'Executive Lounge & Networking ☕',
            desc: 'Networking santai bersama para pemimpin industri di Executive Lounge.',
            onTap: _executiveLoungeBreak,
          ),
          _buildActivityButton(
            context: context,
            icon: Icons.workspace_premium,
            color: Colors.amber.shade700,
            title: 'Portofolio & Audit Karir 🏆',
            desc: 'Melihat jenjang jabatan (Senior/Principal/Director) & klaim deviden tahunan.',
            onTap: _showCareerAudit,
          ),

          _buildActivityButton(
            context: context,
            icon: Icons.exit_to_app,
            color: Colors.red,
            title: 'Resign / Keluar Kerja',
            desc: 'Berhenti bekerja dari posisi karir profesional saat ini',
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
