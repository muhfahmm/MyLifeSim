// lib/pilih_karakter/logic/family_generator.dart
import 'dart:math';
import '../character.dart';
import 'package:bitlife/avatar/skin_color_inheritance.dart';

class FamilyGenerator {
  static final Random _random = Random();

  /// Menghasilkan data keluarga untuk karakter baru menggunakan dataset nama asli dari negara terpilih.
  static void generateFamily({
    required Character character,
    required List<String> maleFirstNames,
    required List<String> femaleFirstNames,
    required List<String> lastNames,
  }) {
    // 1. Generate Urutan Kelahiran (Anak ke-berapa)
    _generateBirthOrder(character);

    // 2. Generate Orang Tua (sesuai persentase & set umur awal)
    _generateParents(character, maleFirstNames, femaleFirstNames, lastNames);

    // 3. Generate Saudara (Adik/Kakak & set umur awal) sesuai urutan lahir
    _generateSiblings(character, maleFirstNames, femaleFirstNames, lastNames);

    // 4. Generate Extended Family (Kakek-Nenek dari Ayah/Ibu, Paman/Bibi, Sepupu)
    _generateExtendedFamily(character, maleFirstNames, femaleFirstNames, lastNames);

    // 5. Tambahkan log kelahiran ke inbox karakter
    final birthLabel = character.birthOrderLabel;
    String orderSuffix = character.birthOrder == 1 ? 'pertama' : 'ke-${character.birthOrder}';
    character.inbox.add(
      '👶 Kelahiran: Kamu lahir di ${character.location} sebagai anak $orderSuffix ($birthLabel).'
    );
  }

  static int _generateAgeGap() {
    // Total weight: 90 (1-2) + 80 (3-4) + 60 (5-8) + 40 (9-10) + 30 (11-20) + 20 (others) = 320
    final int roll = _random.nextInt(320);
    if (roll < 90) {
      // 1-2: 90% (relative weight)
      return 1 + _random.nextInt(2);
    } else if (roll < 170) {
      // 3-4: 80%
      return 3 + _random.nextInt(2);
    } else if (roll < 230) {
      // 5-8: 60%
      return 5 + _random.nextInt(4);
    } else if (roll < 270) {
      // 9-10: 40%
      return 9 + _random.nextInt(2);
    } else if (roll < 300) {
      // 11-20: 30%
      return 11 + _random.nextInt(10);
    } else {
      // Lainnya: 20% (bisa 0, atau 21-25)
      final list = [0, 21, 22, 23, 24, 25];
      return list[_random.nextInt(list.length)];
    }
  }

  // ============================================
  // 1. LOGIKA ORANG TUA
  // ============================================
  static void _generateParents(
    Character character,
    List<String> maleFirstNames,
    List<String> femaleFirstNames,
    List<String> lastNames,
  ) {
    // Reset semua data orang tua
    character.fatherName = null;
    character.motherName = null;
    character.stepFatherName = null;
    character.stepMotherName = null;
    character.fatherAge = null;
    character.motherAge = null;
    character.stepFatherAge = null;
    character.stepMotherAge = null;

    // Persentase: Lengkap 70%, Hanya Ayah 10%, Hanya Ibu 10%, Ayah Tiri (Ibu + Ayah Tiri) 10%
    int roll = _random.nextInt(100);

    if (roll < 70) {
      // Orang tua lengkap
      character.fatherName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
      character.motherName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
      
      int mAge = 19 + _random.nextInt(25); // 19 - 43 tahun
      int gap = _generateAgeGap();
      
      int fAge;
      if (_random.nextInt(100) < 85) {
        // 85% peluang ayah lebih tua
        fAge = mAge + gap;
      } else {
        fAge = mAge - gap;
      }
      
      // Batasi usia minimal 20, maksimal 55 untuk ayah agar logis
      if (fAge < 20) fAge = 20;
      if (fAge > 55) fAge = 55;
      
      character.motherAge = mAge;
      character.fatherAge = fAge;

      // === WARNA KULIT ORANG TUA ===
      character.fatherSkinColor = SkinColorInheritance.randomSkin();
      character.motherSkinColor = SkinColorInheritance.randomSkin();
      if (character.avatarSkinColor == null || character.avatarSkinColor!.isEmpty) {
        character.avatarSkinColor = SkinColorInheritance.blendChildSkin(
          character.fatherSkinColor,
          character.motherSkinColor,
        );
      } else {
        character.fatherSkinColor = SkinColorInheritance.parentSkinFromChild(character.avatarSkinColor, shift: 1);
        character.motherSkinColor = SkinColorInheritance.parentSkinFromChild(character.avatarSkinColor, shift: -1);
      }
    } else if (roll < 80) {
      // Hanya ayah (Ibu Cerai atau Meninggal)
      character.fatherName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
      character.fatherAge = 22 + _random.nextInt(28);
      character.fatherSkinColor = SkinColorInheritance.randomSkin();

      character.motherName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
      character.motherAge = (character.fatherAge! - 2).clamp(20, 55);
      character.motherSkinColor = SkinColorInheritance.randomSkin();

      if (_random.nextBool()) {
        character.isMotherDeceased = true;
      } else {
        character.isMotherDivorced = true;
        character.motherRelationship = 20 + _random.nextInt(30);
      }

      if (character.avatarSkinColor == null || character.avatarSkinColor!.isEmpty) {
        character.avatarSkinColor = SkinColorInheritance.blendChildSkin(
          character.fatherSkinColor,
          character.motherSkinColor,
        );
      } else {
        character.fatherSkinColor = SkinColorInheritance.parentSkinFromChild(character.avatarSkinColor, shift: 1);
        character.motherSkinColor = SkinColorInheritance.parentSkinFromChild(character.avatarSkinColor, shift: -1);
      }

      // Peluang 30% memiliki Ibu Tiri saat lahir
      if (_random.nextInt(100) < 30) {
        character.stepMotherName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
        character.stepMotherAge = character.fatherAge! + _random.nextInt(5) - 2;
        character.stepMotherRelationship = 50;
      }
    } else if (roll < 90) {
      // Hanya ibu (Ayah Cerai atau Meninggal)
      character.motherName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
      character.motherAge = 19 + _random.nextInt(25);
      character.motherSkinColor = SkinColorInheritance.randomSkin();

      character.fatherName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
      character.fatherAge = (character.motherAge! + 2).clamp(20, 55);
      character.fatherSkinColor = SkinColorInheritance.randomSkin();

      if (_random.nextBool()) {
        character.isFatherDeceased = true;
      } else {
        character.isFatherDivorced = true;
        character.fatherRelationship = 20 + _random.nextInt(30);
      }

      if (character.avatarSkinColor == null || character.avatarSkinColor!.isEmpty) {
        character.avatarSkinColor = SkinColorInheritance.blendChildSkin(
          character.fatherSkinColor,
          character.motherSkinColor,
        );
      } else {
        character.fatherSkinColor = SkinColorInheritance.parentSkinFromChild(character.avatarSkinColor, shift: 1);
        character.motherSkinColor = SkinColorInheritance.parentSkinFromChild(character.avatarSkinColor, shift: -1);
      }

      // Peluang 30% memiliki Ayah Tiri saat lahir
      if (_random.nextInt(100) < 30) {
        character.stepFatherName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
        character.stepFatherAge = character.motherAge! + _random.nextInt(5) - 2;
        character.stepFatherRelationship = 50;
      }
    } else {
      // Ibu + Ayah Tiri (Ayah Kandung Cerai atau Meninggal)
      character.motherName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
      character.stepFatherName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
      
      int mAge = 19 + _random.nextInt(25);
      int gap = _generateAgeGap();
      int fAge;
      if (_random.nextInt(100) < 85) {
        fAge = mAge + gap;
      } else {
        fAge = mAge - gap;
      }
      if (fAge < 20) fAge = 20;
      if (fAge > 55) fAge = 55;
      
      character.motherAge = mAge;
      character.stepFatherAge = fAge;
      character.stepFatherRelationship = 50;

      character.fatherName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
      character.fatherAge = (mAge + 2).clamp(20, 55);
      character.fatherSkinColor = SkinColorInheritance.randomSkin();
      character.motherSkinColor = SkinColorInheritance.randomSkin();

      if (_random.nextBool()) {
        character.isFatherDeceased = true;
      } else {
        character.isFatherDivorced = true;
        character.fatherRelationship = 15 + _random.nextInt(25);
      }

      if (character.avatarSkinColor == null || character.avatarSkinColor!.isEmpty) {
        character.avatarSkinColor = SkinColorInheritance.blendChildSkin(
          character.fatherSkinColor,
          character.motherSkinColor,
        );
      } else {
        character.fatherSkinColor = SkinColorInheritance.parentSkinFromChild(character.avatarSkinColor, shift: 1);
        character.motherSkinColor = SkinColorInheritance.parentSkinFromChild(character.avatarSkinColor, shift: -1);
      }
    }
  }

  // ============================================
  // 2. LOGIKA URUTAN KELAHIRAN
  // ============================================
  static void _generateBirthOrder(Character character) {
    // Anak 1: 30%, Anak 2: 30%, Anak 3: 25%, Anak 4: 15%
    int roll = _random.nextInt(100);
    int order;
    if (roll < 30) {
      order = 1;
    } else if (roll < 60) {
      order = 2;
    } else if (roll < 85) {
      order = 3;
    } else {
      order = 4 + _random.nextInt(3); // Anak ke-4, 5, atau 6
    }
    character.birthOrder = order;
  }

  // ============================================
  // 3. LOGIKA SAUDARA
  // ============================================
  static void _generateSiblings(
    Character character,
    List<String> maleFirstNames,
    List<String> femaleFirstNames,
    List<String> lastNames,
  ) {
    List<Map<String, String>> siblingsList = [];

    // Jika anak ke-2, ke-3, dst, maka PASTI memiliki kakak sebanyak (birthOrder - 1)
    int kakakCount = character.birthOrder - 1;
    for (int i = 0; i < kakakCount; i++) {
      String gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      String name = _generateRandomName(
        gender == 'Laki-laki' ? 'male' : 'female',
        maleFirstNames,
        femaleFirstNames,
        lastNames,
      );
      // Kakak berusia lebih tua (e.g. 1 - 8 tahun lebih tua dari karakter)
      int age = 1 + _random.nextInt(8);
      
      final Map<String, String> siblingMap = {
        'id': 'sib_${_random.nextInt(1000000)}',
        'name': name,
        'gender': gender,
        'relation': gender == 'Laki-laki' ? 'Kakak Laki-laki' : 'Kakak Perempuan',
        'relationship': (50 + _random.nextInt(31)).toString(),
        'age': '$age',
        'isDeceased': 'false',
      };

      // Jika usia kakak >= 20 tahun saat lahir, beri peluang memiliki pasangan & anak
      if (age >= 20) {
        if (_random.nextInt(100) < 60) {
          final String spouseGender = gender == 'Laki-laki' ? 'Perempuan' : 'Laki-laki';
          final String spouseName = _generateRandomName(spouseGender == 'Laki-laki' ? 'male' : 'female', maleFirstNames, femaleFirstNames, lastNames);
          siblingMap['spouseName'] = spouseName;
          siblingMap['spouseAge'] = (age - 1 - _random.nextInt(4)).toString();
          siblingMap['spouseGender'] = spouseGender;
          
          if (_random.nextInt(100) < 80) {
            int childCount = _random.nextInt(2) + 1;
            List<String> cNames = [];
            List<String> cAges = [];
            List<String> cGenders = [];
            for (int c = 0; c < childCount; c++) {
              final bool isBoy = _random.nextBool();
              cNames.add(_generateRandomName(isBoy ? 'male' : 'female', maleFirstNames, femaleFirstNames, lastNames));
              cAges.add((_random.nextInt(age - 18)).toString());
              cGenders.add(isBoy ? 'Laki-laki' : 'Perempuan');
            }
            siblingMap['childNames'] = cNames.join(',');
            siblingMap['childAges'] = cAges.join(',');
            siblingMap['childGenders'] = cGenders.join(',');
          }
        }
      }

      siblingsList.add(siblingMap);
    }

    // Peluang memiliki adik adalah 50%
    if (_random.nextBool()) {
      // Jumlah adik: 1 sampai 3 orang
      int adikCount = _random.nextInt(3) + 1;
      for (int i = 0; i < adikCount; i++) {
        String gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
        String name = _generateRandomName(
          gender == 'Laki-laki' ? 'male' : 'female',
          maleFirstNames,
          femaleFirstNames,
          lastNames,
        );
        // Adik berusia lebih muda (negatif saat lahir, representasi belum lahir)
        int age = -(1 + _random.nextInt(6)); // -1 sampai -6
        siblingsList.add({
          'id': 'sib_${_random.nextInt(1000000)}',
          'name': name,
          'gender': gender,
          'relation': gender == 'Laki-laki' ? 'Adik Laki-laki' : 'Adik Perempuan',
          'relationship': (50 + _random.nextInt(31)).toString(),
          'age': '$age',
          'isDeceased': 'false',
        });
      }
    }

    character.siblings = siblingsList;
  }

  // ============================================
  // 4. LOGIKA KELUARGA BESAR (EXTENDED FAMILY)
  // ============================================
  static void _generateExtendedFamily(
    Character character,
    List<String> maleFirstNames,
    List<String> femaleFirstNames,
    List<String> lastNames,
  ) {
    List<Map<String, String>> extList = [];

    // Ambil usia ayah/ibu untuk patokan umur kakek-nenek
    final int fatherBaseAge = character.fatherAge ?? (30 + _random.nextInt(15));
    final int motherBaseAge = character.motherAge ?? (28 + _random.nextInt(15));

    // --- Kakek & Nenek dari Ayah (Selalu berpasangan, peluang hidup 70%) ---
    final String kakekAyahId = 'kakek_ayah_${_random.nextInt(1000000)}';
    final String nenekAyahId = 'nenek_ayah_${_random.nextInt(1000000)}';
    final String kakekAyahName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
    final String nenekAyahName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
    final int kakekAyahAge = fatherBaseAge + 22 + _random.nextInt(15);
    final int nenekAyahAge = fatherBaseAge + 20 + _random.nextInt(12);
    final bool kakekAyahDeceased = _random.nextInt(100) >= 70;
    final bool nenekAyahDeceased = _random.nextInt(100) >= 70;

    extList.add({
      'id': kakekAyahId,
      'name': 'Kakek ($kakekAyahName)',
      'relation': 'Kakek (dari Ayah)',
      'gender': 'Laki-laki',
      'relationship': '50',
      'age': '$kakekAyahAge',
      'isDeceased': kakekAyahDeceased.toString(),
      'spouseId': nenekAyahId,
    });
    extList.add({
      'id': nenekAyahId,
      'name': 'Nenek ($nenekAyahName)',
      'relation': 'Nenek (dari Ayah)',
      'gender': 'Perempuan',
      'relationship': '50',
      'age': '$nenekAyahAge',
      'isDeceased': nenekAyahDeceased.toString(),
      'spouseId': kakekAyahId,
    });

    // --- Kakek & Nenek dari Ibu (Selalu berpasangan, peluang hidup 70%) ---
    final String kakekIbuId = 'kakek_ibu_${_random.nextInt(1000000)}';
    final String nenekIbuId = 'nenek_ibu_${_random.nextInt(1000000)}';
    final String kakekIbuName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
    final String nenekIbuName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
    final int kakekIbuAge = motherBaseAge + 22 + _random.nextInt(15);
    final int nenekIbuAge = motherBaseAge + 20 + _random.nextInt(12);
    final bool kakekIbuDeceased = _random.nextInt(100) >= 70;
    final bool nenekIbuDeceased = _random.nextInt(100) >= 70;

    extList.add({
      'id': kakekIbuId,
      'name': 'Kakek ($kakekIbuName)',
      'relation': 'Kakek (dari Ibu)',
      'gender': 'Laki-laki',
      'relationship': '50',
      'age': '$kakekIbuAge',
      'isDeceased': kakekIbuDeceased.toString(),
      'spouseId': nenekIbuId,
    });
    extList.add({
      'id': nenekIbuId,
      'name': 'Nenek ($nenekIbuName)',
      'relation': 'Nenek (dari Ibu)',
      'gender': 'Perempuan',
      'relationship': '50',
      'age': '$nenekIbuAge',
      'isDeceased': nenekIbuDeceased.toString(),
      'spouseId': kakekIbuId,
    });

    // --- Paman/Bibi & Sepupu ---
    _generateUnclesAndCousins(extList, character, 'Ayah', kakekAyahId, nenekAyahId, maleFirstNames, femaleFirstNames, lastNames, fatherBaseAge);
    _generateUnclesAndCousins(extList, character, 'Ibu', kakekIbuId, nenekIbuId, maleFirstNames, femaleFirstNames, lastNames, motherBaseAge);

    character.extendedFamily = extList;
  }

  static void _generateUnclesAndCousins(
    List<Map<String, String>> extList,
    Character character,
    String side,
    String parentKakekId,
    String parentNenekId,
    List<String> maleFirstNames,
    List<String> femaleFirstNames,
    List<String> lastNames,
    int baseAge,
  ) {
    int count = _random.nextInt(2) + 1; // 1-2 orang saudara dari orang tua
    for (int i = 0; i < count; i++) {
      final bool isMale = _random.nextBool();
      final String genderStr = isMale ? 'male' : 'female';
      final String name = _generateRandomName(genderStr, maleFirstNames, femaleFirstNames, lastNames);
      final String relationLabel = isMale ? 'Paman' : 'Bibi';
      final String memberId = 'ext_${side.toLowerCase()}_${_random.nextInt(1000000)}';
      
      final int age = baseAge + (_random.nextBool() ? 3 : -3) + _random.nextInt(6);
      
      final Map<String, String> relativeMap = {
        'id': memberId,
        'name': '$relationLabel ($name)',
        'relation': '$relationLabel (dari $side)',
        'gender': isMale ? 'Laki-laki' : 'Perempuan',
        'relationship': '50',
        'age': '$age',
        'isDeceased': 'false',
        'parentIds': '$parentKakekId,$parentNenekId',
      };

      // Peluang 75% Paman/Bibi memiliki pasangan (Suami/Istri)
      bool hasSpouse = _random.nextInt(100) < 75;
      String? spouseId;
      if (hasSpouse) {
        spouseId = 'spouse_${_random.nextInt(1000000)}';
        final String spouseGender = isMale ? 'Perempuan' : 'Laki-laki';
        final String spouseName = _generateRandomName(
          spouseGender == 'Laki-laki' ? 'male' : 'female',
          maleFirstNames,
          femaleFirstNames,
          lastNames,
        );
        final int spouseAge = age - 1 - _random.nextInt(5);
        relativeMap['spouseId'] = spouseId;
        
        extList.add({
          'id': spouseId,
          'name': 'Pasangan $relationLabel ($spouseName)',
          'relation': 'Pasangan $relationLabel',
          'gender': spouseGender,
          'relationship': '70',
          'age': '$spouseAge',
          'isDeceased': 'false',
          'spouseId': memberId,
        });
      }

      // Peluang 90% memiliki 1-2 anak (Sepupu)
      if (_random.nextInt(100) < 90) {
        int cousinCount = _random.nextInt(2) + 1;
        List<String> cousinIds = [];
        for (int c = 0; c < cousinCount; c++) {
          final bool isCousinMale = _random.nextBool();
          final String cousinName = _generateRandomName(
            isCousinMale ? 'male' : 'female',
            maleFirstNames,
            femaleFirstNames,
            lastNames,
          );
          final int cousinAge = _random.nextInt(16) - 5;
          final String cousinId = 'cousin_${_random.nextInt(1000000)}';
          cousinIds.add(cousinId);

          extList.add({
            'id': cousinId,
            'name': 'Sepupu ($cousinName)',
            'relation': 'Sepupu (dari $side)',
            'gender': isCousinMale ? 'Laki-laki' : 'Perempuan',
            'relationship': '50',
            'age': '$cousinAge',
            'isDeceased': 'false',
            'parentIds': spouseId != null ? '$memberId,$spouseId' : memberId,
          });
        }
        relativeMap['childrenIds'] = cousinIds.join(',');
      }

      extList.add(relativeMap);
    }
  }

  // ============================================
  // HELPER: RANDOM NAME GENERATOR
  // ============================================
  static String _generateRandomName(
    String gender,
    List<String> maleFirstNames,
    List<String> femaleFirstNames,
    List<String> lastNames,
  ) {
    final random = _random;

    // Fallback jika list kosong
    const fallbackMale = ['Budi', 'Andi', 'Rudi', 'Hendra', 'Agus', 'Joko'];
    const fallbackFemale = ['Sari', 'Dewi', 'Rina', 'Maya', 'Lestari', 'Yuni'];
    const fallbackLast = ['Santoso', 'Wijaya', 'Putra', 'Siregar', 'Hidayat'];

    String first;
    if (gender == 'male') {
      first = maleFirstNames.isNotEmpty
          ? maleFirstNames[random.nextInt(maleFirstNames.length)]
          : fallbackMale[random.nextInt(fallbackMale.length)];
    } else {
      first = femaleFirstNames.isNotEmpty
          ? femaleFirstNames[random.nextInt(femaleFirstNames.length)]
          : fallbackFemale[random.nextInt(fallbackFemale.length)];
    }

    String last = lastNames.isNotEmpty
        ? lastNames[random.nextInt(lastNames.length)]
        : fallbackLast[random.nextInt(fallbackLast.length)];

    return '$first $last';
  }
}