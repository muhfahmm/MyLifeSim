import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranGayCoworker {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    if (rand.nextInt(100) < 20) {
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
