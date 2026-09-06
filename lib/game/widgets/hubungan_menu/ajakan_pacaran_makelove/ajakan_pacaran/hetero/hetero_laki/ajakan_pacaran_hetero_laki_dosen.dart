import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class AjakanPacaranHeteroLakiDosen {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = candidate['relation'].toString().toLowerCase();

    if (rel.contains('pembimbing') || rel.contains('skripsi')) {
      return 30;
    } else if (rel.contains('dekan') || rel.contains('kaprodi')) {
      return 25;
    } else if (rel.contains('penguji')) {
      return 25;
    } else if (rel.contains('dosen')) {
      return 30;
    }
    return 30;
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final int chance = getChance(character, candidate);
    if (rand.nextInt(100) < chance) {
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
