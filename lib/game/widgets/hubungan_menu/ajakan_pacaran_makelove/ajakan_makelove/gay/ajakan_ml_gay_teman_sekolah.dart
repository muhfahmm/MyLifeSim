import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class AjakanMlGayTemanSekolah {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = candidate['relation'].toString().toLowerCase();

    if (rel.contains('kakak kelas')) {
      return 35;
    } else if (rel.contains('teman sekelas')) {
      return 35;
    } else if (rel.contains('teman satu angkatan') || rel.contains('angkatan')) {
      return 30;
    } else if (rel.contains('adik kelas')) {
      return 30;
    }
    return 35;
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
