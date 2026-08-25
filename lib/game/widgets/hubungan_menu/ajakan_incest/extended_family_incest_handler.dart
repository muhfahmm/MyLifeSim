import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class ExtendedFamilyIncestHandler {
  static void checkAndGenerateProposal(Character character, Random random, List<Map<String, dynamic>> candidates) {
    final age = character.age;
    bool isAlreadyPartner(String name) {
      return character.isAnyPartnerNameMatching(name);
    }

    for (var ext in character.extendedFamily) {
      final int extAge = int.tryParse(ext['age'] ?? '0') ?? 0;
      final bool isDeceased = ext['isDeceased'] == 'true';
      final String extName = ext['name'] ?? '';
      final String extRel = (ext['relation'] ?? '').toLowerCase();
      
      bool ageValid = extRel.contains('kakek') ? (age >= 10) : (age >= 12);
      if (ageValid && !isDeceased && extAge >= 12 && !isAlreadyPartner(extName)) {
        candidates.add({
          'name': extName,
          'relation': ext['relation'] ?? 'Keluarga',
          'gender': ext['gender'] ?? 'Laki-laki',
          'age': extAge,
          'role': 'Keluarga',
          'chance': 15,
        });
      }
    }
  }
}
