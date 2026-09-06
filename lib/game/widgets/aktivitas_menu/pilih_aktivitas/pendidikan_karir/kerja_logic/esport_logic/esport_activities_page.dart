// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/esport_logic/esport_activities_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class EsportActivitiesPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const EsportActivitiesPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<EsportActivitiesPage> createState() => _EsportActivitiesPageState();
}

class _EsportActivitiesPageState extends State<EsportActivitiesPage> {
  final Random _random = Random();
  bool _scrimCooldown = false; // Cooldown for Pro Player Scrim

  void _showResultDialog({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(content, style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onRefresh();
              if (mounted) setState(() {});
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // BRAND AMBASSADOR & TALENT ACTIVITIES
  // ==========================================

  void _doMeetAndGreet() {
    if (widget.character.money < 100) {
      _showResultDialog(
        title: 'Uang Kurang 💸',
        content: 'Kamu membutuhkan \$100 untuk biaya transportasi dan akomodasi acara Meet & Greet.',
        icon: Icons.money_off,
        color: Colors.red,
      );
      return;
    }

    setState(() {
      widget.character.money -= 100;
      widget.character.happiness = (widget.character.happiness + 20).clamp(0, 100);
      widget.character.appearance = (widget.character.appearance + 10).clamp(0, 100);
      widget.character.health = (widget.character.health - 10).clamp(10, 100);
    });

    _showResultDialog(
      title: 'Meet & Greet Sukses! 📸',
      content: 'Penggemarmu sangat senang bertemu denganmu!\n\n'
          '• Kebahagiaan: +20%\n'
          '• Penampilan: +10%\n'
          '• Kesehatan: -10% (Capek bertemu banyak orang)\n'
          '• Biaya: -\$100',
      icon: Icons.photo_camera,
      color: Colors.pinkAccent,
    );
  }

  void _doSponsorship() {
    final isBadProduct = _random.nextDouble() < 0.20; // 20% chance of bad product

    if (isBadProduct) {
      setState(() {
        widget.character.money += 500;
        widget.character.appearance = (widget.character.appearance - 10).clamp(0, 100);
        widget.character.happiness = (widget.character.happiness - 10).clamp(0, 100);
      });
      _showResultDialog(
        title: 'Skandal Endorse! ⚠️',
        content: 'Produk yang kamu iklankan ternyata bermasalah dan merusak reputasimu!\n\n'
            '• Uang diterima: +\$500\n'
            '• Penampilan: -10%\n'
            '• Kebahagiaan: -10%',
        icon: Icons.warning,
        color: Colors.redAccent,
      );
    } else {
      setState(() {
        widget.character.money += 500;
        widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
      });
      _showResultDialog(
        title: 'Sponsorship Sukses! 💰',
        content: 'Iklan berjalan dengan lancar dan brand sangat puas dengan performamu.\n\n'
            '• Uang diterima: +\$500\n'
            '• Kebahagiaan: +10%',
        icon: Icons.monetization_on,
        color: Colors.green,
      );
    }
  }

  void _doPublicSpeaking() {
    setState(() {
      widget.character.intelligence = (widget.character.intelligence + 10).clamp(0, 100);
      widget.character.discipline = (widget.character.discipline + 10).clamp(0, 100);
    });

    _showResultDialog(
      title: 'Kelas Berbicara & Akting 🎤',
      content: 'Kamu belajar bagaimana berbicara dengan percaya diri di depan publik.\n\n'
          '• Kecerdasan: +10%\n'
          '• Kedisiplinan: +10%',
      icon: Icons.mic,
      color: Colors.blueAccent,
    );
  }

  void _doContractNegotiation() {
    final double successRate = (widget.character.discipline >= 60 && widget.character.appearance >= 60) ? 0.75 : 0.35;
    final isSuccess = _random.nextDouble() < successRate;

    if (isSuccess) {
      setState(() {
        widget.character.jobSalary = (widget.character.jobSalary ?? 0) + 300;
      });
      _showResultDialog(
        title: 'Negosiasi Sukses! 📑',
        content: 'Manajemen menyetujui kinerjamu yang luar biasa dan menaikkan gajimu!\n\n'
            '• Gaji Tahunan Permanen: +\$300/tahun',
        icon: Icons.assignment_turned_in,
        color: Colors.green,
      );
    } else {
      if (widget.character.supervisor != null) {
        final currentRel = int.tryParse(widget.character.supervisor!['relationship'] ?? '50') ?? 50;
        widget.character.supervisor!['relationship'] = (currentRel - 15).clamp(0, 100).toString();
      }
      _showResultDialog(
        title: 'Negosiasi Ditolak 🚫',
        content: 'Manajemen merasa tuntutanmu terlalu tinggi saat ini.\n\n'
            '• Hubungan dengan Atasan: -15%',
        icon: Icons.cancel,
        color: Colors.red,
      );
    }
  }

  void _doInteractWithPro() {
    if (widget.character.coworkers.isEmpty) {
      _showResultDialog(
        title: 'Tidak Ada Rekan Kerja',
        content: 'Kamu belum memiliki rekan kerja pro player di tim ini.',
        icon: Icons.people_outline,
        color: Colors.grey,
      );
      return;
    }

    final targetIdx = _random.nextInt(widget.character.coworkers.length);
    final coworker = widget.character.coworkers[targetIdx];
    final currentRel = int.tryParse(coworker['relationship'] ?? '50') ?? 50;
    coworker['relationship'] = (currentRel + 15).clamp(0, 100).toString();

    final name = coworker['name'] ?? 'Rekan Kerja';

    // 20% chance of getting a Pro Player job offer opportunity
    final gotOffer = _random.nextDouble() < 0.20;
    String extra = '';
    if (gotOffer && !widget.character.jobName!.startsWith('Pro Player Esport')) {
      extra = '\n\n$name juga merekomendasikanmu untuk dicoba sebagai pro player cadangan!';
    }

    _showResultDialog(
      title: 'Interaksi Pro Player 🎮',
      content: 'Kamu makan siang bersama dan bermain game dengan pro player $name.$extra\n\n'
          '• Hubungan dengan $name: +15%',
      icon: Icons.sports_esports,
      color: Colors.indigo,
    );
  }

  // ==========================================
  // PRO PLAYER ACTIVITIES
  // ==========================================

  void _doScrim() {
    if (_scrimCooldown) {
      _showResultDialog(
        title: 'Cooldown Scrim ⏳',
        content: 'Kamu sudah menjalani latihan intensif hari ini. Istirahatlah sejenak!',
        icon: Icons.timer,
        color: Colors.orange,
      );
      return;
    }

    setState(() {
      _scrimCooldown = true;
      widget.character.intelligence = (widget.character.intelligence + 15).clamp(0, 100);
      widget.character.discipline = (widget.character.discipline + 10).clamp(0, 100);
      widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
    });

    _showResultDialog(
      title: 'Latihan Scrim Selesai 🎮',
      content: 'Kamu berlatih strategi pertandingan (scrimmage) bersama tim.\n\n'
          '• Kecerdasan: +15%\n'
          '• Kedisiplinan: +10%\n'
          '• Kebahagiaan: -5% (Melelahkan)',
      icon: Icons.computer,
      color: Colors.blue,
    );
  }

  void _doTournament() {
    final double winChance = (widget.character.intelligence + widget.character.health) / 200.0;
    final isWin = _random.nextDouble() < winChance;

    if (isWin) {
      setState(() {
        widget.character.money += 1000;
        widget.character.happiness = (widget.character.happiness + 30).clamp(0, 100);
      });
      _showResultDialog(
        title: 'Juara Turnamen! 🏆',
        content: 'Kerja keras tim berbuah hasil manis! Kalian memenangkan trofi juara!\n\n'
            '• Hadiah turnamen: +\$1,000\n'
            '• Kebahagiaan: +30%',
        icon: Icons.emoji_events,
        color: Colors.amber,
      );
    } else {
      setState(() {
        widget.character.happiness = (widget.character.happiness - 20).clamp(0, 100);
      });
      _showResultDialog(
        title: 'Kekalahan Turnamen 😢',
        content: 'Kalian harus gugur di babak gugur. Lawan terlalu kuat kali ini.\n\n'
            '• Kebahagiaan: -20%',
        icon: Icons.sentiment_very_dissatisfied,
        color: Colors.redAccent,
      );
    }
  }

  void _doRehab() {
    setState(() {
      widget.character.health = (widget.character.health + 15).clamp(0, 100);
      widget.character.appearance = (widget.character.appearance + 5).clamp(0, 100);
    });

    _showResultDialog(
      title: 'Terapi & Gym 🏋️',
      content: 'Menjalani fisioterapi pergelangan tangan dan latihan fisik agar tetap bugar.\n\n'
          '• Kesehatan: +15%\n'
          '• Penampilan: +5%',
      icon: Icons.fitness_center,
      color: Colors.green,
    );
  }

  void _doVodReview() {
    setState(() {
      widget.character.intelligence = (widget.character.intelligence + 15).clamp(0, 100);
      widget.character.happiness = (widget.character.happiness - 5).clamp(0, 100);
    });

    _showResultDialog(
      title: 'Analisa VOD Pertandingan 🧠',
      content: 'Menganalisa kelemahan taktik musuh dari rekaman pertandingan replay.\n\n'
          '• Kecerdasan: +15%\n'
          '• Kebahagiaan: -5% (Membosankan)',
      icon: Icons.menu_book,
      color: Colors.purple,
    );
  }

  void _doMentalCoach() {
    setState(() {
      widget.character.happiness = (widget.character.happiness + 15).clamp(0, 100);
      widget.character.discipline = (widget.character.discipline + 10).clamp(0, 100);
    });

    _showResultDialog(
      title: 'Konsultasi Mental Coach 🧘',
      content: 'Berdiskusi dengan psikolog tim untuk meredakan kecemasan dan stres.\n\n'
          '• Kebahagiaan: +15%\n'
          '• Kedisiplinan: +10%',
      icon: Icons.self_improvement,
      color: Colors.teal,
    );
  }

  void _doLiveStream() {
    setState(() {
      widget.character.money += 100;
      widget.character.happiness = (widget.character.happiness + 10).clamp(0, 100);
    });

    _showResultDialog(
      title: 'Live Streaming Pribadi 📱',
      content: 'Melakukan siaran langsung bermain game dan menyapa penggemar.\n\n'
          '• Donasi diterima: +\$100\n'
          '• Kebahagiaan: +10%',
      icon: Icons.live_tv,
      color: Colors.redAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String jobTitle = widget.character.jobName ?? '';
    final bool isBAOrTalent = jobTitle.startsWith('Brand Ambassador Esport') || jobTitle.startsWith('Talent Esports');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Aktivitas Karir Esport 🎮', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: isDark ? Colors.grey.shade900 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.indigo.shade50,
                      child: const Icon(Icons.sports_esports, color: Colors.indigo, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobTitle,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Status Uangmu: \$${widget.character.money}',
                            style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Pilih Aktivitas:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            if (isBAOrTalent) ...[
              _buildActivityButton(
                context: context,
                icon: Icons.photo_camera,
                color: Colors.pink,
                title: 'Event Meet & Greet / Fansign',
                desc: 'Menguras Kesehatan tetapi meningkatkan Kebahagiaan dan Penampilan. Biaya: \$100.',
                onTap: _doMeetAndGreet,
              ),
              _buildActivityButton(
                context: context,
                icon: Icons.monetization_on,
                color: Colors.green,
                title: 'Iklan & Sponsorship Produk',
                desc: 'Terima tawaran endorsement. Dapat uang instan, tapi berisiko merusak reputasi jika produk bermasalah.',
                onTap: _doSponsorship,
              ),
              _buildActivityButton(
                context: context,
                icon: Icons.mic,
                color: Colors.blueAccent,
                title: 'Latihan Public Speaking & Akting',
                desc: 'Meningkatkan Kecerdasan dan Kedisiplinan agar performamu semakin profesional.',
                onTap: _doPublicSpeaking,
              ),
              _buildActivityButton(
                context: context,
                icon: Icons.assignment_turned_in,
                color: Colors.teal,
                title: 'Review Kontrak & Negosiasi Bonus',
                desc: 'Negosiasikan kenaikan gaji berdasarkan performa kedisiplinan dan penampilanmu.',
                onTap: _doContractNegotiation,
              ),
              _buildActivityButton(
                context: context,
                icon: Icons.sports_esports,
                color: Colors.indigo,
                title: 'Interaksi Khusus dengan Pro Player',
                desc: 'Bermain game atau makan siang bersama roster pro player untuk mempererat hubungan.',
                onTap: _doInteractWithPro,
              ),
            ] else ...[
              _buildActivityButton(
                context: context,
                icon: Icons.computer,
                color: Colors.blue,
                title: 'Latihan Scrim / Latihan Tim',
                desc: 'Latihan tanding taktis bersama tim. Menambah Kecerdasan game dan Kedisiplinan.',
                onTap: _doScrim,
              ),
              _buildActivityButton(
                context: context,
                icon: Icons.emoji_events,
                color: Colors.amber,
                title: 'Ikut Turnamen / Kompetisi',
                desc: 'Turnamen tingkat tinggi. Berhasil jika game sense-mu kuat. Hadiah uang besar!',
                onTap: _doTournament,
              ),
              _buildActivityButton(
                context: context,
                icon: Icons.fitness_center,
                color: Colors.green,
                title: 'Latihan Fisik & Rehabilitasi',
                desc: 'Menjaga refleks tangan dan kebugaran tubuh agar terhindar dari cedera.',
                onTap: _doRehab,
              ),
              _buildActivityButton(
                context: context,
                icon: Icons.menu_book,
                color: Colors.purple,
                title: 'Analisa VOD / Replay',
                desc: 'Menonton rekaman musuh untuk menambah Kecerdasan secara taktis.',
                onTap: _doVodReview,
              ),
              _buildActivityButton(
                context: context,
                icon: Icons.self_improvement,
                color: Colors.teal,
                title: 'Konsultasi Mental Coach',
                desc: 'Sesi psikologi olahraga untuk meredakan burnout mental dan memicu motivasi.',
                onTap: _doMentalCoach,
              ),
              _buildActivityButton(
                context: context,
                icon: Icons.live_tv,
                color: Colors.redAccent,
                title: 'Interaksi Fans & Live Streaming',
                desc: 'Live streaming game untuk mendulang donasi uang tunai dari penggemar.',
                onTap: _doLiveStream,
              ),
            ],
          ],
        ),
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
      color: isDark ? Colors.grey.shade900 : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
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
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
