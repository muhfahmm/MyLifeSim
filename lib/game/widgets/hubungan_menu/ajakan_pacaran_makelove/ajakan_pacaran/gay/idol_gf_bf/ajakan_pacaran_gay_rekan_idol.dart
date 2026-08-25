import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranGayRekanIdol {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    if (rand.nextDouble() < 0.20) {
      return {
        'name': '${candidate['name']} (Rekan Idol)',
        'relation': 'Rekan Idol',
        'type': 'Ajak Pacaran',
        'gender': 'Laki-laki',
        'age': candidate['age'] ?? '16',
        'role': 'Rekan Idol',
      };
    }
    return null;
  }
}
