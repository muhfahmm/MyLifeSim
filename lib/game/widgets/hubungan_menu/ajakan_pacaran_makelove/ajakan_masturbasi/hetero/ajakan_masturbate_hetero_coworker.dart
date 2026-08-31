import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMasturbateHeteroCoworker {
  static int _getChance(int age) {
    if (age < 13) return 0;
    if (age <= 15) return 25;
    if (age <= 17) return 35;
    if (age >= 18) return 45;
    return 0;
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    int chance = _getChance(character.age);
    if (character.gender.toLowerCase() == 'perempuan' || character.gender.toLowerCase() == 'female') {
      chance += 5;
    }

    final String rel = (candidate['relation'] ?? '').toString().toLowerCase();
    if (rel.contains('supervisor') || rel.contains('atasan')) {
      chance += 5;
    } else if (rel.contains('ceo')) {
      chance += 3;
    }

    if (rand.nextInt(100) < chance) {
      return {
        'name': candidate['name'],
        'relation': candidate['relation'],
        'type': 'Masturbasi',
        'gender': candidate['gender'],
        'age': candidate['age'],
        'role': candidate['role'],
      };
    }
    return null;
  }
}
