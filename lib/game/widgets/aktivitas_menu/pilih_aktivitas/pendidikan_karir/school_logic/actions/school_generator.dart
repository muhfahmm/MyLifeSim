import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/school_sexuality_logic.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';

class SchoolGenerator {
  static final Random _random = Random();

  static String generateRandomName(String gender, Character character) {
    List<String> firstList = gender == 'Laki-laki' 
        ? (character.maleFirstNames ?? []) 
        : (character.femaleFirstNames ?? []);
    List<String> lastList = character.lastNames ?? [];

    final first = firstList[_random.nextInt(firstList.length)];
    final last = lastList[_random.nextInt(lastList.length)];
    return '$first $last';
  }

  static void generateClassmatesIfEmpty(Character character) {
    if (character.classmates.isNotEmpty) return;

    final int count = 20 + _random.nextInt(11); // 20 to 30
    for (int i = 0; i < count; i++) {
      final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      final name = generateRandomName(gender, character);
      // Jarak usia maksimal 1-2 tahun (-1, 0, atau +1)
      int classmateAge = character.age + _random.nextInt(3) - 1;
      if (character.age >= 6 && classmateAge < 6) {
        classmateAge = 6;
      } else if (classmateAge < 0) {
        classmateAge = 0;
      }

      character.classmates.add({
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

  static void generateTeachersIfEmpty(Character character) {
    // Generate Headmaster
    if (character.headmaster == null) {
      final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      character.headmaster = {
        'name': generateRandomName(gender, character),
        'gender': gender,
        'relationship': (40 + _random.nextInt(21)).toString(),
        'age': (35 + _random.nextInt(26)).toString(), // 35 to 60
        'sexuality': SexualityLogic.getTeacherSexuality(gender),
      };
    }

    // Generate BK Teacher
    if (character.bkTeacher == null) {
      final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      character.bkTeacher = {
        'name': generateRandomName(gender, character),
        'gender': gender,
        'relationship': (40 + _random.nextInt(21)).toString(),
        'age': (28 + _random.nextInt(23)).toString(), // 28 to 50
        'sexuality': SexualityLogic.getTeacherSexuality(gender),
      };
    }

    // SD Teachers
    if (character.sdTeachers.isEmpty) {
      for (int i = 0; i < 3; i++) {
        final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
        character.sdTeachers.add({
          'name': generateRandomName(gender, character),
          'gender': gender,
          'relationship': (45 + _random.nextInt(16)).toString(),
          'subject': ['Matematika', 'B. Indonesia', 'IPA', 'IPS', 'B. Inggris'][i % 5],
          'age': (25 + _random.nextInt(31)).toString(),
          'sexuality': SexualityLogic.getTeacherSexuality(gender),
        });
      }
    }

    // SMP Teachers
    if (character.smpTeachers.isEmpty) {
      for (int i = 0; i < 3; i++) {
        final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
        character.smpTeachers.add({
          'name': generateRandomName(gender, character),
          'gender': gender,
          'relationship': (45 + _random.nextInt(16)).toString(),
          'subject': ['Matematika', 'B. Indonesia', 'Fisika', 'Sejarah', 'Olahraga'][i % 5],
          'age': (25 + _random.nextInt(31)).toString(),
          'sexuality': SexualityLogic.getTeacherSexuality(gender),
        });
      }
    }

    // SMA Teachers
    if (character.smaTeachers.isEmpty) {
      for (int i = 0; i < 3; i++) {
        final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
        character.smaTeachers.add({
          'name': generateRandomName(gender, character),
          'gender': gender,
          'relationship': (45 + _random.nextInt(16)).toString(),
          'subject': ['Kalkulus', 'Kimia', 'Biologi', 'Sosiologi', 'Ekonomi'][i % 5],
          'age': (25 + _random.nextInt(31)).toString(),
          'sexuality': SexualityLogic.getTeacherSexuality(gender),
        });
      }
    }
  }
}
