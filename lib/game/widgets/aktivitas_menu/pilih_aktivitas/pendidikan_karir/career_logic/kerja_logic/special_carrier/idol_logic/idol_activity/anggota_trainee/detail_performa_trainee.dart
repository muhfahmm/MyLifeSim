import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';

class DetailPerformaTraineePage extends StatelessWidget {
  final Character character;
  final String searchQuery;

  const DetailPerformaTraineePage({
    super.key,
    required this.character,
    required this.searchQuery,
  });

  Widget _buildGenBadge(int age, {String? genStr, bool isUser = false}) {
    int genNumber;
    if (genStr != null && int.tryParse(genStr) != null) {
      genNumber = int.parse(genStr);
    } else {
      if (age >= 16) {
        genNumber = 5;
      } else if (age >= 14) {
        genNumber = 6;
      } else {
        genNumber = 7;
      }
    }

    final String text = 'Gen $genNumber';
    final Color color = isUser ? Colors.orange.shade800 : Colors.deepPurple.shade700;
    final Color bgColor = isUser ? Colors.orange.shade50 : Colors.deepPurple.shade50;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, int value, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            Text(
              '$value%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (value / 100.0).clamp(0.0, 1.0),
            backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final members = character.idolTrainees;
    final isUserInTeam = character.jobName == 'Idol (Trainee)';

    final filteredMembers = members.where((m) {
      if (searchQuery.isEmpty) return true;
      final name = (m['name'] ?? '').toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    final bool matchesSearchUser = searchQuery.isEmpty || character.name.toLowerCase().contains(searchQuery.toLowerCase());
    final bool includeUser = isUserInTeam && matchesSearchUser;

    final totalCount = filteredMembers.length + (includeUser ? 1 : 0);

    if (totalCount == 0) {
      return Center(
        child: Text(
          'Tidak ada anggota trainee ditemukan',
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        bool isUserCard = false;
        Map<String, String> memberData;

        if (includeUser && index == 0) {
          isUserCard = true;
          memberData = {
            'name': '${character.name} (Kamu)',
            'gender': character.gender,
            'age': character.age.toString(),
            'relationship': '100',
            'yearsInTrainee': character.yearsInTrainee.toString(),
          };
        } else {
          final adjustedIndex = includeUser ? index - 1 : index;
          memberData = filteredMembers[adjustedIndex];
        }

        final String name = memberData['name'] ?? 'Trainee';
        final String gender = memberData['gender'] ?? 'Perempuan';
        final int age = int.tryParse(memberData['age'] ?? '13') ?? 13;
        final String skinColor = memberData['skinColor'] ?? 'ffdbb4';
        
        // Masa pelatihan yang dibaca langsung dari data trainee
        final int yearsInTrainee = int.tryParse(memberData['yearsInTrainee'] ?? '') ??
            (age >= 16 ? 2 : (age >= 14 ? 1 : 0));

        // Simulasi performa berdasarkan seed nama anggota agar konsisten
        final int seed = name.hashCode;
        final Random memberRand = Random(seed);
        final int vokal = 40 + memberRand.nextInt(51);
        final int tarian = 45 + memberRand.nextInt(51);
        final int pesona = 50 + memberRand.nextInt(46);
        final int stamina = 50 + memberRand.nextInt(41);
        final int staminaStage = (vokal + tarian + pesona + stamina) ~/ 4;

        final avatarUrl = isUserCard
            ? AvatarAgeRules.getAgeBasedAvatarUrl(character)
            : AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
                name: name,
                gender: gender,
                age: age,
                happiness: 80,
                forcedSkinColor: skinColor,
              );

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          color: isDark ? Colors.grey.shade800 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isUserCard
                  ? Colors.orange.shade300
                  : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              width: isUserCard ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.pink.shade100,
                      radius: 22,
                      child: ClipOval(
                        child: Image(
                          image: AvatarImageCache.getImageProvider(avatarUrl),
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildGenBadge(age, genStr: memberData['generation'], isUser: isUserCard),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Usia: $age th • Pelatihan: $yearsInTrainee th',
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    color: isDark ? Colors.white60 : Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: staminaStage >= 75
                            ? Colors.green.shade50
                            : (staminaStage >= 60 ? Colors.blue.shade50 : Colors.orange.shade50),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: staminaStage >= 75
                              ? Colors.green.shade300
                              : (staminaStage >= 60 ? Colors.blue.shade300 : Colors.orange.shade300),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Overall',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          Text(
                            '$staminaStage',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: staminaStage >= 75
                                  ? Colors.green.shade700
                                  : (staminaStage >= 60 ? Colors.blue.shade700 : Colors.orange.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildStatBar('Vokal', vokal, Colors.blue, isDark)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatBar('Tarian', tarian, Colors.pink, isDark)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildStatBar('Pesona', pesona, Colors.purple, isDark)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatBar('Stamina', stamina, Colors.orange, isDark)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
