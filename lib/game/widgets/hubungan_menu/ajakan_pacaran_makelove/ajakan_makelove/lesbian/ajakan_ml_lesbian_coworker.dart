import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlLesbianCoworker {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
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
