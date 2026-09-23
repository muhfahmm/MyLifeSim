// lib/game/widgets/hubungan_menu/npc_family_view.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/action_menu.dart';
import 'dart:math';

/// Screen untuk menampilkan keluarga NPC (Guru / Siswa / Anak)
/// Desain mengikuti gaya RelationshipButton (Hubungan & Keluarga).
class NpcFamilyViewScreen extends StatefulWidget {
  final String npcName;
  final String npcGender;
  final int npcAge;
  final String npcRole;
  final Character? character;
  final String? relationToPlayer;

  const NpcFamilyViewScreen({
    super.key,
    required this.npcName,
    required this.npcGender,
    required this.npcAge,
    required this.npcRole,
    this.character,
    this.relationToPlayer,
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

  bool _isSameName(String? n1, String? n2) {
    if (n1 == null || n2 == null) return false;
    final clean1 = n1.replaceAll('Ibu ', '').replaceAll('Ayah ', '').replaceAll(' (Anda)', '').replaceAll(' (Diri)', '').trim().toLowerCase();
    final clean2 = n2.replaceAll('Ibu ', '').replaceAll('Ayah ', '').replaceAll(' (Anda)', '').replaceAll(' (Diri)', '').trim().toLowerCase();
    return clean1 == clean2;
  }

  List<Map<String, dynamic>> _generateFamily() {
    final int seed = widget.npcName.codeUnits.fold(0, (a, b) => a + b);
    final rng = Random(seed);
    final bool isMale = widget.npcGender == 'Laki-laki';
    final int age = widget.npcAge;
    final List<Map<String, dynamic>> family = [];
    final Character? char = widget.character;

    // 1. Determine target's relation tag to player
    String targetRelTag = widget.relationToPlayer ?? 'OTHER';
    if (char != null && targetRelTag == 'OTHER') {
      if (_isSameName(widget.npcName, char.name)) {
        targetRelTag = 'SELF';
      } else if (_isSameName(widget.npcName, char.fatherName)) {
        targetRelTag = 'FATHER';
      } else if (_isSameName(widget.npcName, char.motherName)) {
        targetRelTag = 'MOTHER';
      } else if (_isSameName(widget.npcName, char.stepFatherName)) {
        targetRelTag = 'STEP_FATHER';
      } else if (_isSameName(widget.npcName, char.stepMotherName)) {
        targetRelTag = 'STEP_MOTHER';
      } else if (char.siblings.any((s) => _isSameName(widget.npcName, s['name']))) {
        targetRelTag = 'SIBLING';
      } else if (char.children.any((c) => _isSameName(widget.npcName, c['name']))) {
        targetRelTag = 'CHILD';
      } else if (char.isAnyPartnerNameMatching(widget.npcName)) {
        targetRelTag = 'SPOUSE';
      }
    }

    // 2. Helper flags based on targetRelTag
    final bool isPlayerFather = targetRelTag == 'FATHER';
    final bool isPlayerMother = targetRelTag == 'MOTHER';
    final bool isPlayerStepFather = targetRelTag == 'STEP_FATHER';
    final bool isPlayerStepMother = targetRelTag == 'STEP_MOTHER';
    final bool isPlayerSibling = targetRelTag == 'SIBLING';
    final bool isPlayerChild = targetRelTag == 'CHILD';
    final bool isPlayerPartner = targetRelTag == 'SPOUSE';

    // === 1. ORANG TUA ===
    String fatherNameVal = _randomName('Laki-laki', seed + 1);
    int fatherAgeVal = age + 25 + rng.nextInt(10);
    int fatherRelVal = 40 + rng.nextInt(50);
    bool fatherDeceasedVal = fatherAgeVal >= 80;
    String? fatherSkinColor;
    String fatherRelLabel = 'Ayah Kandung';
    String? fatherRelTag;

    String motherNameVal = _randomName('Perempuan', seed + 2);
    int motherAgeVal = age + 23 + rng.nextInt(8);
    int motherRelVal = 45 + rng.nextInt(50);
    bool motherDeceasedVal = motherAgeVal >= 78;
    String? motherSkinColor;
    String motherRelLabel = 'Ibu Kandung';
    String? motherRelTag;

    bool includeFather = true;
    bool includeMother = true;

    if (targetRelTag == 'SIBLING' && char != null) {
      if (char.fatherName != null) {
        fatherNameVal = char.fatherName!;
        fatherAgeVal = char.fatherAge ?? (age + 25);
        fatherRelVal = char.fatherRelationship ?? 80;
        fatherDeceasedVal = char.isFatherDeceased;
        fatherSkinColor = char.fatherSkinColor;
        fatherRelLabel = 'Ayah Kandung Anda';
        fatherRelTag = 'FATHER';
      } else {
        includeFather = false;
      }
      if (char.motherName != null) {
        motherNameVal = char.motherName!;
        motherAgeVal = char.motherAge ?? (age + 23);
        motherRelVal = char.motherRelationship ?? 80;
        motherDeceasedVal = char.isMotherDeceased;
        motherSkinColor = char.motherSkinColor;
        motherRelLabel = 'Ibu Kandung Anda';
        motherRelTag = 'MOTHER';
      } else {
        includeMother = false;
      }
    } else if (targetRelTag == 'CHILD' && char != null) {
      final bool playerIsMale = char.gender.toLowerCase() == 'laki-laki';
      if (playerIsMale) {
        fatherNameVal = '${char.name} (Anda)';
        fatherAgeVal = char.age;
        fatherRelVal = 80;
        fatherDeceasedVal = false;
        fatherSkinColor = char.avatarSkinColor;
        fatherRelLabel = 'Ayah (Anda)';
        fatherRelTag = 'SELF';

        if (char.partner != null) {
          motherNameVal = char.partner!['name'] ?? motherNameVal;
          motherAgeVal = int.tryParse(char.partner!['age'] ?? '') ?? (char.age - 2);
          motherRelVal = 80;
          motherDeceasedVal = char.partner!['isDeceased'] == 'true';
          motherSkinColor = char.partner!['skinColor'];
          motherRelLabel = 'Ibu (Pasangan Anda)';
          motherRelTag = 'SPOUSE';
        } else {
          includeMother = false;
        }
      } else {
        motherNameVal = '${char.name} (Anda)';
        motherAgeVal = char.age;
        motherRelVal = 80;
        motherDeceasedVal = false;
        motherSkinColor = char.avatarSkinColor;
        motherRelLabel = 'Ibu (Anda)';
        motherRelTag = 'SELF';

        if (char.partner != null) {
          fatherNameVal = char.partner!['name'] ?? fatherNameVal;
          fatherAgeVal = int.tryParse(char.partner!['age'] ?? '') ?? (char.age + 2);
          fatherRelVal = 80;
          fatherDeceasedVal = char.partner!['isDeceased'] == 'true';
          fatherSkinColor = char.partner!['skinColor'];
          fatherRelLabel = 'Ayah (Pasangan Anda)';
          fatherRelTag = 'SPOUSE';
        } else {
          includeFather = false;
        }
      }
    } else if (targetRelTag == 'FATHER' || targetRelTag == 'MOTHER') {
      fatherRelLabel = 'Kakek Anda';
      fatherRelTag = 'GRANDFATHER';
      motherRelLabel = 'Nenek Anda';
      motherRelTag = 'GRANDMOTHER';
    } else if (targetRelTag == 'GRANDFATHER' || targetRelTag == 'GRANDMOTHER') {
      fatherRelLabel = 'Kakek Buyut Anda';
      fatherRelTag = 'GREAT_GRANDFATHER';
      motherRelLabel = 'Nenek Buyut Anda';
      motherRelTag = 'GREAT_GRANDMOTHER';
    } else if (targetRelTag == 'UNCLE_AUNT') {
      fatherRelLabel = 'Kakek Anda';
      fatherRelTag = 'GRANDFATHER';
      motherRelLabel = 'Nenek Anda';
      motherRelTag = 'GRANDMOTHER';
    } else if (targetRelTag == 'COUSIN') {
      fatherRelLabel = 'Paman Anda';
      fatherRelTag = 'UNCLE_AUNT';
      motherRelLabel = 'Tante Anda';
      motherRelTag = 'UNCLE_AUNT';
    }

    if (includeFather) {
      family.add({
        'section': 'orangtua',
        'name': fatherNameVal,
        'cleanName': fatherNameVal.replaceAll(' (Anda)', ''),
        'relation': 'Ayah',
        'relLabel': fatherRelLabel,
        'relationToPlayer': fatherRelTag,
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
        'cleanName': motherNameVal.replaceAll(' (Anda)', ''),
        'relation': 'Ibu',
        'relLabel': motherRelLabel,
        'relationToPlayer': motherRelTag,
        'gender': 'Perempuan',
        'age': motherAgeVal,
        'isDeceased': motherDeceasedVal,
        'rel': motherRelVal,
        'color': Colors.pink,
        if (motherSkinColor != null) 'skinColor': motherSkinColor,
      });
    }

    // === 2. PASANGAN (SUAMI / ISTRI) ===
    if (targetRelTag == 'FATHER' && char != null) {
      if (!char.isMotherDivorced && char.motherName != null) {
        family.add({
          'section': 'pasangan',
          'name': char.motherName!,
          'cleanName': char.motherName!,
          'relation': 'Istri',
          'relLabel': 'Istri (Ibu Kandung Anda)',
          'relationToPlayer': 'MOTHER',
          'gender': 'Perempuan',
          'age': char.motherAge ?? (age - 2),
          'isDeceased': char.isMotherDeceased,
          'rel': char.motherRelationship ?? 80,
          'color': Colors.redAccent,
          if (char.motherSkinColor != null) 'skinColor': char.motherSkinColor,
        });
      }
      if (char.stepMotherName != null) {
        family.add({
          'section': 'pasangan',
          'name': char.stepMotherName!,
          'cleanName': char.stepMotherName!,
          'relation': 'Istri',
          'relLabel': 'Istri Tiri',
          'relationToPlayer': 'STEP_MOTHER',
          'gender': 'Perempuan',
          'age': char.stepMotherAge ?? (age - 2),
          'isDeceased': char.isStepMotherDeceased,
          'rel': char.stepMotherRelationship ?? 80,
          'color': Colors.redAccent,
          if (char.stepMotherSkinColor != null) 'skinColor': char.stepMotherSkinColor,
        });
      }
    } else if (targetRelTag == 'MOTHER' && char != null) {
      if (!char.isMotherDivorced && char.fatherName != null) {
        family.add({
          'section': 'pasangan',
          'name': char.fatherName!,
          'cleanName': char.fatherName!,
          'relation': 'Suami',
          'relLabel': 'Suami (Ayah Kandung Anda)',
          'relationToPlayer': 'FATHER',
          'gender': 'Laki-laki',
          'age': char.fatherAge ?? (age + 2),
          'isDeceased': char.isFatherDeceased,
          'rel': char.fatherRelationship ?? 80,
          'color': Colors.redAccent,
          if (char.fatherSkinColor != null) 'skinColor': char.fatherSkinColor,
        });
      }
      if (char.stepFatherName != null) {
        family.add({
          'section': 'pasangan',
          'name': char.stepFatherName!,
          'cleanName': char.stepFatherName!,
          'relation': 'Suami',
          'relLabel': 'Suami Tiri',
          'relationToPlayer': 'STEP_FATHER',
          'gender': 'Laki-laki',
          'age': char.stepFatherAge ?? (age + 2),
          'isDeceased': char.isStepFatherDeceased,
          'rel': char.stepFatherRelationship ?? 80,
          'color': Colors.redAccent,
          if (char.stepFatherSkinColor != null) 'skinColor': char.stepFatherSkinColor,
        });
      }
    } else if (targetRelTag == 'STEP_FATHER' && char != null && char.motherName != null) {
      family.add({
        'section': 'pasangan',
        'name': char.motherName!,
        'cleanName': char.motherName!,
        'relation': 'Istri',
        'relLabel': 'Istri (Ibu Kandung Anda)',
        'relationToPlayer': 'MOTHER',
        'gender': 'Perempuan',
        'age': char.motherAge ?? age,
        'isDeceased': char.isMotherDeceased,
        'rel': char.motherRelationship ?? 80,
        'color': Colors.redAccent,
        if (char.motherSkinColor != null) 'skinColor': char.motherSkinColor,
      });
    } else if (targetRelTag == 'STEP_MOTHER' && char != null && char.fatherName != null) {
      family.add({
        'section': 'pasangan',
        'name': char.fatherName!,
        'cleanName': char.fatherName!,
        'relation': 'Suami',
        'relLabel': 'Suami (Ayah Kandung Anda)',
        'relationToPlayer': 'FATHER',
        'gender': 'Laki-laki',
        'age': char.fatherAge ?? age,
        'isDeceased': char.isFatherDeceased,
        'rel': char.fatherRelationship ?? 80,
        'color': Colors.redAccent,
        if (char.fatherSkinColor != null) 'skinColor': char.fatherSkinColor,
      });
    } else if (targetRelTag == 'SPOUSE' && char != null) {
      family.add({
        'section': 'pasangan',
        'name': '${char.name} (Anda)',
        'cleanName': char.name,
        'relation': char.gender.toLowerCase() == 'laki-laki' ? 'Suami' : 'Istri',
        'relLabel': 'Pasangan (Anda)',
        'relationToPlayer': 'SELF',
        'gender': char.gender,
        'age': char.age,
        'isDeceased': false,
        'rel': 90,
        'color': Colors.redAccent,
        if (char.avatarSkinColor != null) 'skinColor': char.avatarSkinColor,
      });
    } else {
      final String spouseGender = isMale ? 'Perempuan' : 'Laki-laki';
      String spouseNameVal = _randomName(spouseGender, seed + 20);
      if (age >= 18 && rng.nextBool()) {
        final int spouseAge = (age - 3 + rng.nextInt(7)).clamp(17, 80);
        String spouseRelLabel = isMale ? 'Istri' : 'Suami';
        String? spouseRelTag;
        if (targetRelTag == 'GRANDFATHER') {
          spouseRelLabel = 'Nenek Anda';
          spouseRelTag = 'GRANDMOTHER';
        } else if (targetRelTag == 'GRANDMOTHER') {
          spouseRelLabel = 'Kakek Anda';
          spouseRelTag = 'GRANDFATHER';
        } else if (targetRelTag == 'UNCLE_AUNT') {
          spouseRelLabel = isMale ? 'Tante Anda' : 'Paman Anda';
          spouseRelTag = 'UNCLE_AUNT';
        }

        family.add({
          'section': 'pasangan',
          'name': spouseNameVal,
          'cleanName': spouseNameVal,
          'relation': isMale ? 'Istri' : 'Suami',
          'relLabel': spouseRelLabel,
          'relationToPlayer': spouseRelTag,
          'gender': spouseGender,
          'age': spouseAge,
          'isDeceased': false,
          'rel': 50 + rng.nextInt(50),
          'color': Colors.redAccent,
        });
      }
    }

    // === 3. DIRI NPC & SAUDARA KANDUNG ===
    String selfBadgeLabel = 'Subjek';
    if (targetRelTag == 'FATHER') {
      selfBadgeLabel = 'Ayah Kandung Anda';
    } else if (targetRelTag == 'MOTHER') {
      selfBadgeLabel = 'Ibu Kandung Anda';
    } else if (targetRelTag == 'STEP_FATHER') {
      selfBadgeLabel = 'Ayah Tiri Anda';
    } else if (targetRelTag == 'STEP_MOTHER') {
      selfBadgeLabel = 'Ibu Tiri Anda';
    } else if (targetRelTag == 'GRANDFATHER') {
      selfBadgeLabel = 'Kakek Anda';
    } else if (targetRelTag == 'GRANDMOTHER') {
      selfBadgeLabel = 'Nenek Anda';
    } else if (targetRelTag == 'GREAT_GRANDFATHER') {
      selfBadgeLabel = 'Kakek Buyut Anda';
    } else if (targetRelTag == 'GREAT_GRANDMOTHER') {
      selfBadgeLabel = 'Nenek Buyut Anda';
    } else if (targetRelTag == 'UNCLE_AUNT') {
      selfBadgeLabel = isMale ? 'Paman Anda' : 'Tante Anda';
    } else if (targetRelTag == 'COUSIN') {
      selfBadgeLabel = 'Sepupu Anda';
    } else if (targetRelTag == 'SIBLING') {
      selfBadgeLabel = 'Saudara Anda';
    } else if (targetRelTag == 'CHILD') {
      selfBadgeLabel = 'Anak Anda';
    } else if (targetRelTag == 'SPOUSE') {
      selfBadgeLabel = isMale ? 'Suami (Pasangan Anda)' : 'Istri (Pasangan Anda)';
    } else if (targetRelTag == 'SELF') {
      selfBadgeLabel = 'Diri Anda';
    } else if (widget.npcRole.isNotEmpty) {
      selfBadgeLabel = widget.npcRole;
    }

    family.add({
      'section': 'saudara',
      'name': widget.npcName,
      'cleanName': widget.npcName,
      'relation': selfBadgeLabel,
      'relLabel': selfBadgeLabel,
      'relationToPlayer': targetRelTag,
      'gender': widget.npcGender,
      'age': widget.npcAge,
      'isDeceased': false,
      'rel': 100,
      'color': isMale ? Colors.blue : Colors.pink,
      'isSelf': true,
    });

    if (isPlayerSibling && char != null) {
      family.add({
        'section': 'saudara',
        'name': '${char.name} (Anda)',
        'cleanName': char.name,
        'relation': 'Saudara',
        'relLabel': 'Saudara Anda',
        'relationToPlayer': 'SELF',
        'gender': char.gender,
        'age': char.age,
        'isDeceased': false,
        'rel': 80,
        'color': Colors.teal,
        if (char.avatarSkinColor != null) 'skinColor': char.avatarSkinColor,
      });

      for (var s in char.siblings) {
        final String sName = s['name'] ?? '';
        if (sName.isNotEmpty && !_isSameName(sName, widget.npcName)) {
          final int sAge = int.tryParse(s['age'] ?? '') ?? age;
          final int sRel = int.tryParse(s['relationship'] ?? '80') ?? 80;
          family.add({
            'section': 'saudara',
            'name': sName,
            'cleanName': sName,
            'relation': s['relation'] ?? 'Saudara',
            'relLabel': 'Saudara Anda',
            'relationToPlayer': 'SIBLING',
            'gender': s['gender'] ?? 'Laki-laki',
            'age': sAge,
            'isDeceased': s['isDeceased'] == 'true',
            'rel': sRel,
            'color': Colors.purple,
            if (s['skinColor'] != null) 'skinColor': s['skinColor'],
          });
        }
      }
    } else {
      final int siblingSeed = seed + 100;
      final siblingRng = Random(siblingSeed);

      // 50-50 chance if parent of player, or 60% chance for other NPCs
      final bool hasSiblings = (isPlayerFather || isPlayerMother || isPlayerStepFather || isPlayerStepMother)
          ? siblingRng.nextBool()
          : siblingRng.nextDouble() < 0.6;

      if (hasSiblings) {
        final int siblingCount = 1 + siblingRng.nextInt(3);

        for (int i = 0; i < siblingCount; i++) {
          final bool brotherOrSister = siblingRng.nextBool();
          final String sGender = brotherOrSister ? 'Laki-laki' : 'Perempuan';
          final int ageDiff = -4 + siblingRng.nextInt(9);
          final int sAge = (age + ageDiff).clamp(5, 90);

          final bool isOlder = sAge > age;
          String relLabel = brotherOrSister 
              ? (isOlder ? 'Kakak Laki-laki' : 'Adik Laki-laki') 
              : (isOlder ? 'Kakak Perempuan' : 'Adik Perempuan');
          String badgeText = brotherOrSister ? 'Saudara Laki-laki' : 'Saudara Perempuan';
          String? sRelTag;

          if (isPlayerFather || isPlayerMother || isPlayerStepFather || isPlayerStepMother) {
            relLabel = brotherOrSister ? 'Paman' : 'Tante';
            badgeText = brotherOrSister ? 'Paman Anda' : 'Tante Anda';
            sRelTag = 'UNCLE_AUNT';
          } else if (targetRelTag == 'GRANDFATHER' || targetRelTag == 'GRANDMOTHER') {
            relLabel = brotherOrSister ? 'Paman Buyut' : 'Tante Buyut';
            badgeText = brotherOrSister ? 'Paman Buyut Anda' : 'Tante Buyut Anda';
            sRelTag = 'GREAT_UNCLE_AUNT';
          } else if (targetRelTag == 'UNCLE_AUNT') {
            relLabel = brotherOrSister ? 'Paman' : 'Tante';
            badgeText = brotherOrSister ? 'Paman Anda' : 'Tante Anda';
            sRelTag = 'UNCLE_AUNT';
          } else if (targetRelTag == 'COUSIN') {
            relLabel = 'Sepupu';
            badgeText = 'Sepupu Anda';
            sRelTag = 'COUSIN';
          } else if (targetRelTag == 'SIBLING') {
            relLabel = 'Saudara';
            badgeText = 'Saudara Anda';
            sRelTag = 'SIBLING';
          }

          final String sName = _randomName(sGender, siblingSeed + 10 + i);

          family.add({
            'section': 'saudara',
            'name': sName,
            'cleanName': sName,
            'relation': relLabel,
            'relLabel': badgeText,
            'relationToPlayer': sRelTag,
            'gender': sGender,
            'age': sAge,
            'isDeceased': false,
            'rel': 30 + siblingRng.nextInt(60),
            'color': brotherOrSister ? Colors.indigo : Colors.purple,
          });
        }
      }
    }

    // === 4. ANAK-ANAK ===
    if ((isPlayerFather || isPlayerMother) && char != null) {
      family.add({
        'section': 'anak',
        'name': '${char.name} (Anda)',
        'cleanName': char.name,
        'relation': 'Anak',
        'relLabel': 'Anak (Anda)',
        'gender': char.gender,
        'age': char.age,
        'isDeceased': false,
        'rel': isPlayerFather ? char.fatherRelationship : char.motherRelationship,
        'color': Colors.teal,
        if (char.avatarSkinColor != null) 'skinColor': char.avatarSkinColor,
      });

      for (var s in char.siblings) {
        final String sName = s['name'] ?? '';
        if (sName.isNotEmpty) {
          final int sAge = int.tryParse(s['age'] ?? '') ?? 10;
          final int sRel = int.tryParse(s['relationship'] ?? '80') ?? 80;
          family.add({
            'section': 'anak',
            'name': sName,
            'cleanName': sName,
            'relation': 'Anak',
            'relLabel': s['relation'] ?? 'Anak',
            'gender': s['gender'] ?? 'Laki-laki',
            'age': sAge,
            'isDeceased': s['isDeceased'] == 'true',
            'rel': sRel,
            'color': Colors.teal,
            if (s['skinColor'] != null) 'skinColor': s['skinColor'],
          });
        }
      }
    } else if (isPlayerPartner && char != null) {
      for (var c in char.children) {
        final String cName = c['name'] ?? '';
        if (cName.isNotEmpty) {
          final int cAge = int.tryParse(c['age'] ?? '') ?? 1;
          final int cRel = int.tryParse(c['relationship'] ?? '80') ?? 80;
          family.add({
            'section': 'anak',
            'name': cName,
            'cleanName': cName,
            'relation': 'Anak',
            'relLabel': 'Anak',
            'gender': c['gender'] ?? 'Laki-laki',
            'age': cAge,
            'isDeceased': c['isDeceased'] == 'true',
            'rel': cRel,
            'color': Colors.teal,
            if (c['skinColor'] != null) 'skinColor': c['skinColor'],
          });
        }
      }
    } else if (!isPlayerChild && age >= 22 && rng.nextDouble() < 0.5) {
      final int childCount = 1 + rng.nextInt(3);
      for (int i = 0; i < childCount; i++) {
        final bool childMale = rng.nextBool();
        final String cGender = childMale ? 'Laki-laki' : 'Perempuan';
        final int cAge = max(1, age - 22 - rng.nextInt(5));
        final String cName = _randomName(cGender, seed + 30 + i);
        family.add({
          'section': 'anak',
          'name': cName,
          'cleanName': cName,
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
                  _buildSectionHeader(
                    widget.npcGender == 'Perempuan' ? 'Suami' : 'Istri',
                    Icons.favorite,
                    isDark,
                  ),
                  const SizedBox(height: 8),
                  ...pasangan.map((m) => _buildFamilyCard(m, isDark)),
                ],

                // === SAUDARA & DIRI ===
                if (saudara.isNotEmpty) ...[
                  const Divider(height: 32),
                  _buildSectionHeader('Saudara & Diri', Icons.people, isDark),
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
    final String rawName = (member['cleanName'] as String?) ?? (member['name'] as String);
    final bool isSelf = member['isSelf'] == true;
    final String displayName = member['name'] as String;
    final String relation = member['relation'] as String;
    final String relLabel = member['relLabel'] as String;
    final int age = member['age'] as int;
    final int rel = member['rel'] as int;
    final bool isDeceased = member['isDeceased'] as bool;
    final bool isMale = member['gender'] == 'Laki-laki';
    final Color color = isDeceased ? Colors.grey : (member['color'] as Color);
    final bool isPlayer = member['isPlayer'] == true ||
        member['relationToPlayer'] == 'SELF' ||
        (widget.character != null && _isSameName(rawName, widget.character!.name));
    final bool canClick = !isDeceased && !isSelf && !isPlayer;

    final String avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: rawName,
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
            if (c['name'] == rawName) {
              isPlayerChild = true;
              break;
            }
          }
          if (isPlayerChild) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActionMenuScreen(
                  targetName: rawName,
                  targetRole: isMale ? 'Laki-laki' : 'Perempuan',
                  character: char,
                ),
              ),
            );
            return;
          }

          // 2. Cek apakah dia adalah pasangan player
          if (char.isAnyPartnerNameMatching(rawName)) {
            String pRole = 'Pacar';
            if (char.partner != null && char.partner!['name'] == rawName) {
              pRole = char.partner!['relation'] ?? 'Pacar';
            } else if (char.secondPartner != null && char.secondPartner!['name'] == rawName) {
              pRole = char.secondPartner!['relation'] ?? 'Pacar';
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActionMenuScreen(
                  targetName: rawName,
                  targetRole: pRole,
                  character: char,
                ),
              ),
            );
            return;
          }

          // 3. Cek apakah dia adalah orang tua player
          if (rawName == char.fatherName) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActionMenuScreen(
                  targetName: rawName,
                  targetRole: 'Ayah Kandung',
                  character: char,
                ),
              ),
            );
            return;
          }
          if (rawName == char.motherName) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActionMenuScreen(
                  targetName: rawName,
                  targetRole: 'Ibu Kandung',
                  character: char,
                ),
              ),
            );
            return;
          }

          // 4. Cek apakah dia adalah saudara player
          for (var s in char.siblings) {
            if (s['name'] == rawName) {
              final String sRelation = s['relation'] ?? 'Saudara';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActionMenuScreen(
                    targetName: '$rawName ($sRelation)',
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
              npcName: rawName,
              npcGender: member['gender'] as String,
              npcAge: age,
              npcRole: relation,
              character: widget.character,
              relationToPlayer: member['relationToPlayer'] as String?,
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
                        isDeceased ? '$displayName (Wafat)' : displayName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDeceased
                              ? (isDark ? Colors.white38 : Colors.grey.shade600)
                              : (isDark ? Colors.white : Colors.black87),
                          decoration: isDeceased ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                  Text(
                    'Hubungan: ',
                    style: TextStyle(fontSize: 10, color: isDark ? Colors.white54 : Colors.grey),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: rel / 100,
                        backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
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
