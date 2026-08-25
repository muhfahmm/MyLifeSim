import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class ChildIncestHandler {
  static void checkAndGenerateProposal(Character character, Random random, List<Map<String, dynamic>> candidates) {
    if (character.age < 12) return;

    bool isAlreadyPartner(String name) {
      return character.isAnyPartnerNameMatching(name);
    }

    for (var child in character.children) {
      final int childAge = int.tryParse(child['age'] ?? '0') ?? 0;
      final bool isDeceased = child['isDeceased'] == 'true';
      final String childName = child['name'] ?? '';
      if (!isDeceased && childAge >= 12 && !isAlreadyPartner(childName)) {
        candidates.add({
          'name': childName,
          'relation': 'Anak',
          'gender': child['gender'] ?? 'Laki-laki',
          'age': childAge,
          'role': 'Anak',
          'chance': 15,
        });
      }
    }
  }
}
