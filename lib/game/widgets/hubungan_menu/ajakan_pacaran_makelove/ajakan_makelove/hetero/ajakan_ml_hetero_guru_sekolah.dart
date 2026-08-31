import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlHeteroGuruSekolah {
  static int _getChance(int age) {
  if (age == 6) return 1;
  if (age == 7) return 15;
  if (age == 8) return 20;
  if (age == 9) return 35;
  if (age == 10) return 50;
  if (age == 11) return 55; // Interpolasi dari 50 ke 60
  if (age == 12) return 60;
  if (age == 13) return 65;
  if (age == 14) return 65;
  if (age == 15) return 65;
  if (age == 16) return 60;
  if (age == 17) return 60;
  if (age == 18) return 70;
  return 0; // Usia di bawah 6 atau di atas 18
}

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    int chance = _getChance(character.age);
    if (character.gender.toLowerCase() == 'perempuan' || character.gender.toLowerCase() == 'female') { chance += 5; }

    if (rel.contains('wali kelas')) {
      // Wali Kelas: +10% chance
      chance += 10;
    } else if (rel.contains('guru bk')) {
      // Guru BK: +5% chance
      chance += 5;
    } else if (rel.contains('kepala sekolah')) {
      // Kepala Sekolah: +8% chance
      chance += 8;
    } else if (rel.contains('guru')) {
      // Guru Mata Pelajaran Biasa: normal chance
    }

    if (rand.nextInt(100) < chance) {
      return {
        'name': candidate['name'],
        'relation': candidate['relation'],
        'type': 'Bercinta',
        'gender': candidate['gender'],
        'age': candidate['age'],
        'role': candidate['role'],
      };
    }
    return null;
  }
}
