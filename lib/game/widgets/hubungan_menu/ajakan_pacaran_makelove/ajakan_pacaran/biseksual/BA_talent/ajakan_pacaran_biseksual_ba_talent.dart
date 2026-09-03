import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/pilih_karakter/settings/proposal_percentage_settings.dart';

class AjakanPacaranBiseksualBaTalent {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = (candidate['relation'] ?? candidate['role'] ?? '').toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    int chance;
    if (isBiseksual) {
      if (rel.contains('ceo') || rel.contains('atasan')) {
        chance = 60;
      } else if (rel.contains('brand ambassador') || rel.contains('ba')) {
        chance = 55;
      } else if (rel.contains('talent')) {
        chance = 50;
      } else if (rel.contains('pro player')) {
        chance = 45;
      } else {
        chance = 50;
      }
    } else {
      chance = ProposalPercentageSettings.getChance(rel, 'Ajak Pacaran', gender: character.gender).toInt();
    }

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
