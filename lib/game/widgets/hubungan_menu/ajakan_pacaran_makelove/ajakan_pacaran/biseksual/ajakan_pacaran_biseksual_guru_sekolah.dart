import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/pilih_karakter/settings/proposal_percentage_settings.dart';

class AjakanPacaranBiseksualGuruSekolah {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    int chance;
    if (isBiseksual) {
      if (rel.contains('wali kelas')) {
        chance = 60;
      } else if (rel.contains('kepala sekolah')) {
        chance = 55;
      } else if (rel.contains('guru bk')) {
        chance = 50;
      } else if (rel.contains('guru')) {
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
