// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/military_job_logic/rekan_militer/rekan_militer_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/military_job_logic/rekan_militer/rekan_militer_interaction_page.dart';

class RekanMiliterPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const RekanMiliterPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<RekanMiliterPage> createState() => _RekanMiliterPageState();
}

class _RekanMiliterPageState extends State<RekanMiliterPage> {
  Character get character => widget.character;

  @override
  void initState() {
    super.initState();
    if (character.jobName != null && character.coworkers.isEmpty) {
      character.generateCoworkersIfEmpty();
    }
    _adjustMilitaryRoles();
  }

  void _adjustMilitaryRoles() {
    final String job = character.jobName ?? '';

    List<String> roles = [];
    if (job.contains('Angkatan Laut') || job.contains('AL') || job.contains('Laksamana') || job.contains('Kelasi')) {
      roles = ['Prajurit Bahari', 'Sersan AL', 'Letnan Kapal', 'Kapten Armada', 'Laksamana Pertama'];
    } else if (job.contains('Angkatan Udara') || job.contains('AU') || job.contains('Marsekal') || job.contains('Penerbang')) {
      roles = ['Prajurit Penerbang', 'Sersan Skuadron', 'Letnan Pilot', 'Kapten Airframe', 'Marsekal Muda'];
    } else {
      roles = ['Prajurit Infanteri', 'Sersan Kompi', 'Letnan Batalyon', 'Kapten Taktis', 'Mayor AD'];
    }

    for (int i = 0; i < character.coworkers.length; i++) {
      final item = character.coworkers[i];
      item['role'] = roles[i % roles.length];
    }
  }

  String _getCommanderHeader() {
    final String job = character.jobName ?? '';
    if (job.contains('Angkatan Laut') || job.contains('AL') || job.contains('Laksamana')) {
      return 'Komandan Pangkalan AL & Laksamana ⚓';
    } else if (job.contains('Angkatan Udara') || job.contains('AU') || job.contains('Marsekal')) {
      return 'Komandan Skuadron & Marsekal AU ✈️';
    }
    return 'Komandan Batalyon & Senior AD 🪖';
  }

  String _getCommanderSubtitle() {
    final String job = character.jobName ?? '';
    if (job.contains('Angkatan Laut') || job.contains('AL') || job.contains('Laksamana')) {
      return 'Komando armada perairan dan pangkalan militer laut';
    } else if (job.contains('Angkatan Udara') || job.contains('AU') || job.contains('Marsekal')) {
      return 'Komando pangkalan udara dan skuadron skuadron tempur';
    }
    return 'Komando Markas Besar Batalyon dan Infanteri AD';
  }

  Widget _buildRoleBadge(String role) {
    Color color = Colors.green.shade800;
    Color bgColor = Colors.green.shade50;
    if (role.contains('Laksamana') || role.contains('Marsekal') || role.contains('Mayor') || role.contains('Kapten') || role.contains('Komandan')) {
      color = Colors.amber.shade900;
      bgColor = Colors.amber.shade50;
    } else if (role.contains('Letnan') || role.contains('Sersan')) {
      color = Colors.blue.shade800;
      bgColor = Colors.blue.shade50;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(102), width: 0.5),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

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

  void _interactCommander(Map<String, String> commander, String action) {
    final r = Random();
    int currentRel = int.tryParse(commander['relationship'] ?? '50') ?? 50;

    if (action == 'laporan') {
      currentRel = (currentRel + 4 + r.nextInt(4)).clamp(0, 100);
      commander['relationship'] = currentRel.toString();
      character.discipline = (character.discipline + 2).clamp(0, 100);
      setState(() {});
      widget.onRefresh();
      _showAlert(
        'Laporan Dinas Militer 🫡',
        'Kamu menyampaikan laporan kesiapan kedinasan dan loyalitas tempur kepada Komandan ${commander['name']}.\n\n'
        '• Kepercayaan Komandan: $currentRel%\n'
        '• Kedisiplinan Militer: +2%',
      );
    } else if (action == 'latihan') {
      currentRel = (currentRel + 5 + r.nextInt(5)).clamp(0, 100);
      commander['relationship'] = currentRel.toString();
      character.intelligence = (character.intelligence + 1).clamp(0, 100);
      setState(() {});
      widget.onRefresh();
      _showAlert(
        'Latihan Taktis Komando 🎯',
        'Kamu mengikuti instruksi simulasi operasi militer dan taktik tempur komando bersama Komandan ${commander['name']}.\n\n'
        '• Tingkat Hubungan: $currentRel%\n'
        '• Kecerdasan Taktis: +1%',
      );
    } else if (action == 'penghormatan') {
      currentRel = (currentRel + 6 + r.nextInt(5)).clamp(0, 100);
      commander['relationship'] = currentRel.toString();
      character.happiness = (character.happiness + 2).clamp(0, 100);
      setState(() {});
      widget.onRefresh();
      _showAlert(
        'Pemberian Hormat Militer 🎖️',
        'Kamu memberi salam hormat militer resmi dan menyampaikan apresiasi atas integritas kepemimpinan Komandan ${commander['name']}.\n\n'
        '• Tingkat Hubungan: $currentRel%\n'
        '• Kebahagiaan: +2%',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String currentJob = character.jobName ?? 'Militer';
    final coworkers = character.coworkers;
    final supervisor = character.supervisor;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : null,
      appBar: AppBar(
        title: const Text('Rekan Dinas & Komandan 🪖'),
        backgroundColor: Colors.green.shade900,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.green.shade900.withAlpha(64) : Colors.green.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.green.shade700, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.military_tech, color: Colors.amber, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jajaran Personel $currentJob',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Perkuat hirarki komando dan bangun solidaritas sesama prajurit militer.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= KOMANDAN / SENIOR MILITER SECTION =================
          if (supervisor != null) ...[
            Text(
              _getCommanderHeader(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getCommanderSubtitle(),
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 0,
              color: isDark ? Colors.grey.shade800 : Colors.green.shade50.withAlpha(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.green.shade700, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AvatarImageCache.buildAvatar(
                          url: AvatarAgeRules.getSchoolAvatarUrl(
                            name: supervisor['name'] ?? 'Komandan Atasan',
                            gender: supervisor['gender'] ?? 'Laki-laki',
                            age: int.tryParse(supervisor['age'] ?? '45') ?? 45,
                            schoolLevel: 'SMA',
                            happiness: int.tryParse(supervisor['relationship'] ?? '50') ?? 50,
                          ),
                          width: 44,
                          height: 44,
                          gender: supervisor['gender'] ?? 'Laki-laki',
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                supervisor['name'] ?? 'Komandan Atasan',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  _buildRoleBadge('Komandan'),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Umur: ${supervisor['age']} th • Hubungan: ${supervisor['relationship']}%',
                                      style: const TextStyle(fontSize: 11),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: (int.tryParse(supervisor['relationship'] ?? '50') ?? 50) / 100.0,
                                  minHeight: 4,
                                  backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade800,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _interactCommander(supervisor, 'laporan'),
                            icon: const Icon(Icons.assignment, size: 12),
                            label: const Text(
                              'Laporan 🫡',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _interactCommander(supervisor, 'latihan'),
                            icon: const Icon(Icons.fitness_center, size: 12),
                            label: const Text(
                              'Latihan 🎯',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade800,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _interactCommander(supervisor, 'penghormatan'),
                            icon: const Icon(Icons.military_tech, size: 12),
                            label: const Text(
                              'Hormat 🎖️',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ================= DAFTAR PRAJURIT & REKAN MILITER =================
          Text(
            'Daftar Prajurit & Rekan Skuad 👥',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 10),

          if (coworkers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Belum ada data prajurit/rekan militer.',
                  style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: coworkers.length,
              itemBuilder: (ctx, idx) {
                final c = coworkers[idx];
                final String name = c['name'] ?? 'Prajurit Militer';
                final String gender = c['gender'] ?? 'Laki-laki';
                final int age = int.tryParse(c['age'] ?? '28') ?? 28;
                final int rel = int.tryParse(c['relationship'] ?? '50') ?? 50;
                final String role = c['role'] ?? 'Prajurit';

                final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
                  name: name,
                  gender: gender,
                  age: age,
                  schoolLevel: 'SMA',
                  happiness: rel,
                );

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => RekanMiliterInteractionPage(
                          character: character,
                          coworker: c,
                          onRefresh: () {
                            if (mounted) setState(() {});
                            widget.onRefresh();
                          },
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          AvatarImageCache.buildAvatar(
                            url: avatarUrl,
                            width: 48,
                            height: 48,
                            gender: gender,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.grey.shade900,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                _buildRoleBadge(role),
                                const SizedBox(height: 6),
                                Text(
                                  'Umur: $age th • Solidaritas: $rel%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (rel.clamp(0, 100)) / 100.0,
                                    backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                    color: Colors.orange.shade700,
                                    minHeight: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: isDark ? Colors.white54 : Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
