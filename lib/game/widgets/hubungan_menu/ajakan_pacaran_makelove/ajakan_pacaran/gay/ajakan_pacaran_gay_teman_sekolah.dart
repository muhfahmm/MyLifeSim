import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/school_sexuality/siswa_siswa/siswa_siswa_proposal_chance.dart';

class AjakanPacaranGayTemanSekolah {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final int chance = SiswaSiswaProposalChance.getPacaranChance(character.age);
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
