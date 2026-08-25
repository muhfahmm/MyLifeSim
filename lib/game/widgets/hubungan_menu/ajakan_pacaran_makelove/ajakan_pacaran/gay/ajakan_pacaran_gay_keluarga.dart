import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranGayKeluarga {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    int chance = 10;

    if (rel.contains('ayah mertua')) {
      chance = 5;
    } else if (rel.contains('anak')) {
      chance = 30;
    } else if (rel.contains('keponakan')) {
      chance = 30;
    } else if (rel.contains('paman')) {
      chance = 5;
    } else if (rel.contains('ayah')) {
      chance = 10;
    } else if (rel.contains('adik laki')) {
      chance = 5;
    } else if (rel.contains('kakak laki')) {
      chance = 5;
    } else if (rel.contains('sepupu')) {
      chance = 35;
    } else if (rel.contains('kakek')) {
      chance = 5;
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
