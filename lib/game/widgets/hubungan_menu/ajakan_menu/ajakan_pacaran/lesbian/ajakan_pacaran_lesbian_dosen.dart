import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/guru_perempuan_siswi/guru_perempuan_siswi_proposal_chance.dart';

class AjakanPacaranLesbianDosen {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    int chance = GuruPerempuanSiswiProposalChance.getPacaranChance(character.age) + 5;
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
