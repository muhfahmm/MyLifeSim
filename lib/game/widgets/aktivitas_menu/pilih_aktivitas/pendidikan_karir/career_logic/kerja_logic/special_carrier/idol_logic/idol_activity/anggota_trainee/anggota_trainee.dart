import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import '../0_interactions_pages/idols_interaction_page.dart';

import 'detail_performa_trainee.dart';

class AnggotaTraineePage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AnggotaTraineePage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AnggotaTraineePage> createState() => _AnggotaTraineePageState();
}

class _AnggotaTraineePageState extends State<AnggotaTraineePage> {
  String _searchQuery = '';

  Widget _buildGenBadge(int age, {String? genStr, bool isUser = false}) {
    int genNumber;
    if (genStr != null && int.tryParse(genStr) != null) {
      genNumber = int.parse(genStr);
    } else {
      if (age >= 16) {
        genNumber = 5;
      } else if (age >= 14) {
        genNumber = 6;
      } else {
        genNumber = 7;
      }
    }

    final String text = 'Gen $genNumber';
    final Color color = isUser ? Colors.orange.shade800 : Colors.deepPurple.shade700;
    final Color bgColor = isUser ? Colors.orange.shade50 : Colors.deepPurple.shade50;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(102), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final members = widget.character.idolTrainees;

    final isUserInTeam = widget.character.jobName == 'Idol (Trainee)';
    final matchesSearch = _searchQuery.isEmpty || widget.character.name.toLowerCase().contains(_searchQuery.toLowerCase());
    final includeUser = isUserInTeam && matchesSearch;

    final filteredMembers = members.where((m) {
      if (_searchQuery.isEmpty) return true;
      final name = (m['name'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    final membersCount = filteredMembers.length + (includeUser ? 1 : 0);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        appBar: AppBar(
          title: const Text('Anggota Trainee ⭐'),
          backgroundColor: Colors.pink.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: Icon(Icons.people_alt_outlined, size: 20),
                text: 'Member Trainee',
              ),
              Tab(
                icon: Icon(Icons.analytics_outlined, size: 20),
                text: 'Detail Performa',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Cari anggota trainee...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      filled: true,
                      fillColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: members.isEmpty && !isUserInTeam
                      ? const Center(
                          child: Text(
                            'Tidak ada anggota trainee.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : membersCount == 0
                          ? const Center(
                              child: Text(
                                'Anggota tidak ditemukan.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: membersCount,
                        itemBuilder: (context, index) {
                          if (includeUser && index == 0) {
                            final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(widget.character, happiness: widget.character.happiness);
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.orange.shade200, width: 1.5),
                              ),
                              color: Colors.orange.shade50.withAlpha(76),
                              child: ListTile(
                                leading: AvatarImageCache.buildAvatar(
                                  url: avatarUrl,
                                  width: 40,
                                  height: 40,
                                  gender: widget.character.gender,
                                ),
                                title: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        widget.character.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Kamu (Anda) ⭐',
                                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        _buildGenBadge(widget.character.age, isUser: true),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            'Anggota Trainee • Umur: ${widget.character.age} th • Disiplin: ${widget.character.discipline}%',
                                            style: const TextStyle(fontSize: 11),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.star, color: Colors.orangeAccent),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (c) => AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      title: const Text('Profil Diri'),
                                      content: const Text('Ini adalah dirimu! Teruslah berlatih keras!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(c),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }

                          final memberIndex = includeUser ? index - 1 : index;
                          final member = filteredMembers[memberIndex];
                          final String name = member['name'] ?? '';
                          final String gender = member['gender'] ?? 'Perempuan';
                          final int age = int.tryParse(member['age'] ?? '13') ?? 13;
                          final int rel = int.tryParse(member['relationship'] ?? '50') ?? 50;
                          final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                            name: name,
                            gender: gender,
                            age: age,
                            happiness: rel,
                            forcedSkinColor: member['skinColor'],
                          );

                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              leading: AvatarImageCache.buildAvatar(
                                url: avatarUrl,
                                width: 40,
                                height: 40,
                                gender: gender,
                              ),
                              title: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (widget.character.isAnyPartnerNameMatching(name)) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.pink.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.pink.shade200, width: 0.5),
                                      ),
                                      child: const Text(
                                        'Pacar ❤️',
                                        style: TextStyle(color: Colors.pink, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      _buildGenBadge(age, genStr: member['generation']),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'Umur: $age th • Hubungan: $rel%',
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
                                      value: rel / 100,
                                      backgroundColor: Colors.grey.shade100,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                                      minHeight: 4,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IdolsInteractionPage(
                                      character: widget.character,
                                      person: member,
                                      category: 'Trainee',
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
                ),
              ],
            ),

            // Tab 2: Detail Performa
            DetailPerformaTraineePage(
              character: widget.character,
              searchQuery: _searchQuery,
            ),
          ],
        ),
      ),
    );
  }
}
