// lib/game/widgets/aktivitas_menu/school_logic/actions/kelas.dart

import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'school_generator.dart';
import 'interactions/classmate_interaction_page.dart';
import 'interactions/teacher_interaction_page.dart';

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
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    SchoolGenerator.generateClassmatesIfEmpty(widget.character);
    SchoolGenerator.generateTeachersIfEmpty(widget.character);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final age = widget.character.age;

    // Filter classmates berdasarkan pencarian
    final filteredClassmates = widget.character.classmates.where((cm) {
      final name = (cm['name'] ?? '').toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    // Ambil guru wali kelas dari daftar guru mapel
    Map<String, String>? waliKelas;
    List<Map<String, String>> teachersList = [];
    if (age >= 6 && age <= 12) {
      teachersList = widget.character.sdTeachers;
    } else if (age >= 13 && age <= 15) {
      teachersList = widget.character.smpTeachers;
    } else {
      teachersList = widget.character.smaTeachers;
    }

    if (teachersList.isNotEmpty) {
      waliKelas = teachersList.first;
    }

    // Tentukan level sekolah berdasarkan usia
    final String schoolLevel = age <= 12 ? 'SD' : age <= 15 ? 'SMP' : 'SMA';

    final bool showWali = waliKelas != null && (waliKelas['name'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
    final bool showUser = widget.character.name.toLowerCase().contains(_searchQuery.toLowerCase());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teman Sekelas (Kelas)'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.blueAccent,
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
                hintText: 'Cari nama teman sekelas / guru...',
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
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: (showWali ? 1 : 0) + (showUser ? 1 : 0) + filteredClassmates.length,
              itemBuilder: (context, index) {
                int currentIndex = index;

                if (showWali) {
                  if (currentIndex == 0) {
                    final String name = waliKelas!['name']!;
                    final String gender = waliKelas['gender']!;
                    final int ageVal = int.tryParse(waliKelas['age'] ?? '40') ?? 40;
                    final int rel = int.tryParse(waliKelas['relationship'] ?? '50') ?? 50;
                    final String subject = waliKelas['subject'] ?? 'Mata Pelajaran';
                    final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
                      name: name,
                      gender: gender,
                      age: ageVal,
                      schoolLevel: 'Guru',
                      happiness: rel,
                    );

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: isDark ? Colors.grey.shade800 : Colors.teal.shade50,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(avatarUrl),
                        ),
                        title: Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                        ),
                        subtitle: Text(
                          'Guru Wali Kelas (Guru $subject) • Umur: $ageVal tahun • Hubungan: $rel%',
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherInteractionPage(
                                teacher: waliKelas!,
                                role: 'Guru Wali Kelas (Guru $subject) 🧑‍🏫',
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
                  currentIndex--;
                }

                if (showUser) {
                  if (currentIndex == 0) {
                    final userAvatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
                      name: widget.character.name,
                      gender: widget.character.gender,
                      age: widget.character.age,
                      schoolLevel: schoolLevel,
                      happiness: widget.character.happiness,
                      forcedSkinColor: widget.character.avatarSkinColor,
                    );
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(userAvatarUrl),
                        ),
                        title: Text(
                          widget.character.name,
                          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                        ),
                        subtitle: Text(
                          'Siswa • Kamu • Umur: ${widget.character.age} tahun',
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                        ),
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
                  currentIndex--;
                }

                final cm = filteredClassmates[currentIndex];
                final String name = cm['name']!;
                final String gender = cm['gender']!;
                final int ageVal = int.tryParse(cm['age'] ?? '0') ?? widget.character.age;
                final int rel = int.tryParse(cm['relationship'] ?? '50') ?? 50;
                final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
                  name: name,
                  gender: gender,
                  age: ageVal,
                  schoolLevel: schoolLevel,
                  happiness: rel,
                );

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: isDark ? Colors.grey.shade800 : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        (() {
                          final String? relStr = widget.character.getPartnerRelation(name);
                          if (relStr == null) return const SizedBox.shrink();
                          return Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              relStr,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          );
                        }()),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Teman Sekelas • Umur: $ageVal tahun • Kecerdasan: ${cm['intelligence'] ?? '50'}%',
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Hubungan: $rel%',
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
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
          ),
        ],
      ),
    );
  }
}