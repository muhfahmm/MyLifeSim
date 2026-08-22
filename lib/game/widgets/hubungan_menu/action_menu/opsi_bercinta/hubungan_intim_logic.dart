// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart
import 'dart:math';

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
    final String targetNameLower = targetName.toLowerCase();
    final String targetRoleLower = targetRole.toLowerCase();
    final bool isChild = targetRole == 'Laki-laki' || targetRole == 'Perempuan';

    // Cek kondisi khusus incest adik/kakak lawan jenis sejak usia 7 tahun
    final bool isSibling = targetRoleLower.contains('saudara') || 
                           targetRoleLower.contains('kandung') || 
                           targetNameLower.contains('kakak') || 
                           targetNameLower.contains('adik');
    final String cleanMyGender = myGender.trim().toLowerCase();
    final String cleanPartnerGender = partnerGender.trim().toLowerCase();
    final bool isOppositeGender = (cleanMyGender == 'laki-laki' && cleanPartnerGender == 'perempuan') ||
                                  (cleanMyGender == 'perempuan' && cleanPartnerGender == 'laki-laki');

    if (playerAge != null && playerAge >= 7 && isSibling && isOppositeGender) {
      // Logika khusus: player perempuan mengajak kakak/adik laki-laki
      if (cleanMyGender == 'perempuan' && cleanPartnerGender == 'laki-laki') {
        if (targetNameLower.contains('kakak')) {
          return random.nextInt(100) < 60; // kakak laki-laki: 60%
        } else if (targetNameLower.contains('adik')) {
          return random.nextInt(100) < 55; // adik laki-laki: 55%
        }
      }
      // Logika lama (player laki-laki mengajak kakak/adik perempuan)
      if (cleanMyGender == 'laki-laki' && cleanPartnerGender == 'perempuan') {
        if (targetNameLower.contains('adik')) {
          return random.nextInt(100) < 40;
        } else if (targetNameLower.contains('kakak')) {
          return random.nextInt(100) < 10;
        }
      }
    }

    bool success = false;

    // 1. Logika Orang Tua Mengajak Anak Kandung/Tiri
    if (isChild) {
      if (myGender == 'laki-laki') {
        if (partnerGender == 'laki-laki') {
          success = random.nextInt(100) < (20 + partnerBonus);
        } else {
          success = random.nextInt(100) < (35 + partnerBonus);
        }
      } else {
        if (partnerGender == 'laki-laki') {
          success = random.nextInt(100) < (20 + partnerBonus);
        } else {
          success = random.nextInt(100) < (20 + partnerBonus);
        }
      }
    } 
    // 2. Logika Anak Mengajak Orang Tua
    else if (targetNameLower.startsWith('ayah') || targetNameLower.contains('ayah')) {
      if (custodyParent == 'Ayah' && cleanMyGender == 'perempuan') {
        success = random.nextInt(100) < (70 + partnerBonus);
      } else if (myGender == 'laki-laki') {
        success = random.nextInt(100) < (10 + partnerBonus);
      } else {
        success = random.nextInt(100) < (30 + partnerBonus);
      }
    } else if (targetNameLower.startsWith('ibu') || targetNameLower.contains('ibu')) {
      if (custodyParent == 'Ibu' && cleanMyGender == 'laki-laki') {
        success = random.nextInt(100) < (70 + partnerBonus);
      } else if (myGender == 'laki-laki') {
        success = random.nextInt(100) < (10 + partnerBonus);
      } else {
        success = random.nextInt(100) < (30 + partnerBonus);
      }
    } else if (targetNameLower.contains('paman')) {
      if (cleanMyGender == 'perempuan') {
        success = random.nextInt(100) < (30 + partnerBonus);
      } else {
        success = random.nextInt(100) < (10 + partnerBonus);
      }
    } else if (targetNameLower.contains('bibi')) {
      if (cleanMyGender == 'perempuan') {
        success = random.nextInt(100) < (10 + partnerBonus);
      } else {
        success = random.nextInt(100) < (30 + partnerBonus);
      }
    } else if (targetNameLower.contains('sepupu')) {
      success = random.nextInt(100) < (40 + partnerBonus);
    } else if (targetNameLower.contains('kakek')) {
      if (cleanMyGender == 'perempuan') {
        success = random.nextInt(100) < (15 + partnerBonus);
      } else {
        success = random.nextInt(100) < (5 + partnerBonus);
      }
    } else if (targetNameLower.contains('nenek')) {
      if (cleanMyGender == 'perempuan') {
        success = random.nextInt(100) < (5 + partnerBonus);
      } else {
        success = random.nextInt(100) < (15 + partnerBonus);
      }
    } else if (targetNameLower.contains('mertua')) {
      if (targetNameLower.contains('ayah')) {
        success = cleanMyGender == 'perempuan' ? random.nextInt(100) < (30 + partnerBonus) : random.nextInt(100) < (10 + partnerBonus);
      } else {
        success = cleanMyGender == 'perempuan' ? random.nextInt(100) < (10 + partnerBonus) : random.nextInt(100) < (30 + partnerBonus);
      }
    } else if (targetNameLower.contains('keponakan')) {
      success = random.nextInt(100) < (35 + partnerBonus);
    } else if (targetRole.toLowerCase().contains('laki-laki') || targetRole.toLowerCase().contains('perempuan') || targetRole.toLowerCase().contains('anak')) {
      // Anak Kandung / Anak Tiri
      if (cleanMyGender == 'perempuan') {
        success = cleanPartnerGender == 'laki-laki' ? random.nextInt(100) < (25 + partnerBonus) : random.nextInt(100) < (5 + partnerBonus);
      } else {
        success = cleanPartnerGender == 'perempuan' ? random.nextInt(100) < (25 + partnerBonus) : random.nextInt(100) < (5 + partnerBonus);
      }
    }
    // 3. Logika Saudara Kandung / Kakak/Adik
    else if (isSibling) {
      if (myGender == 'perempuan' && partnerGender == 'perempuan') {
        success = random.nextInt(100) < (20 + partnerBonus);
      } else if (myGender == 'laki-laki' && partnerGender == 'laki-laki') {
        success = random.nextInt(100) < (10 + partnerBonus);
      } else if (myGender == 'laki-laki' && partnerGender == 'perempuan') {
        success = random.nextInt(100) < (30 + partnerBonus);
      } else if (myGender == 'perempuan' && partnerGender == 'laki-laki') {
        success = random.nextInt(100) < (30 + partnerBonus);
      } else {
        success = random.nextInt(100) < 30;
      }
    }
    // 4. Hubungan Normal / Bukan Incest
    else {
      // Menolak jika kepuasan hubungan kurang dari 40%
      if (partnerBonus < 0) {
        success = false;
      } else {
        // Peluang normal
        success = random.nextInt(100) < (50 + partnerBonus);
      }
    }

    return success;
  }
}
