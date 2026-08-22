import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/avatar/avatar_generator.dart';

class AvatarAgeRules {
  /// Mendapatkan URL avatar PNG yang disesuaikan secara dinamis berdasarkan usia karakter
  static String getAgeBasedAvatarUrl(Character character, {int happiness = 50}) {
    final age = character.age;
    final gender = character.gender;
    final isMale = gender.toLowerCase() == 'laki-laki' || gender.toLowerCase() == 'male';

    // 1. Dapatkan parameter dasar (kustom atau acak berdasarkan nama & gender)
    String baseTop = character.avatarTopType ?? '';
    String baseAcc = character.avatarAccessoriesType ?? 'blank';
    String baseHairColor = character.avatarHairColor ?? '2c1b18';
    String baseClothe = character.avatarClotheType ?? 'blazerAndShirt';
    String baseClotheColor = character.avatarClotheColor ?? '262e33';
    String baseSkinColor = character.avatarSkinColor ?? 'ffdbb4';

    // Jika karakter NPC/keluarga yang tidak memiliki avatar kustom, buat secara acak berdasarkan seed namanya
    if (baseTop.isEmpty) {
      final seedMap = AvatarGenerator.generateRandomAvatar(gender, seedName: character.name);
      baseTop = seedMap['topType'] ?? 'shortFlat';
      baseAcc = seedMap['accessoriesType'] ?? 'blank';
      baseHairColor = seedMap['hairColor'] ?? '2c1b18';
      baseClothe = seedMap['clotheType'] ?? 'blazerAndShirt';
      baseClotheColor = seedMap['clotheColor'] ?? '262e33';
      baseSkinColor = seedMap['skinColor'] ?? 'ffdbb4';
    }

    // 2. Terapkan logika umur
    String top = baseTop;
    String accessories = baseAcc;
    String hairColor = baseHairColor;
    String clothing = baseClothe;
    String clothingColor = baseClotheColor;
    String skinColor = baseSkinColor;
    String eyeType = AvatarGenerator.getEyeType(happiness);
    String eyebrowType = AvatarGenerator.getEyebrowType(happiness);
    String mouthType = AvatarGenerator.getMouthType(happiness);

    if (age <= 3) {
      // --- Usia 0-3 (Bayi) ---
      top = 'noHair'; // Botak / rambut tipis sekali
      accessories = 'blank';
      clothing = 'shirtCrewNeck';
      clothingColor = '65c9ff'; // Biru muda cerah khas bayi
      mouthType = 'eating'; // Renders pacifier/dot di DiceBear
      eyeType = 'happy';
    } else if (age <= 6) {
      // --- Usia 4-6 (Balita / Anak Kecil) ---
      top = isMale ? 'shortRound' : 'bob';
      accessories = 'blank';
      clothing = 'graphicShirt';
      clothingColor = 'ffafb9'; // Warna cerah anak-anak
      mouthType = 'smile';
    } else if (age <= 12) {
      // --- Usia 7-12 (Anak-anak sekolah dasar) ---
      top = isMale ? 'theCaesar' : 'straight01';
      accessories = (baseAcc != 'blank') ? 'prescription01' : 'blank';
      clothing = 'shirtCrewNeck';
      clothingColor = 'e6e6e6'; // Warna kaos biasa
    } else if (age <= 18) {
      // --- Usia 13-18 (Remaja / Teenager) ---
      top = isMale ? 'shaggy' : 'straight02';
      clothing = 'hoodie'; // Hoodie keren untuk remaja
      clothingColor = '262e33';
    } else if (age <= 39) {
      // --- Usia 19-39 (Dewasa Muda / Dewasa) ---
      // Gunakan pilihan kustom penuh
    } else if (age <= 59) {
      // --- Usia 40-59 (Paruh Baya / Middle Aged) ---
      // (Automatic override removed per request - glasses now determined by eye test)
    } else if (age <= 70) {
      // --- Usia 60-70 (Terlihat Tua / Lansia) ---
      hairColor = 'e8e1e1'; // Mulai beruban (warna silver/abu-abu)
      mouthType = 'concerned'; // Ekspresi berkerut
    } else {
      // --- Usia 71-80+ (Terlihat Sangat Tua) ---
      hairColor = 'e8e1e1'; // Rambut beruban total
      top = isMale ? 'sides' : 'bun'; // Botak atas (sides) atau sanggul nenek
      mouthType = 'sad';
    }

    return AvatarGenerator.buildCustomAvatarUrl(
      topType: top,
      accessoriesType: accessories,
      hairColor: hairColor,
      clotheType: clothing,
      clotheColor: clothingColor,
      skinColor: skinColor,
      eyeType: eyeType,
      eyebrowType: eyebrowType,
      mouthType: mouthType,
    );
  }

  /// Mendapatkan URL avatar untuk NPC/Anggota Keluarga berdasarkan nama, gender, dan usia
  static String getAgeBasedAvatarUrlForNPC({
    required String name,
    required String gender,
    required int age,
    int happiness = 50,
    String? forcedSkinColor, // override warna kulit (untuk warisan)
  }) {
    // Ekstrak nama bersih dari string seperti "Ibu (Bunga Luthfi)"
    String cleanName = name;
    if (name.contains('(') && name.contains(')')) {
      final int start = name.indexOf('(') + 1;
      final int end = name.indexOf(')');
      if (start < end) {
        cleanName = name.substring(start, end).replaceAll(' (Wafat)', '').replaceAll('(Wafat)', '').trim();
      }
    }
    cleanName = cleanName.replaceAll(' (Wafat)', '').replaceAll('(Wafat)', '').trim();

    final dummy = Character(
      name: cleanName,
      gender: gender,
      location: 'Indonesia',
      age: age,
      happiness: happiness,
      avatarSkinColor: forcedSkinColor, // pakai warna kulit yang diwariskan jika ada
    );
    return getAgeBasedAvatarUrl(dummy, happiness: happiness);
  }

  /// Mendapatkan URL avatar dengan seragam sekolah.
  /// [schoolLevel]: 'SD', 'SMP', 'SMA', 'Guru'
  static String getSchoolAvatarUrl({
    required String name,
    required String gender,
    required int age,
    required String schoolLevel,
    int happiness = 50,
    String? forcedSkinColor,
  }) {
    final isMale = gender.toLowerCase() == 'laki-laki' || gender.toLowerCase() == 'male';

    // Tentukan seragam berdasarkan level sekolah
    String clotheType;
    String clotheColor;

    switch (schoolLevel) {
      case 'SD':
        // Putih + celana/rok merah (SD Indonesia)
        clotheType = 'shirtCrewNeck';
        clotheColor = 'ffffff';
        break;
      case 'SMP':
        // Putih + biru (SMP Indonesia)
        clotheType = 'shirtCrewNeck';
        clotheColor = '5199e4';
        break;
      case 'SMA':
        // Putih + abu-abu (SMA Indonesia)
        clotheType = 'shirtCrewNeck';
        clotheColor = 'e6e6e6';
        break;
      case 'Guru':
        // Blazer formal
        clotheType = 'blazerAndShirt';
        clotheColor = '262e33';
        break;
      default:
        // Default: seragam SMP
        clotheType = 'shirtCrewNeck';
        clotheColor = '5199e4';
    }

    // Seed avatar dari nama
    final seedMap = AvatarGenerator.generateRandomAvatar(gender, seedName: name);
    final String top = isMale
        ? (age <= 12 ? 'theCaesar' : age <= 18 ? 'shaggy' : seedMap['topType']!)
        : (age <= 12 ? 'straight01' : age <= 18 ? 'straight02' : seedMap['topType']!);
    final String hairColor = seedMap['hairColor']!;
    final String skinColor = forcedSkinColor ?? seedMap['skinColor']!;
    final String eyeType = AvatarGenerator.getEyeType(happiness);
    final String eyebrowType = AvatarGenerator.getEyebrowType(happiness);
    final String mouthType = AvatarGenerator.getMouthType(happiness);

    return AvatarGenerator.buildCustomAvatarUrl(
      topType: top,
      accessoriesType: 'blank',
      hairColor: hairColor,
      clotheType: clotheType,
      clotheColor: clotheColor,
      skinColor: skinColor,
      eyeType: eyeType,
      eyebrowType: eyebrowType,
      mouthType: mouthType,
    );
  }
}
