import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class AjakanMlHeteroPerempuanKeluarga {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = candidate['relation'].toString().toLowerCase();

    if (rel.contains('ayah tiri')) {
      return 60;
    } else if (rel.contains('ayah mertua')) {
      return 35;
    } else if (rel.contains('anak') || rel == 'laki-laki' || rel == 'perempuan') {
      return 65;
    } else if (rel.contains('keponakan')) {
      return 30;
    } else if (rel.contains('paman')) {
      return 30;
    } else if (rel.contains('ayah')) {
      return character.custodyParent == 'Ayah' ? (character.age >= 12 ? 55 : 45) : 30;
    } else if (rel.contains('adik laki')) {
      return 45;
    } else if (rel.contains('kakak laki')) {
      return 45;
    } else if (rel.contains('sepupu')) {
      return 40;
    } else if (rel.contains('kakek')) {
      return 15;
    }
    return 10;
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
