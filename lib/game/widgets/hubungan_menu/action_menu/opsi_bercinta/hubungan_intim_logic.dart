// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_resolver.dart';

class HubunganIntimLogic {
  /// Mengambil tingkat kepuasan / hubungan saat ini dengan target
  static int getRelationshipValue(Character character, String targetName) {
    if (character.partner != null && character.partner!['name'] == targetName) {
      return int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
    }
    if (character.secondPartner != null && character.secondPartner!['name'] == targetName) {
      return int.tryParse(character.secondPartner!['relationship'] ?? '50') ?? 50;
    }
    if (character.thirdPartner != null && character.thirdPartner!['name'] == targetName) {
      return int.tryParse(character.thirdPartner!['relationship'] ?? '50') ?? 50;
    }
    if (character.fourthPartner != null && character.fourthPartner!['name'] == targetName) {
      return int.tryParse(character.fourthPartner!['relationship'] ?? '50') ?? 50;
    }
    if (character.fifthPartner != null && character.fifthPartner!['name'] == targetName) {
      return int.tryParse(character.fifthPartner!['relationship'] ?? '50') ?? 50;
    }
    for (var sib in character.siblings) {
      if (sib['name'] == targetName || '${sib['name']} (${sib['relation']})' == targetName) {
        return int.tryParse(sib['relationship'] ?? '50') ?? 50;
      }
    }
    for (var ext in character.extendedFamily) {
      if (ext['name'] == targetName) {
        return int.tryParse(ext['relationship'] ?? '50') ?? 50;
      }
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
    // Jika tingkat hubungan 60% ke atas, otomatis mau!
    if (satisfaction >= 60) {
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
        if (roll < 50) {
          isWilling = true;
        } else {
          isWilling = false;
          rejectReason = 'merasa hubungan kalian kurang hangat untuk melakukan itu ($satisfaction%).';
        }
      } else {
        isWilling = false;
        rejectReason = 'menolak mentah-mentah karena tingkat kepuasan hubungannya terlalu rendah ($satisfaction%).';
      }
    } else {
      if (satisfaction <= 40) {
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
    
    // Jika tingkat hubungan > 60%, otomatis mau (100% penerimaan)!
    if (satisfaction > 60 || (satisfaction >= 60)) {
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
