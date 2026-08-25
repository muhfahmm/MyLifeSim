import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlGayKeluarga {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    int chance = 10;

    if (rel.contains('ayah mertua')) {
      // Ayah Mertua: 5%
      chance = 5;
    } else if (rel.contains('anak')) {
      // Anak Kandung/Tiri: 30%
      chance = 30;
    } else if (rel.contains('keponakan')) {
      // Keponakan: 30%
      chance = 30;
    } else if (rel.contains('paman')) {
      // Paman: 5%
      chance = 5;
    } else if (rel.contains('ayah')) {
      // Ayah Kandung: 10%
      chance = 10;
    } else if (rel.contains('adik laki')) {
      // Adik Laki-laki: 5%
      chance = 5;
    } else if (rel.contains('kakak laki')) {
      // Kakak Laki-laki: 5%
      chance = 5;
    } else if (rel.contains('sepupu')) {
      // Sepupu: 35%
      chance = 35;
    } else if (rel.contains('kakek')) {
      // Kakek: 5%
      chance = 5;
    }

    if (rand.nextInt(100) < chance) {
      // bercinta check is 20% of the normal dating proposal
      if (rand.nextInt(100) >= 80) {
        return {
          'name': candidate['name'],
          'relation': candidate['relation'],
          'type': 'Bercinta',
          'gender': candidate['gender'],
          'age': candidate['age'],
          'role': candidate['role'],
        };
      }
    }
    return null;
  }
}
