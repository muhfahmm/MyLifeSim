// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/aktor_film_job_logic/menu_aktor/syuting_produksi_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

import 'package:mylifesim/game/widgets/dialog_helper.dart';

class SyutingProduksiPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const SyutingProduksiPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<SyutingProduksiPage> createState() => _SyutingProduksiPageState();
}

class _SyutingProduksiPageState extends State<SyutingProduksiPage> {
  void _showAlert(String title, String desc) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(desc, style: const TextStyle(fontSize: 13)),
    );
  }

  void _pendalamanKarakter() {
    final r = Random();
    final int gain = r.nextInt(3) + 2;
    widget.character.intelligence = (widget.character.intelligence + gain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Pendalaman Karakter & Method Acting 🎭',
      'Kamu mempelajari latar belakang psikologis dan emosi karakter peranmu selama bertumpuk jam.\n\n'
      '• Penghayatan Peran & Inteligensi: +$gain',
    );
  }

  void _latihanAdeganSpesifik(String namaAdegan, String efekDetail, bool risikoCedera, int gainsPop) {
    final r = Random();
    if (risikoCedera) {
      final bool isSuccess = r.nextInt(100) < widget.character.health;
      if (isSuccess) {
        widget.character.popularity = (widget.character.popularity + gainsPop).clamp(0, 100);
        setState(() {});
        widget.onRefresh();

        _showAlert(
          'Adegan $namaAdegan Sukses! 🎬🌟',
          'Pengambilan gambar adegan $namaAdegan berjalan sempurna! Sutradara dan kru memuji profesionalismemu!\n\n'
          '• Popularitas: +$gainsPop%',
        );
      } else {
        widget.character.health = (widget.character.health - 12).clamp(0, 100);
        setState(() {});
        widget.onRefresh();

        _showAlert(
          'Kelelahan & Insiden Syuting 🚑',
          'Kamu mengalami kelelahan berat saat pengambilan gambar $namaAdegan.\n\n'
          '• Kesehatan: -12%',
        );
      }
    } else {
      widget.character.popularity = (widget.character.popularity + gainsPop).clamp(0, 100);
      widget.character.happiness = (widget.character.happiness + 3).clamp(0, 100);
      setState(() {});
      widget.onRefresh();

      _showAlert(
        'Pengambilan Gambar $namaAdegan 📽️',
        '$efekDetail\n\n'
        '• Popularitas: +$gainsPop%\n'
        '• Kebahagiaan: +3%',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String job = widget.character.jobName ?? '';

    final bool isAction = job.contains('Action');
    final bool isDrama = job.contains('Drama');
    final bool isThriller = job.contains('Antagonis') || job.contains('Thriller');
    final bool isKomediHorror = job.contains('Komedi') || job.contains('Horror') || job.contains('Pendukung');
    final bool isFiguran = job.contains('Figuran');
    final bool isAdult18 = job.contains('18+');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Syuting & Produksi 🎥'),
        backgroundColor: Colors.deepPurple.shade800,
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
                  const CircleAvatar(backgroundColor: Colors.deepPurple, child: Icon(Icons.video_camera_back, color: Colors.white)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Project Aktif Syuting', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey.shade700)),
                        Text(widget.character.jobName ?? 'Belum Ada Project Film', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.deepPurple.shade900)),
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
            child: Text('Aktivitas di Set Syuting 🎬', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
          ),
          _buildActionCard(
            title: 'Pendalaman Karakter & Method Acting 🎭',
            desc: 'Latih dialog, gestur, dan ekspresi emosi karakter (+Inteligensi)',
            icon: Icons.psychology,
            color: Colors.purple,
            onTap: _pendalamanKarakter,
          ),

          // AKTIVITAS DINAMIS BERDASARKAN PERAN FILM DITERIMA USER
          if (isAction) ...[
            _buildActionCard(
              title: 'Lakukan Action Stunt Berbahaya 💥',
              desc: 'Adegan pertarungan & lompat gedung tanpa stuntman (+Popularitas / Riset Cedera)',
              icon: Icons.bolt,
              color: Colors.orange,
              onTap: () => _latihanAdeganSpesifik('Action Stunt Laga', 'Adegan baku hantam dan kejar-kejaran mobil berlangsung seru!', true, 5),
            ),
            _buildActionCard(
              title: 'Latihan Tembak & Koreografi Silat 🥷',
              desc: 'Kuasai teknik senjata & gerakan tarung intens (+Popularitas)',
              icon: Icons.sports_mma,
              color: Colors.red,
              onTap: () => _latihanAdeganSpesifik('Koreografi Tarung', 'Koreografi pertarunganmu dengan lawan main sangat rapi!', false, 4),
            ),
          ] else if (isDrama) ...[
            _buildActionCard(
              title: 'Pengambilan Adegan Emosional & Tangisan 😢',
              desc: 'Keluarkan emosi mendalam di depan kamera (+Popularitas)',
              icon: Icons.favorite,
              color: Colors.pink,
              onTap: () => _latihanAdeganSpesifik('Adegan Tangis Drama', 'Kru film dan sutradara tersentuh hingga meneteskan air mata!', false, 4),
            ),
            _buildActionCard(
              title: 'Syuting Chemistry Pasangan Romantis 💑',
              desc: 'Bangun suasana romantis yang meyakinkan penonton (+Popularitas)',
              icon: Icons.volunteer_activism,
              color: Colors.pinkAccent,
              onTap: () => _latihanAdeganSpesifik('Chemistry Romantis', 'Penampilan mesramu dengan lawan main terasa sangat nyata!', false, 4),
            ),
          ] else if (isThriller) ...[
            _buildActionCard(
              title: 'Latihan Tatapan & Karisma Antagonis 🦹‍♂️',
              desc: 'Tunjukkan aura intimidasi & karakter villain yang kuat (+Popularitas)',
              icon: Icons.visibility,
              color: Colors.deepOrange,
              onTap: () => _latihanAdeganSpesifik('Antagonis Villian', 'Ekspresi dingin dan kejam yang kamu tunjukkan mendapat standing ovation!', false, 5),
            ),
            _buildActionCard(
              title: 'Adegan Monolog Plot Twist 🎭',
              desc: 'Bawakan dialog pengungkapan rahasia utama cerita (+Popularitas)',
              icon: Icons.auto_awesome,
              color: Colors.amber.shade900,
              onTap: () => _latihanAdeganSpesifik('Monolog Plot Twist', 'Monolog misterimu mengubah atmosfer ruangan syuting!', false, 4),
            ),
          ] else if (isKomediHorror) ...[
            _buildActionCard(
              title: 'Latihan Improvisasi Komedi & Humor 😂',
              desc: 'Ciptakan adegan lucu spionan untuk menghidupkan suasana (+Popularitas)',
              icon: Icons.sentiment_very_satisfied,
              color: Colors.amber,
              onTap: () => _latihanAdeganSpesifik('Improvisasi Lucu', 'Seluruh kru tertawa terbahak-bahak melihat celotehan improvisasimu!', false, 4),
            ),
            _buildActionCard(
              title: 'Syuting Adegan Horor & Jeritan 😱',
              desc: 'Tunjukkan ekspresi ketakutan yang mencekam di lokasi malam (+Popularitas)',
              icon: Icons.nightlight_round,
              color: Colors.teal,
              onTap: () => _latihanAdeganSpesifik('Adegan Horor Mencekam', 'Jeritan dan ekspresi panikmu berhasil menciptakan ketakutan nyata!', true, 4),
            ),
          ] else if (isAdult18) ...[
            _buildActionCard(
              title: 'Syuting Adegan Dewasa & Sensual (18+) 🔥',
              desc: 'Pengambilan adegan intens dengan pengawasan kru profesional (+Popularitas Tinggi)',
              icon: Icons.explicit,
              color: Colors.pink.shade700,
              onTap: () => _latihanAdeganSpesifik('Sensual Dewasa 18+', 'Pengambilan adegan sensual berjalan lancar dengan profesionalisme tinggi!', true, 6),
            ),
            _buildActionCard(
              title: 'Sesi Foto Promo & Poster Eksklusif 📸',
              desc: 'Tunjukkan pesona & aura di sesi fotografi resmi (+Popularitas)',
              icon: Icons.camera_enhance,
              color: Colors.purple.shade700,
              onTap: () => _latihanAdeganSpesifik('Fotografi Promo', 'Poster rilis eksklusif yang menampilkanmu menjadi perbincangan hangat!', false, 5),
            ),
          ] else if (isFiguran) ...[
            _buildActionCard(
              title: 'Syuting Adegan Keramaian & Extras 👥',
              desc: 'Ikuti arahan asisten sutradara di latar belakang (+Pengalaman)',
              icon: Icons.groups,
              color: Colors.blue,
              onTap: () => _latihanAdeganSpesifik('Figuran Latar', 'Kamu berdiri dan berjalan rapi sesuai aba-aba di latar belakang adegan.', false, 2),
            ),
          ] else ...[
            _buildActionCard(
              title: 'Lakukan Action Stunt Berbahaya 💥',
              desc: 'Lakukan adegan berbahaya sendiri tanpa stuntman (+Popularitas / Riset Cedera)',
              icon: Icons.bolt,
              color: Colors.orange,
              onTap: () => _latihanAdeganSpesifik('Action Stunt Berbahaya', 'Adegan aksi dilakukan dengan baik!', true, 4),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), child: Icon(icon, color: color, size: 20)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
        subtitle: Text(desc, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
