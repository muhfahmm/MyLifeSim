// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/esport_logic/menu_esport/rekan_esport_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'rekan_esport_interaction_page.dart';

class RekanEsportPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const RekanEsportPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<RekanEsportPage> createState() => _RekanEsportPageState();
}

class _RekanEsportPageState extends State<RekanEsportPage> {
  @override
  void initState() {
    super.initState();
    if (widget.character.coworkers.isEmpty) {
      widget.character.generateCoworkersIfEmpty();
    }
  }

  Widget _buildRoleBadge(String role, {bool isUser = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isUser
            ? Colors.purple.shade50
            : Colors.purple.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.purple.shade200,
          width: 1,
        ),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.purple.shade700,
        ),
      ),
    );
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
        title: const Text('Rekan Kerja & Tim Esport 🎮', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFF3F4F8),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // KARTU KAMU (USER CARD)
          _buildUserCard(isDark, userAvatarUrl),

          const SizedBox(height: 8),

          // KARTU REKAN ESPORT LAINNYA
          if (coworkers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  'Belum ada data rekan kerja atau anggota tim Esport saat ini.',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey,
                    fontSize: 12,
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
    String userRole = widget.character.jobName ?? 'Player Esport';
    if (userRole.contains('(') && userRole.contains(')')) {
      userRole = userRole.substring(0, userRole.indexOf('(')).trim();
    }
    final int perf = widget.character.discipline.clamp(0, 100);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.indigo.shade400 : Colors.indigo.shade200,
          width: 1.5,
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
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            AvatarImageCache.buildAvatar(
              url: userAvatarUrl,
              width: 48,
              height: 48,
              gender: widget.character.gender,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.character.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey.shade900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildRoleBadge(userRole, isUser: true),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade700,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Kamu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Umur: ${widget.character.age} th • Performa: $perf%',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: perf / 100.0,
                      backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                      color: Colors.orange.shade700,
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoworkerCard(Map<String, String> cm, bool isDark) {
    final String name = cm['name'] ?? 'Rekan Tim';
    final String gender = cm['gender'] ?? 'Laki-laki';
    final String role = cm['role'] ?? cm['title'] ?? 'Pro Player';
    final int age = int.tryParse(cm['age'] ?? '20') ?? 20;
    final int rel = int.tryParse(cm['relationship'] ?? '50') ?? 50;

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
            builder: (context) => RekanEsportInteractionPage(
              coworker: cm,
              character: widget.character,
              onRefresh: () {
                setState(() {});
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
                      'Umur: $age th • Hubungan: $rel%',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
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
  }
}
