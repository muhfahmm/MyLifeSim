// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/military_job_logic/aktivitas_peran/ad_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import '../rekan_militer/rekan_militer_page.dart';
import '../army_menu.dart';

class AdPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AdPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
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

  void _doPatroliPerbatasan() {
    final r = Random();
    final discGain = 3 + r.nextInt(5);
    final happyGain = 2 + r.nextInt(4);
    character.discipline = (character.discipline + discGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Patroli Perbatasan & Teritorial 🪖',
      'Kamu memimpin atau mengikuti ronda siaga di pos perbatasan daratan kedaulatan negara.\n\n'
      '• Kedisiplinan Militer: +$discGain%\n'
      '• Performa Kedinasan: $_jobPerformance%',
    );
  }

  void _doLatihanTaktis() {
    final r = Random();
    final intelGain = 2 + r.nextInt(3);
    final discGain = 2 + r.nextInt(3);
    character.intelligence = (character.intelligence + intelGain).clamp(0, 100);
    character.discipline = (character.discipline + discGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Latihan Tempur & Simulasi Perang 🎯',
      'Kamu menembak alutsista, latihan navigasi darat, dan taktik manuver infanteri.\n\n'
      '• Kecerdasan Taktis: +$intelGain%\n'
      '• Kedisiplinan: +$discGain%',
    );
  }

  void _doPengamananVip() {
    final r = Random();
    final karmaGain = 3 + r.nextInt(5);
    final happyGain = 2 + r.nextInt(3);
    character.karma = (character.karma + karmaGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Pengamanan Objek Vital & Kedaulatan 🛡️',
      'Kamu mengamankan gedung vital kedaulatan negara & misi pertahanan sipil Batalyon.\n\n'
      '• Reputasi & Kepercayaan: +$karmaGain%\n'
      '• Kebahagiaan: +$happyGain%',
    );
  }

  void _doKomandoStrategis() {
    final r = Random();
    final intelGain = 2 + r.nextInt(3);
    final happyGain = 2 + r.nextInt(3);
    character.intelligence = (character.intelligence + intelGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Rapat Operasi Komando Strategis 🎖️',
      'Kamu menelaah peta garis pertahanan dan rencana pengerahan alutsista AD.\n\n'
      '• Strategi Militer: +$intelGain%\n'
      '• Kepuasan Komando: +$happyGain%',
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
                'Mundurkan Diri dari Dinas Militer 🪖',
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
            'Apakah kamu yakin ingin pensiun/mengundurkan diri dari dinas ${character.jobName}?',
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
              character.jobSalary = null;
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
    final String currentJob = character.jobName ?? 'Tentara Angkatan Darat';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Angkatan Darat (TNI AD) 🪖'),
        backgroundColor: Colors.green.shade900,
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
                    backgroundColor: Colors.green.shade100,
                    child: Icon(Icons.military_tech, size: 32, color: Colors.green.shade900),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pangkat & Status Militer AD:',
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentJob,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.green.shade300 : Colors.green.shade900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gaji: ${CurrencySettings.format(character.jobSalary ?? 3500)}/tahun',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Job Performance
                  Row(
                    children: [
                      Icon(Icons.trending_up, size: 16, color: Colors.blue.shade600),
                      const SizedBox(width: 6),
                      Text('Performa Kedinasan:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.black87)),
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
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Aktivitas Pertahanan Angkatan Darat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.blueGrey),
          ),
          const SizedBox(height: 12),

          _buildTile(
            icon: Icons.terrain,
            color: Colors.green.shade900,
            title: 'Patroli Perbatasan & Teritorial 🪖',
            subtitle: 'Menjaga keutuhan garis perbatasan darat kedaulatan negara',
            onTap: _doPatroliPerbatasan,
          ),

          _buildTile(
            icon: Icons.gps_fixed,
            color: Colors.deepOrange.shade800,
            title: 'Latihan Tempur & Simulasi Perang 🎯',
            subtitle: 'Menembak alutsista infanteri & latihan taktis Batalyon',
            onTap: _doLatihanTaktis,
          ),

          _buildTile(
            icon: Icons.shield,
            color: Colors.blue.shade800,
            title: 'Pengamanan Objek Vital & Kedaulatan 🛡️',
            subtitle: 'Misi pengawalan fasilitas strategis & operasi penanggulangan',
            onTap: _doPengamananVip,
          ),

          _buildTile(
            icon: Icons.military_tech,
            color: Colors.amber.shade900,
            title: 'Rapat Operasi Komando Strategis 🎖️',
            subtitle: 'Merencanakan manuver alutsista & siaga komando Batalyon',
            onTap: _doKomandoStrategis,
          ),

          _buildTile(
            icon: Icons.group,
            color: Colors.teal,
            title: 'Rekan Dinas & Komandan 👥',
            subtitle: 'Berinteraksi dengan sesama prajurit & Komandan Batalyon',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => RekanMiliterPage(
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
            icon: Icons.arrow_upward,
            color: Colors.indigo,
            title: 'Pilihan Pangkat & Cabang Militer 📊',
            subtitle: 'Melihat syarat kenaikan pangkat & pendaftaran cabang militer',
            onTap: () {
              ArmyMenuHelper.showBranchMenu(
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
            subtitle: 'Mundur dari dinas militer Angkatan Darat',
            onTap: _resign,
          ),
        ],
      ),
    );
  }
}
