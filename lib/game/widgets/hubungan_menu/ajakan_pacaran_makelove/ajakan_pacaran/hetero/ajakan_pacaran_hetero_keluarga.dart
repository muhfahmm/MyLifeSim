import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranHeteroKeluarga {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    final String myGenderLower = character.gender.trim().toLowerCase();
    int chance = 10;

    if (rel.contains('ayah tiri')) {
      // Step-father special logic
      if (rand.nextInt(100) < 70) {
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

    if (myGenderLower == 'perempuan') {
      if (rel.contains('ayah mertua')) chance = 30;
      else if (rel.contains('anak')) chance = 30;
      else if (rel.contains('keponakan')) chance = 30;
      else if (rel.contains('paman')) chance = 25;
      else if (rel.contains('ayah')) chance = character.custodyParent == 'Ayah' ? 65 : 40;
      else if (rel.contains('adik laki')) chance = 40;
      else if (rel.contains('kakak laki')) chance = 40;
      else if (rel.contains('sepupu')) chance = 35;
      else if (rel.contains('kakek')) chance = 10;
    } else {
      if (rel.contains('ibu mertua')) chance = 30;
      else if (rel.contains('anak')) chance = 30;
      else if (rel.contains('keponakan')) chance = 30;
      else if (rel.contains('pasangan paman')) chance = 5;
      else if (rel.contains('bibi')) chance = 25;
      else if (rel.contains('ibu')) chance = character.custodyParent == 'Ibu' ? 50 : 10;
      else if (rel.contains('kakak perempuan')) chance = 30;
      else if (rel.contains('adik perempuan')) chance = 40;
      else if (rel.contains('sepupu')) chance = 35;
      else if (rel.contains('nenek')) chance = 10;
    }

    if (myGenderLower == 'perempuan' || myGenderLower == 'female') {
      chance += 5;
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
