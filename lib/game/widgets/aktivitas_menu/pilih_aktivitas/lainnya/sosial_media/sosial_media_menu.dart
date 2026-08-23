// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/sosial_media/sosial_media_menu.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class SocialMediaMenuHelper {
  static void showSocialMediaMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 12) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 12 tahun untuk memiliki akun sosial media.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    DialogHelper.show(
      context: context,
      title: 'Sosial Media 📱',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(children: [
              const Icon(Icons.people, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(
                'Total Pengikut (Followers): ${_fmt(character.followers)}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 13),
              ),
            ]),
          ),
          
          // Opsi 1: Posting Konten
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: const Icon(Icons.post_add, color: Colors.blueAccent),
              title: const Text('Posting Konten Baru 📝', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Buat konten menarik untuk menambah pengikut secara organik'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                Navigator.pop(context);
                _showPostContentConfig(context, character, onComplete);
              },
            ),
          ),

          // Opsi 2: Beli Pengikut Bot
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: const Icon(Icons.android, color: Colors.redAccent),
              title: const Text('Beli Pengikut Bot 🤖', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('Instan menambah 10.000 pengikut (Biaya: Rp 1.000.000, Risiko Banned: 15%)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                Navigator.pop(context);
                _executeBuyBotFollowers(context, character, onComplete);
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  // Pilih Platform & Jenis Konten
  static void _showPostContentConfig(BuildContext context, Character character, VoidCallback onComplete) {
    String selectedPlatform = 'TikTok';
    String selectedType = 'Dance Video / Komedi';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Row(children: [
              Icon(Icons.share, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text('Buat Postingan Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pilih Platform Sosial Media:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                DropdownButton<String>(
                  value: selectedPlatform,
                  isExpanded: true,
                  items: <String>['TikTok', 'Instagram', 'YouTube'].map((String val) {
                    return DropdownMenuItem<String>(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (val) => setState(() => selectedPlatform = val!),
                ),
                const SizedBox(height: 10),
                const Text('Pilih Jenis Konten:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                DropdownButton<String>(
                  value: selectedType,
                  isExpanded: true,
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
              ],
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
                  _executePostContent(context, character, selectedPlatform, selectedType, onComplete);
                },
                child: const Text('Post Sekarang 🚀', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  // Eksekusi Posting Konten
  static void _executePostContent(
      BuildContext context, Character character, String platform, String type, VoidCallback onComplete) {
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
      outcomeMsg = '💃 Kamu memposting video dance lucu di $platform. Konten tersebut menghibur penonton!';
    } else if (type.contains('Edukasi')) {
      gain = 30 + r.nextInt(200);
      intelligenceGain = 5;
      outcomeMsg = '📚 Kamu membagikan infografis edukatif tentang sains di $platform. Penonton memuji kecerdasanmu!';
    } else if (type.contains('Gaming')) {
      gain = 100 + r.nextInt(800);
      happinessGain = 12;
      healthLoss = 5;
      outcomeMsg = '🎮 Kamu melakukan streaming game maraton di $platform. Streamnya sangat seru!';
    } else {
      // Opini Politik
      final bool viral = r.nextBool();
      if (viral) {
        gain = 500 + r.nextInt(5000);
        karmaLoss = 10;
        outcomeMsg = '🔥 Konten opini politik kontroversialmu di $platform viral! Banyak yang setuju namun memicu perdebatan sengit.';
      } else {
        gain = -(50 + r.nextInt(300));
        karmaLoss = 15;
        outcomeMsg = '🤬 Opini politik kontroversialmu di $platform dihujat netizen! Kamu mendapatkan banyak ujaran kebencian.';
      }
    }

    // Terapkan perubahan status
    character.followers = max(0, character.followers + gain);
    character.happiness = (character.happiness + happinessGain).clamp(0, 100);
    character.intelligence = (character.intelligence + intelligenceGain).clamp(0, 100);
    character.health = (character.health - healthLoss).clamp(0, 100);
    character.karma = (character.karma - karmaLoss).clamp(0, 100);

    String finalStatsMsg = '$outcomeMsg\n\n📊 Hasil:\n';
    if (gain > 0) finalStatsMsg += '• +${_fmt(gain)} Pengikut\n';
    else if (gain < 0) finalStatsMsg += '• -${_fmt(gain.abs())} Pengikut\n';
    
    if (happinessGain > 0) finalStatsMsg += '• +$happinessGain% Kebahagiaan\n';
    if (intelligenceGain > 0) finalStatsMsg += '• +$intelligenceGain% Kecerdasan\n';
    if (healthLoss > 0) finalStatsMsg += '• -$healthLoss% Kesehatan\n';
    if (karmaLoss > 0) finalStatsMsg += '• -$karmaLoss% Karma\n';

    character.inbox.add(finalStatsMsg);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Posting Berhasil', style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text(finalStatsMsg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  // Eksekusi Beli Pengikut Bot
  static void _executeBuyBotFollowers(BuildContext context, Character character, VoidCallback onComplete) {
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
      character.followers = 0;
      character.happiness = (character.happiness - 30).clamp(0, 100);
      character.karma = (character.karma - 15).clamp(0, 100);
      msg = '🚫 BANNED! Sistem mendeteksi adanya aktivitas bot ilegal di akunmu. Semua pengikutmu telah dihapus dan akunmu dinonaktifkan sementara! (-30% Kebahagiaan, -15% Karma)';
    } else {
      character.followers += 10000;
      character.karma = (character.karma - 5).clamp(0, 100);
      msg = '🤖 BERHASIL! Kamu membeli pengikut bot secara ilegal. Akunmu sekarang memiliki tambahan +10.000 pengikut! (-5% Karma)';
    }

    character.inbox.add(msg);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          Icon(banned ? Icons.cancel : Icons.check_circle, color: banned ? Colors.red : Colors.green),
          const SizedBox(width: 8),
          Text(banned ? 'Akun Di-banned!' : 'Transaksi Sukses', style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  static String _fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
