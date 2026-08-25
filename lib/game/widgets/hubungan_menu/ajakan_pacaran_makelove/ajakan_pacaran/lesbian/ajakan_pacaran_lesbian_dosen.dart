import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranLesbianDosen {
  static int _getChance(int age) {
    if (age == 6) return 5;
    if (age == 7) return 10;
    if (age == 8) return 15;
    if (age == 9) return 20;
    if (age == 10) return 25;
    if (age == 11) return 30;
    if (age == 12) return 35;
    if (age == 13) return 40;
    if (age == 14) return 45;
    if (age >= 15) return 50;
    return 0;
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    int chance = _getChance(character.age);
    if (character.gender.toLowerCase() == 'perempuan' || character.gender.toLowerCase() == 'female') { chance += 5; }

    if (rel.contains('pembimbing') || rel.contains('skripsi')) {
      // Dosen Pembimbing Skripsi: +10% chance
      chance += 10;
    } else if (rel.contains('penguji')) {
      // Dosen Penguji Sidang: +5% chance
      chance += 5;
    } else if (rel.contains('dekan') || rel.contains('kaprodi')) {
      // Dekan / Kaprodi: +8% chance
      chance += 8;
    } else if (rel.contains('dosen')) {
      // Dosen Biasa: normal chance
    }

    if (rand.nextInt(100) < chance) {
      return {
        'name': candidate['name'],
        'relation': candidate['relation'],
        'type': 'Ajak Pacaran',
        'gender': candidate['gender'],
        'age': candidate['age'],
        'role': candidate['role'],
      };
    }
    return null;
  }
}
