// lib/game/widgets/aktivitas_menu/school_logic/actions/school_generator.dart

import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';

class SchoolGenerator {
  static final Random _random = Random();

  static final List<String> maleNames = [
    'Aditya', 'Budi', 'Candra', 'Dedi', 'Eko', 'Fajar', 'Guntur', 'Hendra', 'Irfan', 'Joko',
    'Kurniawan', 'Lukman', 'Maman', 'Nugroho', 'Oki', 'Prabowo', 'Rian', 'Suryo', 'Taufik', 'Umar',
    'Wawan', 'Yanto', 'Zainal', 'Rian', 'Dimas', 'Angga', 'Rendi', 'Bagus', 'Arief', 'Rizal'
  ];

  static final List<String> femaleNames = [
    'Anisa', 'Bunga', 'Citra', 'Dewi', 'Elisa', 'Fitri', 'Gita', 'Hani', 'Indah', 'Julia',
    'Kartika', 'Laras', 'Melati', 'Novi', 'Olivia', 'Putri', 'Ratih', 'Siti', 'Tari', 'Utami',
    'Wulan', 'Yani', 'Zahra', 'Rina', 'Sari', 'Mega', 'Santi', 'Dian', 'Ayu', 'Nining'
  ];

  static final List<String> lastNames = [
    'Saputro', 'Wijaya', 'Sihombing', 'Pratama', 'Hidayat', 'Kusuma', 'Santoso', 'Gunawan', 'Siregar', 'Lubis',
    'Nasution', 'Simanjuntak', 'Setiawan', 'Budiman', 'Wibowo', 'Nugraha', 'Harahap', 'Ginting', 'Sutrisno', 'Purnama'
  ];

  static String generateRandomName(String gender) {
    final firstList = gender == 'Laki-laki' ? maleNames : femaleNames;
    final first = firstList[_random.nextInt(firstList.length)];
    final last = lastNames[_random.nextInt(lastNames.length)];
    return '$first $last';
  }

  static void generateClassmatesIfEmpty(Character character) {
    if (character.classmates.isNotEmpty) return;

    final int count = 20 + _random.nextInt(11); // 20 to 30
    for (int i = 0; i < count; i++) {
      final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      final name = generateRandomName(gender);
      character.classmates.add({
        'name': name,
        'gender': gender,
        'relationship': (40 + _random.nextInt(21)).toString(), // 40 to 60 initial
        'age': character.age.toString(),
        'isDeceased': 'false',
      });
    }
  }

  static void generateTeachersIfEmpty(Character character) {
    // Generate Headmaster
    if (character.headmaster == null) {
      final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      character.headmaster = {
        'name': generateRandomName(gender),
        'gender': gender,
        'relationship': (40 + _random.nextInt(21)).toString(),
        'age': (35 + _random.nextInt(26)).toString(), // 35 to 60
      };
    }

    // Generate BK Teacher
    if (character.bkTeacher == null) {
      final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      character.bkTeacher = {
        'name': generateRandomName(gender),
        'gender': gender,
        'relationship': (40 + _random.nextInt(21)).toString(),
        'age': (28 + _random.nextInt(23)).toString(), // 28 to 50
      };
    }

    // SD Teachers
    if (character.sdTeachers.isEmpty) {
      for (int i = 0; i < 3; i++) {
        final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
        character.sdTeachers.add({
          'name': generateRandomName(gender),
          'gender': gender,
          'relationship': (45 + _random.nextInt(16)).toString(),
          'subject': ['Matematika', 'B. Indonesia', 'IPA', 'IPS', 'B. Inggris'][i % 5],
          'age': (25 + _random.nextInt(31)).toString(),
        });
      }
    }

    // SMP Teachers
    if (character.smpTeachers.isEmpty) {
      for (int i = 0; i < 3; i++) {
        final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
        character.smpTeachers.add({
          'name': generateRandomName(gender),
          'gender': gender,
          'relationship': (45 + _random.nextInt(16)).toString(),
          'subject': ['Matematika', 'B. Indonesia', 'Fisika', 'Sejarah', 'Olahraga'][i % 5],
          'age': (25 + _random.nextInt(31)).toString(),
        });
      }
    }

    // SMA Teachers
    if (character.smaTeachers.isEmpty) {
      for (int i = 0; i < 3; i++) {
        final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
        character.smaTeachers.add({
          'name': generateRandomName(gender),
          'gender': gender,
          'relationship': (45 + _random.nextInt(16)).toString(),
          'subject': ['Kalkulus', 'Kimia', 'Biologi', 'Sosiologi', 'Ekonomi'][i % 5],
          'age': (25 + _random.nextInt(31)).toString(),
        });
      }
    }
  }
}
