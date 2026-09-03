import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlHeteroLakiCoworker {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = candidate['relation'].toString().toLowerCase();

    if (rel.contains('bos') || rel.contains('atasan') || rel.contains('direktur')) {
      return 30;
    } else if (rel.contains('supervisor')) {
      return 25;
    } else if (rel.contains('rekan kerja') || rel.contains('coworker')) {
      return 30;
    } else if (rel.contains('anak magang') || rel.contains('intern')) {
      return 20;
    }
    return 25;
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
