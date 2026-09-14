// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/tempat_tinggal/tempat_tinggal_logic.dart
import 'package:mylifesim/pilih_karakter/character.dart';

class TempatTinggalLogic {
  /// Change living arrangement:
  /// - If [livesWithParents] is true: character moves back in with parents.
  /// - If [livesWithParents] is false: character lives in [houseName] (which must be owned).
  static Map<String, dynamic> setLivingArrangement(
    Character character, {
    required bool livesWithParents,
    String? houseName,
  }) {
    if (livesWithParents) {
      character.livesWithParents = true;
      character.activeHouseName = null;
      return {
        'success': true,
        'message': 'Kamu memilih untuk tinggal bersama orang tua.',
      };
    } else {
      if (houseName == null || houseName.isEmpty) {
        return {
          'success': false,
          'message': 'Pilih rumah yang ingin kamu tinggali.',
        };
      }

      final ownsHouse = character.ownedHouses.any((h) => h['name'] == houseName);
      if (!ownsHouse) {
        return {
          'success': false,
          'message': 'Kamu tidak memiliki rumah "$houseName".',
        };
      }

      character.livesWithParents = false;
      character.activeHouseName = houseName;
      return {
        'success': true,
        'message': 'Kamu sekarang tinggal mandiri di $houseName!',
      };
    }
  }
}
