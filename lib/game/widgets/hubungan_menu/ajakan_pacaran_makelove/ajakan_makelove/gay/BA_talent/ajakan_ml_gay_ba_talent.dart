import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class AjakanMlGayBaTalent {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = (candidate['relation'] ?? candidate['role'] ?? '').toString().toLowerCase();

    if (rel.contains('ceo') || rel.contains('atasan')) {
      return 30;
    } else if (rel.contains('brand ambassador') || rel.contains('ba')) {
      return 25;
    } else if (rel.contains('talent')) {
      return 25;
    } else if (rel.contains('pro player')) {
      return 30;
    }
    return 25;
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final int chance = getChance(character, candidate);
    if (rand.nextInt(100) < chance) {
      return {
        'name': candidate['name'],
        'relation': candidate['role'] ?? 'Rekan Esports',
        'type': 'Bercinta',
        'gender': candidate['gender'] ?? 'Laki-laki',
        'age': candidate['age'] ?? '18',
        'role': candidate['role'] ?? 'BA_talent',
      };
    }
    return null;
  }
}
