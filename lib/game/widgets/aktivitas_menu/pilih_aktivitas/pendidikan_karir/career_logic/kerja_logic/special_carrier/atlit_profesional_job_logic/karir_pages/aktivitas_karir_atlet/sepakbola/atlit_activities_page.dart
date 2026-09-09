// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/daftar_tim/sepakbola/aktivitas_karir_atlet/atlit_activities_page.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/actions/rekan_kerja.dart';

class AtlitActivitiesPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AtlitActivitiesPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AtlitActivitiesPage> createState() => _AtlitActivitiesPageState();
}

class _AtlitActivitiesPageState extends State<AtlitActivitiesPage> {
  final Random _random = Random();

  // Custom helper for showing result modal
  void _showResult(String title, String message, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 1. MENU LATIHAN & KONDISI FISIK
  void _doFinishingDrill() {
    widget.character.discipline = (widget.character.discipline + 4).clamp(0, 100);
    widget.character.health = (widget.character.health + 2).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showResult(
      'Latihan Finishing & Tembakan ⚽🎯',
      'Kamu menghabiskan 2 jam melatih penyelesaian akhir, volley, dan tendangan penalti. Akurasi tembakanmu meningkat! (+4 Kedisiplinan, +2 Kesehatan).',
      Icons.sports_soccer,
      Colors.green,
    );
  }

  void _doPhysicalDrill() {
    widget.character.health = (widget.character.health + 5).clamp(0, 100);
    widget.character.discipline = (widget.character.discipline + 3).clamp(0, 100);
    widget.character.happiness = (widget.character.happiness - 2).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showResult(
      'Latihan Sprint & Ketahanan 🏃‍♂️⚡',
      'Latihan fisik intensif bersama pelatih kebugaran. Fisikmu makin prima dan cepat! (+5 Kesehatan, +3 Kedisiplinan).',
      Icons.fitness_center,
      Colors.orange,
    );
  }

  void _doRestRecovery() {
    widget.character.health = (widget.character.health + 8).clamp(0, 100);
    widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showResult(
      'Istirahat & Pemulihan 🛀🌱',
      'Kamu melakukan mandi es, pijat otot, dan tidur nyenyak. Tubuhmu merasa sangat segar! (+8 Kesehatan, +5 Kebahagiaan).',
      Icons.hot_tub,
      Colors.teal,
    );
  }

  void _doPhysioConsultation() {
    if (widget.character.money < 200) {
      _showResult('Uang Tidak Cukup 💵', 'Kamu butuh \$200 untuk konsultasi fisioterapis pribadi.', Icons.warning, Colors.red);
      return;
    }

    widget.character.money -= 200;
    widget.character.health = (widget.character.health + 10).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showResult(
      'Sesi Fisioterapi 🩺✨',
      'Fisioterapis memeriksa persendian dan merawat otot kaki. Ototmu bebas dari ketegangan cedera! (- \$200, +10 Kesehatan).',
      Icons.medical_services,
      Colors.blue,
    );
  }

  // 3. NEGOSIASI KONTRAK & AGEN
  void _negotiateContract() {
    final bool success = _random.nextInt(100) < 65;
    if (success) {
      final int raise = (widget.character.jobSalary! * 0.25).round();
      widget.character.jobSalary = widget.character.jobSalary! + raise;
      widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
      setState(() {});
      widget.onRefresh();

      _showResult(
        'Negosiasi Sukses! 📝💰',
        'Manajemen klub menyetujui kenaikan gajimu sebesar 25%! Gaji barumu kini ${CurrencySettings.format(widget.character.jobSalary!)}/tahun.',
        Icons.verified,
        Colors.green,
      );
    } else {
      widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
      setState(() {});
      widget.onRefresh();

      _showResult(
        'Negosiasi Ulet 🚫',
        'Klub menolak menaikkan gaji saat ini. Mereka meminta bukti performa yang lebih konsisten di lapangan.',
        Icons.cancel,
        Colors.red,
      );
    }
  }

  void _consultAgent() {
    _showResult(
      'Konsultasi Agen 💼',
      'Agenmu melaporkan bahwa 2 klub besar sedang memantau perkembanganmu untuk bursa transfer mendatang. Jaga performamu tetap tinggi!',
      Icons.record_voice_over,
      Colors.purple,
    );
  }

  void _showCareerHistoryModal() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final history = widget.character.athleteSeasonStats;

    int totalAppearances = 0;
    int totalGoals = 0;
    int totalAssists = 0;
    double sumRating = 0.0;
    int countRating = 0;

    for (var item in history) {
      final app = item['appearances'];
      final g = item['goals'];
      final a = item['assists'];
      final r = item['rating'];

      if (app is int) {
        totalAppearances += app;
      } else if (app != null) {
        totalAppearances += int.tryParse(app.toString()) ?? 0;
      }

      if (g is int) {
        totalGoals += g;
      } else if (g != null) {
        totalGoals += int.tryParse(g.toString()) ?? 0;
      }

      if (a is int) {
        totalAssists += a;
      } else if (a != null) {
        totalAssists += int.tryParse(a.toString()) ?? 0;
      }

      if (r is num) {
        sumRating += r.toDouble();
        countRating++;
      } else if (r != null) {
        final parsedR = double.tryParse(r.toString());
        if (parsedR != null) {
          sumRating += parsedR;
          countRating++;
        }
      }
    }

    final double avgCareerRating = countRating > 0 ? (sumRating / countRating) : 0.0;
    final String avgRatingText = countRating > 0 ? '${avgCareerRating.toStringAsFixed(1)} ⭐' : '0.0 ⭐';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(ctx).size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history, color: Colors.purple, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    'Riwayat Karir & Statistik Musim 📜',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // CARD TOTAL KARIER KESELURUHAN
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? Colors.purple.shade700 : Colors.purple.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.workspace_premium, size: 16, color: Colors.purple),
                        const SizedBox(width: 6),
                        Text(
                          'TOTAL KARIR KESELURUHAN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTotalStatItem('Total Main', '$totalAppearances Laga', Icons.sports_soccer, Colors.blue, isDark),
                        _buildTotalStatItem('Total Gol', '$totalGoals ⚽', Icons.sports_score, Colors.green, isDark),
                        _buildTotalStatItem('Total Assist', '$totalAssists 👟', Icons.handshake, Colors.orange, isDark),
                        _buildTotalStatItem('Rating Karir', avgRatingText, Icons.star, Colors.amber, isDark),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (history.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'Belum ada statistik musim lalu.\nStatistik otomatis berjalan saat kamu bertambah umur (1 tahun)! ⏳',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.grey, fontSize: 13),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (ctx, index) {
                      final item = history[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: isDark ? Colors.grey.shade800 : Colors.purple.shade50.withValues(alpha: 0.5),
                        child: ListTile(
                          title: Text(
                            'Musim Usia ${item['age']} Tahun - ${item['team']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.purple),
                          ),
                          subtitle: Text(
                            '• Main: ${item['appearances']} Laga | Gol: ${item['goals']} ⚽ | Assist: ${item['assists']} 👟\n'
                            '• Performa Rating Rata-rata: ${item['rating']} / 10.0',
                            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotalStatItem(String label, String value, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey.shade700),
        ),
      ],
    );
  }

  // 4. MEDIA & MEDIA SOSIAL
  void _pressConference() {
    final bool positiveRep = _random.nextBool();
    if (positiveRep) {
      widget.character.happiness = (widget.character.happiness + 5).clamp(0, 100);
      _showResult(
        'Konferensi Pers 🎙️✨',
        'Jawabanmu yang rendah hati dipuji oleh wartawan dan pelatih. Kepercayaan publik meningkat!',
        Icons.mic,
        Colors.blue,
      );
    } else {
      _showResult(
        'Konferensi Pers 🎙️🔥',
        'Pernyataanmu memicu perdebatan panas di media olahraga. Fans menantikan pembuktianmu di pertandingan!',
        Icons.campaign,
        Colors.orange,
      );
    }
    setState(() {});
    widget.onRefresh();
  }

  void _postSocialMedia() {
    widget.character.happiness = (widget.character.happiness + 4).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showResult(
      'Unggahan Sosial Media 📲',
      'Kamu mengunggah foto latihan hari ini. Ribuan likes dan komentar dukungan dari suporter membanjiri akunmu!',
      Icons.thumb_up,
      Colors.lightBlue,
    );
  }

  // 5. HUBUNGAN TIM & BONDING
  void _teamDinner() {
    if (widget.character.money < 300) {
      _showResult('Uang Tidak Cukup 💵', 'Kamu butuh \$300 untuk mentraktir makan malam tim.', Icons.warning, Colors.red);
      return;
    }

    widget.character.money -= 300;
    widget.character.happiness = (widget.character.happiness + 8).clamp(0, 100);
    for (var cw in widget.character.coworkers) {
      int r = int.tryParse(cw['relationship'] ?? '50') ?? 50;
      cw['relationship'] = (r + 10).clamp(0, 100).toString();
    }
    setState(() {});
    widget.onRefresh();

    _showResult(
      'Makan Malam Tim 🥩🍷',
      'Kamu mengajak tim utama & cadangan makan malam bersama. Kekompakan dan suasana ruang ganti semakin solid! (+10% Hubungan Rekan Tim).',
      Icons.restaurant,
      Colors.amber.shade800,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final int fitnessVal = widget.character.health;
    final String statusStarter = ((widget.character.discipline + widget.character.health) / 2) >= 65 ? 'Pemain Utama (Starter) ⭐' : 'Pemain Cadangan 👥';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Karir Atlet ⚽🏆'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // STATUS BAR PEMAIN ATLET
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.green.shade50.withValues(alpha: 0.7),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.sports_soccer, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.character.jobName ?? 'Atlet Profesional',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : Colors.green.shade900,
                              ),
                            ),
                            Text(
                              'Status Skuad: $statusStarter',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description, size: 16, color: Colors.blue),
                          const SizedBox(width: 6),
                          Text(
                            'Kontrak Tersisa:',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: widget.character.athleteContractYears <= 1 ? Colors.red.shade100 : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.character.athleteContractYears} Tahun',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.character.athleteContractYears <= 1 ? Colors.red.shade900 : Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.fitness_center, size: 16, color: Colors.green),
                          const SizedBox(width: 6),
                          Text('Kebugaran & Stamina:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                        ],
                      ),
                      Text('$fitnessVal%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: fitnessVal >= 70 ? Colors.green : Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: fitnessVal / 100,
                      minHeight: 10,
                      backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(fitnessVal >= 70 ? Colors.green : (fitnessVal >= 40 ? Colors.amber : Colors.red)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // KATEGORI 1: LATIHAN & KONDISI FISIK
          _buildCategoryHeader('LATIHAN & KONDISI FISIK', Icons.fitness_center, Colors.orange),
          _buildActionCard(
            title: 'Latihan Finishing & Shooting 🎯',
            subtitle: 'Melatih penyelesaian akhir, sepakan insting, dan volley',
            icon: Icons.sports_soccer,
            color: Colors.green,
            onTap: _doFinishingDrill,
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Latihan Fisik & Kecepatan 🏃‍♂️',
            subtitle: 'Meningkatkan ketahanan otot dan kecepatan sprint',
            icon: Icons.speed,
            color: Colors.orange,
            onTap: _doPhysicalDrill,
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Pemulihan & Mandi Es 🛀',
            subtitle: 'Memulihkan stamina dan mencegah kelelahan otot',
            icon: Icons.hot_tub,
            color: Colors.teal,
            onTap: _doRestRecovery,
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Konsultasi Fisioterapis 🩺',
            subtitle: 'Merawat persendian dan mencegah kecenderungan cedera (\$200)',
            icon: Icons.medical_services,
            color: Colors.blue,
            onTap: _doPhysioConsultation,
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // KATEGORI 2: PERTANDINGAN & KARIER INTI
          _buildCategoryHeader('PERTANDINGAN & STATISTIK', Icons.stadium, Colors.deepOrange),
          _buildActionCard(
            title: 'Riwayat Karir & Statistik Musim 📜',
            subtitle: 'Lihat perjalanan gol, assist, dan rating per perambahan usia',
            icon: Icons.history,
            color: Colors.purple,
            onTap: _showCareerHistoryModal,
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // KATEGORI 3: KONTRAK & MANAJEMEN
          _buildCategoryHeader('KONTRAK & MANAJEMEN', Icons.business_center, Colors.purple),
          _buildActionCard(
            title: 'Negosiasi Kenaikan Kontrak 📝',
            subtitle: 'Minta kenaikan nilai gaji tahunan kepada manajemen klub',
            icon: Icons.monetization_on,
            color: Colors.purple,
            onTap: _negotiateContract,
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Diskusi Bersama Agen 💼',
            subtitle: 'Membahas peluang bursa transfer dan minat klub lain',
            icon: Icons.record_voice_over,
            color: Colors.deepPurple,
            onTap: _consultAgent,
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // KATEGORI 4: SOSIAL & MEDIA
          _buildCategoryHeader('SOSIAL & MEDIA FANS', Icons.campaign, Colors.lightBlue),
          _buildActionCard(
            title: 'Hadir di Konferensi Pers 🎙️',
            subtitle: 'Berikan pernyataan pers setelah sesi latihan/pertandingan',
            icon: Icons.mic,
            color: Colors.lightBlue,
            onTap: _pressConference,
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Unggah Aktivitas di Medsos 📲',
            subtitle: 'Berinteraksi dengan penggemar dan meningkatkan popularitas',
            icon: Icons.thumb_up,
            color: Colors.blueAccent,
            onTap: _postSocialMedia,
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // KATEGORI 5: TIM & BONDING
          _buildCategoryHeader('KEKOMPAKAN & REKAN TIM', Icons.group, Colors.amber.shade800),
          _buildActionCard(
            title: 'Makan Malam Bersama Tim 🥩',
            subtitle: 'Mentraktir rekan tim utama & cadangan (\$300)',
            icon: Icons.restaurant,
            color: Colors.amber.shade800,
            onTap: _teamDinner,
            isDark: isDark,
          ),
          _buildActionCard(
            title: 'Rekan Tim Utama & Cadangan 👥',
            subtitle: 'Berinteraksi, membangun chemistry, dan mengobrol bersama rekan',
            icon: Icons.group,
            color: Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RekanKerjaPage(
                    character: widget.character,
                    onRefresh: () {
                      if (mounted) setState(() {});
                      widget.onRefresh();
                    },
                  ),
                ),
              );
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title, IconData icon, Color color) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: isDark ? Colors.white70 : Colors.blueGrey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 22),
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
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54),
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white54 : Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
