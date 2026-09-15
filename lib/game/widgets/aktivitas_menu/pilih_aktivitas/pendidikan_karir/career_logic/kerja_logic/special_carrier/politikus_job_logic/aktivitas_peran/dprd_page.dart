// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/politikus_job_logic/aktivitas_peran/dprd_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import '../rekan_politik/rekan_politik_page.dart';
import '../politik_menu.dart';

class DprdPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const DprdPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<DprdPage> createState() => _DprdPageState();
}

class _DprdPageState extends State<DprdPage> {
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

  void _doSidangParipurna() {
    final r = Random();
    final discGain = 3 + r.nextInt(5);
    final happyGain = 2 + r.nextInt(4);
    character.discipline = (character.discipline + discGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Sidang Paripurna & Pengawasan Perda 🏛️',
      'Kamu menghadiri sidang pleno rapat parlemen lokal untuk pengesahan peraturan daerah.\n\n'
      '• Kedisiplinan Kedewanan: +$discGain%\n'
      '• Performa Kerja: $_jobPerformance%',
    );
  }

  void _doResesWarga() {
    final r = Random();
    final karmaGain = 4 + r.nextInt(5);
    final happyGain = 2 + r.nextInt(4);
    character.karma = (character.karma + karmaGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Reses & Dengar Pendapat Warga 🗣️',
      'Kamu turun ke dapil menyerap aspirasi dan keluhan masyarakat terkait fasilitas publik.\n\n'
      '• Dukungan Publik (Karma): +$karmaGain% (Total: ${character.karma}%)\n'
      '• Kebahagiaan: +$happyGain%',
    );
  }

  void _doRapatKomisi() {
    final r = Random();
    final intelGain = 2 + r.nextInt(3);
    final discGain = 2 + r.nextInt(3);
    character.intelligence = (character.intelligence + intelGain).clamp(0, 100);
    character.discipline = (character.discipline + discGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Rapat Komisi & Anggaran Daerah 📊',
      'Kamu menelaah pos-pos pengeluaran anggaran dinas daerah bersama komisi DPRD.\n\n'
      '• Kecerdasan Politik: +$intelGain%\n'
      '• Kedisiplinan: +$discGain%',
    );
  }

  void _doLobiFraksi() {
    final r = Random();
    final intelGain = 1 + r.nextInt(3);
    final karmaGain = 2 + r.nextInt(4);
    character.intelligence = (character.intelligence + intelGain).clamp(0, 100);
    character.karma = (character.karma + karmaGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Lobi Fraksi Parlemen 🤝',
      'Kamu membangun kompromi politik dengan anggota fraksi partai lain untuk menggolkan rancangan perundangan.\n\n'
      '• Kecerdasan Politik: +$intelGain%\n'
      '• Reputasi Politik: +$karmaGain%',
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
                'Mundurkan Diri dari DPRD 🏛️',
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
            'Apakah kamu yakin ingin melepaskan posisi sebagai Anggota Dewan Kota / DPRD?',
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
        title: const Text('Anggota Dewan Kota / DPRD 🏛️'),
        backgroundColor: Colors.amber.shade800,
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
                    backgroundColor: Colors.amber.shade100,
                    child: Icon(Icons.account_balance, size: 32, color: Colors.amber.shade900),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Jabatan Legislatif:',
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Anggota Dewan Kota / DPRD',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.amber.shade300 : Colors.amber.shade900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gaji: ${CurrencySettings.format(character.jobSalary ?? 95000)}/tahun',
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

                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onPressed: _resign,
                    icon: const Icon(Icons.exit_to_app, size: 16),
                    label: const Text('Resign / Keluar Kerja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Aktivitas Kedewanan (DPRD)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.blueGrey),
          ),
          const SizedBox(height: 12),

          _buildTile(
            icon: Icons.gavel,
            color: Colors.amber.shade800,
            title: 'Sidang Paripurna & Pengawasan Perda 🏛️',
            subtitle: 'Menghadiri rapat rapat pleno dan menyusun regulasi daerah',
            onTap: _doSidangParipurna,
          ),

          _buildTile(
            icon: Icons.record_voice_over,
            color: Colors.green.shade700,
            title: 'Reses & Dengar Pendapat Warga 🗣️',
            subtitle: 'Menyerap aspirasi masyarakat dan konstituen daerah',
            onTap: _doResesWarga,
          ),

          _buildTile(
            icon: Icons.analytics,
            color: Colors.blue.shade700,
            title: 'Rapat Komisi & Anggaran Daerah 📊',
            subtitle: 'Membahas alokasi APBD dan efisiensi anggaran dinas',
            onTap: _doRapatKomisi,
          ),

          _buildTile(
            icon: Icons.handshake,
            color: Colors.purple,
            title: 'Lobi Fraksi Parlemen 🤝',
            subtitle: 'Membangun kesepakatan koalisi lintas fraksi',
            onTap: _doLobiFraksi,
          ),

          _buildTile(
            icon: Icons.group,
            color: Colors.teal,
            title: 'Rekan Kerja & Staf Dewan 👥',
            subtitle: 'Berinteraksi dengan rekan sesama anggota DPRD & staf ahli',
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
            title: 'Ikuti Pemilu Walikota / Tingkat Lanjut 🗳️',
            subtitle: 'Mencalonkan diri ke jenjang politik yang lebih tinggi',
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
        ],
      ),
    );
  }
}
