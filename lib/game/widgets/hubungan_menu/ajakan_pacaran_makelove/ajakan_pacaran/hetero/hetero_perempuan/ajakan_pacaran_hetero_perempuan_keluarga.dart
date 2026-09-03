import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranHeteroPerempuanKeluarga {
  static int getChance(Character character, Map<String, dynamic> candidate) {
    final String rel = candidate['relation'].toString().toLowerCase();

    if (rel.contains('ayah tiri')) {
      return 70;
    } else if (rel.contains('ayah mertua')) {
      return 45;
    } else if (rel.contains('anak') || rel == 'laki-laki' || rel == 'perempuan') {
      return 60;
    } else if (rel.contains('keponakan')) {
      return 30;
    } else if (rel.contains('paman')) {
      return 25;
    } else if (rel.contains('ayah')) {
      return character.custodyParent == 'Ayah' ? (character.age >= 12 ? 75 : 65) : 40;
    } else if (rel.contains('adik laki')) {
      return 40;
    } else if (rel.contains('kakak laki')) {
      return 40;
    } else if (rel.contains('sepupu')) {
      return 35;
    } else if (rel.contains('kakek')) {
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
