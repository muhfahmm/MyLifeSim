import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class AjakanMlHeteroPerempuanRekanIdol {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = (candidate['relation'] ?? candidate['role'] ?? '').toString().toLowerCase();

    if (rel.contains('leader') || rel.contains('pemimpin')) {
      return 32;
    } else if (rel.contains('center') || rel.contains('main member') || rel.contains('utama')) {
      return 30;
    } else if (rel.contains('rekan idol') || rel.contains('member')) {
      return 25;
    } else if (rel.contains('trainee')) {
      return 20;
    }
    return 25;
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final int chance = getChance(character, candidate);
    if (rand.nextInt(100) < chance) {
      return {
        'name': '${candidate['name']} (Rekan Idol)',
        'relation': 'Rekan Idol',
        'type': 'Bercinta',
        'gender': candidate['gender'] ?? 'Laki-laki',
        'age': candidate['age'] ?? '16',
        'role': 'Rekan Idol',
      };
    }
    return null;
  }
}
