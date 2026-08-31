// lib/game/widgets/hubungan_menu/daftar_pasangan_hamil.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/action_menu.dart';

class DaftarPasanganHamilScreen extends StatelessWidget {
  final Character character;

  const DaftarPasanganHamilScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Parse list nama pasangan hamil
    final String currentPartners = character.pregnantByPartnerName ?? '';
    final List<String> listHamil = currentPartners
        .split(', ')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('🤰 Pasangan Hamil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: listHamil.isEmpty
          ? Center(
              child: Text(
                'Tidak ada pasangan yang sedang hamil.',
                style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listHamil.length,
              itemBuilder: (context, index) {
                final String name = listHamil[index];
                
                // Cari data hubungan NPC
                int relationshipValue = 50;
                int ageVal = 18;
                String genderVal = 'Perempuan';
                String roleVal = 'Pasangan';
                String? skinColorVal;

                // 1. Cek partner utama
                if (character.partner != null && character.partner!['name'] == name) {
                  // PERBAIKAN: Ambil nilai relationship dari map partner
                  relationshipValue = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
                  ageVal = int.tryParse(character.partner!['age'] ?? '18') ?? 18;
                  genderVal = character.partner!['gender'] ?? 'Perempuan';
                  roleVal = character.partner!['relation'] ?? 'Pasangan';
                  skinColorVal = character.partner!['skinColor'];
                }
                // 2. Cek partner kedua
                else if (character.secondPartner != null && character.secondPartner!['name'] == name) {
                  relationshipValue = int.tryParse(character.secondPartner!['relationship'] ?? '50') ?? 50;
                  ageVal = int.tryParse(character.secondPartner!['age'] ?? '18') ?? 18;
                  genderVal = character.secondPartner!['gender'] ?? 'Perempuan';
                  roleVal = character.secondPartner!['relation'] ?? 'Selingkuhan';
                  skinColorVal = character.secondPartner!['skinColor'];
                }
                // 3. Cek classmates
                else {
                  for (var cm in character.classmates) {
                    if (cm['name'] == name) {
                      relationshipValue = int.tryParse(cm['relationship'] ?? '50') ?? 50;
                      ageVal = int.tryParse(cm['age'] ?? '18') ?? 18;
                      genderVal = cm['gender'] ?? 'Perempuan';
                      roleVal = cm['relation'] ?? 'Teman Sekelas';
                      skinColorVal = cm['skinColor'];
                      break;
                    }
                  }
                  // 4. Cek coworkers
                  for (var cw in character.coworkers) {
                    if (cw['name'] == name) {
                      relationshipValue = int.tryParse(cw['relationship'] ?? '50') ?? 50;
                      ageVal = int.tryParse(cw['age'] ?? '18') ?? 18;
                      genderVal = cw['gender'] ?? 'Perempuan';
                      roleVal = cw['relation'] ?? 'Rekan Kerja';
                      skinColorVal = cw['skinColor'];
                      break;
                    }
                  }
                }

                // Generasi avatar URL agar wajah & rambut konsisten sesuai rule
                final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                  name: name,
                  gender: genderVal,
                  age: ageVal,
                  happiness: relationshipValue,
                  forcedSkinColor: skinColorVal,
                );

                const Color color = Colors.pink; // PERBAIKAN: Gunakan const
                final Color barColor = relationshipValue > 65
                    ? Colors.green
                    : relationshipValue > 35
                        ? Colors.amber
                        : Colors.red;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActionMenuScreen(
                          character: character,
                          targetName: name,
                          targetRole: roleVal,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // PERBAIKAN: Ganti withOpacity -> withValues(alpha: ...)
                      color: color.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withValues(alpha: 0.3)),
                    ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: color.withValues(alpha: 0.15),
                            child: Image(
                              image: AvatarImageCache.getImageProvider(avatarUrl),
                              width: 32,
                              height: 32,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.woman,
                                color: color,
                                size: 20,
                              ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 1.5),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$name ($roleVal)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Umur: $ageVal tahun',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? Colors.white54 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              // PERBAIKAN: Ganti withOpacity -> withValues(alpha: ...)
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: color.withValues(alpha: 0.25)),
                            ),
                            child: const Text(
                              'Hamil 👶',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Hubungan: ',
                            style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.grey),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: relationshipValue / 100,
                                backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$relationshipValue%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: barColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}