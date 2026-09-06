import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class AjakanPacaranBiseksualGuruSekolah {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = candidate['relation'].toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    if (isBiseksual) {
      if (rel.contains('wali kelas')) {
        return 50;
      } else if (rel.contains('kepala sekolah')) {
        return 50;
      } else if (rel.contains('guru bk')) {
        return 50;
      } else if (rel.contains('guru')) {
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
