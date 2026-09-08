// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_rekan_kerja.dart

import 'package:mylifesim/avatar/avatar_age_rules.dart';

class PanggilanRekanKerja {
  static String getPanggilan({
    required String targetName,
    required String targetRole,
    String? targetGender,
    bool isSpeakerPlayer = false,
    String? userName,
    String? userGender,
    bool isIntimate = false,
  }) {
    final String cleanTargetName = AvatarAgeRules.getCleanNPCName(targetName);
    if (isIntimate) {
      return cleanTargetName;
    }
    return cleanTargetName;
  }
}
