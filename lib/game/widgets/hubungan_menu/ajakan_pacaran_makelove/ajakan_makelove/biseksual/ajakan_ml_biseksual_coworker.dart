import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/pilih_karakter/settings/proposal_percentage_settings.dart';

class AjakanMlBiseksualCoworker {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    int chance;
    if (isBiseksual) {
      if (rel.contains('bos') || rel.contains('atasan') || rel.contains('direktur')) {
        chance = 60;
      } else if (rel.contains('supervisor')) {
        chance = 55;
      } else if (rel.contains('rekan kerja') || rel.contains('coworker')) {
        chance = 50;
      } else if (rel.contains('anak magang') || rel.contains('intern')) {
        chance = 45;
      } else {
        chance = 50;
      }
    } else {
      chance = ProposalPercentageSettings.getChance(rel, 'Bercinta', gender: character.gender).toInt();
    }

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
