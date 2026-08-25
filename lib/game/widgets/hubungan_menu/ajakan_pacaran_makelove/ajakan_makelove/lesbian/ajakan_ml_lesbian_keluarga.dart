import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlLesbianKeluarga {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    int chance = 30;

    if (rel.contains('ibu mertua')) {
      chance = 5;
    } else if (rel.contains('anak')) {
      chance = 30;
    } else if (rel.contains('keponakan')) {
      chance = 30;
    } else if (rel.contains('pasangan paman')) {
      chance = 25;
    } else if (rel.contains('bibi')) {
      chance = 15;
    } else if (rel.contains('ibu')) {
      chance = character.custodyParent == 'Ayah' ? 10 : 20;
    } else if (rel.contains('kakak perempuan')) {
      chance = 30;
    } else if (rel.contains('adik perempuan')) {
      chance = 30;
    } else if (rel.contains('sepupu')) {
      chance = 35;
    } else if (rel.contains('nenek')) {
      chance = 5;
    }

    chance += 5; // player female bonus

    if (rand.nextInt(100) < chance) {
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
