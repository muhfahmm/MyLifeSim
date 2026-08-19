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
      // Tambahkan kacamata jika belum memakai kacamata (misal kacamata baca)
      if (accessories == 'blank') {
        accessories = 'prescription01';
      }
    } else if (age <= 70) {
      // --- Usia 60-70 (Terlihat Tua / Lansia) ---
      hairColor = 'e8e1e1'; // Mulai beruban (warna silver/abu-abu)
      if (accessories == 'blank') {
        accessories = 'prescription02';
      }
      mouthType = 'concerned'; // Ekspresi berkerut
    } else {
      // --- Usia 71-80+ (Terlihat Sangat Tua) ---
      hairColor = 'e8e1e1'; // Rambut beruban total
      top = isMale ? 'sides' : 'bun'; // Botak atas (sides) atau sanggul nenek
      if (accessories == 'blank') {
        accessories = 'prescription02';
      }
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
  }) {
    final dummy = Character(
      name: name,
      gender: gender,
      location: 'Indonesia',
      age: age,
      happiness: happiness,
    );
    return getAgeBasedAvatarUrl(dummy, happiness: happiness);
  }
}
