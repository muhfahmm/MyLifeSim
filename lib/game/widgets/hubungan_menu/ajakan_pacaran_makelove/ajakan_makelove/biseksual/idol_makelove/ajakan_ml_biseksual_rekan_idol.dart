import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/pilih_karakter/settings/proposal_percentage_settings.dart';

class AjakanMlBiseksualRekanIdol {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = (candidate['relation'] ?? candidate['role'] ?? '').toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    int chance;
    if (isBiseksual) {
      if (rel.contains('leader') || rel.contains('pemimpin')) {
        chance = 60;
      } else if (rel.contains('center') || rel.contains('main member') || rel.contains('utama')) {
        chance = 55;
      } else if (rel.contains('rekan idol') || rel.contains('member')) {
        chance = 50;
      } else if (rel.contains('trainee')) {
        chance = 45;
      } else {
        chance = 50;
      }
    } else {
      chance = ProposalPercentageSettings.getChance(rel, 'Bercinta', gender: character.gender).toInt();
    }

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
