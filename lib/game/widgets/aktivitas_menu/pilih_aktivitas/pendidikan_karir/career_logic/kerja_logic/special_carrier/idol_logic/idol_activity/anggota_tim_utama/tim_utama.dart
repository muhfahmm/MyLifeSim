import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import '../0_interactions_pages/idols_interaction_page.dart';

import 'rekam_jejak_generasi.dart';

class TimUtamaPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const TimUtamaPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<TimUtamaPage> createState() => _TimUtamaPageState();
}

class _TimUtamaPageState extends State<TimUtamaPage> {
  String _searchQuery = '';

  Widget _buildGenBadge(int age, {String? genStr, bool isUser = false}) {
    int genNumber;
    if (genStr != null && int.tryParse(genStr) != null) {
      genNumber = int.parse(genStr);
    } else {
      if (age >= 26) {
        genNumber = 1;
      } else if (age >= 23) {
        genNumber = 2;
      } else if (age >= 20) {
        genNumber = 3;
      } else if (age >= 17) {
        genNumber = 4;
      } else {
        genNumber = 5;
      }
    }

    final String text = 'Gen $genNumber';
    final Color color = isUser ? Colors.orange.shade800 : Colors.purple.shade700;
    final Color bgColor = isUser ? Colors.orange.shade50 : Colors.purple.shade50;

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
    final query = _searchQuery.toLowerCase();
    final members = widget.character.idolMainMembers.where((m) {
      final name = (m['name'] ?? '').toLowerCase();
      return name.contains(query);
    }).toList();

    final isUserInTeam = widget.character.jobName == 'Idol (Main Performer)';
    final bool showUser = isUserInTeam && widget.character.name.toLowerCase().contains(query);
    final membersCount = members.length + (showUser ? 1 : 0);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDark ? Colors.grey.shade900 : null,
        appBar: AppBar(
          title: const Text('Anggota Tim Utama ⭐'),
          backgroundColor: Colors.pink.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(
                icon: Icon(Icons.people, size: 20),
                text: 'Anggota Aktif',
              ),
              Tab(
                icon: Icon(Icons.history_edu, size: 20),
                text: 'Rekam Jejak Generasi',
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
                hintText: 'Cari nama member utama...',
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
            child: members.isEmpty && !showUser
                ? Center(
                    child: Text(
                      'Tidak ada anggota tim utama ditemukan.',
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: membersCount,
                    itemBuilder: (context, index) {
                      if (showUser && index == 0) {
                  final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(widget.character, happiness: widget.character.happiness);
                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.pink.shade200, width: 1.5),
                    ),
                    color: Colors.pink.shade50.withAlpha(76),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.pink.shade100,
                        child: ClipOval(
                          child: Image(
                            image: AvatarImageCache.getImageProvider(avatarUrl),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
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
                              color: Colors.pink,
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
                                  'Anggota Utama • Umur: ${widget.character.age} th • Disiplin: ${widget.character.discipline}%',
                                  style: const TextStyle(fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.star, color: Colors.pinkAccent),
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

                final memberIndex = showUser ? index - 1 : index;
                final member = members[memberIndex];
                final String name = member['name'] ?? '';
                final String gender = member['gender'] ?? 'Perempuan';
                final int age = int.tryParse(member['age'] ?? '16') ?? 16;
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
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink.shade50,
                      child: ClipOval(
                        child: Image(
                          image: AvatarImageCache.getImageProvider(avatarUrl),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
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
                            category: 'Main Team',
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
      RekamJejakGenerasiPage(character: widget.character),
    ],
  ),
),
);
}
}
