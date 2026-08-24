import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/interactions/classmate_interaction_page.dart';

class RekanKerjaPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const RekanKerjaPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<RekanKerjaPage> createState() => _RekanKerjaPageState();
}

class _RekanKerjaPageState extends State<RekanKerjaPage> {
  @override
  Widget build(BuildContext context) {
    final coworkers = widget.character.coworkers;
    final supervisor = widget.character.supervisor;
    final userAvatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
      widget.character,
      happiness: widget.character.happiness,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekan Kerja & Atasan 👥'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================= SUPERVISOR SECTION =================
          if (supervisor != null) ...[
            const Row(
              children: [
                Icon(Icons.supervisor_account, size: 20, color: Colors.blueGrey),
                SizedBox(width: 8),
                Text(
                  'Atasan / Supervisor',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.blue.shade100),
              ),
              child: () {
                final String name = supervisor['name']!;
                final String gender = supervisor['gender']!;
                final int age = int.tryParse(supervisor['age'] ?? '40') ?? 40;
                final int rel = int.tryParse(supervisor['relationship'] ?? '50') ?? 50;
                final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
                  name: name,
                  gender: gender,
                  age: age,
                  schoolLevel: 'SMA',
                  happiness: rel,
                );

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Supervisor',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Atasan • Umur: $age tahun • Hubungan: $rel% • Kecerdasan: ${supervisor['intelligence']}%',
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.blue),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassmateInteractionPage(
                          classmate: supervisor,
                          character: widget.character,
                          onRefresh: () {
                            setState(() {});
                            widget.onRefresh();
                          },
                        ),
                      ),
                    );
                  },
                );
              }(),
            ),
            const SizedBox(height: 24),
          ],

          // ================= TEAM SECTION =================
          Row(
            children: [
              const Icon(Icons.group, size: 20, color: Colors.blueGrey),
              const SizedBox(width: 8),
              const Text(
                'Tim Kerja',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(width: 8),
              if (supervisor != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Text(
                    'Dikontrol oleh ${supervisor['name']!.split(" ").first}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // User Card (Kamu)
          Card(
            elevation: 0,
            color: Colors.green.shade50,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.green.shade200),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(userAvatarUrl),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.character.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Kamu',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                'Posisi: ${widget.character.jobName} • Umur: ${widget.character.age} tahun • Kinerja: Maksimal',
              ),
            ),
          ),

          if (coworkers.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Text(
                  'Tidak ada rekan kerja saat ini.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          else
            ...coworkers.map((cm) {
              final String name = cm['name']!;
              final String gender = cm['gender']!;
              final int age = int.tryParse(cm['age'] ?? '30') ?? 30;
              final int rel = int.tryParse(cm['relationship'] ?? '50') ?? 50;
              final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
                name: name,
                gender: gender,
                age: age,
                schoolLevel: 'SMA',
                happiness: rel,
              );

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      (() {
                        final String? relStr = widget.character.getPartnerRelation(name);
                        if (relStr == null) return const SizedBox.shrink();
                        return Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            relStr,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        );
                      }()),
                    ],
                  ),
                  subtitle: Text(
                    'Rekan Kerja • Umur: $age tahun • Hubungan: $rel% • Kecerdasan: ${cm['intelligence']}%',
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassmateInteractionPage(
                          classmate: cm,
                          character: widget.character,
                          onRefresh: () {
                            setState(() {});
                            widget.onRefresh();
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
        ],
      ),
    );
  }
}
