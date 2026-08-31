import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMasturbateHeteroDosen {
  static int _getChance(int age) {
    if (age < 18) return 0;
    if (age == 18) return 40;
    if (age == 19) return 45;
    if (age >= 20) return 50;
    return 0;
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    int chance = _getChance(character.age);
    if (character.gender.toLowerCase() == 'perempuan' || character.gender.toLowerCase() == 'female') {
      chance += 5;
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
