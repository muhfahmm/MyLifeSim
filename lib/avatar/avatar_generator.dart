// lib/avatar/avatar_generator.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class AvatarGenerator {
  // --- OPTIONS DATA ---
  static const Map<String, String> topsMale = {
    'Botak': 'noHair',
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
    'Tanpa Kacamata': 'blank',
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

  // --- Ekspresi wajah berdasarkan happiness ---
  static String getEyeType(int happiness) {
    if (happiness > 75) return 'happy';
    if (happiness < 30) return 'cry';
    return 'default';
  }

  static String getMouthType(int happiness) {
    if (happiness > 75) return 'smile';
    if (happiness < 35) return 'sad';
    return 'default';
  }

  static String getEyebrowType(int happiness) {
    if (happiness > 75) return 'raisedExcited';
    if (happiness < 30) return 'angry';
    return 'default';
  }

  // --- URL BUILDER (SEMUA MENGGUNAKAN Uri.https) ---
  static String buildAvatarUrl({
    required String seed,
    required String eyeType,
    required String eyebrowType,
    required String mouthType,
  }) {
    final uri = Uri.https(
      'api.dicebear.com',
      '/5.x/avataaars/png',
      {
        'seed': seed,
        'eyes': eyeType,
        'eyebrows': eyebrowType,
        'mouth': mouthType,
      },
    );
    return uri.toString();
  }

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

    final uri = Uri.https(
      'api.dicebear.com',
      '/5.x/avataaars/png',
      {
        'top': finalTopType,
        'topProbability': topProb.toString(),
        'accessories': finalAccType,
        'accessoriesProbability': accProb.toString(),
        'accessoriesColor': 'ffffff',
        'hairColor': hairColor,
        'clothing': clotheType,
        'clothesColor': clotheColor,
        'skinColor': skinColor,
        'eyes': eyeType,
        'eyebrows': eyebrowType,
        'mouth': mouthType,
      },
    );
    return uri.toString();
  }

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

  static String getDeterministicAvatarUrl(String name, String gender, {int happiness = 50}) {
    final seedString = '$name-$gender';
    return buildAvatarUrl(
      seed: seedString,
      eyeType: getEyeType(happiness),
      eyebrowType: getEyebrowType(happiness),
      mouthType: getMouthType(happiness),
    );
  }

  static Map<String, String> generateRandomAvatar(String gender, {String? seedName}) {
    final isMale = gender.toLowerCase() == 'laki-laki' || gender.toLowerCase() == 'male';
    final topMap = isMale ? topsMale : topsFemale;
    final seed = seedName != null ? seedName.hashCode : null;
    final random = seed != null ? Random(seed) : Random();

    return {
      'topType': topMap.values.elementAt(random.nextInt(topMap.length)),
      'accessoriesType': 'blank',
      'hairColor': hairColors.values.elementAt(random.nextInt(hairColors.length)),
      'clotheType': clothes.values.elementAt(random.nextInt(clothes.length)),
      'clotheColor': clotheColors.values.elementAt(random.nextInt(clotheColors.length)),
      'skinColor': skinColors.values.elementAt(random.nextInt(skinColors.length)),
    };
  }

  // --- WIDGET AVATAR DENGAN LOADING INDICATOR DAN FALLBACK ---
  static Widget avatarImage({
    required String url,
    double width = 80,
    double height = 80,
    String gender = 'Perempuan',
    BoxFit fit = BoxFit.cover,
  }) {
    return ClipOval(
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          final isMale = gender.toLowerCase() == 'laki-laki' || gender.toLowerCase() == 'male';
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isMale ? Colors.blue.shade50 : Colors.pink.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isMale ? Icons.face : Icons.face_3,
              color: isMale ? Colors.blue.shade300 : Colors.pink.shade300,
              size: width * 0.65,
            ),
          );
        },
      ),
    );
  }
}

// --- CACHE UNTUK IMAGE PROVIDER (SEDERHANA) ---
class AvatarImageCache {
  static final Map<String, ImageProvider> _cache = {};

  static ImageProvider getImageProvider(String url) {
    if (!_cache.containsKey(url)) {
      _cache[url] = NetworkImage(url);
    }
    return _cache[url]!;
  }
}