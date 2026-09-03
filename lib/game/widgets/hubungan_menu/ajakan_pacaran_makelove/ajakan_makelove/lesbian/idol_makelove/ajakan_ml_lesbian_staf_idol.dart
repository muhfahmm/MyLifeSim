import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlLesbianStafIdol {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = (candidate['relation'] ?? candidate['role'] ?? '').toString().toLowerCase();

    if (rel.contains('produser') || rel.contains('director')) {
      return 30;
    } else if (rel.contains('manager') || rel.contains('gm')) {
      return 25;
    } else if (rel.contains('operasional') || rel.contains('staf')) {
      return 25;
    }
    return 25;
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final int chance = getChance(character, candidate);
    if (rand.nextInt(100) < chance) {
      return {
        'name': '${candidate['name']} (Staf ${candidate['role']})',
        'relation': 'Staf Idol (${candidate['role']})',
        'type': 'Bercinta',
        'gender': candidate['gender'] ?? 'Laki-laki',
        'age': candidate['age'] ?? '30',
        'role': 'Staf Idol',
      };
    }
    return null;
  }
}
