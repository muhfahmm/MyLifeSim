// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/sosial_media/medsos_dashboard/medsos_dashboard.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

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
      case 'TikTok': return Icons.music_note;
      case 'X (Twitter)': return Icons.chat;
      case 'Telegram': return Icons.telegram;
      case 'Twitch': return Icons.live_tv;
      default: return Icons.share;
    }
  }

  Color get _platformColor {
    switch (platformName) {
      case 'YouTube': return Colors.red.shade700;
      case 'Instagram': return Colors.purple.shade600;
      case 'TikTok': return Colors.pink.shade500;
      case 'X (Twitter)': return Colors.lightBlue.shade600;
      case 'Telegram': return Colors.blue.shade600;
      case 'Twitch': return Colors.deepPurple.shade600;
      default: return Colors.grey.shade700;
    }
  }

  int get _followers => character.platformFollowers[platformName] ?? 0;

  bool get _isVerified => (character.posts.any((p) => p['platform'] == platformName && p['isVerified'] == true));

  String _fmt(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _showResultDialog(String title, String message, IconData icon, Color color) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: const TextStyle(fontSize: 14, height: 1.4)),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onComplete();
          },
          child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }

  // ====== 1. AKSI POSTING KONTEN KREATIF ======
  void _executePostContent(String type, String caption) {
    final r = Random();
    int gain = 0;
    int happinessGain = 0;
    int intelligenceGain = 0;
    int healthLoss = 0;
    int karmaLoss = 0;
    int earnedMoney = 0;
    String outcomeMsg = '';

    // Bonus followers multiplier berdasarkan verified & jumlah followers
    double multiplier = 1.0;
    if (_isVerified) multiplier += 0.5;
    if (_followers > 100000) multiplier += 0.5;
    if (_followers > 1000000) multiplier += 1.0;

    switch (type) {
      case 'Dance / Trending Challenge 💃':
        gain = ((50 + r.nextInt(450)) * multiplier).round();
        happinessGain = 8;
        outcomeMsg = '💃 Video dance dan tren challenge di $platformName milikmu sukses menyita perhatian publik!';
        break;

      case 'Edukasi & Tips 📚':
        gain = ((30 + r.nextInt(250)) * multiplier).round();
        intelligenceGain = 5;
        happinessGain = 4;
        outcomeMsg = '📚 Penonton sangat mengapresiasi konten wawasan dan tutorial berbobot yang kamu unggah di $platformName!';
        break;

      case 'Gaming & Live Stream 🎮':
        gain = ((100 + r.nextInt(800)) * multiplier).round();
        happinessGain = 12;
        healthLoss = 4;
        if (_followers > 50000) {
          earnedMoney = 500000 + r.nextInt(1500000);
        }
        outcomeMsg = '🎮 Sesi live streaming maraton di $platformName berlangsung seru! Penonton setia memberikan banyak masukan dan donasi.';
        break;

      case 'Vlog Harian & Lifestyle 📹':
        gain = ((80 + r.nextInt(600)) * multiplier).round();
        happinessGain = 10;
        outcomeMsg = '📹 Momen kehidupan harianmu di $platformName menarik perhatian penonton yang merasa dekat denganmu.';
        break;

      case 'Review Produk / Unboxing 📦':
        gain = ((60 + r.nextInt(500)) * multiplier).round();
        if (_followers > 10000) {
          earnedMoney = 300000 + r.nextInt(1000000);
        }
        happinessGain = 6;
        outcomeMsg = '📦 Ulasan jujur mengenai produk di $platformName disukai netizen karena informatif!';
        break;

      case 'Opini Kontroversial 🔥':
      default:
        final bool viral = r.nextInt(100) < 55;
        if (viral) {
          gain = ((400 + r.nextInt(3500)) * multiplier).round();
          karmaLoss = 8;
          outcomeMsg = '🔥 Opini tajam yang kamu lontarkan di $platformName langsung viral menduduki trending topik!';
        } else {
          gain = -(50 + r.nextInt(400));
          karmaLoss = 12;
          happinessGain = -10;
          outcomeMsg = '🤬 Postingan opini milikmu di $platformName mendapat gelombang kemarahan dan balasan sengit netizen.';
        }
        break;
    }

    int oldFollowers = character.platformFollowers[platformName] ?? 0;
    int newFollowers = max(0, oldFollowers + gain);
    character.platformFollowers[platformName] = newFollowers;

    character.happiness = (character.happiness + happinessGain).clamp(0, 100).toInt();
    character.intelligence = (character.intelligence + intelligenceGain).clamp(0, 100).toInt();
    character.health = (character.health - healthLoss).clamp(0, 100).toInt();
    character.karma = (character.karma - karmaLoss).clamp(0, 100).toInt();
    if (earnedMoney > 0) character.money += earnedMoney;

    String finalStatsMsg = '$outcomeMsg\n';
    if (caption.isNotEmpty) {
      finalStatsMsg += '💬 Captions: "$caption"\n';
    }
    finalStatsMsg += '\n📊 Dampak Aktivitas:\n';
    if (gain > 0) {
      finalStatsMsg += '• +${_fmt(gain)} Pengikut baru di $platformName\n';
    } else if (gain < 0) {
      finalStatsMsg += '• -${_fmt(gain.abs())} Pengikut di $platformName\n';
    }
    if (earnedMoney > 0) {
      finalStatsMsg += '• +${CurrencySettings.format(earnedMoney)} Pendapatan Konten\n';
    }
    if (happinessGain > 0) {
      finalStatsMsg += '• +$happinessGain% Kebahagiaan\n';
    } else if (happinessGain < 0) {
      finalStatsMsg += '• $happinessGain% Kebahagiaan\n';
    }
    if (intelligenceGain > 0) {
      finalStatsMsg += '• +$intelligenceGain% Kecerdasan\n';
    }
    if (healthLoss > 0) {
      finalStatsMsg += '• -$healthLoss% Kesehatan\n';
    }
    if (karmaLoss > 0) {
      finalStatsMsg += '• -$karmaLoss% Karma\n';
    }

    character.inbox.add(finalStatsMsg);

    character.posts.add({
      'platform': platformName,
      'type': type,
      'caption': caption,
      'gain': gain,
      'earnedMoney': earnedMoney,
      'message': outcomeMsg,
      'date': DateTime.now().toString(),
    });

    setState(() {});
    _showResultDialog('Unggahan Berhasil 🚀', finalStatsMsg, Icons.check_circle, Colors.green);
  }

  void _showPostContentConfig() {
    String selectedType = 'Dance / Trending Challenge 💃';
    final TextEditingController captionController = TextEditingController();

    DialogHelper.show(
      context: context,
      title: 'Buat Konten $platformName',
      content: StatefulBuilder(
        builder: (context, setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Pilih Tema Konten:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: <String>[
                  'Dance / Trending Challenge 💃',
                  'Vlog Harian & Lifestyle 📹',
                  'Edukasi & Tips 📚',
                  'Gaming & Live Stream 🎮',
                  'Review Produk / Unboxing 📦',
                  'Opini Kontroversial 🔥',
                ].map((String val) {
                  return DropdownMenuItem<String>(value: val, child: Text(val, style: const TextStyle(fontSize: 13)));
                }).toList(),
                onChanged: (val) => setModalState(() => selectedType = val!),
              ),
              const SizedBox(height: 14),
              const Text('Keterangan / Caption:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: captionController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Tulis caption menarik di sini...',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _platformColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            Navigator.pop(context);
            _executePostContent(selectedType, captionController.text.trim());
          },
          child: const Text('Unggah 🚀', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // ====== 2. AKSI SPONSORSHIP / ENDORSEMENT ======
  void _executeSponsorship() {
    if (_followers < 5000) {
      _showResultDialog(
        'Belum Memenuhi Syarat',
        'Kamu butuh minimal 5.000 pengikut di $platformName untuk menerima tawaran sponsorship dari brand!',
        Icons.lock,
        Colors.orange,
      );
      return;
    }

    final r = Random();
    int basePay = (_followers * (15 + r.nextInt(25)));
    int pay = basePay.clamp(100000, 500000000);
    character.money += pay;
    character.happiness = (character.happiness + 6).clamp(0, 100).toInt();

    String msg = '💰 Kontrak Sponsorship Berhasil!\n\nBrand ternama mengontrakmu di $platformName untuk mempromosikan produk mereka.\n• Pendapatan: +${CurrencySettings.format(pay)}\n• +6% Kebahagiaan';
    character.inbox.add(msg);
    setState(() {});
    _showResultDialog('Sponsorship Deal! 🤝', msg, Icons.monetization_on, Colors.green);
  }

  // ====== 3. AKSI AJAKAN KOLABORASI ======
  void _executeCollaboration() {
    if (_followers < 1000) {
      _showResultDialog(
        'Minimal 1.000 Followers',
        'Kamu butuh minimal 1.000 pengikut di $platformName untuk melakukan kolaborasi dengan sesama influencer.',
        Icons.people,
        Colors.orange,
      );
      return;
    }

    final r = Random();
    int bonusFollowers = 200 + r.nextInt(1500) + (_followers ~/ 50);
    character.platformFollowers[platformName] = _followers + bonusFollowers;
    character.happiness = (character.happiness + 8).clamp(0, 100).toInt();

    String msg = '🤝 Kolaborasi Sukses!\n\nKamu berkolaborasi membuat konten bersama influencer terkenal di $platformName.\n• +${_fmt(bonusFollowers)} Pengikut Baru\n• +8% Kebahagiaan';
    character.inbox.add(msg);
    setState(() {});
    _showResultDialog('Kolaborasi Sukses ✨', msg, Icons.group_add, Colors.purple);
  }

  // ====== 4. AKSI AJUKAN VERIFIKASI (CENTANG BIRU) ======
  void _executeApplyVerification() {
    if (_isVerified) {
      _showResultDialog('Sudah Terverifikasi', 'Akun $platformName milikmu sudah terverifikasi dengan Lencana Centang Biru ✔️!', Icons.verified, Colors.blue);
      return;
    }

    if (_followers < 25000) {
      _showResultDialog(
        'Syarat Belum Cukup',
        'Pengajuan verifikasi centang biru memerlukan minimal 25.000 pengikut di $platformName.',
        Icons.verified_user_outlined,
        Colors.orange,
      );
      return;
    }

    // Set verified flag in posts metadata list
    character.posts.add({
      'platform': platformName,
      'isVerified': true,
      'date': DateTime.now().toString(),
    });

    character.happiness = (character.happiness + 15).clamp(0, 100).toInt();
    String msg = '🎉 SELAMAT! Akun $platformName milikmu telah resmi mendapatkan Centang Biru Resmi (Verified Badge)! Reputasimu naik drastis.';
    character.inbox.add(msg);
    setState(() {});
    _showResultDialog('Akun Terverifikasi! ✔️', msg, Icons.verified, Colors.blue);
  }

  // ====== 5. AKSI BELI BOT FOLLOWERS ======
  void _executeBuyBotFollowers() {
    const int priceInUsd = 50; // $50 USD realistic price for 10k bot followers
    if (character.money < priceInUsd) {
      DialogHelper.show(
        context: context,
        title: 'Uang Tidak Cukup ⚠️',
        content: Text(
          'Kamu memerlukan ${CurrencySettings.format(priceInUsd)} untuk membeli paket 10.000 pengikut bot.',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      );
      return;
    }

    final r = Random();
    final bool banned = r.nextInt(100) < 20;
    character.money -= priceInUsd;

    String msg = '';
    if (banned) {
      character.platformFollowers[platformName] = 0;
      character.happiness = (character.happiness - 25).clamp(0, 100).toInt();
      character.karma = (character.karma - 15).clamp(0, 100).toInt();
      msg = '🚫 BANNED! Tim Moderasi $platformName mendeteksi aktivitas bot ilegal (${CurrencySettings.format(priceInUsd)}). Semua pengikutmu hangus dan akunmu terkena penalti berat (-25% Kebahagiaan, -15% Karma)!';
    } else {
      int oldFollowers = character.platformFollowers[platformName] ?? 0;
      character.platformFollowers[platformName] = oldFollowers + 10000;
      character.karma = (character.karma - 5).clamp(0, 100).toInt();
      msg = '🤖 BERHASIL! Kamu membeli 10.000 pengikut bot di $platformName seharga ${CurrencySettings.format(priceInUsd)} secara sembunyi-sembunyi (-5% Karma).';
    }

    character.inbox.add(msg);
    setState(() {});
    _showResultDialog(
      banned ? 'Banned oleh Sistem!' : 'Pengikut Bot Ditambahkan',
      msg,
      banned ? Icons.cancel : Icons.android,
      banned ? Colors.red : Colors.green,
    );
  }

  // ====== BUILD RIWAYAT POSTINGAN ======
  Widget _buildPostCard(Map<String, dynamic> post) {
    if (post['isVerified'] == true) return const SizedBox.shrink();

    final int gain = post['gain'] ?? 0;
    final int money = post['earnedMoney'] ?? 0;
    final String caption = post['caption'] ?? '';

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: _platformColor.withValues(alpha: 0.15),
          child: Icon(_platformIcon, color: _platformColor, size: 20),
        ),
        title: Text(
          post['type'] ?? 'Unggahan Konten',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (caption.isNotEmpty)
              Text('"$caption"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
            Text(
              '${gain >= 0 ? '+' : ''}${_fmt(gain)} Pengikut ${money > 0 ? '• +${CurrencySettings.format(money)}' : ''}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: gain >= 0 ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final myPosts = character.posts
        .where((post) => post['platform'] == platformName && post['isVerified'] != true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard $platformName',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: _platformColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Profile & Statistik Akun
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _platformColor.withValues(alpha: 0.9),
                    _platformColor.withValues(alpha: 0.65),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _platformColor.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(_platformIcon, color: _platformColor, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    character.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (_isVerified) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, color: Colors.cyanAccent, size: 18),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Account: @${character.name.toLowerCase().replaceAll(" ", "_")}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Pengikut', _fmt(_followers)),
                      _buildStatColumn('Total Post', '${myPosts.length}'),
                      _buildStatColumn('Status', _isVerified ? 'Verified' : 'Reguler'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 1: Aksi Utama Konten
            Text(
              'Aktivitas & Fitur Akun',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            _buildMenuCard(
              icon: Icons.post_add,
              title: 'Unggah Konten 📝',
              subtitle: 'Buat postingan baru untuk menambah pengikut',
              iconColor: Colors.blue.shade600,
              onTap: _showPostContentConfig,
            ),
            _buildMenuCard(
              icon: Icons.monetization_on,
              title: 'Sponsorship & Endorse 🤝',
              subtitle: 'Terima tawaran iklan dari brand (Min 5.000 Followers)',
              iconColor: Colors.green.shade600,
              onTap: _executeSponsorship,
            ),
            _buildMenuCard(
              icon: Icons.group_add,
              title: 'Kolaborasi Influencer ✨',
              subtitle: 'Buat konten bareng influencer lain (Min 1.000 Followers)',
              iconColor: Colors.purple.shade600,
              onTap: _executeCollaboration,
            ),
            _buildMenuCard(
              icon: Icons.verified,
              title: 'Pengajuan Centang Biru ✔️',
              subtitle: 'Dapatkan Lencana Verifikasi Resmi (Min 25.000 Followers)',
              iconColor: Colors.amber.shade700,
              onTap: _executeApplyVerification,
            ),
            _buildMenuCard(
              icon: Icons.android,
              title: 'Beli Pengikut Bot 🤖',
              subtitle: 'Beli 10.000 pengikut bot (${CurrencySettings.format(50)} - Risiko Banned!)',
              iconColor: Colors.redAccent,
              onTap: _executeBuyBotFollowers,
            ),

            const SizedBox(height: 20),

            // Section 2: Riwayat Postingan
            Text(
              'Riwayat Postingan ($platformName)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            if (myPosts.isNotEmpty)
              ...myPosts.reversed.map((post) => _buildPostCard(post)).toList()
            else
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.dashboard_customize_outlined, size: 36, color: Colors.grey.shade500),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada postingan di $platformName.\nYuk mulai buat konten pertamamu!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? Colors.white54 : Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
