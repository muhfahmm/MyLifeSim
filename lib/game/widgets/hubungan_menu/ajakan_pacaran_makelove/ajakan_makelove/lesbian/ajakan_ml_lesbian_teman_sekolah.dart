import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class AjakanMlLesbianTemanSekolah {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    return 35;
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final int chance = getChance(character, candidate);
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
