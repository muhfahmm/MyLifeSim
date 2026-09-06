// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/persentase_ajakan.dart
import 'package:mylifesim/pilih_karakter/character.dart';

class PersentaseAjakan {
  /// Mendapatkan persentase keberhasilan ajakan (rayuan) saat ketahuan bermasturbasi
  /// berdasarkan hubungan keluarga dekat (incest) dan jenis kelamin.
  static int getSuccessChance({
    required Character character,
    required String relationType,
    required String viewerName,
  }) {
    final String relLower = relationType.toLowerCase();
    final bool isMalePlayer = character.gender.toLowerCase() == 'laki-laki';

    // Default persentase dasar jika tidak cocok
    int chance = 10;

    if (relLower == 'ayah' || relLower == 'ayah tiri') {
      if (isMalePlayer) {
        chance = 5;
      } else {
        int baseChance = 40;
        final int age = character.age;
        if (age == 12) baseChance = 40;
        else if (age == 13) baseChance = 45;
        else if (age == 14) baseChance = 50;
        else if (age == 15) baseChance = 55;
        else if (age == 16) baseChance = 60;
        else if (age == 17) baseChance = 65;
        else if (age >= 18) baseChance = 70;

        // Bonus/Min limit jika ikut Ayah
        if (character.custodyParent == 'Ayah' || character.custodyParent == 'Ayah Tiri') {
          if (baseChance < 65) baseChance = 65;
        }

        // Tambah 10% jika sudah menjadi pacar/partner
        final bool isPartner = character.partner != null && character.partner!['name'] == viewerName;
        if (isPartner) {
          baseChance += 10;
        }

        chance = baseChance.clamp(0, 100);
      }
    } else if (relLower == 'ibu' || relLower == 'ibu tiri') {
      chance = isMalePlayer ? 5 : 15;
    } else if (relLower.contains('kakak') && relLower.contains('laki')) {
      chance = isMalePlayer ? 10 : 25;
    } else if (relLower.contains('kakak') && relLower.contains('perempuan')) {
      chance = isMalePlayer ? 30 : 20;
    } else if (relLower.contains('adik') && relLower.contains('laki')) {
      chance = isMalePlayer ? 25 : 40;
    } else if (relLower.contains('adik') && relLower.contains('perempuan')) {
      chance = isMalePlayer ? 45 : 35;
    }

    return chance;
  }
}
