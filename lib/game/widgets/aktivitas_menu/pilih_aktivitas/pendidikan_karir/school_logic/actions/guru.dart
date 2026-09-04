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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    SchoolGenerator.generateTeachersIfEmpty(widget.character);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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

    final query = _searchQuery.toLowerCase();
    final bool showHead = headmaster != null && ((headmaster['name'] ?? '').toLowerCase().contains(query) || 'kepala sekolah'.contains(query));
    final bool showBk = bkTeacher != null && ((bkTeacher['name'] ?? '').toLowerCase().contains(query) || 'bimbingan konseling'.contains(query));

    final filteredTeachers = teachersList.where((t) {
      final name = (t['name'] ?? '').toLowerCase();
      final subject = (t['subject'] ?? '').toLowerCase();
      return name.contains(query) || subject.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guru & Staf Sekolah'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.teal,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: 'Cari nama guru / mata pelajaran...',
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Kepala Sekolah Card
                if (showHead) ...[
                  _buildStaffCard(headmaster!, 'Kepala Sekolah 🏫', isDark),
                  const SizedBox(height: 12),
                ],

                // Guru BK Card
                if (showBk) ...[
                  _buildStaffCard(bkTeacher!, 'Guru Bimbingan Konseling (BK) 🧑‍🏫', isDark),
                  const SizedBox(height: 12),
                ],

                if (filteredTeachers.isNotEmpty) ...[
                  const Divider(height: 32),
                  Text(
                    'Daftar Guru Mata Pelajaran',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      color: isDark ? Colors.white70 : Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Guru Mapel
                  ...filteredTeachers.map((t) {
                    final subject = t['subject'] ?? 'Guru';
                    return _buildStaffCard(t, 'Guru $subject 📖', isDark);
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffCard(Map<String, String> staff, String role, bool isDark) {
    final name = staff['name']!;
    final gender = staff['gender']!;
    final int age = int.tryParse(staff['age'] ?? '40') ?? 40;
    final int rel = int.tryParse(staff['relationship'] ?? '50') ?? 50;
    final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
      name: name,
      gender: gender,
      age: age,
      schoolLevel: 'Guru',
      happiness: rel,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? Colors.grey.shade800 : Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        title: Text(
          name, 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$role • Umur: $age tahun', 
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey.shade600, 
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Hubungan: $rel%',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: rel / 100.0,
                color: rel > 70 ? Colors.green : (rel > 40 ? Colors.orange : Colors.red),
                backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                minHeight: 6,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? Colors.white70 : Colors.grey,
        ),
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
