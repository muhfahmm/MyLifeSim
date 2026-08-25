import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/siswi_siswi/siswi_siswi_proposal_chance.dart';

class AjakanPacaranLesbianTemanSekolah {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    // Lesbian classmate dating proposal
    // If user is female, chance gets +5%
    int chance = SiswiSiswiProposalChance.getPacaranChance(character.age) + 5;
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
