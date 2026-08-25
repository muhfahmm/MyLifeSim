import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlGayCoworker {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    // 10% chance for Bercinta (roll 20 to 29 out of 100)
    final int roll = rand.nextInt(100);
    if (roll >= 20 && roll < 30) {
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
