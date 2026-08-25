import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class InLawIncestHandler {
  static void checkAndGenerateProposal(Character character, Random random, List<Map<String, dynamic>> candidates) {
    if (character.age < 12) return;

    bool isAlreadyPartner(String name) {
      return character.isAnyPartnerNameMatching(name);
    }

    if (character.fatherInLawName != null && character.fatherInLawAge != null && !isAlreadyPartner(character.fatherInLawName!)) {
      candidates.add({
        'name': character.fatherInLawName!,
        'relation': 'Ayah Mertua',
        'gender': 'Laki-laki',
        'age': character.fatherInLawAge!,
        'role': 'Mertua',
        'chance': 15,
      });
    }
    if (character.motherInLawName != null && character.motherInLawAge != null && !isAlreadyPartner(character.motherInLawName!)) {
      candidates.add({
        'name': character.motherInLawName!,
        'relation': 'Ibu Mertua',
        'gender': 'Perempuan',
        'age': character.motherInLawAge!,
        'role': 'Mertua',
        'chance': 15,
      });
    }
  }
}
