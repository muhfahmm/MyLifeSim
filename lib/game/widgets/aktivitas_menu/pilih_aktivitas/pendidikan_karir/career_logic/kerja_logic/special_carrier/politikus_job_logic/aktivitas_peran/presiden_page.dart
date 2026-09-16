// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/politikus_job_logic/aktivitas_peran/presiden_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import '../rekan_politik/rekan_politik_page.dart';
import '../politik_menu.dart';

class PresidenPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const PresidenPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<PresidenPage> createState() => _PresidenPageState();
}

class _PresidenPageState extends State<PresidenPage> {
  Character get character => widget.character;

  int get _jobPerformance => ((character.discipline + character.happiness) / 2).round().clamp(0, 100);

  void _showAlert(String title, String msg) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.infinity,
          child: Text(
            msg,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  void _doRapatKabinet() {
    final r = Random();
    final discGain = 4 + r.nextInt(5);
    final happyGain = 2 + r.nextInt(4);
    character.discipline = (character.discipline + discGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Rapat Kabinet Menteri Istana 👑',
      'Kamu memimpin rapat terbatas bersama para Menteri untuk menetapkan stabilitas ekonomi & hukum nasional.\n\n'
      '• Kepemimpinan Kenegaraan: +$discGain%\n'
      '• Performa Kerja: $_jobPerformance%',
    );
  }

  void _doKttDiplomasi() {
    final r = Random();
    final karmaGain = 4 + r.nextInt(6);
    final happyGain = 2 + r.nextInt(5);
    character.karma = (character.karma + karmaGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'KTT Internasional & Diplomasi Global 🌍',
      'Kamu menghadiri Konferensi Tingkat Tinggi (KTT) bersama para Pemimpin Negara sahabat dan menandatangani pakta perdamaian dunia.\n\n'
      '• Wibawa Internasional (Karma): +$karmaGain% (Total: ${character.karma}%)\n'
      '• Kebahagiaan: +$happyGain%',
    );
  }

  void _doDekritPresiden() {
    final r = Random();
    final intelGain = 2 + r.nextInt(4);
    final discGain = 2 + r.nextInt(3);
    character.intelligence = (character.intelligence + intelGain).clamp(0, 100);
    character.discipline = (character.discipline + discGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Pidato Kenegaraan & Peraturan Pemerintah 📜',
      'Kamu menerbitkan Peraturan Pemerintah dan menyampaikan Pidato Kenegaraan dalam Sidang Pleno DPR RI.\n\n'
      '• Kebijakan Strategis: +$intelGain%\n'
      '• Kedisiplinan: +$discGain%',
    );
  }

  void _doInspeksiMiliter() {
    final r = Random();
    final karmaGain = 3 + r.nextInt(5);
    final happyGain = 2 + r.nextInt(4);
    character.karma = (character.karma + karmaGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Inspeksi Militer & Pertahanan Nasional 🎖️',
      'Kamu bertindak selaku Panglima Tertinggi melakukan inspeksi Alutsista Mabes TNI & pasukan pertahanan negara.\n\n'
      '• Kepercayaan Militer & Rakyat: +$karmaGain%\n'
      '• Kebahagiaan: +$happyGain%',
    );
  }

  void _resign() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Mundurkan Diri dari Presiden 👑',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.infinity,
          child: Text(
            'Apakah kamu yakin ingin melepaskan jabatan tertinggi sebagai Presiden / Perdana Menteri?',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 14,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              character.jobName = null;
              character.jobSalary = 0;
              character.coworkers.clear();
              character.supervisor = null;
              setState(() {});
              widget.onRefresh();
              Navigator.of(context).popUntil((route) => route.settings.name == 'KerjaMenuScreen' || route.isFirst);
            },
            child: const Text('Resign', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presiden / Perdana Menteri 👑'),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade900 : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.red.shade100,
                    child: Icon(Icons.stars, size: 32, color: Colors.red.shade900),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kepala Negara & Kepala Pemerintahan:',
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Presiden / Perdana Menteri',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.red.shade300 : Colors.red.shade900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gaji: ${CurrencySettings.format(character.jobSalary ?? 2500000)}/tahun',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Job Performance
                  Row(
                    children: [
                      Icon(Icons.trending_up, size: 16, color: Colors.blue.shade600),
                      const SizedBox(width: 6),
                      Text('Performa Kerja:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: (_jobPerformance.clamp(0, 100)) / 100.0,
                            minHeight: 10,
                            backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(_jobPerformance >= 70 ? Colors.green : (_jobPerformance >= 40 ? Colors.amber : Colors.red)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('$_jobPerformance%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Dukungan Publik
                  Row(
                    children: [
                      const Icon(Icons.how_to_vote, size: 16, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text('Dukungan Publik:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: (character.karma.clamp(0, 100)) / 100.0,
                            minHeight: 10,
                            backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${character.karma}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Aktivitas Kepresidenan & Kenegaraan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.blueGrey),
          ),
          const SizedBox(height: 12),

          _buildTile(
            icon: Icons.meeting_room,
            color: Colors.red.shade800,
            title: 'Rapat Kabinet Menteri & Istana 👑',
            subtitle: 'Memimpin sidang menteri eksekutif menetapkan kebijakan kenegaraan',
            onTap: _doRapatKabinet,
          ),

          _buildTile(
            icon: Icons.public,
            color: Colors.blue.shade800,
            title: 'KTT Internasional & Diplomasi Global 🌍',
            subtitle: 'Pertemuan antar Kepala Negara sahabat & diplomasi dunia',
            onTap: _doKttDiplomasi,
          ),

          _buildTile(
            icon: Icons.article,
            color: Colors.amber.shade800,
            title: 'Pidato Kenegaraan & Dekrit Presiden 📜',
            subtitle: 'Menyampaikan perundangan nasional & amanat kepresidenan',
            onTap: _doDekritPresiden,
          ),

          _buildTile(
            icon: Icons.shield,
            color: Colors.green.shade800,
            title: 'Inspeksi Militer & Pertahanan Nasional 🎖️',
            subtitle: 'Melakukan inspeksi kesiapan militer & Panglima Tertinggi',
            onTap: _doInspeksiMiliter,
          ),

          _buildTile(
            icon: Icons.group,
            color: Colors.teal,
            title: 'Rekan Kerja & Kabinet Menteri 👥',
            subtitle: 'Berinteraksi dengan Wakil Presiden, para Menteri & Sekretaris Kabinet',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => RekanPolitikPage(
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

          _buildTile(
            icon: Icons.how_to_vote,
            color: Colors.deepOrange,
            title: 'Pertahankan Tahta / Kampanye Pemilu 🗳️',
            subtitle: 'Meninjau peta pencalonan pemilu & persaingan politik',
            onTap: () {
              PolitikMenuHelper.showElectionMenu(
                context,
                character,
                () {
                  if (mounted) setState(() {});
                  widget.onRefresh();
                },
              );
            },
          ),
          _buildTile(
            icon: Icons.exit_to_app,
            color: Colors.red,
            title: 'Resign / Keluar Kerja',
            subtitle: 'Berhenti dari jabatan Presiden Republik Indonesia',
            onTap: _resign,
          ),
        ],
      ),
    );
  }
}
