import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/pilih_karakter/settings/proposal_percentage_settings.dart';

class AjakanPacaranBiseksualKeluarga {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    int chance;
    if (isBiseksual) {
      if (rel.contains('ayah tiri')) {
        chance = 65;
      } else if (rel.contains('ayah mertua')) {
        chance = 50;
      } else if (rel.contains('ayah')) {
        chance = 60;
      } else if (rel.contains('ibu tiri')) {
        chance = 60;
      } else if (rel.contains('ibu mertua')) {
        chance = 45;
      } else if (rel.contains('ibu')) {
        chance = 50;
      } else if (rel.contains('kakak laki') || rel.contains('adik laki')) {
        chance = 45;
      } else if (rel.contains('kakak perempuan') || rel.contains('adik perempuan')) {
        chance = 50;
      } else if (rel.contains('paman')) {
        chance = 45;
      } else if (rel.contains('pasangan paman') || rel.contains('bibi')) {
        chance = 50;
      } else if (rel.contains('sepupu')) {
        chance = 55;
      } else if (rel.contains('kakek') || rel.contains('nenek')) {
        chance = 45;
      } else if (rel.contains('anak') || rel.contains('keponakan')) {
        chance = 60;
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
