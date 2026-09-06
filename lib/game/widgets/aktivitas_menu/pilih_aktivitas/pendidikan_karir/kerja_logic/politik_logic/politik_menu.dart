import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'politik_career.dart';

class PolitikMenuHelper {
  static void showPolitikMenu(BuildContext context, Character character, VoidCallback onComplete) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PolitikMenuPage(character: character, onComplete: onComplete),
      ),
    );
  }
}

class PolitikMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onComplete;

  const PolitikMenuPage({super.key, required this.character, required this.onComplete});

  @override
  State<PolitikMenuPage> createState() => _PolitikMenuPageState();
}

class _PolitikMenuPageState extends State<PolitikMenuPage> {
  Character get character => widget.character;

  String _fmt(int val) {
    return val.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.");
  }

  void _runElectionCampaign(PoliticalLevel level) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Checks
    if (character.age < level.minAge) {
      _showAlert('Syarat Usia Belum Cukup 🔞', 'Kamu belum cukup umur untuk posisi ${level.title}. Minimal berusia ${level.minAge} tahun.');
      return;
    }
    if (level.requireDegree && !character.isUnivGraduated) {
      _showAlert('Syarat Gelar Pendidikan 🎓', 'Posisi ${level.title} membutuhkan gelar Sarjana/Universitas.');
      return;
    }
    if (character.karma < level.minKarma) {
      _showAlert('Reputasi Rendah ⚠️', 'Karma/reputasimu terlalu rendah (${character.karma}%). Minimal ${level.minKarma}% untuk meyakinkan partai.');
      return;
    }
    if (character.money < level.campaignCost) {
      _showAlert('Dana Kampanye Kurang 💸', 'Kamu membutuhkan dana kampanye minimal \$${_fmt(level.campaignCost)}.');
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        title: Row(
          children: [
            const Icon(Icons.how_to_vote, color: Colors.amber),
            const SizedBox(width: 8),
            Text('Mulai Kampanye 🏛️', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          ],
        ),
        content: Text(
          'Apakah kamu siap mencalonkan diri sebagai ${level.title}?\n\n'
          '• Biaya Kampanye: \$${_fmt(level.campaignCost)}\n'
          '• Estimasi Gaji: \$${_fmt(level.baseSalary)}/tahun\n\n'
          'Peluang kemenangan ditentukan oleh Kecerdasan, Karma, dan Kebahagiaanmu.',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              _processElection(level);
            },
            child: const Text('Mulai Pemilu 🗳️', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _processElection(PoliticalLevel level) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    character.money -= level.campaignCost;

    final r = Random();
    // Election score formula based on Intelligence, Karma, Happiness, and Random luck
    final int score = ((character.intelligence * 0.35) + (character.karma * 0.35) + (character.happiness * 0.30) + r.nextInt(25)).round();
    final bool won = score >= 55;

    if (won) {
      character.jobName = level.title;
      character.jobSalary = level.baseSalary;
      character.happiness = (character.happiness + 20).clamp(0, 100);
      character.karma = (character.karma + 10).clamp(0, 100);

      final msg = '🎉 SELAMAT! Kamu MEMENANGKAN Pemilu dan resmi menjabat sebagai ${level.title} dengan gaji \$${_fmt(level.baseSalary)}/tahun!';
      character.inbox.add(msg);
      widget.onComplete();

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : null,
          title: const Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber),
              SizedBox(width: 8),
              Text('Kemenangan Pemilu! 🏆', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(msg, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {});
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      character.happiness = (character.happiness - 15).clamp(0, 100);
      final msg = '😔 Sayang sekali! Kamu kalah dalam pemilu ${level.title}. Hasil suara tidak mencukupi dukungan publik.';
      character.inbox.add(msg);
      widget.onComplete();

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : null,
          title: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 8),
              Text('Kalah Pemilu 💔', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(msg, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() {});
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showAlert(String title, String msg) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        content: Text(msg, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karier Politik 🏛️'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Row(
                children: [
                  const Text('🏛️', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.jobName != null && character.jobName!.contains(RegExp(r'Dewan|Walikota|Gubernur|Presiden|Staf'))
                              ? 'Jabatan Sekarang: ${character.jobName}'
                              : 'Status: Belum Menjabat di Politik',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDark ? Colors.amberAccent : Colors.amber.shade900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Saldo: \$${_fmt(character.money)} • Karma: ${character.karma}%',
                          style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: PoliticalCareerData.levels.length,
                itemBuilder: (ctx, idx) {
                  final level = PoliticalCareerData.levels[idx];
                  final bool isCurrentJob = character.jobName == level.title;
                  final bool canAge = character.age >= level.minAge;
                  final bool canDegree = !level.requireDegree || character.isUnivGraduated;
                  final bool canAfford = character.money >= level.campaignCost;

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    color: isCurrentJob
                        ? (isDark ? Colors.amber.shade900.withValues(alpha: 0.25) : Colors.amber.shade50)
                        : (isDark ? Colors.grey.shade800 : Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isCurrentJob
                            ? Colors.amber
                            : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: isCurrentJob ? Colors.amber : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                                child: Text('${idx + 1}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isCurrentJob ? Colors.black : (isDark ? Colors.white : Colors.black87))),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  level.title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87),
                                ),
                              ),
                              if (isCurrentJob)
                                const Chip(
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  label: Text('Menjabat', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                  backgroundColor: Colors.amber,
                                )
                              else
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber.shade700,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () => _runElectionCampaign(level),
                                  icon: const Icon(Icons.how_to_vote, size: 14),
                                  label: const Text('Calonkan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(level.description, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.black54)),
                          const Divider(height: 14),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              Text('💰 Biaya: \$${_fmt(level.campaignCost)}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: canAfford ? (isDark ? Colors.greenAccent : Colors.green.shade700) : Colors.red)),
                              Text('💵 Gaji: \$${_fmt(level.baseSalary)}/thn', style: TextStyle(fontSize: 11, color: isDark ? Colors.tealAccent : Colors.teal.shade700, fontWeight: FontWeight.bold)),
                              Text('🎂 Min Usia: ${level.minAge} thn', style: TextStyle(fontSize: 11, color: canAge ? (isDark ? Colors.white70 : Colors.black54) : Colors.red)),
                            ],
                          ),
                          if (level.requireDegree) ...[
                            const SizedBox(height: 4),
                            Text(
                              '🎓 Syarat Gelar: ${level.requiredDegreeName}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: canDegree ? (isDark ? Colors.lightBlueAccent : Colors.blue.shade800) : Colors.red,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
