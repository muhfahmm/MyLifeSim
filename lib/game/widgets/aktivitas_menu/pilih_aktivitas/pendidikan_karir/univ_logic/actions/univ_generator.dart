// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/actions/univ_generator.dart
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';

class UnivGenerator {
  static final Random _random = Random();

  // Helper untuk menentukan seksualitas tanpa bergantung pada file external
  static String _generateRandomSexuality(String gender) {
    // 80% Heteroseksual, 10% Homoseksual, 10% Biseksual (sesuai standar game)
    final int roll = _random.nextInt(100);
    if (roll < 80) return 'Heteroseksual';
    if (roll < 90) {
      // Untuk Homoseksual, sesuaikan dengan gender agar tidak membingungkan
      return gender == 'Laki-laki' ? 'Homoseksual' : 'Lesbian';
    }
    return 'Biseksual';
  }

  static String generateRandomName(String gender, Character character) {
    // Tentukan rasio keaslian berdasarkan tempat tinggal karakter saat ini
    final String currentLoc = character.location.isNotEmpty ? character.location : (character.birthCountry ?? 'Indonesia');
    final String birthLoc = character.birthCountry ?? 'Indonesia';
    final bool isAbroad = currentLoc.toLowerCase() != birthLoc.toLowerCase();

    // Jika di luar negeri (misal China): 85% nama lokal (China), 15% nama pendatang/luar negeri.
    // Jika di negara asal: 85% nama lokal negara asal, 15% nama pendatang luar negeri.
    final bool useLocalName = _random.nextDouble() < (isAbroad ? 0.85 : 0.85);

    List<String> firstList = [];
    List<String> lastList = [];

    if (useLocalName) {
      firstList = gender == 'Laki-laki' 
          ? (character.maleFirstNames ?? []) 
          : (character.femaleFirstNames ?? []);
      lastList = character.lastNames ?? [];
    } else {
      // 15% Pendatang / ekspatriat (menggunakan nama internasional dari global names)
      firstList = gender == 'Laki-laki' 
          ? Character.globalMaleFirstNames 
          : Character.globalFemaleFirstNames;
      lastList = Character.globalLastNames;
    }

    if (firstList.isEmpty) {
      firstList = gender == 'Laki-laki' ? Character.globalMaleFirstNames : Character.globalFemaleFirstNames;
    }
    if (lastList.isEmpty) {
      lastList = Character.globalLastNames;
    }

    if (firstList.isEmpty) {
      firstList = gender == 'Laki-laki' ? ['Alex', 'David', 'Michael', 'Daniel', 'Ryan'] : ['Emma', 'Sophia', 'Olivia', 'Ava', 'Mia'];
    }
    if (lastList.isEmpty) {
      lastList = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones'];
    }

    final first = firstList[_random.nextInt(firstList.length)];
    final last = lastList[_random.nextInt(lastList.length)];
    return '$first $last';
  }

  static Future<void> generateClassmatesIfEmpty(Character character) async {
    if (character.univClassmates.isNotEmpty) return;

    if (character.maleFirstNames == null || character.maleFirstNames!.isEmpty) {
      await character.updateLocationNamesData();
    }

    final int count = 20 + _random.nextInt(11); // 20 to 30
    for (int i = 0; i < count; i++) {
      final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      final name = generateRandomName(gender, character);
      // University age: character.age +/- 2 years
      int classmateAge = character.age + _random.nextInt(5) - 2;
      if (classmateAge < 18) classmateAge = 18;

      character.univClassmates.add({
        'name': name,
        'gender': gender,
        'relationship': (40 + _random.nextInt(21)).toString(), // 40 to 60 initial
        'age': classmateAge.toString(),
        'isDeceased': 'false',
        'sexuality': _generateRandomSexuality(gender), // Diganti dari SexualityLogic
        'intelligence': (30 + _random.nextInt(61)).toString(),
      });
    }
  }

  static Future<void> generateLecturersIfEmpty(Character character) async {
    if (character.univLecturers.isNotEmpty) return;

    if (character.maleFirstNames == null || character.maleFirstNames!.isEmpty) {
      await character.updateLocationNamesData();
    }

    final List<String> subjects = [
      'Aljabar Linear',
      'Algoritma & Pemrograman',
      'Struktur Data',
      'Sistem Operasi',
      'Filsafat Ilmu',
      'Metode Penelitian',
      'Statistika Terapan'
    ];

    for (int i = 0; i < 3; i++) {
      final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      character.univLecturers.add({
        'name': 'Dosen ' + generateRandomName(gender, character),
        'gender': gender,
        'relationship': (45 + _random.nextInt(16)).toString(),
        'subject': subjects[i % subjects.length],
        'age': (30 + _random.nextInt(31)).toString(), // 30 to 60
        'sexuality': _generateRandomSexuality(gender), // Diganti dari SexualityLogic
      });
    }
  }
}