import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranBiseksualStafIdol {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = (candidate['relation'] ?? candidate['role'] ?? '').toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    if (isBiseksual) {
      if (rel.contains('produser') || rel.contains('director')) {
        return 50;
      } else if (rel.contains('manager') || rel.contains('gm')) {
        return 50;
      } else if (rel.contains('operasional') || rel.contains('staf')) {
        return 50;
      } else {
        return 50;
      }
    }
    return 50;
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final int chance = getChance(character, candidate);

    if (rand.nextInt(100) < chance) {
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
