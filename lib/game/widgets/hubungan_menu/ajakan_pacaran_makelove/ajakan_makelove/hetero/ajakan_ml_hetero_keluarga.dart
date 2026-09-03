import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlHeteroKeluarga {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = candidate['relation'].toString().toLowerCase();
    final String myGenderLower = character.gender.trim().toLowerCase();
    int chance = 10;

    if (rel.contains('ayah tiri')) {
      return 60;
    } else if (rel.contains('ibu tiri')) {
      return 60;
    }

    if (myGenderLower == 'perempuan') {
      if (rel.contains('ayah mertua')) chance = 35;
      else if (rel.contains('anak') || rel == 'laki-laki' || rel == 'perempuan') chance = 65;
      else if (rel.contains('keponakan')) chance = 30;
      else if (rel.contains('paman')) chance = 30;
      else if (rel.contains('ayah')) chance = character.custodyParent == 'Ayah' ? (character.age >= 12 ? 55 : 45) : 30;
      else if (rel.contains('adik laki')) chance = 45;
      else if (rel.contains('kakak laki')) chance = 45;
      else if (rel.contains('sepupu')) chance = 40;
      else if (rel.contains('kakek')) chance = 15;
    } else {
      if (rel.contains('ibu mertua')) chance = 30;
      else if (rel.contains('anak') || rel == 'laki-laki' || rel == 'perempuan') chance = 65;
      else if (rel.contains('keponakan')) chance = 30;
      else if (rel.contains('pasangan paman')) chance = 10;
      else if (rel.contains('bibi')) chance = 25;
      else if (rel.contains('ibu')) chance = character.custodyParent == 'Ibu' ? 45 : 10;
      else if (rel.contains('kakak perempuan')) chance = 30;
      else if (rel.contains('adik perempuan')) chance = 40;
      else if (rel.contains('sepupu')) chance = 40;
      else if (rel.contains('nenek')) chance = 10;
    }

    return chance;
  }

  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final int chance = getChance(character, candidate);
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
