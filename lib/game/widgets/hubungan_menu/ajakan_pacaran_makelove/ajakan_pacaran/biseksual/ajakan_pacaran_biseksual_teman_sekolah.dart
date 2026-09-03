import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/pilih_karakter/settings/proposal_percentage_settings.dart';

class AjakanPacaranBiseksualTemanSekolah {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    int chance;
    if (isBiseksual) {
      if (rel.contains('kakak kelas')) {
        chance = 55;
      } else if (rel.contains('teman sekelas')) {
        chance = 50;
      } else if (rel.contains('teman satu angkatan') || rel.contains('angkatan')) {
        chance = 45;
      } else if (rel.contains('adik kelas')) {
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
