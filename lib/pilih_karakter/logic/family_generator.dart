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
    // Persentase: Lengkap 70%, Hanya Ayah 10%, Hanya Ibu 10%, Ayah Tiri (Ibu + Ayah Tiri) 10%
    int roll = _random.nextInt(100);

    character.fatherName = null;
    character.motherName = null;
    character.stepFatherName = null;
    character.fatherAge = null;
    character.motherAge = null;
    character.stepFatherAge = null;

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
    } else if (roll < 90) {
      // Hanya ibu
      character.motherName = _generateRandomName('female', maleFirstNames, femaleFirstNames, lastNames);
      character.motherAge = 19 + _random.nextInt(25);
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
      order = 4;
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
        'relationship': '50',
        'age': '$age',
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
          'relationship': '50',
          'age': '$age',
        });
      }
    }

    character.siblings = siblingsList;
  }

  // ============================================
  // HELPER: RANDOM NAME GENERATOR (MENDUKUNG FALLBACK JIKA KOSONG)
  // ============================================
  static String _generateRandomName(
    String gender,
    List<String> maleFirstNames,
    List<String> femaleFirstNames,
    List<String> lastNames,
  ) {
    final random = _random;

    // Fallback names jika data kosong
    List<String> fallbackMale = ['Budi', 'Andi', 'Rudi', 'Hendra', 'Agus', 'Joko', 'Slamet', 'Tono'];
    List<String> fallbackFemale = ['Sari', 'Dewi', 'Rina', 'Maya', 'Lestari', 'Yuni', 'Nina', 'Tina'];
    List<String> fallbackLast = ['Santoso', 'Wijaya', 'Putra', 'Siregar', 'Hidayat', 'Kusuma'];

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