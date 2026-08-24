import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import '../0_interactions_pages/idols_interaction_page.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/idol_logic/idol_manager.dart';

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
  @override
  Widget build(BuildContext context) {
    final members = widget.character.idolTrainees;

    final isUserInTeam = widget.character.jobName == 'Idol (Trainee)';
    final membersCount = members.length + (isUserInTeam ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anggota Trainee ⭐'),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      body: members.isEmpty && !isUserInTeam
          ? const Center(
              child: Text(
                'Tidak ada anggota trainee.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: membersCount,
              itemBuilder: (context, index) {
                if (isUserInTeam && index == 0) {
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
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
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
                      subtitle: Text('Anggota Trainee • Umur: ${widget.character.age} tahun • Disiplin: ${widget.character.discipline}%'),
                      trailing: const Icon(Icons.star, color: Colors.orangeAccent),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ini adalah dirimu! Teruslah berlatih keras!')),
                        );
                      },
                    ),
                  );
                }

                final memberIndex = isUserInTeam ? index - 1 : index;
                final member = members[memberIndex];
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
                        Text('Rekan Trainee • Umur: $age tahun • Hubungan: $rel%'),
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
    );
  }
}
