import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/action_menu/rekan_tim/rekan_atlet_interaction_page.dart';

import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/sepakbola_logic/logika_usia_rekan_tim.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/sepakbola_logic/database_formasi_pelatih.dart';

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
    LogikaUsiaRekanTim.syncTeammateAges(widget.character);
  }

  Widget _buildRoleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.shade700.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade500.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.green.shade800,
        ),
      ),
    );
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

    final bool isUserStarter = ((widget.character.discipline + widget.character.health) / 2) >= 65;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekan Tim & Staf Pelatih 👥', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
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
                        size: 18, color: isDark ? Colors.white70 : Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(
                      'Staf Kepelatihan / Pelatih',
                      style: TextStyle(
                        fontSize: 14,
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
            const SizedBox(height: 16),
          ],

          // ================= REKAN TIM SECTION =================
          Row(
            children: [
              Icon(Icons.group, size: 18, color: isDark ? Colors.white70 : Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                'Rekan Tim',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.blueGrey,
                ),
              ),
              const SizedBox(width: 8),
              if (headCoach != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.green.shade900 : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isDark ? Colors.green.shade700 : Colors.green.shade300),
                  ),
                  child: Text(
                    'Dikontrol oleh ${headCoach['name']!.split(" ").first}${headCoach['formation'] != null ? " (${headCoach['formation']})" : ""}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.greenAccent : Colors.green.shade800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          if (coworkers.isEmpty) ...[
            _buildUserCard(isDark, userAvatarUrl, isUserStarter),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  'Tidak ada rekan tim saat ini.',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ] else ...[
            (() {
              final bool hasTeamCategories =
                  coworkers.any((cm) => cm.containsKey('teamCategory'));

              if (!hasTeamCategories) {
                return Column(
                  children: [
                    _buildUserCard(isDark, userAvatarUrl, isUserStarter),
                    ...coworkers.map((cm) => _buildCoworkerCard(cm, isDark)),
                  ],
                );
              }

              final mainTeam = coworkers
                  .where((cm) => cm['role'] == 'Pemain Utama' || (cm.containsKey('teamCategory') && !cm['teamCategory'].toString().contains('Cadangan')))
                  .toList();
              final subTeam = coworkers
                  .where((cm) => cm['role'] == 'Pemain Cadangan' || (cm.containsKey('teamCategory') && cm['teamCategory'].toString().contains('Cadangan')))
                  .toList();

              final String mainCategoryTitle = mainTeam.isNotEmpty && mainTeam.first.containsKey('teamCategory')
                  ? mainTeam.first['teamCategory']!
                  : LogikaUsiaRekanTim.getKategoriTimBerdasarkanUsia(usia: widget.character.age);

              final int mainTeamCount = isUserStarter ? (mainTeam.length + 1) : mainTeam.length;
              final int subTeamCount = !isUserStarter ? (subTeam.length + 1) : subTeam.length;

              // Susun daftar widget pemain utama berurutan sesuai posisi (Kiper -> Bek -> Gelandang -> Penyerang)
              final List<Map<String, dynamic>> mainPlayerItems = [];
              if (isUserStarter) {
                String uPos = widget.character.jobName ?? 'Atlet';
                if (uPos.contains(' - ')) uPos = uPos.split(' - ').first.trim();
                if (uPos.contains('(')) uPos = uPos.split('(').first.trim();
                mainPlayerItems.add({
                  'priority': _getPositionPriority(uPos),
                  'widget': _buildUserCard(isDark, userAvatarUrl, true),
                });
              }

              for (var cm in mainTeam) {
                final pos = cm['position'] ?? 'Pemain';
                mainPlayerItems.add({
                  'priority': _getPositionPriority(pos),
                  'widget': _buildCoworkerCard(cm, isDark),
                });
              }

              mainPlayerItems.sort((a, b) => (a['priority'] as int).compareTo(b['priority'] as int));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mainTeam.isNotEmpty || isUserStarter) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '$mainCategoryTitle ($mainTeamCount Pemain)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: isDark
                                  ? Colors.green.shade300
                                  : Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...mainPlayerItems.map((item) => item['widget'] as Widget),
                  ],
                  if (subTeam.isNotEmpty || !isUserStarter) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          const Icon(Icons.groups,
                              color: Colors.orange, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '$mainCategoryTitle Cadangan ($subTeamCount Pemain)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: isDark
                                  ? Colors.orange.shade300
                                  : Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isUserStarter) _buildUserCard(isDark, userAvatarUrl, false),
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

  int _getPositionPriority(String position) {
    final p = position.toLowerCase();
    if (p.contains('kiper') || p.contains('goalkeeper')) return 10;
    if (p.contains('bek kiri') || p.contains('left back')) return 21;
    if (p.contains('bek tengah') || p.contains('center back')) return 22;
    if (p.contains('bek kanan') || p.contains('right back')) return 23;
    if (p.contains('bek') || p.contains('defender')) return 24;
    if (p.contains('gelandang bertahan') || p.contains('cdm')) return 31;
    if (p.contains('gelandang tengah') || p.contains('cm') || p.contains('midfielder')) return 32;
    if (p.contains('sayap kiri') || p.contains('left wing')) return 33;
    if (p.contains('sayap kanan') || p.contains('right wing')) return 34;
    if (p.contains('gelandang serang') || p.contains('cam')) return 35;
    if (p.contains('gelandang')) return 36;
    if (p.contains('penyerang sayap kiri') || p.contains('lw')) return 41;
    if (p.contains('striker') || p.contains('penyerang tengah') || p.contains('cf')) return 42;
    if (p.contains('penyerang sayap kanan') || p.contains('rw')) return 43;
    if (p.contains('penyerang')) return 44;
    return 50;
  }

  Widget _buildUserCard(bool isDark, String userAvatarUrl, bool isStarter) {
    String userPos = widget.character.jobName ?? 'Atlet';
    if (userPos.contains(' - ')) {
      userPos = userPos.split(' - ').first.trim();
    }
    if (userPos.contains('(')) {
      userPos = userPos.split('(').first.trim();
    }
    if (userPos == 'Bek Bertahan' || userPos == 'Bek') {
      userPos = 'Bek Tengah';
    }
    userPos = FormasiPelatihDatabase.toPositionCode(userPos);

    return Card(
      elevation: 0,
      color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isDark ? Colors.green.shade600 : Colors.green.shade300,
          width: 1.2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        leading: AvatarImageCache.buildAvatar(
          url: userAvatarUrl,
          width: 40,
          height: 40,
          gender: widget.character.gender,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.character.name,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.lightGreenAccent : Colors.green.shade800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            _buildRoleBadge(userPos),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isStarter ? Colors.green.shade700 : Colors.orange.shade700,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Kamu',
                style: TextStyle(
                  color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          'Umur: ${widget.character.age} tahun • Kinerja: Maksimal',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
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
    final String? formationStr = coachData['formation'];
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
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.blue.shade100),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        leading: AvatarImageCache.buildAvatar(
          url: avatarUrl,
          width: 40,
          height: 40,
          gender: gender,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.lightBlueAccent : Colors.blue,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (formationStr != null && formationStr.isNotEmpty) ...[
              const SizedBox(width: 6),
              _buildRoleBadge(formationStr),
            ],
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: const TextStyle(
                    color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        subtitle: Text(
          '$label • Umur: $age tahun • Hubungan: $rel% • Kecerdasan: ${coachData['intelligence'] ?? '60'}%',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: Icon(Icons.chevron_right,
            size: 14, color: isDark ? Colors.white70 : Colors.blue),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RekanAtletInteractionPage(
                coworker: coachData,
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

    String position = cm['position'] ?? '';
    if (position.isEmpty) {
      final String userJob = widget.character.jobName ?? '';
      if (userJob.contains('Basket') || userJob.contains('Guard') || userJob.contains('Center')) {
        position = ['Point Guard', 'Shooting Guard', 'Center', 'Power Forward'][name.hashCode.abs() % 4];
      } else if (userJob.contains('Balap') || userJob.contains('Pebalap')) {
        position = 'Pebalap';
      } else if (userJob.contains('Tenis') || userJob.contains('Petenis')) {
        position = 'Petenis';
      } else {
        position = ['ST', 'CM', 'CB', 'GK'][name.hashCode.abs() % 4];
      }
    } else {
      position = FormasiPelatihDatabase.toPositionCode(position);
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        leading: AvatarImageCache.buildAvatar(
          url: avatarUrl,
          width: 40,
          height: 40,
          gender: gender,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            _buildRoleBadge(position),
            if (category != null)
              Container(
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: category.contains('Cadangan')
                      ? Colors.orange.shade700
                      : Colors.green.shade700,
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
                margin: const EdgeInsets.only(left: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  relStr,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.bold),
                ),
              );
            }()),
          ],
        ),
        subtitle: Text(
          'Umur: $age tahun • Hubungan: $rel% • Kecerdasan: ${cm['intelligence'] ?? '60'}%',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: Icon(Icons.chevron_right,
            size: 14, color: isDark ? Colors.white70 : Colors.black87),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RekanAtletInteractionPage(
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
      ),
    );
  }
}

