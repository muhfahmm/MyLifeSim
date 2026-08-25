import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlGayRekanIdol {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    if (rand.nextDouble() < 0.15) {
      return {
        'name': '${candidate['name']} (Rekan Idol)',
        'relation': 'Rekan Idol',
        'type': 'Bercinta',
        'gender': 'Laki-laki',
        'age': candidate['age'] ?? '16',
        'role': 'Rekan Idol',
      };
    }
    return null;
  }
}
