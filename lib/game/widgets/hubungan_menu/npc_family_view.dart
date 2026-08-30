// lib/game/widgets/hubungan_menu/npc_family_view.dart
import 'package:flutter/material.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/action_menu.dart';
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

    // Cari apakah dia adalah anak hasil donor sperma
    String donorMotherName = '';
    int donorMotherAge = age + 25;
    if (char != null) {
      final String npcClean = widget.npcName.replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
      for (var r in char.donorRecipients) {
        final String rCleanChild = (r['childName'] ?? '').replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
        if (rCleanChild == npcClean) {
          donorMotherName = (r['name'] ?? '').replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
          donorMotherAge = int.tryParse(r['age'] ?? '') ?? donorMotherAge;
          break;
        }
      }
    }

    String? fatherSkinColor;
    String? motherSkinColor;

    if (isChildOfPlayer) {
      int childRel = 80;
      for (var c in char.children) {
        if (c['name'] == widget.npcName) {
          childRel = int.tryParse(c['relationship'] ?? '80') ?? 80;
          break;
        }
      }
      
      final bool playerIsMale = char.gender.toLowerCase() == 'laki-laki';
      if (donorMotherName.isNotEmpty) {
        fatherNameVal = char.name;
        fatherAgeVal = char.age;
        fatherRelVal = childRel;
        fatherDeceasedVal = false;
        fatherSkinColor = char.avatarSkinColor;
        
        motherNameVal = donorMotherName;
        motherAgeVal = donorMotherAge;
        motherRelVal = childRel;
        motherDeceasedVal = false;
        for (var r in char.donorRecipients) {
          if (r['name'] == donorMotherName) {
            motherSkinColor = r['skinColor'];
            break;
          }
        }
      } else if (playerIsMale) {
        fatherNameVal = char.name;
        fatherAgeVal = char.age;
        fatherRelVal = childRel;
        fatherDeceasedVal = false;
        fatherSkinColor = char.avatarSkinColor;
        
        if (char.partner != null) {
          motherNameVal = char.partner!['name'] ?? motherNameVal;
          motherAgeVal = int.tryParse(char.partner!['age'] ?? '') ?? motherAgeVal;
          motherRelVal = childRel;
          motherDeceasedVal = char.partner!['isDeceased'] == 'true';
          motherSkinColor = char.partner!['skinColor'];
        }
      } else {
        motherNameVal = char.name;
        motherAgeVal = char.age;
        motherRelVal = childRel;
        motherDeceasedVal = false;
        motherSkinColor = char.avatarSkinColor;
        
        if (char.partner != null) {
          fatherNameVal = char.partner!['name'] ?? fatherNameVal;
          fatherAgeVal = int.tryParse(char.partner!['age'] ?? '') ?? fatherAgeVal;
          fatherRelVal = childRel;
          fatherDeceasedVal = char.partner!['isDeceased'] == 'true';
          fatherSkinColor = char.partner!['skinColor'];
        }
      }
    }

    final bool playerIsMale = char != null && char.gender.toLowerCase() == 'laki-laki';
    final bool includeFather = !isChildOfPlayer || playerIsMale || char.partner != null || donorMotherName.isNotEmpty;
    final bool includeMother = !isChildOfPlayer || !playerIsMale || char.partner != null || donorMotherName.isNotEmpty;

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
        if (fatherSkinColor != null) 'skinColor': fatherSkinColor,
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
        if (motherSkinColor != null) 'skinColor': motherSkinColor,
      });
    }

    // === PASANGAN ===
    bool hasOfficialSpouse = false;
    final String spouseGender = isMale ? 'Perempuan' : 'Laki-laki';
    String spouseNameVal = _randomName(spouseGender, seed + 20);
    
    if (char != null) {
      for (var r in char.donorRecipients) {
        final String recipientName = (r['name'] ?? '').replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
        if (recipientName.isEmpty) continue;
        
        final int rSeed = recipientName.codeUnits.fold(0, (a, b) => a + b);
        final String rFather = _randomName('Laki-laki', rSeed + 1).replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
        final String rMother = _randomName('Perempuan', rSeed + 2).replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
        
        if (widget.npcName == rFather) {
          spouseNameVal = rMother;
          hasOfficialSpouse = true;
          break;
        } else if (widget.npcName == rMother) {
          spouseNameVal = rFather;
          hasOfficialSpouse = true;
          break;
        }
      }
    }

    if (age >= 18 && (hasOfficialSpouse || rng.nextBool())) {
      hasOfficialSpouse = true;
      final int spouseAge = (age - 3 + rng.nextInt(7)).clamp(17, 80);
      family.add({
        'section': 'pasangan',
        'name': spouseNameVal,
        'relation': isMale ? 'Istri' : 'Suami',
        'relLabel': isMale ? 'Istri' : 'Suami',
        'gender': spouseGender,
        'age': spouseAge,
        'isDeceased': false,
        'rel': 50 + rng.nextInt(50),
        'color': Colors.redAccent,
      });
    }

    final bool isDatingUser = char != null && char.isAnyPartnerNameMatching(widget.npcName);
    if (isDatingUser && hasOfficialSpouse) {
      family.add({
        'section': 'pasangan',
        'name': char.name,
        'relation': 'Selingkuhan',
        'relLabel': 'Selingkuhan',
        'gender': char.gender,
        'age': char.age,
        'isDeceased': false,
        'rel': 80,
        'color': Colors.pinkAccent,
      });
    }

    // === SAUDARA KANDUNG ===
    final int siblingSeed = (isChildOfPlayer && donorMotherName.isNotEmpty) 
        ? donorMotherName.codeUnits.fold(0, (a, b) => a + b) 
        : seed;
    final siblingRng = Random(siblingSeed);
    final int siblingCount = siblingRng.nextInt(4);
    
    for (int i = 0; i < siblingCount; i++) {
      final bool brotherOrSister = siblingRng.nextBool();
      final String sGender = brotherOrSister ? 'Laki-laki' : 'Perempuan';
      final int ageDiff = -4 + siblingRng.nextInt(9);
      final int sAge = (age + ageDiff).clamp(5, 90);
      
      final bool isOlder = sAge > age;
      final String relLabel = brotherOrSister 
          ? (isOlder ? 'Kakak Laki-laki' : 'Adik Laki-laki') 
          : (isOlder ? 'Kakak Perempuan' : 'Adik Perempuan');
          
      family.add({
        'section': 'saudara',
        'name': _randomName(sGender, siblingSeed + 10 + i),
        'relation': relLabel,
        'relLabel': isChildOfPlayer ? 'Seibu' : 'Kandung',
        'gender': sGender,
        'age': sAge,
        'isDeceased': false,
        'rel': 30 + siblingRng.nextInt(60),
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

    // === ANAK DONOR SPERMA ===
    if (char != null) {
      Map<String, String>? matchingRecipient;
      final String npcClean = widget.npcName.replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
      for (var r in char.donorRecipients) {
        final String rCleanName = (r['name'] ?? '').replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
        if (rCleanName == npcClean) {
          matchingRecipient = r;
          break;
        }
      }
      if (matchingRecipient != null && matchingRecipient['childName'] != null) {
        final String expectedChildName = matchingRecipient['childName']!;
        Map<String, String>? childData;
        for (var c in char.children) {
          if (c['name'] == expectedChildName) {
            childData = c;
            break;
          }
        }
        if (childData != null) {
          final String cGender = childData['gender'] ?? 'Laki-laki';
          final String cAgeStr = childData['age'] ?? '0';
          final int cAge = int.tryParse(cAgeStr) ?? 0;
          final int cRel = int.tryParse(childData['relationship'] ?? '80') ?? 80;
          
          family.add({
            'section': 'anak',
            'name': expectedChildName,
            'relation': 'Anak',
            'relLabel': 'Anak Anda (Donor)',
            'gender': cGender,
            'age': cAge,
            'isDeceased': childData['isDeceased'] == 'true',
            'rel': cRel,
            'color': Colors.teal,
          });
        }
      }
    }



    // Cari apakah widget.npcName adalah orang tua dari salah satu penerima donor sperma player
    if (char != null) {
      final String npcClean = widget.npcName.replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
      for (var r in char.donorRecipients) {
        final String recipientName = (r['name'] ?? '').replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
        if (recipientName.isEmpty) continue;
        
        final int rSeed = recipientName.codeUnits.fold(0, (a, b) => a + b);
        final rRng = Random(rSeed);
        final String rFather = _randomName('Laki-laki', rSeed + 1).replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
        final String rMother = _randomName('Perempuan', rSeed + 2).replaceAll('Ibu ', '').replaceAll('Ibu', '').trim();
        
        if (npcClean == rFather || npcClean == rMother) {
          int recipientAge = int.tryParse(r['age'] ?? '25') ?? 25;
          
          family.add({
            'section': 'anak',
            'name': recipientName,
            'relation': 'Anak',
            'relLabel': 'Anak',
            'gender': 'Perempuan',
            'age': recipientAge,
            'isDeceased': false,
            'rel': int.tryParse(r['relationship'] ?? '50') ?? 50,
            'color': Colors.teal,
            'skinColor': r['skinColor'],
          });
          
          final int sibCount = rRng.nextInt(4);
          for (int i = 0; i < sibCount; i++) {
            final bool broOrSis = rRng.nextBool();
            final String sGender = broOrSis ? 'Laki-laki' : 'Perempuan';
            final int ageDiff = -4 + rRng.nextInt(9);
            final int sAge = (recipientAge + ageDiff).clamp(5, 90);
            
            family.add({
              'section': 'anak',
              'name': _randomName(sGender, rSeed + 10 + i),
              'relation': 'Anak',
              'relLabel': 'Anak',
              'gender': sGender,
              'age': sAge,
              'isDeceased': false,
              'rel': 30 + rRng.nextInt(60),
              'color': Colors.teal,
            });
          }
        }
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
      final bool isDonor = char.donorRecipients.any((r) => r['childName'] == widget.npcName);
      // Ambil skinColor milik anak itu sendiri dari char.children
      String? childSkinColor;
      for (var c in char.children) {
        if (c['name'] == widget.npcName) {
          childSkinColor = c['skinColor'];
          break;
        }
      }

      family.add({
        'section': 'anak',
        'name': widget.npcName,
        'relation': 'Anak',
        'relLabel': isDonor ? 'Anak Anda (Donor)' : 'Anak Anda',
        'gender': widget.npcGender,
        'age': widget.npcAge,
        'isDeceased': false,
        'rel': childRel,
        'color': Colors.teal,
        if (childSkinColor != null) 'skinColor': childSkinColor,
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Keluarga ${widget.npcName}'),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: _family.isEmpty
          ? Center(
              child: Text(
                'Tidak ada data keluarga.',
                style: TextStyle(fontSize: 16, color: isDark ? Colors.white54 : Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // === ORANGTUA ===
                if (orangTua.isNotEmpty) ...[
                  _buildSectionHeader('Orang Tua', Icons.family_restroom, isDark),
                  const SizedBox(height: 8),
                  ...orangTua.map((m) => _buildFamilyCard(m, isDark)),
                ],

                // === PASANGAN ===
                if (pasangan.isNotEmpty) ...[
                  const Divider(height: 32),
                  _buildSectionHeader('Suami / Istri', Icons.favorite, isDark),
                  const SizedBox(height: 8),
                  ...pasangan.map((m) => _buildFamilyCard(m, isDark)),
                ],

                // === SAUDARA ===
                if (saudara.isNotEmpty) ...[
                  const Divider(height: 32),
                  _buildSectionHeader('Saudara', Icons.people, isDark),
                  const SizedBox(height: 8),
                  ...saudara.map((m) => _buildFamilyCard(m, isDark)),
                ],

                // === ANAK ===
                if (anak.isNotEmpty) ...[
                  const Divider(height: 32),
                  _buildSectionHeader('Anak-anak', Icons.child_care, isDark),
                  const SizedBox(height: 8),
                  ...anak.map((m) => _buildFamilyCard(m, isDark)),
                ],

                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    final Color headerColor = isDark ? Colors.blueGrey.shade200 : Colors.blueGrey;
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: headerColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Icon(icon, size: 18, color: headerColor),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: headerColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyCard(Map<String, dynamic> member, bool isDark) {
    final String name = member['name'] as String;
    final String relation = member['relation'] as String;
    final String relLabel = member['relLabel'] as String;
    final int age = member['age'] as int;
    final int rel = member['rel'] as int;
    final bool isDeceased = member['isDeceased'] as bool;
    final bool isMale = member['gender'] == 'Laki-laki';
    final Color color = isDeceased ? Colors.grey : (member['color'] as Color);
    final String section = member['section'] as String;
    bool canClick = false;
    final char = widget.character;
    if (char != null) {
      for (var c in char.children) {
        if (c['name'] == name) {
          canClick = true;
          break;
        }
      }
    }

    final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: isMale ? 'Laki-laki' : 'Perempuan',
      age: age,
      happiness: rel,
      forcedSkinColor: member['skinColor'],
    );

    final Color barColor = rel > 65
        ? Colors.green
        : rel > 35
            ? Colors.amber
            : Colors.red;

    return InkWell(
      onTap: (isDeceased || !canClick) ? null : () {
        final char = widget.character;
        if (char != null) {
          // 1. Cek apakah dia adalah anak player
          bool isPlayerChild = false;
          for (var c in char.children) {
            if (c['name'] == name) {
              isPlayerChild = true;
              break;
            }
          }
          if (isPlayerChild) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActionMenuScreen(
                  targetName: name,
                  targetRole: isMale ? 'Laki-laki' : 'Perempuan',
                  character: char,
                ),
              ),
            );
            return;
          }

          // 2. Cek apakah dia adalah pasangan player
          if (char.isAnyPartnerNameMatching(name)) {
            String pRole = 'Pacar';
            if (char.partner != null && char.partner!['name'] == name) {
              pRole = char.partner!['relation'] ?? 'Pacar';
            } else if (char.secondPartner != null && char.secondPartner!['name'] == name) {
              pRole = char.secondPartner!['relation'] ?? 'Pacar';
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActionMenuScreen(
                  targetName: name,
                  targetRole: pRole,
                  character: char,
                ),
              ),
            );
            return;
          }

          // 3. Cek apakah dia adalah orang tua player
          if (name == char.fatherName) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActionMenuScreen(
                  targetName: name,
                  targetRole: 'Ayah Kandung',
                  character: char,
                ),
              ),
            );
            return;
          }
          if (name == char.motherName) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActionMenuScreen(
                  targetName: name,
                  targetRole: 'Ibu Kandung',
                  character: char,
                ),
              ),
            );
            return;
          }

          // 4. Cek apakah dia adalah saudara player
          for (var s in char.siblings) {
            if (s['name'] == name) {
              final String sRelation = s['relation'] ?? 'Saudara';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActionMenuScreen(
                    targetName: '$name ($sRelation)',
                    targetRole: sRelation,
                    character: char,
                  ),
                ),
              );
              return;
            }
          }
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NpcFamilyViewScreen(
              npcName: name,
              npcGender: member['gender'] as String,
              npcAge: age,
              npcRole: relation,
              character: widget.character,
            ),
          ),
        );
      },
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
                          color: isDeceased
                              ? Colors.grey.shade600
                              : (isDark ? Colors.white : Colors.black87),
                          decoration: isDeceased ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Umur: $age tahun',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
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

                if (!isDeceased && canClick) ...[
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
