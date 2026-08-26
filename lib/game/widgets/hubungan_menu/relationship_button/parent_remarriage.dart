import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/skin_color_inheritance.dart';

class ParentRemarriage {
  static void checkAndApplyRemarriage(Character character, Random random, List<String> events) {
    // Case 1: Ibu kandung hidup, tetapi tidak ada ayah kandung (atau wafat/cerai) dan belum punya ayah tiri
    if (character.motherName != null && !character.isMotherDeceased && character.stepFatherName == null) {
      bool shouldRemarry = false;
      
      if (character.isMotherDivorced) {
        // jika cerai ibu menikah lagi 40%
        if (random.nextInt(100) < 40) {
          shouldRemarry = true;
        }
      } else if (character.fatherName == null || character.isFatherDeceased) {
        // jika suami meninggal ibu menikah lagi 40%
        if (random.nextInt(100) < 40) {
          shouldRemarry = true;
        }
      }

      if (shouldRemarry) {
        final List<String> boys = (character.maleFirstNames != null && character.maleFirstNames!.isNotEmpty) 
            ? character.maleFirstNames! 
            : ['Fajar', 'Aditya', 'Budi', 'Rafi', 'Daffa', 'Gibran'];
        final List<String> familyNames = (character.lastNames != null && character.lastNames!.isNotEmpty) 
            ? character.lastNames! 
            : ['Pratama', 'Saputra', 'Wijaya', 'Kusuma', 'Sari', 'Utami'];
        
        character.stepFatherName = '${boys[random.nextInt(boys.length)]} ${familyNames[random.nextInt(familyNames.length)]}';
        character.stepFatherAge = (character.motherAge ?? 40) + random.nextInt(5) - 2;
        character.stepFatherRelationship = 50;
        character.isStepFatherDeceased = false;
        character.stepFatherSkinColor = SkinColorInheritance.randomSkin();
        
        final String notice = '💍 Kabar Keluarga: Ibumu menikah lagi! Sekarang kamu memiliki Ayah Tiri bernama ${character.stepFatherName}.';
        events.add(notice);
        character.inbox.add(notice);
      }
    }

    if (character.fatherName != null && !character.isFatherDeceased && character.stepMotherName == null) {
      bool shouldRemarry = false;
      final bool isFemaleUserWithFather = character.gender.toLowerCase() == 'perempuan' && character.custodyParent == 'Ayah';

      if (character.isFatherDivorced) {
        // jika cerai ayah menikah lagi 30%, jika perempuan ikut ayah cuma 10%
        final int limit = isFemaleUserWithFather ? 10 : 30;
        if (random.nextInt(100) < limit) {
          shouldRemarry = true;
        }
      } else if (character.motherName == null || character.isMotherDeceased) {
        // jika istri meninggal ayah menikah lagi 40%, jika perempuan ikut ayah cuma 10%
        final int limit = isFemaleUserWithFather ? 10 : 40;
        if (random.nextInt(100) < limit) {
          shouldRemarry = true;
        }
      }

      if (shouldRemarry) {
        final List<String> girls = (character.femaleFirstNames != null && character.femaleFirstNames!.isNotEmpty) 
            ? character.femaleFirstNames! 
            : ['Dian', 'Lestari', 'Nadia', 'Sania', 'Zahra', 'Aura'];
        final List<String> familyNames = (character.lastNames != null && character.lastNames!.isNotEmpty) 
            ? character.lastNames! 
            : ['Pratama', 'Saputra', 'Wijaya', 'Kusuma', 'Sari', 'Utami'];
        
        character.stepMotherName = '${girls[random.nextInt(girls.length)]} ${familyNames[random.nextInt(familyNames.length)]}';
        character.stepMotherAge = (character.fatherAge ?? 40) + random.nextInt(5) - 2;
        character.stepMotherRelationship = 50;
        character.isStepMotherDeceased = false;
        character.stepMotherSkinColor = SkinColorInheritance.randomSkin();

        final String notice = '💍 Kabar Keluarga: Ayahmu menikah lagi! Sekarang kamu memiliki Ibu Tiri bernama ${character.stepMotherName}.';
        events.add(notice);
        character.inbox.add(notice);
      }
    }
  }
}
