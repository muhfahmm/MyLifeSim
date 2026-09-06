import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class AjakanPacaranLesbianTemanSekolah {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final int age = character.age;
    if (character.univMajor != null || age >= 18) {
      return 65; // Kuliah / Universitas
    } else if (age >= 15) {
      return 50; // SMA
    } else if (age >= 12) {
      return 40; // SMP
    } else {
      return 30; // SD
    }
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final int chance = getChance(character, candidate);
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
