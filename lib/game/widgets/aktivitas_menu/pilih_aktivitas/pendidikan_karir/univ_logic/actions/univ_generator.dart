// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/actions/univ_generator.dart
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/school_sexuality_logic.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';

class UnivGenerator {
  static final Random _random = Random();

  static String generateRandomName(String gender, Character character) {
    List<String> firstList = gender == 'Laki-laki' 
        ? (character.maleFirstNames ?? []) 
        : (character.femaleFirstNames ?? []);
    List<String> lastList = character.lastNames ?? [];

    if (firstList.isEmpty) firstList = ['Budi', 'Joko', 'Andi', 'Siti', 'Ani', 'Dewi'];
    if (lastList.isEmpty) lastList = ['Santoso', 'Pratama', 'Hidayat', 'Wijaya', 'Sari'];

    final first = firstList[_random.nextInt(firstList.length)];
    final last = lastList[_random.nextInt(lastList.length)];
    return '$first $last';
  }

  static void generateClassmatesIfEmpty(Character character) {
    if (character.univClassmates.isNotEmpty) return;

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
        'sexuality': SexualityLogic.getStudentSexuality(gender),
        'intelligence': (30 + _random.nextInt(61)).toString(),
      });
    }
  }

  static void generateLecturersIfEmpty(Character character) {
    if (character.univLecturers.isNotEmpty) return;

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
        'sexuality': SexualityLogic.getTeacherSexuality(gender),
      });
    }
  }
}
