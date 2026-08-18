// lib/pilih_karakter/logic/family_generator.dart
import 'dart:math';
import '../character.dart';

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
      character.fatherAge = 22 + _random.nextInt(28); // 22 - 49 tahun
      character.motherAge = 19 + _random.nextInt(25); // 19 - 43 tahun
    } else if (roll < 80) {
      // Hanya ayah
      character.fatherName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
      character.fatherAge = 22 + _random.nextInt(28);
      // Peluang 30% memiliki Ibu Tiri saat lahir
      if (_random.nextInt(100) < 30) {
        character.stepMotherName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
        character.stepMotherAge = character.fatherAge! + _random.nextInt(5) - 2;
        character.stepMotherRelationship = 50;
      }
    } else if (roll < 90) {
      // Hanya ibu
      character.motherName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
      character.motherAge = 19 + _random.nextInt(25);
      // Peluang 30% memiliki Ayah Tiri saat lahir
      if (_random.nextInt(100) < 30) {
        character.stepFatherName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
        character.stepFatherAge = character.motherAge! + _random.nextInt(5) - 2;
        character.stepFatherRelationship = 50;
      }
    } else {
      // Ayah tiri (Ibu + Ayah Tiri)
      character.motherName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
      character.stepFatherName = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
      character.motherAge = 19 + _random.nextInt(25);
      character.stepFatherAge = 22 + _random.nextInt(28);
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
      siblingsList.add({
        'name': name,
        'gender': gender,
        'relation': gender == 'Laki-laki' ? 'Kakak Laki-laki' : 'Kakak Perempuan',
        'relationship': (50 + _random.nextInt(31)).toString(),
        'age': '$age',
        'isDeceased': 'false',
      });
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

    // --- Kakek & Nenek dari Ayah (Peluang 70% hidup) ---
    if (_random.nextInt(100) < 70) {
      final String name = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
      final int age = fatherBaseAge + 22 + _random.nextInt(15);
      extList.add({
        'name': 'Kakek ($name)',
        'relation': 'Kakek (dari Ayah)',
        'gender': 'Laki-laki',
        'relationship': '50',
        'age': '$age',
        'isDeceased': 'false',
      });
    }
    if (_random.nextInt(100) < 70) {
      final String name = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
      final int age = fatherBaseAge + 20 + _random.nextInt(12);
      extList.add({
        'name': 'Nenek ($name)',
        'relation': 'Nenek (dari Ayah)',
        'gender': 'Perempuan',
        'relationship': '50',
        'age': '$age',
        'isDeceased': 'false',
      });
    }

    // --- Kakek & Nenek dari Ibu (Peluang 70% hidup) ---
    if (_random.nextInt(100) < 70) {
      final String name = _generateRandomName('male', maleFirstNames, femaleFirstNames, lastNames);
      final int age = motherBaseAge + 22 + _random.nextInt(15);
      extList.add({
        'name': 'Kakek ($name)',
        'relation': 'Kakek (dari Ibu)',
        'gender': 'Laki-laki',
        'relationship': '50',
        'age': '$age',
        'isDeceased': 'false',
      });
    }
    if (_random.nextInt(100) < 70) {
      final String name = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
      final int age = motherBaseAge + 20 + _random.nextInt(12);
      extList.add({
        'name': 'Nenek ($name)',
        'relation': 'Nenek (dari Ibu)',
        'gender': 'Perempuan',
        'relationship': '50',
        'age': '$age',
        'isDeceased': 'false',
      });
    }

    // --- Paman/Bibi & Sepupu ---
    // Generate 1-2 Paman/Bibi dari Ayah dan Ibu masing-masing
    _generateUnclesAndCousins(extList, character, 'Ayah', maleFirstNames, femaleFirstNames, lastNames, fatherBaseAge);
    _generateUnclesAndCousins(extList, character, 'Ibu', maleFirstNames, femaleFirstNames, lastNames, motherBaseAge);

    character.extendedFamily = extList;
  }

  static void _generateUnclesAndCousins(
    List<Map<String, String>> extList,
    Character character,
    String side,
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
      
      // Usia: sekitar 3 tahun lebih muda atau lebih tua dari orang tua
      final int age = baseAge + (_random.nextBool() ? 3 : -3) + _random.nextInt(6);
      
      // Tambahkan Paman/Bibi
      extList.add({
        'name': '$relationLabel ($name)',
        'relation': '$relationLabel (dari $side)',
        'gender': isMale ? 'Laki-laki' : 'Perempuan',
        'relationship': '50',
        'age': '$age',
        'isDeceased': 'false',
      });

      // Peluang 60% Paman/Bibi memiliki pasangan (Suami/Istri)
      bool hasSpouse = _random.nextInt(100) < 60;
      if (hasSpouse) {
        final String spouseGender = isMale ? 'Perempuan' : 'Laki-laki';
        final String spouseName = _generateRandomName(
          spouseGender == 'Laki-laki' ? 'male' : 'female',
          maleFirstNames,
          femaleFirstNames,
          lastNames,
        );
        final int spouseAge = age - 1 - _random.nextInt(5);
        // Tambahkan pasangan
        extList.add({
          'name': 'Pasangan $relationLabel ($spouseName)',
          'relation': 'Pasangan $relationLabel',
          'gender': spouseGender,
          'relationship': '70',
          'age': '$spouseAge',
          'isDeceased': 'false',
        });
      }

      // Peluang 90% Paman/Bibi (baik single maupun berpasangan) memiliki 1-2 anak (Sepupu)
      if (_random.nextInt(100) < 90) {
        int cousinCount = _random.nextInt(2) + 1;
        for (int c = 0; c < cousinCount; c++) {
          final bool isCousinMale = _random.nextBool();
          final String cousinName = _generateRandomName(
            isCousinMale ? 'male' : 'female',
            maleFirstNames,
            femaleFirstNames,
            lastNames,
          );
          // Usia sepupu: -5 hingga +10 tahun dari karakter utama
          final int cousinAge = _random.nextInt(16) - 5; // -5..10
          extList.add({
            'name': 'Sepupu ($cousinName)',
            'relation': 'Sepupu (dari $side)',
            'gender': isCousinMale ? 'Laki-laki' : 'Perempuan',
            'relationship': '50',
            'age': '$cousinAge',
            'isDeceased': 'false',
          });
        }
      }
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