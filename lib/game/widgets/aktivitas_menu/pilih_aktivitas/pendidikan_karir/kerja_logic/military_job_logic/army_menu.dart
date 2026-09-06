// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/army_logic/army_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class ArmyMenuPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const ArmyMenuPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<ArmyMenuPage> createState() => _ArmyMenuPageState();
}

class _ArmyMenuPageState extends State<ArmyMenuPage> {
  final List<Map<String, dynamic>> _branches = [
    {
      'branch': 'Angkatan Darat',
      'title': 'Tentara Angkatan Darat (TNI AD)',
      'desc': 'Menjaga pertahanan wilayah daratan dan pertahanan nasional',
      'icon': Icons.military_tech,
      'color': Colors.green.shade800,
      'ranks': [
        {'rank': 'Prajurit Dua', 'salary': 2200, 'minIntel': 20},
        {'rank': 'Sersan', 'salary': 3500, 'minIntel': 40},
        {'rank': 'Letnan', 'salary': 4500, 'minIntel': 55},
        {'rank': 'Kapten', 'salary': 6000, 'minIntel': 65},
        {'rank': 'Mayor', 'salary': 7500, 'minIntel': 75},
        {'rank': 'Jenderal AD', 'salary': 12000, 'minIntel': 85},
      ],
    },
    {
      'branch': 'Angkatan Laut',
      'title': 'Tentara Angkatan Laut (TNI AL)',
      'desc': 'Menjaga kedaulatan laut dan wilayah perairan kedaulatan negara',
      'icon': Icons.directions_boat_rounded,
      'color': Colors.blue.shade800,
      'ranks': [
        {'rank': 'Kelasi Dua', 'salary': 2300, 'minIntel': 20},
        {'rank': 'Sersan AL', 'salary': 3600, 'minIntel': 40},
        {'rank': 'Letnan Laut', 'salary': 4600, 'minIntel': 55},
        {'rank': 'Kapten Laut', 'salary': 6200, 'minIntel': 65},
        {'rank': 'Laksamana Pertama', 'salary': 8000, 'minIntel': 75},
        {'rank': 'Laksamana AL', 'salary': 12500, 'minIntel': 85},
      ],
    },
    {
      'branch': 'Angkatan Udara',
      'title': 'Tentara Angkatan Udara (TNI AU)',
      'desc': 'Mengamankan wilayah udara nasional dan armada skuadron tempur',
      'icon': Icons.flight_takeoff,
      'color': Colors.lightBlue.shade800,
      'ranks': [
        {'rank': 'Prajurit Udara', 'salary': 2400, 'minIntel': 25},
        {'rank': 'Sersan Udara', 'salary': 3800, 'minIntel': 45},
        {'rank': 'Letnan Udara', 'salary': 4800, 'minIntel': 60},
        {'rank': 'Kapten Penerbang', 'salary': 6500, 'minIntel': 70},
        {'rank': 'Marsekal Muda', 'salary': 8500, 'minIntel': 80},
        {'rank': 'Marsekal AU', 'salary': 13000, 'minIntel': 90},
      ],
    },
  ];

  void _showBranchDetail(Map<String, dynamic> branchData) {
    final bool isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final List<Map<String, dynamic>> ranks = branchData['ranks'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(branchData['icon'] as IconData, color: branchData['color'] as Color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                branchData['branch'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ranks.length,
            itemBuilder: (context, index) {
              final r = ranks[index];
              final String rankTitle = '${branchData['branch']} - ${r['rank']}';
              final int salary = r['salary'];
              final int minIntel = r['minIntel'];
              final bool isEligible = widget.character.intelligence >= minIntel;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    r['rank'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87),
                  ),
                  subtitle: Text('Gaji: \$$salary/tahun | Min Intel: $minIntel%', style: const TextStyle(fontSize: 12)),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEligible ? (branchData['color'] as Color) : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final bool hasMilitaryJob = widget.character.jobName != null &&
                          (widget.character.jobName!.contains('Angkatan Darat') ||
                              widget.character.jobName!.contains('Angkatan Laut') ||
                              widget.character.jobName!.contains('Angkatan Udara'));

                      if (hasMilitaryJob) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('⚠️ Kamu saat ini sedang aktif bertugas sebagai ${widget.character.jobName}. Mundur terlebih dahulu jika ingin mendaftar ke cabang militer lain.'),
                            backgroundColor: Colors.orange.shade800,
                          ),
                        );
                        return;
                      }

                      if (!isEligible) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Kecerdasanmu (${widget.character.intelligence}%) belum memenuhi syarat minimal $minIntel%!')),
                        );
                        return;
                      }

                      Navigator.pop(ctx);
                      setState(() {
                        widget.character.jobName = rankTitle;
                        widget.character.jobSalary = salary;
                        widget.character.inbox.add('🪖 Karir Militer: Kamu resmi mendaftar dan diterima sebagai $rankTitle dengan gaji \$$salary/tahun!');
                      });
                      widget.onRefresh();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('🎖️ Selamat! Kamu kini bergabung dengan $rankTitle!'),
                          backgroundColor: Colors.green.shade700,
                        ),
                      );
                    },
                    child: const Text('Daftar'),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final bool hasMilitaryJob = widget.character.jobName != null &&
        (widget.character.jobName!.contains('Angkatan Darat') ||
            widget.character.jobName!.contains('Angkatan Laut') ||
            widget.character.jobName!.contains('Angkatan Udara'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karir Militer 🪖', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Status Militer Karakter jika sudah bertugas
            if (hasMilitaryJob)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade900, Colors.teal.shade900],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.military_tech, color: Colors.amber, size: 28),
                        SizedBox(width: 8),
                        Text('Status Militer Aktif', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Pangkat & Tugas: ${widget.character.jobName}', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    Text('Gaji Militer: \$${widget.character.jobSalary}/tahun', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          widget.character.jobName = null;
                          widget.character.jobSalary = null;
                          widget.character.inbox.add('🪖 Kamu telah mengundurkan diri dari dinas militer.');
                        });
                        widget.onRefresh();
                      },
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text('Mundur dari Dinas Militer'),
                    ),
                  ],
                ),
              ),

            Text(
              'PILIH CABANG ANGKATAN MILITER',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white60 : Colors.grey.shade700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),

            ..._branches.map((b) {
              final IconData icon = b['icon'] as IconData;
              final Color color = b['color'] as Color;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: isDark ? Colors.grey.shade800 : Colors.white,
                elevation: 3,
                child: InkWell(
                  onTap: () => _showBranchDetail(b),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: color, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                b['title'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                b['desc'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: isDark ? Colors.white54 : Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
