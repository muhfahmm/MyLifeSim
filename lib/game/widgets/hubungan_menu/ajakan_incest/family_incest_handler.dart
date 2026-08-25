import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class FamilyIncestHandler {
  static void checkAndGenerateProposal(Character character, Random random) {
    if (character.age < 12 || character.activeProposal != null) return;

    final String myGenderLower = character.gender.trim().toLowerCase();
    final bool isParentsDivorced = character.isFatherDivorced || character.isMotherDivorced;
    final String? custody = character.custodyParent; // 'Ayah' atau 'Ibu'

    List<Map<String, dynamic>> candidates = [];

    bool isAlreadyPartner(String name) {
      return character.isAnyPartnerNameMatching(name);
    }

    if (isParentsDivorced) {
      // 2.1. Status orang tuanya cerai
      if (myGenderLower == 'laki-laki') {
        if (custody == 'Ibu') {
          // Laki dan ikut Ibu
          if (character.motherName != null && !character.isMotherDeceased && !isAlreadyPartner(character.motherName!)) {
            candidates.add({
              'relation': 'Ibu',
              'name': 'Ibu (${character.motherName})',
              'gender': 'Perempuan',
              'age': character.motherAge ?? 40,
              'role': 'Kandung',
              'chance': 30,
            });
          }
          if (character.fatherName != null && !character.isFatherDeceased && !isAlreadyPartner(character.fatherName!)) {
            candidates.add({
              'relation': 'Ayah',
              'name': 'Ayah (${character.fatherName})',
              'gender': 'Laki-laki',
              'age': character.fatherAge ?? 40,
              'role': 'Kandung',
              'chance': 10,
            });
          }
          if (character.stepFatherName != null && !character.isStepFatherDeceased && !isAlreadyPartner(character.stepFatherName!)) {
            candidates.add({
              'relation': 'Ayah Tiri',
              'name': 'Ayah Tiri (${character.stepFatherName})',
              'gender': 'Laki-laki',
              'age': character.stepFatherAge ?? 40,
              'role': 'Tiri',
              'chance': 5,
            });
          }
        } else if (custody == 'Ayah') {
          // Laki dan ikut Ayah
          if (character.motherName != null && !character.isMotherDeceased && !isAlreadyPartner(character.motherName!)) {
            candidates.add({
              'relation': 'Ibu',
              'name': 'Ibu (${character.motherName})',
              'gender': 'Perempuan',
              'age': character.motherAge ?? 40,
              'role': 'Kandung',
              'chance': 15,
            });
          }
          if (character.fatherName != null && !character.isFatherDeceased && !isAlreadyPartner(character.fatherName!)) {
            candidates.add({
              'relation': 'Ayah',
              'name': 'Ayah (${character.fatherName})',
              'gender': 'Laki-laki',
              'age': character.fatherAge ?? 40,
              'role': 'Kandung',
              'chance': 5,
            });
          }
          if (character.stepMotherName != null && !character.isStepMotherDeceased && !isAlreadyPartner(character.stepMotherName!)) {
            candidates.add({
              'relation': 'Ibu Tiri',
              'name': 'Ibu Tiri (${character.stepMotherName})',
              'gender': 'Perempuan',
              'age': character.stepMotherAge ?? 40,
              'role': 'Tiri',
              'chance': 25,
            });
          }
        }
      } else {
        // Perempuan
        if (custody == 'Ibu') {
          // Perempuan ikut Ibu
          if (character.motherName != null && !character.isMotherDeceased && !isAlreadyPartner(character.motherName!)) {
            candidates.add({
              'relation': 'Ibu',
              'name': 'Ibu (${character.motherName})',
              'gender': 'Perempuan',
              'age': character.motherAge ?? 40,
              'role': 'Kandung',
              'chance': 10,
            });
          }
          if (character.fatherName != null && !character.isFatherDeceased && !isAlreadyPartner(character.fatherName!)) {
            candidates.add({
              'relation': 'Ayah',
              'name': 'Ayah (${character.fatherName})',
              'gender': 'Laki-laki',
              'age': character.fatherAge ?? 40,
              'role': 'Kandung',
              'chance': 25,
            });
          }
          if (character.stepFatherName != null && !character.isStepFatherDeceased && !isAlreadyPartner(character.stepFatherName!)) {
            candidates.add({
              'relation': 'Ayah Tiri',
              'name': 'Ayah Tiri (${character.stepFatherName})',
              'gender': 'Laki-laki',
              'age': character.stepFatherAge ?? 40,
              'role': 'Tiri',
              'chance': 40,
            });
          }
        } else if (custody == 'Ayah') {
          // Perempuan ikut Ayah (4th rule in prompt, mapping user perempuan and custody Ayah)
          if (character.motherName != null && !character.isMotherDeceased && !isAlreadyPartner(character.motherName!)) {
            candidates.add({
              'relation': 'Ibu',
              'name': 'Ibu (${character.motherName})',
              'gender': 'Perempuan',
              'age': character.motherAge ?? 40,
              'role': 'Kandung',
              'chance': 10,
            });
          }
          if (character.fatherName != null && !character.isFatherDeceased && !isAlreadyPartner(character.fatherName!)) {
            candidates.add({
              'relation': 'Ayah',
              'name': 'Ayah (${character.fatherName})',
              'gender': 'Laki-laki',
              'age': character.fatherAge ?? 40,
              'role': 'Kandung',
              'chance': 60,
            });
          }
          if (character.stepMotherName != null && !character.isStepMotherDeceased && !isAlreadyPartner(character.stepMotherName!)) {
            candidates.add({
              'relation': 'Ibu Tiri',
              'name': 'Ibu Tiri (${character.stepMotherName})',
              'gender': 'Perempuan',
              'age': character.stepMotherAge ?? 40,
              'role': 'Tiri',
              'chance': 5,
            });
          }
        }
      }
    } else {
      // 2.2. Status orang tuanya masih lengkap
      if (myGenderLower == 'perempuan') {
        if (character.motherName != null && !character.isMotherDeceased && !isAlreadyPartner(character.motherName!)) {
          candidates.add({
            'relation': 'Ibu',
            'name': 'Ibu (${character.motherName})',
            'gender': 'Perempuan',
            'age': character.motherAge ?? 40,
            'role': 'Kandung',
            'chance': 10,
          });
        }
        if (character.fatherName != null && !character.isFatherDeceased && !isAlreadyPartner(character.fatherName!)) {
          candidates.add({
            'relation': 'Ayah',
            'name': 'Ayah (${character.fatherName})',
            'gender': 'Laki-laki',
            'age': character.fatherAge ?? 40,
            'role': 'Kandung',
            'chance': 25,
          });
        }
      } else {
        // Laki-laki
        if (character.motherName != null && !character.isMotherDeceased && !isAlreadyPartner(character.motherName!)) {
          candidates.add({
            'relation': 'Ibu',
            'name': 'Ibu (${character.motherName})',
            'gender': 'Perempuan',
            'age': character.motherAge ?? 40,
            'role': 'Kandung',
            'chance': 5,
          });
        }
        if (character.fatherName != null && !character.isFatherDeceased && !isAlreadyPartner(character.fatherName!)) {
          candidates.add({
            'relation': 'Ayah',
            'name': 'Ayah (${character.fatherName})',
            'gender': 'Laki-laki',
            'age': character.fatherAge ?? 40,
            'role': 'Kandung',
            'chance': 10,
          });
        }
      }
    }

    if (candidates.isEmpty) return;

    List<Map<String, dynamic>> eligible = [];
    for (var c in candidates) {
      if (random.nextInt(100) < c['chance']) {
        eligible.add(c);
      }
    }

    if (eligible.isNotEmpty) {
      final chosen = eligible[random.nextInt(eligible.length)];
      final String proposalType = random.nextBool() ? 'Ajak Pacaran' : 'Bercinta';
      character.activeProposal = {
        'name': chosen['name'],
        'relation': chosen['relation'],
        'type': proposalType,
        'gender': chosen['gender'],
        'age': chosen['age'].toString(),
        'role': chosen['role'],
      };
    }
  }
}
