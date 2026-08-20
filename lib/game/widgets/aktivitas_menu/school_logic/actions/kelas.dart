// lib/game/widgets/aktivitas_menu/school_logic/actions/kelas.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'school_generator.dart';
import 'interactions/classmate_interaction_page.dart';

class KelasActionPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const KelasActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<KelasActionPage> createState() => _KelasActionPageState();
}

class _KelasActionPageState extends State<KelasActionPage> {
  @override
  void initState() {
    super.initState();
    SchoolGenerator.generateClassmatesIfEmpty(widget.character);
  }

  @override
  Widget build(BuildContext context) {
    final classmates = widget.character.classmates;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teman Sekelas (Kelas)'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: classmates.length + 1, // +1 for the User (Kamu)
        itemBuilder: (context, index) {
          if (index == 0) {
            // User (Kamu) Card
            final userAvatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(widget.character, happiness: widget.character.happiness);
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.blue.shade50,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(userAvatarUrl),
                ),
                title: Text(widget.character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Siswa • Kamu'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Kamu',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }

          // Classmates list
          final cm = classmates[index - 1];
          final String name = cm['name']!;
          final String gender = cm['gender']!;
          final int age = int.tryParse(cm['age'] ?? '0') ?? widget.character.age;
          final int rel = int.tryParse(cm['relationship'] ?? '50') ?? 50;
          final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
            name: name,
            gender: gender,
            age: age,
            happiness: rel,
          );

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text('Hubungan: $rel%'),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: rel / 100.0,
                      color: rel > 70 ? Colors.green : (rel > 40 ? Colors.orange : Colors.red),
                      backgroundColor: Colors.grey.shade200,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
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
        },
      ),
    );
  }
}
