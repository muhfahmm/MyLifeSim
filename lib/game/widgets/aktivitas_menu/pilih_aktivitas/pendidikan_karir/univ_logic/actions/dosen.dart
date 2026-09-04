// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/actions/dosen.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'univ_generator.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/interactions/teacher_interaction_page.dart';

class DosenActionPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const DosenActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<DosenActionPage> createState() => _DosenActionPageState();
}

class _DosenActionPageState extends State<DosenActionPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await UnivGenerator.generateLecturersIfEmpty(widget.character);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lecturers = widget.character.univLecturers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosen Pengajar (Dosen)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lecturers.length,
        itemBuilder: (context, index) {
          final doc = lecturers[index];
          final String name = doc['name']!;
          final String gender = doc['gender']!;
          final int age = int.tryParse(doc['age'] ?? '45') ?? 45;
          final int rel = int.tryParse(doc['relationship'] ?? '50') ?? 50;
          final String subject = doc['subject'] ?? 'Mata Kuliah';
          final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
            name: name,
            gender: gender,
            age: age,
            schoolLevel: 'Guru',
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
                  Text('Dosen $subject • Umur: $age tahun'),
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
                    builder: (context) => TeacherInteractionPage(
                      teacher: doc,
                      role: 'Dosen $subject 🧑‍🏫',
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
