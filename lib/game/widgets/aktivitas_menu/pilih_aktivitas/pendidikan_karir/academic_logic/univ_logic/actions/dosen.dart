// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/univ_logic/actions/dosen.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'univ_generator.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/school_logic/actions/interactions/teacher_interaction_page.dart';

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
        title: const Text('Dosen Pengajar (Dosen)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

          final bool isDark = Theme.of(context).brightness == Brightness.dark;

          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
            ),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
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
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(avatarUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Dosen $subject • Umur: $age tahun',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Hubungan: $rel%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: rel / 100.0,
                                    color: rel > 70 ? Colors.green : (rel > 40 ? Colors.orange : Colors.red),
                                    backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: isDark ? Colors.white54 : Colors.grey.shade400, size: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
