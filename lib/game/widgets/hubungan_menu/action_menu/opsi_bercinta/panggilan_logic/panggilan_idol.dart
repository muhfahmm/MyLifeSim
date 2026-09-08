// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_idol.dart

import 'dart:math';

/// Logika panggilan untuk hubungan di Industri Idol.
class PanggilanIdol {
  static final Random _random = Random();

  static String getPanggilan({
    required String targetName,
    required String targetRole,
    String? targetGender,
    bool isSpeakerPlayer = false,
    String? userName,
    String? userGender,
    bool isStaffOrManager = false,
  }) {
    final String roleLower = targetRole.toLowerCase();
    final String listenerName = isSpeakerPlayer ? targetName : (userName ?? 'Member');
    final String listenerGender = isSpeakerPlayer ? (targetGender ?? '').toLowerCase() : (userGender ?? '').toLowerCase();
    final bool isListenerMale = listenerGender.contains('laki') || listenerGender.contains('male');

    final List<String> pool = [];

    if (isSpeakerPlayer) {
      if (roleLower.contains('produser')) {
        pool.addAll(['Produser-san', 'Pak Produser', 'Bu Produser', 'Produser $listenerName']);
      } else if (roleLower.contains('manager') || roleLower.contains('manajer')) {
        pool.addAll(['Manager-san', isListenerMale ? 'Pak Manager' : 'Bu Manager', 'Manager $listenerName']);
      } else {
        pool.addAll(['$listenerName-chan', '$listenerName-senpai', 'Rekan Idol $listenerName', 'Member $listenerName']);
      }
    } else {
      if (roleLower.contains('manager') || roleLower.contains('produser')) {
        // NPC Manager memanggil User Idol
        pool.addAll(['$listenerName-chan', 'Member $listenerName', listenerName]);
      } else {
        pool.addAll(['$listenerName-chan', '$listenerName-senpai', 'Rekan Idol $listenerName', listenerName]);
      }
    }

    if (pool.isEmpty) return listenerName;
    return pool[_random.nextInt(pool.length)];
  }
}
