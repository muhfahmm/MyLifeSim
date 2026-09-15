// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/astronot_job_logic/menu_astronot/rekan_astronot_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/school_logic/actions/interactions/classmate_interaction_page.dart';

class RekanAstronotPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const RekanAstronotPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<RekanAstronotPage> createState() => _RekanAstronotPageState();
}

class _RekanAstronotPageState extends State<RekanAstronotPage> {
  @override
  void initState() {
    super.initState();
    if (widget.character.coworkers.isEmpty) {
      widget.character.generateCoworkersIfEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final coworkers = widget.character.coworkers;
    final userAvatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
      widget.character,
      happiness: widget.character.happiness,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekan Kosmonot & Kru Stasiun 👨‍🚀🛰️'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // KARTU KAMU (USER CARD)
          _buildUserCard(isDark, userAvatarUrl),

          const SizedBox(height: 12),

          // KARTU REKAN ASTRONOT LAINNYA
          if (coworkers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  'Belum ada data astronot / kosmonot di lembaga ini.',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ...coworkers.map((cm) => _buildCoworkerCard(cm, isDark)),
        ],
      ),
    );
  }

  Widget _buildUserCard(bool isDark, String userAvatarUrl) {
    String userRole = widget.character.jobName ?? 'Astronot';
    if (userRole.startsWith('Astronot:')) {
      userRole = userRole.replaceAll('Astronot:', '').trim();
    }

    final String userTitleDisplay = '${widget.character.name} - $userRole';

    return Card(
      elevation: 0,
      color: isDark ? Colors.grey.shade800 : Colors.indigo.shade50,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.indigo.shade400 : Colors.indigo.shade300,
          width: 1.5,
        ),
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
                userTitleDisplay,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.indigo.shade200 : Colors.indigo.shade900,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.indigo.shade700,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Kamu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          'Umur: ${widget.character.age} tahun • Kinerja: Maksimal',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildCoworkerCard(Map<String, String> cm, bool isDark) {
    final String name = cm['name'] ?? 'Astronot';
    final String gender = cm['gender'] ?? 'Laki-laki';
    final String role = cm['role'] ?? cm['title'] ?? 'Kosmonot Senior';
    final int age = int.tryParse(cm['age'] ?? '35') ?? 35;
    final int rel = int.tryParse(cm['relationship'] ?? '50') ?? 50;
    final int intel = int.tryParse(cm['intelligence'] ?? '75') ?? 75;

    final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
      name: name,
      gender: gender,
      age: age,
      schoolLevel: 'SMA',
      happiness: rel,
    );

    final String titleDisplay = '$name - $role';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        title: Text(
          titleDisplay,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Umur: $age tahun • Hubungan: $rel% • Kecerdasan: $intel%',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: 16,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
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
