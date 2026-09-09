import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/school_logic/actions/interactions/classmate_interaction_page.dart';

class RekanTimPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const RekanTimPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<RekanTimPage> createState() => _RekanTimPageState();
}

class _RekanTimPageState extends State<RekanTimPage> {
  @override
  void initState() {
    super.initState();
    if (widget.character.jobName != null &&
        (widget.character.coworkers.isEmpty ||
            widget.character.supervisor == null ||
            widget.character.assistantCoach == null)) {
      widget.character.generateCoworkersIfEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final coworkers = widget.character.coworkers;
    final headCoach = widget.character.supervisor;
    final assistantCoach = widget.character.assistantCoach;
    final userAvatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
      widget.character,
      happiness: widget.character.happiness,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekan Tim & Staf Pelatih 👥'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================= STAF KEPELATIHAN SECTION =================
          if (headCoach != null || assistantCoach != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.supervisor_account,
                        size: 20, color: isDark ? Colors.white70 : Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(
                      'Staf Kepelatihan / Pelatih',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Pelatih Utama (Head Coach)
                if (headCoach != null)
                  _buildCoachCard(
                    coachData: headCoach,
                    label: 'Pelatih Utama',
                    isDark: isDark,
                  ),

                if (headCoach != null && assistantCoach != null)
                  const SizedBox(height: 8),

                // Asisten Pelatih (Assistant Coach)
                if (assistantCoach != null)
                  _buildCoachCard(
                    coachData: assistantCoach,
                    label: 'Asisten Pelatih',
                    isDark: isDark,
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // ================= REKAN TIM SECTION =================
          Row(
            children: [
              Icon(Icons.group, size: 20, color: isDark ? Colors.white70 : Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                'Rekan Tim',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.blueGrey,
                ),
              ),
              const SizedBox(width: 8),
              if (headCoach != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.green.shade900 : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDark ? Colors.green.shade700 : Colors.green.shade300),
                  ),
                  child: Text(
                    'Dikontrol oleh ${headCoach['name']!.split(" ").first}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.greenAccent : Colors.green.shade800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // User Card (Kamu)
          Card(
            elevation: 0,
            color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                  color: isDark ? Colors.grey.shade700 : Colors.green.shade200),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.lightGreenAccent : Colors.green,
                      ),
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
                      style: TextStyle(
                          color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                'Posisi: ${widget.character.jobName} • Umur: ${widget.character.age} tahun • Kinerja: Maksimal',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ),

          if (coworkers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  'Tidak ada rekan tim saat ini.',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else ...[
            (() {
              final bool hasTeamCategories =
                  coworkers.any((cm) => cm.containsKey('teamCategory'));

              if (!hasTeamCategories) {
                return Column(
                  children: coworkers
                      .map((cm) => _buildCoworkerCard(cm, isDark))
                      .toList(),
                );
              }

              final mainTeam = coworkers
                  .where((cm) => cm['teamCategory'] == 'Tim Utama')
                  .toList();
              final subTeam = coworkers
                  .where((cm) => cm['teamCategory'] == 'Tim Cadangan')
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mainTeam.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Tim Utama (${mainTeam.length} Pemain)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark
                                  ? Colors.green.shade300
                                  : Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...mainTeam.map((cm) => _buildCoworkerCard(cm, isDark)),
                  ],
                  if (subTeam.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.groups,
                              color: Colors.orange, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            'Tim Cadangan (${subTeam.length} Pemain)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isDark
                                  ? Colors.orange.shade300
                                  : Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...subTeam.map((cm) => _buildCoworkerCard(cm, isDark)),
                  ],
                ],
              );
            })(),
          ],
        ],
      ),
    );
  }

  Widget _buildCoachCard({
    required Map<String, String> coachData,
    required String label,
    required bool isDark,
  }) {
    final String name = coachData['name']!;
    final String gender = coachData['gender']!;
    final int age = int.tryParse(coachData['age'] ?? '40') ?? 40;
    final int rel = int.tryParse(coachData['relationship'] ?? '50') ?? 50;
    final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
      name: name,
      gender: gender,
      age: age,
      schoolLevel: 'SMA',
      happiness: rel,
    );

    return Card(
      elevation: 0,
      color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.blue.shade100),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.lightBlueAccent : Colors.blue,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: const TextStyle(
                    color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Text(
          '$label • Umur: $age tahun • Hubungan: $rel% • Kecerdasan: ${coachData['intelligence'] ?? '60'}%',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: Icon(Icons.chevron_right,
            size: 16, color: isDark ? Colors.white70 : Colors.blue),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassmateInteractionPage(
                classmate: coachData,
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
  }

  Widget _buildCoworkerCard(Map<String, String> cm, bool isDark) {
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

    final String? category = cm['teamCategory'];

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (category != null)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: category == 'Tim Utama'
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
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
                  style: const TextStyle(
                      color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              );
            }()),
          ],
        ),
        subtitle: Text(
          '${cm['role'] ?? 'Pemain'} • Umur: $age tahun • Hubungan: $rel% • Kecerdasan: ${cm['intelligence']}%',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: Icon(Icons.chevron_right,
            size: 16, color: isDark ? Colors.white70 : Colors.black87),
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
  }
}
