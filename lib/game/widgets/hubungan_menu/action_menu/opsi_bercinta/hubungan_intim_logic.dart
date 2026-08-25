// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart
import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_resolver.dart';

class HubunganIntimLogic {
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
  /// Mengembalikan Map yang berisi 'isWilling' (bool) dan 'rejectReason' (String)
  static Map<String, dynamic> checkInitialWillingness({
    required String myGender,
    required String partnerGender,
    required int satisfaction,
    required Random random,
  }) {
    final bool isHetero = myGender != partnerGender;
    bool isWilling = true;
    String rejectReason = '';

    if (isHetero) {
      final int roll = random.nextInt(100);
      if (satisfaction >= 60) {
        if (roll < 70) {
          isWilling = true;
        } else {
          isWilling = false;
          rejectReason = 'sedang tidak dalam mood yang baik meskipun hubungan kalian cukup dekat ($satisfaction%).';
        }
      } else if (satisfaction >= 50) {
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
    // Jika sudah menjadi pacar → 80% penerimaan
    if (isAlreadyPartner) {
      return random.nextInt(100) < 80;
    }
    
    // Gunakan logika penentu dari folder ajakan_makelove
    return AjakanResolver.checkMakeLove(character, targetName, targetRole, random);
  }
}
