// lib/game/widgets/hubungan_menu/npc_family_view.dart
import 'package:flutter/material.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';

/// Screen untuk menampilkan keluarga NPC (Guru / Siswa / Anak)
/// Desain mengikuti gaya RelationshipButton (Hubungan & Keluarga).
class NpcFamilyViewScreen extends StatefulWidget {
  final String npcName;
  final String npcGender;
  final int npcAge;
  final String npcRole;
  final Character? character;

  const NpcFamilyViewScreen({
    super.key,
    required this.npcName,
    required this.npcGender,
    required this.npcAge,
    required this.npcRole,
    this.character,
  });

  @override
  State<NpcFamilyViewScreen> createState() => _NpcFamilyViewScreenState();
}

class _NpcFamilyViewScreenState extends State<NpcFamilyViewScreen> {
  late List<Map<String, dynamic>> _family;

  String _randomName(String gender, int seed) {
    final rng = Random(seed);
    final char = widget.character;
    
    final List<String> maleFirst = (char?.maleFirstNames != null && char!.maleFirstNames!.isNotEmpty) 
        ? char.maleFirstNames! 
        : Character.globalMaleFirstNames;
    final List<String> femaleFirst = (char?.femaleFirstNames != null && char!.femaleFirstNames!.isNotEmpty) 
        ? char.femaleFirstNames! 
        : Character.globalFemaleFirstNames;
    final List<String> lastList = (char?.lastNames != null && char!.lastNames!.isNotEmpty) 
        ? char.lastNames! 
        : Character.globalLastNames;
        
    final belakang = lastList[rng.nextInt(lastList.length)];
    if (gender == 'Laki-laki') {
      return '${maleFirst[rng.nextInt(maleFirst.length)]} $belakang';
    } else {
      return '${femaleFirst[rng.nextInt(femaleFirst.length)]} $belakang';
    }
  }

  List<Map<String, dynamic>> _generateFamily() {
    final int seed = widget.npcName.codeUnits.fold(0, (a, b) => a + b);
    final rng = Random(seed);
    final bool isMale = widget.npcGender == 'Laki-laki';
    final int age = widget.npcAge;
    final List<Map<String, dynamic>> family = [];

    // === ORANG TUA ===
    final Character? char = widget.character;
    final bool isChildOfPlayer = char != null && (widget.npcRole == 'Laki-laki' || widget.npcRole == 'Perempuan');

    String fatherNameVal = _randomName('Laki-laki', seed + 1);
    int fatherAgeVal = age + 25 + rng.nextInt(10);
    int fatherRelVal = 40 + rng.nextInt(50);
    bool fatherDeceasedVal = fatherAgeVal >= 80;

    String motherNameVal = _randomName('Perempuan', seed + 2);
    int motherAgeVal = age + 23 + rng.nextInt(8);
    int motherRelVal = 45 + rng.nextInt(50);
    bool motherDeceasedVal = motherAgeVal >= 78;

    if (isChildOfPlayer) {
      int childRel = 80;
      for (var c in char.children) {
        if (c['name'] == widget.npcName) {
          childRel = int.tryParse(c['relationship'] ?? '80') ?? 80;
          break;
        }
      }
      
      final bool playerIsMale = char.gender.toLowerCase() == 'laki-laki';
      if (playerIsMale) {
        fatherNameVal = char.name;
        fatherAgeVal = char.age;
        fatherRelVal = childRel;
        fatherDeceasedVal = false;
        
        if (char.partner != null) {
          motherNameVal = char.partner!['name'] ?? motherNameVal;
          motherAgeVal = int.tryParse(char.partner!['age'] ?? '') ?? motherAgeVal;
          motherRelVal = childRel;
          motherDeceasedVal = char.partner!['isDeceased'] == 'true';
        }
      } else {
        motherNameVal = char.name;
        motherAgeVal = char.age;
        motherRelVal = childRel;
        motherDeceasedVal = false;
        
        if (char.partner != null) {
          fatherNameVal = char.partner!['name'] ?? fatherNameVal;
          fatherAgeVal = int.tryParse(char.partner!['age'] ?? '') ?? fatherAgeVal;
          fatherRelVal = childRel;
          fatherDeceasedVal = char.partner!['isDeceased'] == 'true';
        }
      }
    }

    final bool playerIsMale = char != null && char.gender.toLowerCase() == 'laki-laki';
    final bool includeFather = !isChildOfPlayer || playerIsMale || char.partner != null;
    final bool includeMother = !isChildOfPlayer || !playerIsMale || char.partner != null;

    if (includeFather) {
      family.add({
        'section': 'orangtua',
        'name': fatherNameVal,
        'relation': 'Ayah',
        'relLabel': 'Ayah',
        'gender': 'Laki-laki',
        'age': fatherAgeVal,
        'isDeceased': fatherDeceasedVal,
        'rel': fatherRelVal,
        'color': Colors.blue,
      });
    }

    if (includeMother) {
      family.add({
        'section': 'orangtua',
        'name': motherNameVal,
        'relation': 'Ibu',
        'relLabel': 'Ibu',
        'gender': 'Perempuan',
        'age': motherAgeVal,
        'isDeceased': motherDeceasedVal,
        'rel': motherRelVal,
        'color': Colors.pink,
      });
    }

    // === PASANGAN ===
    if (age >= 18 && rng.nextBool()) {
      final String spouseGender = isMale ? 'Perempuan' : 'Laki-laki';
      final int spouseAge = (age - 3 + rng.nextInt(7)).clamp(17, 80);
      family.add({
        'section': 'pasangan',
        'name': _randomName(spouseGender, seed + 20),
        'relation': isMale ? 'Istri' : 'Suami',
        'relLabel': isMale ? 'Istri' : 'Suami',
        'gender': spouseGender,
        'age': spouseAge,
        'isDeceased': false,
        'rel': 50 + rng.nextInt(50),
        'color': Colors.redAccent,
      });
    }

    // === SAUDARA KANDUNG ===
    final int siblingCount = rng.nextInt(4);
    for (int i = 0; i < siblingCount; i++) {
      final bool brotherOrSister = rng.nextBool();
      final String sGender = brotherOrSister ? 'Laki-laki' : 'Perempuan';
      final int ageDiff = -4 + rng.nextInt(9);
      final int sAge = (age + ageDiff).clamp(5, 90);
      final String relLabel = brotherOrSister ? 'Kakak Laki-laki' : 'Kakak Perempuan';
      family.add({
        'section': 'saudara',
        'name': _randomName(sGender, seed + 10 + i),
        'relation': relLabel,
        'relLabel': 'Kandung',
        'gender': sGender,
        'age': sAge,
        'isDeceased': false,
        'rel': 30 + rng.nextInt(60),
        'color': brotherOrSister ? Colors.indigo : Colors.purple,
      });
    }

    // === ANAK ===
    if (age >= 22 && rng.nextDouble() < 0.5) {
      final int childCount = 1 + rng.nextInt(3);
      for (int i = 0; i < childCount; i++) {
        final bool childMale = rng.nextBool();
        final String cGender = childMale ? 'Laki-laki' : 'Perempuan';
        final int cAge = max(1, age - 22 - rng.nextInt(5));
        family.add({
          'section': 'anak',
          'name': _randomName(cGender, seed + 30 + i),
          'relation': childMale ? 'Anak Laki-laki' : 'Anak Perempuan',
          'relLabel': childMale ? 'Anak Laki-laki' : 'Anak Perempuan',
          'gender': cGender,
          'age': cAge,
          'isDeceased': false,
          'rel': 60 + rng.nextInt(40),
          'color': Colors.teal,
        });
      }
    }

    if (isChildOfPlayer) {
      int childRel = 80;
      for (var c in char.children) {
        if (c['name'] == widget.npcName) {
          childRel = int.tryParse(c['relationship'] ?? '80') ?? 80;
          break;
        }
      }
      family.add({
        'section': 'anak',
        'name': widget.npcName,
        'relation': 'Anak',
        'relLabel': 'Anak Anda',
        'gender': widget.npcGender,
        'age': widget.npcAge,
        'isDeceased': false,
        'rel': childRel,
        'color': Colors.teal,
      });
    }

    return family;
  }

  @override
  void initState() {
    super.initState();
    _family = _generateFamily();
  }

  @override
  Widget build(BuildContext context) {
    final orangTua = _family.where((m) => m['section'] == 'orangtua').toList();
    final pasangan = _family.where((m) => m['section'] == 'pasangan').toList();
    final saudara = _family.where((m) => m['section'] == 'saudara').toList();
    final anak = _family.where((m) => m['section'] == 'anak').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Keluarga ${widget.npcName}'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _family.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada data keluarga.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // === ORANGTUA ===
                if (orangTua.isNotEmpty) ...[
                  _buildSectionHeader('Orang Tua', Icons.family_restroom),
                  const SizedBox(height: 8),
                  ...orangTua.map(_buildFamilyCard),
                ],

                // === PASANGAN ===
                if (pasangan.isNotEmpty) ...[
                  const Divider(height: 32),
                  _buildSectionHeader('Pasangan Hidup', Icons.favorite),
                  const SizedBox(height: 8),
                  ...pasangan.map(_buildFamilyCard),
                ],

                // === SAUDARA ===
                if (saudara.isNotEmpty) ...[
                  const Divider(height: 32),
                  _buildSectionHeader('Saudara Kandung', Icons.people),
                  const SizedBox(height: 8),
                  ...saudara.map(_buildFamilyCard),
                ],

                // === ANAK ===
                if (anak.isNotEmpty) ...[
                  const Divider(height: 32),
                  _buildSectionHeader('Anak', Icons.child_care),
                  const SizedBox(height: 8),
                  ...anak.map(_buildFamilyCard),
                ],

                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, size: 18, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyCard(Map<String, dynamic> member) {
    final String name = member['name'] as String;
    final String relation = member['relation'] as String;
    final String relLabel = member['relLabel'] as String;
    final int age = member['age'] as int;
    final int rel = member['rel'] as int;
    final bool isDeceased = member['isDeceased'] as bool;
    final bool isMale = member['gender'] == 'Laki-laki';
    final Color color = isDeceased ? Colors.grey : (member['color'] as Color);

    final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: isMale ? 'Laki-laki' : 'Perempuan',
      age: age,
      happiness: rel,
    );

    final Color barColor = rel > 65
        ? Colors.green
        : rel > 35
            ? Colors.amber
            : Colors.red;

    return InkWell(
      onTap: null, // NPC keluarga tidak bisa di-navigate (tidak ada actionMenu untuk mereka)
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Image(
                    image: AvatarImageCache.getImageProvider(avatarUrl),
                    width: 32,
                    height: 32,
                    errorBuilder: (_, __, ___) => Icon(
                      isMale ? Icons.man : Icons.woman,
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

                // Name + age
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDeceased ? '$name (Wafat)' : '$name ($relation)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDeceased ? Colors.grey.shade600 : Colors.black87,
                          decoration: isDeceased ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Umur: $age tahun',
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                // Badge status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.25)),
                  ),
                  child: Text(
                    isDeceased ? 'Wafat' : relLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),

                // Chevron (hanya jika tidak meninggal)
                if (!isDeceased) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_ios, size: 13, color: Colors.grey),
                ],
              ],
            ),

            // Progress bar hubungan
            if (!isDeceased) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Hubungan: ',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: rel / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$rel%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: barColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
