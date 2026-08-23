// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/sosial_media/medsos_dashboard/medsos_dashboard.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class MedSosDashboard extends StatefulWidget {
  final String platformName;
  final Character character;
  final VoidCallback onComplete;

  const MedSosDashboard({
    Key? key,
    required this.platformName,
    required this.character,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<MedSosDashboard> createState() => _MedSosDashboardState();
}

class _MedSosDashboardState extends State<MedSosDashboard> {
  String get platformName => widget.platformName;
  Character get character => widget.character;

  IconData get _platformIcon {
    switch (platformName) {
      case 'YouTube': return Icons.play_circle_filled;
      case 'Instagram': return Icons.camera_alt;
      case 'X (Twitter)': return Icons.chat;
      case 'Telegram': return Icons.telegram;
      default: return Icons.share;
    }
  }

  Color get _platformColor {
    switch (platformName) {
      case 'YouTube': return Colors.red;
      case 'Instagram': return Colors.purple;
      case 'X (Twitter)': return Colors.black;
      case 'Telegram': return Colors.blue;
      default: return Colors.grey;
    }
  }

  int get _followers => character.platformFollowers[platformName] ?? 0;

  String _fmt(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _showResultDialog(String title, String message, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onComplete();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ====== AKSI POSTING KONTEN ======
  void _executePostContent(String type) {
    final r = Random();
    int gain = 0;
    int happinessGain = 0;
    int intelligenceGain = 0;
    int healthLoss = 0;
    int karmaLoss = 0;
    String outcomeMsg = '';

    if (type.contains('Dance')) {
      gain = 50 + r.nextInt(450);
      happinessGain = 10;
      outcomeMsg = '💃 Kamu memposting video dance lucu di $platformName. Konten tersebut menghibur penonton!';
    } else if (type.contains('Edukasi')) {
      gain = 30 + r.nextInt(200);
      intelligenceGain = 5;
      outcomeMsg = '📚 Kamu membagikan infografis edukatif tentang sains di $platformName. Penonton memuji kecerdasanmu!';
    } else if (type.contains('Gaming')) {
      gain = 100 + r.nextInt(800);
      happinessGain = 12;
      healthLoss = 5;
      outcomeMsg = '🎮 Kamu melakukan streaming game maraton di $platformName. Streamnya sangat seru!';
    } else {
      final bool viral = r.nextBool();
      if (viral) {
        gain = 500 + r.nextInt(5000);
        karmaLoss = 10;
        outcomeMsg = '🔥 Konten opini politik kontroversialmu di $platformName viral! Banyak yang setuju namun memicu perdebatan sengit.';
      } else {
        gain = -(50 + r.nextInt(300));
        karmaLoss = 15;
        outcomeMsg = '🤬 Opini politik kontroversialmu di $platformName dihujat netizen! Kamu mendapatkan banyak ujaran kebencian.';
      }
    }

    int oldFollowers = character.platformFollowers[platformName] ?? 0;
    int newFollowers = max(0, oldFollowers + gain);
    character.platformFollowers[platformName] = newFollowers;

    character.happiness = (character.happiness + happinessGain).clamp(0, 100).toInt();
    character.intelligence = (character.intelligence + intelligenceGain).clamp(0, 100).toInt();
    character.health = (character.health - healthLoss).clamp(0, 100).toInt();
    character.karma = (character.karma - karmaLoss).clamp(0, 100).toInt();

    String finalStatsMsg = '$outcomeMsg\n\n📊 Hasil:\n';
    if (gain > 0) finalStatsMsg += '• +${_fmt(gain)} Pengikut di $platformName\n';
    else if (gain < 0) finalStatsMsg += '• -${_fmt(gain.abs())} Pengikut di $platformName\n';
    if (happinessGain > 0) finalStatsMsg += '• +$happinessGain% Kebahagiaan\n';
    if (intelligenceGain > 0) finalStatsMsg += '• +$intelligenceGain% Kecerdasan\n';
    if (healthLoss > 0) finalStatsMsg += '• -$healthLoss% Kesehatan\n';
    if (karmaLoss > 0) finalStatsMsg += '• -$karmaLoss% Karma\n';

    character.inbox.add(finalStatsMsg);

    character.posts.add({
      'platform': platformName,
      'type': type,
      'gain': gain,
      'message': outcomeMsg,
    });

    setState(() {});

    _showResultDialog('Posting Berhasil', finalStatsMsg, Icons.check_circle, Colors.green);
  }

  // ====== MODAL POSTING (DIPERBESAR BESAR SEKALI) ======
  void _showPostContentConfig() {
    String selectedType = 'Dance Video / Komedi';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(_platformIcon, color: _platformColor),
                const SizedBox(width: 8),
                Text('Posting di $platformName',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40), // Padding vertikal sangat besar
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Pilih Jenis Konten:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    items: <String>[
                      'Dance Video / Komedi',
                      'Konten Edukasi',
                      'Gaming Stream',
                      'Opini Politik Kontroversial'
                    ].map((String val) {
                      return DropdownMenuItem<String>(value: val, child: Text(val));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedType = val!),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Konten yang bagus akan mendapatkan lebih banyak pengikut!',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {
                  Navigator.pop(ctx);
                  _executePostContent(selectedType);
                },
                child: const Text('Post Sekarang 🚀', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  // ====== AKSI BELI BOT ======
  void _executeBuyBotFollowers() {
    if (character.money < 1000000) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Uang Tidak Cukup'),
          content: const Text('Kamu butuh minimal Rp 1.000.000 untuk membeli pengikut bot.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    final r = Random();
    final bool banned = r.nextInt(100) < 15;
    character.money -= 1000000;

    String msg = '';
    if (banned) {
      character.platformFollowers[platformName] = 0;
      character.happiness = (character.happiness - 30).clamp(0, 100).toInt();
      character.karma = (character.karma - 15).clamp(0, 100).toInt();
      msg = '🚫 BANNED! Sistem mendeteksi adanya aktivitas bot ilegal di akun $platformName. Semua pengikut di platform tersebut dihapus dan akunmu dinonaktifkan sementara! (-30% Kebahagiaan, -15% Karma)';
    } else {
      int oldFollowers = character.platformFollowers[platformName] ?? 0;
      character.platformFollowers[platformName] = oldFollowers + 10000;
      character.karma = (character.karma - 5).clamp(0, 100).toInt();
      msg = '🤖 BERHASIL! Kamu membeli pengikut bot secara ilegal di $platformName. Akunmu sekarang memiliki tambahan +10.000 pengikut di platform tersebut! (-5% Karma)';
    }

    character.inbox.add(msg);
    setState(() {});

    _showResultDialog(
      banned ? 'Akun Di-banned!' : 'Transaksi Sukses',
      msg,
      banned ? Icons.cancel : Icons.check_circle,
      banned ? Colors.red : Colors.green,
    );
  }

  // ====== KARTU POSTINGAN ======
  Widget _buildPostCard(Map<String, dynamic> post) {
    final int gain = post['gain'] ?? 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.post_add, color: _platformColor),
        title: Text(
          post['type'] ?? 'Konten',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${gain >= 0 ? '+' : ''}$gain pengikut',
          style: TextStyle(color: gain >= 0 ? Colors.green : Colors.red),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myPosts = character.posts.where((post) => post['platform'] == platformName).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(_platformIcon, color: _platformColor),
            const SizedBox(width: 10),
            Text('$platformName Dashboard'),
          ],
        ),
        backgroundColor: _platformColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Kartu Info Platform
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(_platformIcon, color: _platformColor, size: 60),
                    const SizedBox(height: 10),
                    Text(
                      platformName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total Pengikut: ${_fmt(_followers)}',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Aksi
            ElevatedButton.icon(
              onPressed: _showPostContentConfig,
              icon: const Icon(Icons.post_add),
              label: const Text('Posting Konten 📝'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _executeBuyBotFollowers,
              icon: const Icon(Icons.android),
              label: const Text('Beli Pengikut Bot 🤖'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            // Riwayat Postingan
            Text(
              'Riwayat Postingan $platformName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (myPosts.isNotEmpty)
              ...myPosts.reversed.map((post) => _buildPostCard(post)).toList()
            else
              Text(
                'Belum ada postingan di $platformName. Yuk mulai posting!',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}