import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlLesbianKeluarga {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    int chance = 30;

    if (rel.contains('ibu mertua')) {
      // Ibu Mertua: 5%
      chance = 5;
    } else if (rel.contains('anak') || rel == 'laki-laki' || rel == 'perempuan') {
      // Anak Kandung/Tiri: 60%
      chance = 60;
    } else if (rel.contains('keponakan')) {
      // Keponakan: 30%
      chance = 30;
    } else if (rel.contains('pasangan paman')) {
      // Pasangan Paman (Istri Paman / Bibi): 25%
      chance = 25;
    } else if (rel.contains('bibi')) {
      // Bibi Kandung: 15%
      chance = 15;
    } else if (rel.contains('ibu')) {
      // Ibu Kandung: 10% jika hak asuh di Ayah, 20% jika di Ibu
      chance = character.custodyParent == 'Ayah' ? 10 : 20;
    } else if (rel.contains('kakak perempuan')) {
      // Kakak Perempuan: 30%
      chance = 30;
    } else if (rel.contains('adik perempuan')) {
      // Adik Perempuan: 30%
      chance = 30;
    } else if (rel.contains('sepupu')) {
      // Sepupu: 35%
      chance = 35;
    } else if (rel.contains('nenek')) {
      // Nenek: 5%
      chance = 5;
    }

    chance += 5; // player female bonus

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
