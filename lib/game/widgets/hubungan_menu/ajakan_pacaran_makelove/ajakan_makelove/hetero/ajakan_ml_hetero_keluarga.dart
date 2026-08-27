import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlHeteroKeluarga {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    final String myGenderLower = character.gender.trim().toLowerCase();
    int chance = 10;

    if (rel.contains('ayah tiri')) {
      if (rand.nextInt(100) >= 53) {
        if (rand.nextInt(100) < 60) {
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

    if (myGenderLower == 'perempuan') {
      if (rel.contains('ayah mertua')) chance = 30; // Ayah Mertua: 30%
      else if (rel.contains('anak') || rel == 'laki-laki' || rel == 'perempuan') chance = 60; // Anak Kandung/Tiri: 60%
      else if (rel.contains('keponakan')) chance = 30; // Keponakan: 30%
      else if (rel.contains('ayah')) chance = character.custodyParent == 'Ayah' ? (character.age >= 12 ? 10 : 65) : 40; // Ayah Kandung: 15% (10 + 5) jika hak asuh di Ayah & usia >= 12, 65% jika hak asuh di Ayah saja, 40% jika tidak
      else if (rel.contains('adik laki')) chance = 40; // Adik Laki-laki: 40%
      else if (rel.contains('kakak laki')) chance = 40; // Kakak Laki-laki: 40%
      else if (rel.contains('sepupu')) chance = 35; // Sepupu: 35%
      else if (rel.contains('kakek')) chance = 10; // Kakek: 10%
    } else {
      if (rel.contains('ibu mertua')) chance = 30; // Ibu Mertua: 30%
      else if (rel.contains('anak') || rel == 'laki-laki' || rel == 'perempuan') chance = 60; // Anak Kandung/Tiri: 60%
      else if (rel.contains('keponakan')) chance = 30; // Keponakan: 30%
      else if (rel.contains('pasangan paman')) chance = 5; // Pasangan Paman: 5%
      else if (rel.contains('bibi')) chance = 25; // Bibi: 25%
      else if (rel.contains('ibu')) chance = character.custodyParent == 'Ibu' ? 50 : 10; // Ibu Kandung: 50% jika hak asuh di Ibu, 10% jika tidak
      else if (rel.contains('kakak perempuan')) chance = 30; // Kakak Perempuan: 30%
      else if (rel.contains('adik perempuan')) chance = 40; // Adik Perempuan: 40%
      else if (rel.contains('sepupu')) chance = 35; // Sepupu: 35%
      else if (rel.contains('nenek')) chance = 10; // Nenek: 10%
    }

    if (myGenderLower == 'perempuan' || myGenderLower == 'female') {
      chance += 5;
    }

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
