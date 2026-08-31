// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/actions/murid_kerja.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/interactions/classmate_interaction_page.dart';

class MuridKerjaPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const MuridKerjaPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<MuridKerjaPage> createState() => _MuridKerjaPageState();
}

class _MuridKerjaPageState extends State<MuridKerjaPage> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Murid-murid didapat dari target 'classmates' / murid sekolah tempat user mengajar.
    // Jika daftar murid kosong, kita fallback/generate list murid default.
    final students = widget.character.classmates;
    
    // Atasan/Supervisor diganti dengan 'Wali Kelas' (menggunakan data supervisor / rekan kerja guru)
    final supervisor = widget.character.supervisor;
    
    final userAvatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
      widget.character,
      happiness: widget.character.happiness,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Murid & Wali Kelas 🏫'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================= WALI KELAS (REKAN KERJA GURU) =================
          if (supervisor != null) ...[
            (() {
              final String name = supervisor['name']!;
              final String gender = supervisor['gender']!;
              final int age = int.tryParse(supervisor['age'] ?? '40') ?? 40;
              final int rel = int.tryParse(supervisor['relationship'] ?? '50') ?? 50;
              final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
                name: name,
                gender: gender,
                age: age,
                schoolLevel: 'SMA',
                happiness: rel,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment_ind, size: 20, color: isDark ? Colors.white70 : Colors.blueGrey),
                      const SizedBox(width: 8),
                      Text(
                        'Wali Kelas',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold, 
                          color: isDark ? Colors.white70 : Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    color: isDark ? Colors.grey.shade800 : Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.blue.shade100),
                    ),
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                color: isDark ? Colors.lightBlueAccent : Colors.blue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Guru Wali Kelas',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Wali Kelas • Umur: $age tahun • Hubungan: $rel% • Kecerdasan: ${supervisor['intelligence']}%',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right, size: 16, color: isDark ? Colors.white70 : Colors.blue),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassmateInteractionPage(
                              classmate: supervisor,
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
                  ),
                ],
              );
            })(),
            const SizedBox(height: 24),
          ],

          // ================= DAFTAR MURID =================
          Row(
            children: [
              Icon(Icons.people, size: 20, color: isDark ? Colors.white70 : Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                'Daftar Murid Didik',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold, 
                  color: isDark ? Colors.white70 : Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // User Card (Kamu sebagai Guru)
          Card(
            elevation: 0,
            color: isDark ? Colors.grey.shade800 : Colors.green.shade50,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.green.shade200),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(userAvatarUrl),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.character.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: isDark ? Colors.lightGreenAccent : Colors.green,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Guru',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                'Posisi: ${widget.character.jobName} • Umur: ${widget.character.age} tahun • Kinerja Guru: Maksimal',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
          ),

          if (students.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text(
                  'Tidak ada murid saat ini.',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey, 
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            ...students.map((cm) {
              final String name = cm['name']!;
              final String gender = cm['gender']!;
              final int age = int.tryParse(cm['age'] ?? '12') ?? 12;
              final int rel = int.tryParse(cm['relationship'] ?? '50') ?? 50;
              final avatarUrl = AvatarAgeRules.getSchoolAvatarUrl(
                name: name,
                gender: gender,
                age: age,
                schoolLevel: 'SMP',
                happiness: rel,
              );

              return Card(
                elevation: 0,
                color: isDark ? Colors.grey.shade800 : Colors.white,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                ),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Murid • Umur: $age tahun • Hubungan: $rel% • Kecerdasan: ${cm['intelligence'] ?? '50'}%',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, size: 16, color: isDark ? Colors.white70 : Colors.grey),
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
            }),
        ],
      ),
    );
  }
}
