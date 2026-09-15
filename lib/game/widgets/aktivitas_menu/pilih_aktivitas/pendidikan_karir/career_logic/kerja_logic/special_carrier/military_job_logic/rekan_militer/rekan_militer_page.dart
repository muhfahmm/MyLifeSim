// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/military_job_logic/rekan_militer/rekan_militer_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/school_logic/actions/interactions/classmate_interaction_page.dart';

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
              color: isDark ? Colors.green.shade900.withValues(alpha: 0.25) : Colors.green.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.green.shade700),
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
                fontSize: 16,
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
              elevation: 2,
              color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.green.shade700),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(
                            AvatarAgeRules.getSchoolAvatarUrl(
                              name: supervisor['name']!,
                              gender: supervisor['gender']!,
                              age: int.tryParse(supervisor['age'] ?? '45') ?? 45,
                              schoolLevel: 'SMA',
                              happiness: int.tryParse(supervisor['relationship'] ?? '50') ?? 50,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                supervisor['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Komandan Kedinasan • Usia ${supervisor['age']} thn',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    'Loyalitas: ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: (int.tryParse(supervisor['relationship'] ?? '50') ?? 50) / 100.0,
                                        minHeight: 8,
                                        backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${supervisor['relationship']}%',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                ],
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
              fontSize: 16,
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

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    title: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$role • $gender, $age thn',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Solidaritas: ',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: rel / 100.0,
                                  minHeight: 6,
                                  backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    rel >= 70 ? Colors.green : (rel >= 40 ? Colors.amber : Colors.red),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$rel%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ClassmateInteractionPage(
                            character: character,
                            classmate: c,
                            onRefresh: () {
                              if (mounted) setState(() {});
                              widget.onRefresh();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
