import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlLesbianCoworker {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    int chance = 10;

    if (rel.contains('bos') || rel.contains('atasan') || rel.contains('supervisor')) {
      // Atasan / Supervisor / Bos: +5%
      chance += 5;
    } else if (rel.contains('rekan kerja') || rel.contains('coworker')) {
      // Rekan Kerja Biasa: normal
    } else if (rel.contains('anak magang') || rel.contains('intern')) {
      // Anak Magang / Intern: -5%
      chance = (chance - 5).clamp(0, 100);
    }

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
