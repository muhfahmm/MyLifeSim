import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/guru_laki_siswi/guru_laki_proposal_chance.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/guru_perempuan_siswa/guru_perempuan_proposal_chance.dart';

class AjakanMlHeteroDosen {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String candGender = (candidate['gender'] ?? 'Laki-laki').trim().toLowerCase();
    int chance = 0;
    
    if (candGender == 'laki-laki' || candGender == 'male') {
      chance = GuruLakiProposalChance.getBercintaChance(character.age);
    } else {
      chance = GuruPerempuanProposalChance.getBercintaChance(character.age);
    }

    if (character.gender.toLowerCase() == 'perempuan' || character.gender.toLowerCase() == 'female') {
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
