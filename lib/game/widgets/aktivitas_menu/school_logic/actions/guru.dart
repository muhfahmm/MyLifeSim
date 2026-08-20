// lib/game/widgets/aktivitas_menu/school_logic/actions/guru.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'school_generator.dart';
import 'interactions/teacher_interaction_page.dart';

class GuruActionPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const GuruActionPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<GuruActionPage> createState() => _GuruActionPageState();
}

class _GuruActionPageState extends State<GuruActionPage> {
  @override
  void initState() {
    super.initState();
    SchoolGenerator.generateTeachersIfEmpty(widget.character);
  }

  @override
  Widget build(BuildContext context) {
    final age = widget.character.age;
    List<Map<String, String>> teachersList = [];
    Map<String, String>? headmaster = widget.character.headmaster;
    Map<String, String>? bkTeacher = widget.character.bkTeacher;

    if (age >= 6 && age <= 12) {
      teachersList = widget.character.sdTeachers;
    } else if (age >= 13 && age <= 15) {
      teachersList = widget.character.smpTeachers;
    } else {
      teachersList = widget.character.smaTeachers;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guru & Staf Sekolah'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Kepala Sekolah Card
          if (headmaster != null) ...[
            _buildStaffCard(headmaster, 'Kepala Sekolah 🏫'),
            const SizedBox(height: 12),
          ],

          // Guru BK Card
          if (bkTeacher != null) ...[
            _buildStaffCard(bkTeacher, 'Guru Bimbingan Konseling (BK) 🧑‍🏫'),
            const SizedBox(height: 12),
          ],

          const Divider(height: 32),
          const Text(
            'Daftar Guru Mata Pelajaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 12),

          // Guru Mapel
          ...teachersList.map((t) {
            final subject = t['subject'] ?? 'Guru';
            return _buildStaffCard(t, 'Guru $subject 📖');
          }),
        ],
      ),
    );
  }

  Widget _buildStaffCard(Map<String, String> staff, String role) {
    final name = staff['name']!;
    final gender = staff['gender']!;
    final int age = int.tryParse(staff['age'] ?? '40') ?? 40;
    final int rel = int.tryParse(staff['relationship'] ?? '50') ?? 50;
    final avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: gender,
      age: age,
      happiness: rel,
    );

    return Card(
      elevation: 2,
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
            Text(role, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
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
                teacher: staff,
                role: role,
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
