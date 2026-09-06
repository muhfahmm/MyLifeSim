// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/school_generator.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'dart:math';

class SchoolGenerator {
  static final Random _random = Random();

  // Helper untuk menentukan seksualitas tanpa bergantung pada file external
  static String _generateRandomSexuality(String gender) {
    // 80% Heteroseksual, 10% Homoseksual/Lesbian, 10% Biseksual
    final int roll = _random.nextInt(100);
    if (roll < 80) return 'Heteroseksual';
    if (roll < 90) {
      return gender == 'Laki-laki' ? 'Homoseksual' : 'Lesbian';
    }
    return 'Biseksual';
  }

  static String generateRandomName(String gender, Character character) {
    final String currentLoc = character.location.isNotEmpty ? character.location : (character.birthCountry ?? 'Indonesia');
    final String birthLoc = character.birthCountry ?? 'Indonesia';
    final bool isAbroad = currentLoc.toLowerCase() != birthLoc.toLowerCase();

    // 85% nama lokal tempat berada (misal China), 15% nama pendatang/ekspatriat
    final bool useLocalName = _random.nextDouble() < (isAbroad ? 0.85 : 0.85);

    List<String> firstList = [];
    List<String> lastList = [];

    if (useLocalName) {
      firstList = gender == 'Laki-laki' 
          ? (character.maleFirstNames ?? []) 
          : (character.femaleFirstNames ?? []);
      lastList = character.lastNames ?? [];
    } else {
      firstList = gender == 'Laki-laki' 
          ? Character.globalMaleFirstNames 
          : Character.globalFemaleFirstNames;
      lastList = Character.globalLastNames;
    }

    if (firstList.isEmpty) {
      firstList = gender == 'Laki-laki' 
          ? (character.maleFirstNames ?? Character.globalMaleFirstNames) 
          : (character.femaleFirstNames ?? Character.globalFemaleFirstNames);
    }
    if (lastList.isEmpty) {
      lastList = character.lastNames ?? Character.globalLastNames;
    }

    final first = firstList.isNotEmpty ? firstList[_random.nextInt(firstList.length)] : (gender == 'Laki-laki' ? 'Alex' : 'Emma');
    final last = lastList.isNotEmpty ? lastList[_random.nextInt(lastList.length)] : 'Smith';
    return '$first $last';
  }

  static void generateClassmatesIfEmpty(Character character) {
    if (character.classmates.isNotEmpty) return;

    final int count = 20 + _random.nextInt(11); // 20 to 30
    for (int i = 0; i < count; i++) {
      final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      final name = generateRandomName(gender, character);
      // Menyesuaikan umur murid didikan secara dinamis berdasarkan jenjang tempat mengajar user
      int classmateAge = character.age + _random.nextInt(3) - 1;
      final String jobName = character.jobName ?? '';
      if (jobName.startsWith('Guru SD')) {
        classmateAge = 6 + _random.nextInt(7); // 6 - 12 tahun
      } else if (jobName.startsWith('Guru SMP')) {
        classmateAge = 13 + _random.nextInt(3); // 13 - 15 tahun
      } else if (jobName.startsWith('Guru SMA')) {
        classmateAge = 16 + _random.nextInt(3); // 16 - 18 tahun
      } else {
        if (character.age >= 6 && classmateAge < 6) {
          classmateAge = 6;
        } else if (classmateAge < 0) {
          classmateAge = 0;
        }
      }

      character.classmates.add({
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

  static void generateTeachersIfEmpty(Character character) {
    // Generate Headmaster
    if (character.headmaster == null) {
      final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
      character.headmaster = {
        'name': generateRandomName(gender, character),
        'gender': gender,
        'relationship': (40 + _random.nextInt(21)).toString(),
        'age': (35 + _random.nextInt(26)).toString(), // 35 to 60
        'sexuality': _generateRandomSexuality(gender), // Diganti dari SexualityLogic
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
        'sexuality': _generateRandomSexuality(gender), // Diganti dari SexualityLogic
      };
    }

    // SD Teachers (5 Guru Kelas 5-6/Mapel)
    if (character.sdTeachers.isEmpty) {
      final List<String> sdSubjects = [
        'Bahasa Indonesia', 'Matematika', 'IPA', 'IPS', 'PPKn', 'Bahasa Inggris', 'Seni Budaya', 'Informatika', 'Pendidikan Agama', 'PJOK'
      ];
      for (int i = 0; i < 6; i++) {
        final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
        character.sdTeachers.add({
          'name': generateRandomName(gender, character),
          'gender': gender,
          'relationship': (45 + _random.nextInt(16)).toString(),
          'subject': sdSubjects[i % sdSubjects.length],
          'age': (25 + _random.nextInt(31)).toString(),
          'sexuality': _generateRandomSexuality(gender), // Diganti dari SexualityLogic
        });
      }
    }

    // SMP Teachers (10 Guru Mapel Lengkap)
    if (character.smpTeachers.isEmpty) {
      final List<String> smpSubjects = [
        'Matematika', 'IPA', 'Bahasa Indonesia', 'Bahasa Inggris', 'Pendidikan Agama',
        'PPKn', 'IPS', 'Seni Budaya', 'PJOK', 'Informatika', 'Prakarya'
      ];
      for (int i = 0; i < 10; i++) {
        final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
        character.smpTeachers.add({
          'name': generateRandomName(gender, character),
          'gender': gender,
          'relationship': (45 + _random.nextInt(16)).toString(),
          'subject': smpSubjects[i % smpSubjects.length],
          'age': (25 + _random.nextInt(31)).toString(),
          'sexuality': _generateRandomSexuality(gender), // Diganti dari SexualityLogic
        });
      }
    }

    // SMA Teachers (14 Guru Mapel Lengkap dari Peminatan)
    if (character.smaTeachers.isEmpty) {
      final List<String> smaSubjects = [
        'Matematika', 'Bahasa Indonesia', 'Bahasa Inggris', 'Fisika', 'Kimia', 'Biologi',
        'Sejarah', 'Geografi', 'Sosiologi', 'Ekonomi', 'Pendidikan Agama', 'PPKn', 'PJOK',
        'Seni Budaya', 'Informatika', 'Akuntansi', 'Antropologi'
      ];
      for (int i = 0; i < 14; i++) {
        final gender = _random.nextBool() ? 'Laki-laki' : 'Perempuan';
        character.smaTeachers.add({
          'name': generateRandomName(gender, character),
          'gender': gender,
          'relationship': (45 + _random.nextInt(16)).toString(),
          'subject': smaSubjects[i % smaSubjects.length],
          'age': (25 + _random.nextInt(31)).toString(),
          'sexuality': _generateRandomSexuality(gender), // Diganti dari SexualityLogic
        });
      }
    }
  }
}