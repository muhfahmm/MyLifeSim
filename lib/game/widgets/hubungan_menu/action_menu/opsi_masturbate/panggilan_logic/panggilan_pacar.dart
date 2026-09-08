// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_pacar.dart

import 'package:mylifesim/avatar/avatar_age_rules.dart';

class PanggilanPacar {
  static String getPanggilan({
    required String targetName,
    String? targetGender,
    String targetRole = 'Pasangan',
    bool isSpeakerPlayer = false,
    String? userName,
    String? userGender,
  }) {
    final String cleanTargetName = AvatarAgeRules.getCleanNPCName(targetName);
    final String roleLower = targetRole.toLowerCase();

    if (roleLower.contains('suami')) {
      return isSpeakerPlayer ? 'Suamiku ($cleanTargetName)' : 'Istriku';
    }
    if (roleLower.contains('istri')) {
      return isSpeakerPlayer ? 'Istriku ($cleanTargetName)' : 'Suamiku';
    }
    if (roleLower.contains('tunangan')) {
      return isSpeakerPlayer ? 'Tunanganku ($cleanTargetName)' : 'Tunanganku';
    }
    return isSpeakerPlayer ? 'Sayang ($cleanTargetName)' : 'Sayang';
  }
}
