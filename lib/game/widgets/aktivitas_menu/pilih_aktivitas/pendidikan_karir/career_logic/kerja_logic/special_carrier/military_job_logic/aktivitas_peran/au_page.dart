// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/military_job_logic/aktivitas_peran/au_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import '../rekan_militer/rekan_militer_page.dart';
import '../army_menu.dart';

class AuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AuPage> createState() => _AuPageState();
}

class _AuPageState extends State<AuPage> {
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

  void _doPatroliUdara() {
    final r = Random();
    final discGain = 3 + r.nextInt(5);
    final happyGain = 2 + r.nextInt(4);
    character.discipline = (character.discipline + discGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Patroli Udara & Skuadron Jet Tempur ✈️',
      'Kamu menerbangkan jet tempur mengamankan ruang udara nasional dari pelanggaran batas kedaulatan.\n\n'
      '• Kedisiplinan Penerbang: +$discGain%\n'
      '• Performa Kedinasan: $_jobPerformance%',
    );
  }

  void _doLatihanDogfight() {
    final r = Random();
    final intelGain = 2 + r.nextInt(3);
    final discGain = 2 + r.nextInt(3);
    character.intelligence = (character.intelligence + intelGain).clamp(0, 100);
    character.discipline = (character.discipline + discGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Latihan Dogfight & Aerobatik Skuadron 🛩️',
      'Kamu melakukan simulasi pertempuran udara dogfight dan manuver kecepatan tinggi di angkasa.\n\n'
      '• Kecerdasan Aviasi: +$intelGain%\n'
      '• Kedisiplinan: +$discGain%',
    );
  }

  void _doOperasiPengintaian() {
    final r = Random();
    final karmaGain = 3 + r.nextInt(5);
    final happyGain = 2 + r.nextInt(3);
    character.karma = (character.karma + karmaGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Misi Pengintaian & Pemetaan Udara 🎯',
      'Kamu melakukan misi reconnaissance dan pengintaian udara untuk radar pertahanan nasional.\n\n'
      '• Reputasi & Kepercayaan: +$karmaGain%\n'
      '• Kebahagiaan: +$happyGain%',
    );
  }

  void _doPemeliharaanArmada() {
    final r = Random();
    final intelGain = 2 + r.nextInt(3);
    final happyGain = 2 + r.nextInt(3);
    character.intelligence = (character.intelligence + intelGain).clamp(0, 100);
    character.happiness = (character.happiness + happyGain).clamp(0, 100);
    setState(() {});
    widget.onRefresh();

    _showAlert(
      'Pemeliharaan Jet & Pangkalan Udara 🛫',
      'Kamu meninjau perawatan helikopter, pesawat angkut, dan jet persenjataan di Lanud.\n\n'
      '• Kesiapan Alat Utama: +$intelGain%\n'
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
                'Mundurkan Diri dari TNI AU ✈️',
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
    final String currentJob = character.jobName ?? 'Tentara Angkatan Udara';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Angkatan Udara (TNI AU) ✈️'),
        backgroundColor: Colors.lightBlue.shade900,
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
                    backgroundColor: Colors.lightBlue.shade100,
                    child: Icon(Icons.flight_takeoff, size: 32, color: Colors.lightBlue.shade900),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pangkat & Status Militer AU:',
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentJob,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.lightBlue.shade300 : Colors.lightBlue.shade900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gaji: ${CurrencySettings.format(character.jobSalary ?? 3800)}/tahun',
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
            'Aktivitas Pertahanan Angkatan Udara',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.blueGrey),
          ),
          const SizedBox(height: 12),

          _buildTile(
            icon: Icons.flight,
            color: Colors.lightBlue.shade900,
            title: 'Patroli Udara & Skuadron Jet Tempur ✈️',
            subtitle: 'Menjaga kedaulatan ruang udara kedaulatan wilayah udara negara',
            onTap: _doPatroliUdara,
          ),

          _buildTile(
            icon: Icons.airplanemode_active,
            color: Colors.blue.shade800,
            title: 'Latihan Dogfight & Aerobatik Skuadron 🛩️',
            subtitle: 'Simulasi tempur dogfight penerbang & kualifikasi skuadron',
            onTap: _doLatihanDogfight,
          ),

          _buildTile(
            icon: Icons.center_focus_strong,
            color: Colors.teal.shade800,
            title: 'Misi Pengintaian & Pemetaan Udara 🎯',
            subtitle: 'Misi pengawasan sistem radar pertahanan udara nasional',
            onTap: _doOperasiPengintaian,
          ),

          _buildTile(
            icon: Icons.flight_land,
            color: Colors.indigo.shade800,
            title: 'Pemeliharaan Jet & Pangkalan Udara 🛫',
            subtitle: 'Kesiapan armada jet tempur & fasilitas pangkalan udara (Lanud)',
            onTap: _doPemeliharaanArmada,
          ),

          _buildTile(
            icon: Icons.group,
            color: Colors.blue,
            title: 'Rekan Dinas & Komandan 👥',
            subtitle: 'Berinteraksi dengan sesama penerbang & Komandan Skuadron Lanud',
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
            color: Colors.purple,
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
            subtitle: 'Mundur dari dinas militer Angkatan Udara',
            onTap: _resign,
          ),
        ],
      ),
    );
  }
}
