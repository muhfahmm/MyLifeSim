import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class AvatarGenerator {
  // --- OPTIONS DATA FOR CUSTOMIZER ---
  
  static const Map<String, String> topsMale = {
    'Botak': 'noHair', // special handling: topProbability=0
    'Gimbal Pendek': 'dreads01',
    'Gimbal Medium': 'dreads02',
    'Keriting Pendek': 'frizzle',
    'Mullet': 'shaggy',
    'Keriting Biasa': 'shortCurly',
    'Flat Top': 'shortFlat',
    'Bulat Pendek': 'shortRound',
    'Gelombang Pendek': 'shortWaved',
    'Cukur Samping': 'sides',
    'Caesar': 'theCaesar',
    'Caesar Belah Samping': 'theCaesarAndSidePart',
  };

  static const Map<String, String> topsFemale = {
    'Bob': 'bob',
    'Sanggul': 'bun',
    'Kuncir Dua': 'bigHair',
    'Keriting Panjang': 'curly',
    'Curvy': 'curvy',
    'Gimbal Panjang': 'dreads',
    'Frida Kahlo': 'frida',
    'Afro': 'fro',
    'Afro Bando': 'froBand',
    'Sebahu': 'longButNotTooLong',
    'Mia Wallace': 'miaWallace',
    'Cepak Samping': 'shavedSides',
    'Lurus Panjang 1': 'straight01',
    'Lurus Panjang 2': 'straight02',
    'Lurus Belah Samping': 'straightAndStrand',
  };

  static const Map<String, String> hairColors = {
    'Hitam': '2c1b18',
    'Cokelat Tua': '4a312c',
    'Cokelat Muda': 'b58143',
    'Auburn': 'a55728',
    'Blonde': 'd6b370',
    'Blonde Terang': 'ecdcbf',
    'Merah': 'c93305',
    'Abu-abu': 'e8e1e1',
    'Pink': 'f59797',
  };

  static const Map<String, String> skinColors = {
    'Putih Pale': 'ffdbb4',
    'Putih Terang': 'edb98a',
    'Kuning Langsat': 'f8d25c',
    'Sawo Matang': 'fd9841',
    'Cokelat': 'ae5d29',
    'Cokelat Gelap': 'd08b5b',
    'Hitam': '614335',
  };

  static const Map<String, String> accessories = {
    'Tanpa Kacamata': 'blank', // special handling: accessoriesProbability=0
    'Bundar': 'round',
    'Kotak': 'prescription01',
    'Besar': 'prescription02',
  };

  static const Map<String, String> clothes = {
    'Blazer & Kemeja': 'blazerAndShirt',
    'Blazer & Sweater': 'blazerAndSweater',
    'Sweater Berkerah': 'collarAndSweater',
    'Kaos Bergambar': 'graphicShirt',
    'Hoodie': 'hoodie',
    'Overall / Baju Kodok': 'overall',
    'Kaos Polos': 'shirtCrewNeck',
    'Scoop Neck': 'shirtScoopNeck',
    'V-Neck': 'shirtVNeck',
  };

  static const Map<String, String> clotheColors = {
    'Hitam': '262e33',
    'Biru Muda': '65c9ff',
    'Biru': '5199e4',
    'Biru Tua': '25557c',
    'Abu Terang': 'e6e6e6',
    'Abu-abu': '929598',
    'Pink': 'ffafb9',
    'Merah': 'ff5c5c',
    'Putih': 'ffffff',
    'Kuning': 'ffffb1',
  };

  // Tentukan mata berdasarkan tingkat kebahagiaan
  static String getEyeType(int happiness) {
    if (happiness > 75) return 'happy';
    if (happiness < 30) return 'cry';
    return 'default';
  }

  // Tentukan mulut berdasarkan tingkat kebahagiaan
  static String getMouthType(int happiness) {
    if (happiness > 75) return 'smile';
    if (happiness < 35) return 'sad';
    return 'default';
  }

  // Tentukan alis berdasarkan tingkat kebahagiaan
  static String getEyebrowType(int happiness) {
    if (happiness > 75) return 'raisedExcited';
    if (happiness < 30) return 'angry';
    return 'default';
  }

  /// Membuat URL avatar PNG dari seed dan parameter ekspresi wajah (untuk mode acak/NPC)
  static String buildAvatarUrl({
    required String seed,
    required String eyeType,
    required String eyebrowType,
    required String mouthType,
  }) {
    final cleanSeed = Uri.encodeComponent(seed);
    return 'https://api.dicebear.com/9.x/avataaars/png?seed=$cleanSeed&eyes=$eyeType&eyebrows=$eyebrowType&mouth=$mouthType';
  }

  /// Membuat URL avatar PNG lengkap dengan parameter kustomisasi manual
  static String buildCustomAvatarUrl({
    required String topType,
    required String accessoriesType,
    required String hairColor,
    required String clotheType,
    required String clotheColor,
    required String skinColor,
    required String eyeType,
    required String eyebrowType,
    required String mouthType,
  }) {
    final topProb = topType == 'noHair' ? 0 : 100;
    final finalTopType = topType == 'noHair' ? 'shortFlat' : topType;

    final accProb = accessoriesType == 'blank' ? 0 : 100;
    final finalAccType = accessoriesType == 'blank' ? 'prescription01' : accessoriesType;

    final params = [
      'top=$finalTopType',
      'topProbability=$topProb',
      'accessories=$finalAccType',
      'accessoriesProbability=$accProb',
      'accessoriesColor=ffffff',
      'hairColor=$hairColor',
      'clothing=$clotheType',
      'clothesColor=$clotheColor',
      'skinColor=$skinColor',
      'eyes=$eyeType',
      'eyebrows=$eyebrowType',
      'mouth=$mouthType',
    ];
    return 'https://api.dicebear.com/9.x/avataaars/png?${params.join('&')}';
  }

  /// Membangun URL avatar untuk karakter tertentu berdasarkan nama dan kebahagiaan
  static String getDeterministicAvatarUrl(String name, String gender, {int happiness = 50}) {
    final seedString = '$name-$gender';
    final eye = getEyeType(happiness);
    final eyebrow = getEyebrowType(happiness);
    final mouth = getMouthType(happiness);

    return buildAvatarUrl(
      seed: seedString,
      eyeType: eye,
      eyebrowType: eyebrow,
      mouthType: mouth,
    );
  }

  /// Membangun URL avatar untuk karakter (mengutamakan parameter kustom jika ada)
  static String getCharacterAvatarUrl(Character character, {int happiness = 50}) {
    if (character.avatarTopType != null) {
      return buildCustomAvatarUrl(
        topType: character.avatarTopType!,
        accessoriesType: character.avatarAccessoriesType ?? 'blank',
        hairColor: character.avatarHairColor ?? '2c1b18',
        clotheType: character.avatarClotheType ?? 'blazerAndShirt',
        clotheColor: character.avatarClotheColor ?? '262e33',
        skinColor: character.avatarSkinColor ?? 'ffdbb4',
        eyeType: getEyeType(happiness),
        eyebrowType: getEyebrowType(happiness),
        mouthType: getMouthType(happiness),
      );
    }
    return getDeterministicAvatarUrl(character.name, character.gender, happiness: happiness);
  }

  /// Membuat parameter kustomisasi acak untuk pemain
  static Map<String, String> generateRandomAvatar(String gender, {String? seedName}) {
    final isMale = gender.trim().toLowerCase() == 'laki-laki' || gender.trim().toLowerCase() == 'male';
    final topMap = isMale ? topsMale : topsFemale;
    
    // Seed generator agar hasil selalu konsisten untuk nama yang sama
    final seed = seedName != null ? seedName.hashCode : null;
    final random = seed != null ? Random(seed) : Random();

    final topVal = topMap.values.elementAt(random.nextInt(topMap.length));
    final hairVal = hairColors.values.elementAt(random.nextInt(hairColors.length));
    final skinVal = skinColors.values.elementAt(random.nextInt(skinColors.length));
    final accVal = accessories.values.elementAt(random.nextInt(accessories.length));
    final clotheVal = clothes.values.elementAt(random.nextInt(clothes.length));
    final clotheColVal = clotheColors.values.elementAt(random.nextInt(clotheColors.length));

    return {
      'topType': topVal,
      'accessoriesType': accVal,
      'hairColor': hairVal,
      'clotheType': clotheVal,
      'clotheColor': clotheColVal,
      'skinColor': skinVal,
    };
  }
}

class AvatarImageCache {
  static final Map<String, ImageProvider> _cache = {};

  static ImageProvider getImageProvider(String url) {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }
    final provider = NetworkImage(url);
    _cache[url] = provider;
    return provider;
  }
}
