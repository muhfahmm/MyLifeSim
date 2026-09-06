import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class AjakanPacaranHeteroLakiKeluarga {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = candidate['relation'].toString().toLowerCase();

    if (rel.contains('ibu tiri')) {
      return 60;
    } else if (rel.contains('ibu mertua')) {
      return 30;
    } else if (rel.contains('anak') || rel == 'laki-laki' || rel == 'perempuan') {
      return 60;
    } else if (rel.contains('keponakan')) {
      return 30;
    } else if (rel.contains('pasangan paman')) {
      return 5;
    } else if (rel.contains('bibi')) {
      return 25;
    } else if (rel.contains('ibu')) {
      return character.custodyParent == 'Ibu' ? 50 : 10;
    } else if (rel.contains('kakak perempuan')) {
      return 30;
    } else if (rel.contains('adik perempuan')) {
      return 40;
    } else if (rel.contains('sepupu')) {
      return 35;
    } else if (rel.contains('nenek')) {
      return 10;
    }
    return 10;
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
