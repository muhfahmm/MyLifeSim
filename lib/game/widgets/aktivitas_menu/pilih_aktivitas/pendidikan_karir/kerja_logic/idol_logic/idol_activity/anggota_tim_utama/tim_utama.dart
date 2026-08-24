import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
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
  @override
  Widget build(BuildContext context) {
    final members = widget.character.idolMainMembers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anggota Tim Utama ⭐'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      body: members.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada anggota tim utama.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final String name = member['name'] ?? '';
                final String gender = member['gender'] ?? 'Perempuan';
                final int age = int.tryParse(member['age'] ?? '16') ?? 16;
                final int rel = int.tryParse(member['relationship'] ?? '50') ?? 50;
                final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                  name: name,
                  gender: gender,
                  age: age,
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
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}
