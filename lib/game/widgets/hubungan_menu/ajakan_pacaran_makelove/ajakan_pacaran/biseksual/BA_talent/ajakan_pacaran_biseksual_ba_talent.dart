import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class AjakanPacaranBiseksualBaTalent {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = (candidate['relation'] ?? candidate['role'] ?? '').toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    if (isBiseksual) {
      if (rel.contains('ceo') || rel.contains('atasan')) {
        return 50;
      } else if (rel.contains('brand ambassador') || rel.contains('ba')) {
        return 50;
      } else if (rel.contains('talent')) {
        return 50;
      } else if (rel.contains('pro player')) {
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
        'relation': candidate['role'] ?? 'Rekan Esports',
        'type': 'Ajak Pacaran',
        'gender': candidate['gender'] ?? 'Laki-laki',
        'age': candidate['age'] ?? '18',
        'role': candidate['role'] ?? 'BA_talent',
      };
    }
    return null;
  }
}
