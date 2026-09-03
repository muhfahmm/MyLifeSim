import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranBiseksualKeluarga {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = candidate['relation'].toString().toLowerCase();
    final bool isBiseksual = character.sexuality.trim().toLowerCase() == 'biseksual';

    if (isBiseksual) {
      if (rel.contains('ayah tiri')) {
        return 50;
      } else if (rel.contains('ayah mertua')) {
        return 50;
      } else if (rel.contains('ayah')) {
        return 50;
      } else if (rel.contains('ibu tiri')) {
        return 50;
      } else if (rel.contains('ibu mertua')) {
        return 50;
      } else if (rel.contains('ibu')) {
        return 50;
      } else if (rel.contains('kakak laki') || rel.contains('adik laki')) {
        return 50;
      } else if (rel.contains('kakak perempuan') || rel.contains('adik perempuan')) {
        return 50;
      } else if (rel.contains('paman')) {
        return 50;
      } else if (rel.contains('pasangan paman') || rel.contains('bibi')) {
        return 50;
      } else if (rel.contains('sepupu')) {
        return 50;
      } else if (rel.contains('kakek') || rel.contains('nenek')) {
        return 50;
      } else if (rel.contains('anak') || rel.contains('keponakan')) {
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
