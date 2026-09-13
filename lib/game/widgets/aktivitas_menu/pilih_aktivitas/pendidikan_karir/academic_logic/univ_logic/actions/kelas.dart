// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/univ_logic/actions/kelas.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'univ_generator.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/school_logic/actions/interactions/classmate_interaction_page.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await UnivGenerator.generateClassmatesIfEmpty(widget.character);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final classmates = widget.character.univClassmates;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekan Mahasiswa (Kelas)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: classmates.length + 1, // User (Kamu) + Teman Sekelas
        itemBuilder: (context, index) {
          if (index == 0) {
            // User (Kamu) Card
            final userAvatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
              name: widget.character.name,
              gender: widget.character.gender,
              age: widget.character.age,
              schoolLevel: 'SMA',
              happiness: widget.character.happiness,
              forcedSkinColor: widget.character.avatarSkinColor,
            );
            return Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isDark ? Colors.indigo.shade700 : Colors.indigo.shade100),
              ),
              color: isDark ? Colors.grey.shade800 : Colors.indigo.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(userAvatarUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.character.name, 
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Mahasiswa • Kamu • Umur: ${widget.character.age} tahun',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.indigoAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Kamu',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
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
          final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
            name: name,
            gender: gender,
            age: age,
            schoolLevel: 'SMA',
            happiness: rel,
          );

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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name, 
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ), 
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              (() {
                                final String? relStr = widget.character.getPartnerRelation(name);
                                if (relStr == null) return const SizedBox.shrink();
                                return Container(
                                  margin: const EdgeInsets.only(left: 6),
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
                          const SizedBox(height: 2),
                          Text(
                            'Teman Kuliah • Umur: $age tahun • Kecerdasan: ${cm['intelligence'] ?? '50'}%',
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
