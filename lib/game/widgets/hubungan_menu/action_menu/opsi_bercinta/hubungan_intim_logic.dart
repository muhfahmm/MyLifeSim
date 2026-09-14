// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_resolver.dart';

class HubunganIntimLogic {
  /// Mengambil tingkat kepuasan / hubungan saat ini dengan target
  static int getRelationshipValue(Character character, String targetName) {
    if (targetName.trim().isEmpty) return 50;

    // Bersihkan targetName dari format "Nama (Relasi)"
    String rawName = targetName;
    final int parenIdx = targetName.indexOf('(');
    if (parenIdx != -1) {
      rawName = targetName.substring(0, parenIdx).trim();
    }
    rawName = rawName.trim();
    final String lowerRaw = rawName.toLowerCase();
    final String lowerFull = targetName.trim().toLowerCase();

    bool isMatch(String? nameInChar) {
      if (nameInChar == null || nameInChar.trim().isEmpty) return false;
      final String cn = nameInChar.trim().toLowerCase();
      return lowerRaw == cn || lowerFull == cn || lowerRaw.contains(cn) || cn.contains(lowerRaw);
    }

    int parseRel(dynamic val) {
      if (val == null) return 50;
      return int.tryParse(val.toString()) ?? 50;
    }

    // 1. Orang Tua Kandung & Tiri & Mertua
    if (isMatch(character.fatherName)) return character.fatherRelationship ?? 50;
    if (isMatch(character.motherName)) return character.motherRelationship ?? 50;
    if (isMatch(character.stepFatherName)) return character.stepFatherRelationship ?? 50;
    if (isMatch(character.stepMotherName)) return character.stepMotherRelationship ?? 50;
    if (isMatch(character.fatherInLawName)) return character.fatherInLawRelationship ?? 50;
    if (isMatch(character.motherInLawName)) return character.motherInLawRelationship ?? 50;

    // 2. Pasangan & Selingkuhan
    for (var p in [
      character.partner,
      character.secondPartner,
      character.thirdPartner,
      character.fourthPartner,
      character.fifthPartner,
    ]) {
      if (p != null && (isMatch(p['name']) || (p['name'] ?? '').toLowerCase() == lowerFull)) {
        return parseRel(p['relationship']);
      }
    }

    // Helper untuk list of map
    int? checkList(List<Map<String, String>> list) {
      for (var item in list) {
        final String itemName = (item['name'] ?? '').trim();
        final String itemRelLabel = '$itemName (${item['relation']})'.trim();
        if (isMatch(itemName) || isMatch(itemRelLabel) || itemName.toLowerCase() == lowerFull || itemRelLabel.toLowerCase() == lowerFull) {
          return parseRel(item['relationship']);
        }
      }
      return null;
    }

    // 3. Children, Siblings, Extended Family, Friends, Classmates, Coworkers, etc.
    final int? childRel = checkList(character.children);
    if (childRel != null) return childRel;

    final int? sibRel = checkList(character.siblings);
    if (sibRel != null) return sibRel;

    final int? extRel = checkList(character.extendedFamily);
    if (extRel != null) return extRel;

    final int? friendRel = checkList(character.friends);
    if (friendRel != null) return friendRel;

    final int? cmRel = checkList(character.classmates);
    if (cmRel != null) return cmRel;

    final int? ucmRel = checkList(character.univClassmates);
    if (ucmRel != null) return ucmRel;

    final int? cwRel = checkList(character.coworkers);
    if (cwRel != null) return cwRel;

    final int? secRel = checkList(character.secretPartners);
    if (secRel != null) return secRel;

    final int? donRel = checkList(character.donorRecipients);
    if (donRel != null) return donRel;

    final int? sdtRel = checkList(character.sdTeachers);
    if (sdtRel != null) return sdtRel;

    final int? smptRel = checkList(character.smpTeachers);
    if (smptRel != null) return smptRel;

    final int? smatRel = checkList(character.smaTeachers);
    if (smatRel != null) return smatRel;

    final int? lectRel = checkList(character.univLecturers);
    if (lectRel != null) return lectRel;

    if (character.supervisor != null && isMatch(character.supervisor!['name'])) {
      return parseRel(character.supervisor!['relationship']);
    }

    return 50;
  }

  /// Mengambil jenis kelamin pasangan/target berdasarkan nama
  static String getPartnerGender(String targetName) {
    if (targetName.startsWith('Ayah')) return 'Laki-laki';
    if (targetName.startsWith('Ibu')) return 'Perempuan';

    final int startIndex = targetName.indexOf('(');
    final int endIndex = targetName.indexOf(')');
    if (startIndex != -1 && endIndex != -1) {
      final String relationText = targetName.substring(startIndex + 1, endIndex).toLowerCase();
      if (relationText.contains('perempuan')) return 'Perempuan';
      if (relationText.contains('laki-laki')) return 'Laki-laki';
    }
    return 'Laki-laki';
  }

  /// Menghitung tingkat kesuburan (fertility rate) dinamis berdasarkan usia dan jenis kelamin
  static double getFertilityRate(int age, String gender) {
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan') {
      if (age < 8 || age > 45) return 0.0;
      if (age >= 8 && age <= 13) return 0.35;
      if (age >= 14 && age <= 19) return 0.55;
      if (age >= 20 && age <= 29) return 0.85;
      if (age >= 30 && age <= 39) return 0.65;
      if (age >= 40 && age <= 45) return 0.30;
    } else { // laki-laki
      if (age < 9 || age > 65) return 0.0;
      if (age >= 9 && age <= 13) return 0.35;
      if (age >= 14 && age <= 19) return 0.55;
      if (age >= 20 && age <= 29) return 0.85;
      if (age >= 30 && age <= 39) return 0.75;
      if (age >= 40 && age <= 49) return 0.55;
      if (age >= 50 && age <= 65) return 0.35;
    }
    return 0.0;
  }

  /// Memeriksa kesediaan awal (willingness) berdasarkan status kepuasan hubungan (satisfaction)
  /// Jika hubungan > 60%, NPC otomatis mau dan tidak boleh menolak.
  static Map<String, dynamic> checkInitialWillingness({
    required String myGender,
    required String partnerGender,
    required int satisfaction,
    required Random random,
  }) {
    // Jika tingkat hubungan 50% ke atas, otomatis mau! (Sama seperti bercinta/makelove)
    if (satisfaction >= 50) {
      return {
        'isWilling': true,
        'rejectReason': '',
      };
    }

    final bool isHetero = myGender != partnerGender;
    bool isWilling = true;
    String rejectReason = '';

    if (isHetero) {
      final int roll = random.nextInt(100);
      if (satisfaction >= 50) {
        if (roll < 60) { // 60% peluang mau
          isWilling = true;
        } else {
          isWilling = false;
          rejectReason = 'merasa hubungan kalian kurang hangat untuk melakukan itu ($satisfaction%).';
        }
      } else {
        if (roll < 60) { // 60% peluang mau
          isWilling = true;
        } else {
          isWilling = false;
          rejectReason = 'menolak mentah-mentah karena tingkat kepuasan hubungannya terlalu rendah ($satisfaction%).';
        }
      }
    } else {
      final int roll = random.nextInt(100);
      if (satisfaction <= 40 && roll >= 60) {
        isWilling = false;
        rejectReason = 'menolak ajakanmu untuk berhubungan intim karena tingkat kepuasan hubungannya saat ini terlalu rendah ($satisfaction%).';
      } else {
        isWilling = true;
      }
    }

    return {
      'isWilling': isWilling,
      'rejectReason': rejectReason,
    };
  }

  /// Menghitung keberhasilan aksi berhubungan seksual berdasarkan relasi keluarga / tipe hubungan
  /// Jika hubungan > 60%, NPC otomatis mau dan tidak boleh menolak.
  static bool calculateMakeLoveSuccess({
    required Character character,
    required String myGender,
    required String partnerGender,
    required String targetName,
    required String targetRole,
    required int partnerBonus,
    required Random random,
    int? playerAge,
    String? custodyParent,
    bool isAlreadyPartner = false,
  }) {
    final int satisfaction = getRelationshipValue(character, targetName);
    
    // Jika tingkat hubungan >= 50%, otomatis mau (100% penerimaan)!
    if (satisfaction >= 50) {
      return true;
    }

    // Jika sudah menjadi pacar → 80% penerimaan
    if (isAlreadyPartner) {
      return random.nextInt(100) < 80;
    }
    
    // Gunakan logika penentu dari folder ajakan_makelove
    return AjakanResolver.checkMakeLove(character, targetName, targetRole, random);
  }
}
