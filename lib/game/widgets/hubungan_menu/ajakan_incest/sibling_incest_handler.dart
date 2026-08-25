import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class SiblingIncestHandler {
  static void checkAndGenerateProposal(Character character, Random random, List<Map<String, dynamic>> candidates) {
    if (character.age < 12) return;

    bool isAlreadyPartner(String name) {
      return character.isAnyPartnerNameMatching(name);
    }

    for (var sib in character.siblings) {
      final int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
      final bool isDeceased = sib['isDeceased'] == 'true';
      final String sName = sib['name'] ?? '';
      if (!isDeceased && sibAge >= 12 && !isAlreadyPartner(sName)) {
        candidates.add({
          'name': '${sib['name']} (${sib['relation']})',
          'relation': sib['relation'] ?? 'Saudara',
          'gender': sib['gender'] ?? 'Laki-laki',
          'age': sibAge,
          'role': 'Kandung',
          'chance': 15,
        });
      }
      if (sib['childNames'] != null && sib['childNames']!.isNotEmpty) {
        final List<String> cNames = sib['childNames']!.split(',');
        final List<String> cAges = sib['childAges']!.split(',');
        final List<String> cGenders = sib['childGenders']!.split(',');
        for (int i = 0; i < cNames.length; i++) {
          int cAge = int.tryParse(cAges[i]) ?? 0;
          if (cAge >= 12 && !isAlreadyPartner(cNames[i])) {
            candidates.add({
              'name': cNames[i],
              'relation': 'Keponakan',
              'gender': cGenders[i],
              'age': cAge,
              'role': 'Keponakan',
              'chance': 10,
            });
          }
        }
      }
    }
  }
}
