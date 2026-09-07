import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import '../0_interactions_pages/idols_interaction_page.dart';

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

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : null,
      appBar: AppBar(
        title: const Text('Anggota Tim Utama ⭐'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
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
                          Text(widget.character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      subtitle: Text('Anggota Utama • Umur: ${widget.character.age} tahun • Disiplin: ${widget.character.discipline}%'),
                      trailing: const Icon(Icons.star, color: Colors.pinkAccent),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ini adalah dirimu! Teruslah berlatih keras!')),
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
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                        Text('Rekan Utama • Umur: $age tahun • Hubungan: $rel%'),
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
    );
  }
}
