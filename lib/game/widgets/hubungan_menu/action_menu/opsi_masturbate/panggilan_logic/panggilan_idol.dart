// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_idol.dart

import 'package:mylifesim/avatar/avatar_age_rules.dart';

class PanggilanIdol {
  static String getPanggilan({
    required String targetName,
    required String targetRole,
    String? targetGender,
    bool isSpeakerPlayer = false,
    String? userName,
    String? userGender,
  }) {
    final String cleanTargetName = AvatarAgeRules.getCleanNPCName(targetName);
    return cleanTargetName;
  }
}
