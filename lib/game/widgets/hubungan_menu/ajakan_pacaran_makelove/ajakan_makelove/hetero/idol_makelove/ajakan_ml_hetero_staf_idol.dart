import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlHeteroStafIdol {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    int chance = 15;

    if (rel.contains('manager') || rel.contains('gm') || rel.contains('direktur')) {
      // Manager / GM: +10%
      chance += 10;
    } else if (rel.contains('staf operasional') || rel.contains('operasional') || rel.contains('staf biasa')) {
      // Staf Operasional Biasa: +5%
      chance += 5;
    } else if (rel.contains('produser') || rel.contains('director')) {
      // Produser / Director: +15%
      chance += 15;
    }

    if (rand.nextDouble() < (chance / 100.0)) {
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
