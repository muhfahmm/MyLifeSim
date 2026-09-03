import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranBiseksualRekanIdol {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = (candidate['relation'] ?? candidate['role'] ?? '').toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    if (isBiseksual) {
      if (rel.contains('leader') || rel.contains('pemimpin')) {
        return 50;
      } else if (rel.contains('center') || rel.contains('main member') || rel.contains('utama')) {
        return 50;
      } else if (rel.contains('rekan idol') || rel.contains('member')) {
        return 50;
      } else if (rel.contains('trainee')) {
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
        'name': '${candidate['name']} (Rekan Idol)',
        'relation': 'Rekan Idol',
        'type': 'Ajak Pacaran',
        'gender': candidate['gender'] ?? 'Laki-laki',
        'age': candidate['age'] ?? '16',
        'role': 'Rekan Idol',
      };
    }
    return null;
  }
}
