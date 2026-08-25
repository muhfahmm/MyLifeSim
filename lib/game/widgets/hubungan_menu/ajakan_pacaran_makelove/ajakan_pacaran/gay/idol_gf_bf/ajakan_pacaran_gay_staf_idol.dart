import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranGayStafIdol {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    if (rand.nextDouble() < 0.25) {
      return {
        'name': '${candidate['name']} (Staf ${candidate['role']})',
        'relation': 'Staf Idol (${candidate['role']})',
        'type': 'Ajak Pacaran',
        'gender': candidate['gender'] ?? 'Laki-laki',
        'age': candidate['age'] ?? '30',
        'role': 'Staf Idol',
      };
    }
    return null;
  }
}
