// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/risiko_masturbasi.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class RisikoMasturbasi {
  // Probabilitas ketahuan (dalam persen) berdasarkan lokasi
  static int getCatchChance(String location) {
    switch (location) {
      case 'Di Rumah':
        return 10;
      case 'Di Mobil':
        return 25;
      case 'Di Kantor':
        return 40;
      case 'Di Toilet Umum':
        return 15;
      default:
        return 10;
    }
  }

  // Daftar ruangan untuk lokasi yang memiliki sub-ruangan
  static List<String> getRoomsForLocation(String location, Character character) {
    if (location == 'Di Rumah') {
      return [
        'Kamar Tidur',
        'Ruang Tamu',
        'Kamar Mandi',
        'Dapur',
      ];
    } else if (location == 'Di Kantor') {
      return [
        'Ruang Kerja Pribadi',
        'Ruang Meeting',
        'Toilet Kantor',
        'Ruang Server',
        'Lift Kantor',
      ];
    } else {
      return [];
    }
  }

  // Modifikator probabilitas ketahuan berdasarkan waktu
  static int getTimeCatchModifier(String timeOfDay) {
    switch (timeOfDay) {
      case 'Pagi':
        return 0;
      case 'Siang':
        return 15;
      case 'Sore':
        return 5;
      case 'Malam':
        return -8;
      default:
        return 0;
    }
  }

  // Hitung probabilitas ketahuan secara dinamis berdasarkan seluruh parameter
  static int getDynamicCatchChance(
    String location,
    String subLocation,
    String timeOfDay,
    String targetName,
    String relation,
  ) {
    int chance = getCatchChance(location);

    // Modifikasi waktu
    chance += getTimeCatchModifier(timeOfDay);

    // Jika waktu Siang atau Sore dan tempatnya bukan Toilet Umum, risiko meningkat (anggota rumah pulang)
    if ((timeOfDay == 'Siang' || timeOfDay == 'Sore') && location != 'Di Toilet Umum') {
      chance += (timeOfDay == 'Siang') ? 15 : 10;
    }

    // Modifikasi tempat spesifik (subLocation)
    if (location == 'Di Rumah') {
      if (subLocation == 'Kamarmu Sendiri') {
        chance -= 5; // Kamar sendiri relatif lebih aman
      } else if (subLocation.startsWith('Kamar Orang Tua')) {
        chance += 15; // Kamar orang tua rawan
      } else if (subLocation.startsWith('Kamar')) {
        chance += 10; // Kamar saudara/anak lain rawan
      } else if (subLocation == 'Ruang Tamu') {
        chance += 20; // Ruang tamu sangat rawan
      } else if (subLocation == 'Dapur') {
        chance += 15;
      } else if (subLocation == 'Kamar Mandi') {
        chance -= 3; // Kamar mandi aman
      }

      // Aturan dinamis: jika membayangkan target pemilik kamar!
      final String cleanTarget = getCleanName(targetName);
      if (cleanTarget.isNotEmpty && subLocation.contains(cleanTarget)) {
        chance += 25; // Risiko bertambah besar secara signifikan (+25%)
      }
    } else if (location == 'Di Kantor') {
      if (subLocation == 'Ruang Kerja Pribadi') {
        chance -= 10;
      } else if (subLocation == 'Ruang Meeting') {
        chance += 20;
      } else if (subLocation == 'Toilet Kantor') {
        chance -= 5;
      } else if (subLocation == 'Lift Kantor') {
        chance += 30; // Sangat rawan
      }
    }

    return chance.clamp(0, 100);
  }

  // Efek tambahan jika ketahuan di lokasi tertentu
  static Map<String, dynamic> getRiskEffects(String location, Character character, String targetName, String relation) {
    final Random random = Random();
    Map<String, dynamic> effects = {
      'happinessDelta': -30,
      'healthDelta': 0,
      'intelligenceDelta': 0,
      'relationshipDelta': 0,
      'message': '',
    };

    // Cari seluruh keluarga serumah/dekat yang masih hidup
    List<Map<String, String>> familyMembers = [];
    if (character.fatherName != null && !character.isFatherDeceased) {
      familyMembers.add({'relation': 'Ayah', 'name': character.fatherName!});
    }
    if (character.motherName != null && !character.isMotherDeceased) {
      familyMembers.add({'relation': 'Ibu', 'name': character.motherName!});
    }
    if (character.stepFatherName != null && !character.isStepFatherDeceased) {
      familyMembers.add({'relation': 'Ayah Tiri', 'name': character.stepFatherName!});
    }
    if (character.stepMotherName != null && !character.isStepMotherDeceased) {
      familyMembers.add({'relation': 'Ibu Tiri', 'name': character.stepMotherName!});
    }
    for (var sib in character.siblings) {
      if (sib['isDeceased'] != 'true') {
        familyMembers.add({
          'relation': sib['relation'] ?? 'Saudara',
          'name': sib['name'] ?? '',
        });
      }
    }
    for (var child in character.children) {
      if (child['isDeceased'] != 'true') {
        familyMembers.add({
          'relation': child['gender'] == 'Laki-laki' ? 'Anak Laki-laki' : 'Anak Perempuan',
          'name': child['name'] ?? '',
        });
      }
    }

    String relationType = 'Lainnya';
    String realName = '';
    Map<String, String>? memberMap;

    String viewer = 'Seseorang';
    if (familyMembers.isNotEmpty) {
      final member = familyMembers[random.nextInt(familyMembers.length)];
      final relationStr = member['relation']!;
      final nameStr = member['name']!;
      viewer = '$relationStr bernama $nameStr';
      relationType = relationStr;
      realName = nameStr;

      for (var sib in character.siblings) {
        if (sib['name'] == nameStr) {
          memberMap = sib;
          break;
        }
      }
      if (memberMap == null) {
        for (var child in character.children) {
          if (child['name'] == nameStr) {
            memberMap = child;
            break;
          }
        }
      }
    } else {
      final bool pickFather = random.nextBool();
      viewer = pickFather ? 'Ayah' : 'Ibu';
      relationType = pickFather ? 'Ayah' : 'Ibu';
      realName = pickFather ? (character.fatherName ?? '') : (character.motherName ?? '');
    }

    effects['viewerRelation'] = relationType;
    effects['viewerName'] = realName;
    effects['viewerMap'] = memberMap;

    // Pesan spesifik berdasarkan lokasi
    switch (location) {
      case 'Di Rumah':
        effects['message'] = '😱 KETAHUAN! Saat sedang asyik bermasturbasi di ruangan, $viewer tiba-tiba membuka pintu! Kamu sangat malu (-30% Kebahagiaan).';
        if (_isFamily(targetName, relation)) {
          effects['message'] = '😱 TRAGEDI MEMALUKAN! Saat membayangkan $targetName, $viewer memergokimu! Kecanggungan luar biasa (-30% Kebahagiaan).';
        }
        break;
      case 'Di Mobil':
        effects['message'] = '🚗 KETAHUAN! Seseorang mengetuk kaca mobil dan melihatmu! Kamu panik dan malu (-30% Kebahagiaan).';
        break;
      case 'Di Kantor':
        effects['message'] = '🏢 KETAHUAN! Rekan kerja atau atasan memergokimu di ruangan! Kamu bisa dipecat atau dipermalukan (-30% Kebahagiaan).';
        // Jika ketahuan di kantor, tambahkan penalti spesial
        effects['intelligenceDelta'] = -10; // kehilangan fokus
        effects['relationshipDelta'] = -10; // hubungan dengan rekan kerja menurun
        break;
      case 'Di Toilet Umum':
        effects['message'] = '🚽 KETAHUAN! Seseorang masuk ke toilet dan mendengar suaramu! Kamu sangat malu (-30% Kebahagiaan).';
        break;
      default:
        effects['message'] = '😱 KETAHUAN!';
    }

    // Jika fantasi keluarga, tambahkan efek kesehatan negatif
    if (_isFamily(targetName, relation)) {
      effects['healthDelta'] = -10;
      effects['message'] += ' Rasa bersalah dan trauma menurunkan kesehatanmu.';
    }

    return effects;
  }

  // Helper untuk mengecek apakah target keluarga
  static bool _isFamily(String name, String relation) {
    final String r = relation.toLowerCase();
    final String n = name.toLowerCase();
    return r == 'kandung' ||
        r == 'tiri' ||
        r.contains('saudara') ||
        n.contains('kakak') ||
        n.contains('adik') ||
        n.startsWith('ayah') ||
        n.startsWith('ibu');
  }

  // Helper untuk mendapatkan nama bersih tanpa prefix/suffix relation
  static String getCleanName(String targetName) {
    String name = targetName;
    
    // 1. Bersihkan prefix "Ayah (" atau "Ibu ("
    if (name.startsWith('Ayah (')) {
      name = name.replaceAll('Ayah (', '').replaceAll(')', '');
    } else if (name.startsWith('Ibu (')) {
      name = name.replaceAll('Ibu (', '').replaceAll(')', '');
    }
    
    // 2. Bersihkan suffix tanda kurung relasi (misal: " (Adik Laki-laki)")
    final int parenIndex = name.indexOf(' (');
    if (parenIndex != -1) {
      name = name.substring(0, parenIndex);
    }
    
    return name.trim();
  }
}