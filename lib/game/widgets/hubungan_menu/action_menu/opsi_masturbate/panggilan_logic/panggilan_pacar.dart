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
    final bool isUserMale = (userGender ?? '').toLowerCase().contains('laki') || (userGender ?? '').toLowerCase().contains('male');
    final bool isTargetFemale = (targetGender == null || targetGender.isEmpty || targetGender.toLowerCase().contains('perempuan') || targetGender.toLowerCase().contains('female') || targetGender.toLowerCase().contains('cewek'));

    if (!isSpeakerPlayer && isUserMale && isTargetFemale) {
      return 'Sayang';
    }

    final String cleanTargetName = AvatarAgeRules.getCleanNPCName(targetName);
    final String roleLower = targetRole.toLowerCase();

    if (roleLower.contains('suami')) {
      return isSpeakerPlayer ? 'Suamiku ($cleanTargetName)' : 'Sayang';
    }
    if (roleLower.contains('istri')) {
      return isSpeakerPlayer ? 'Istriku ($cleanTargetName)' : 'Sayang';
    }
    if (roleLower.contains('tunangan')) {
      return isSpeakerPlayer ? 'Tunanganku ($cleanTargetName)' : 'Sayang';
    }
    return isSpeakerPlayer ? 'Sayang ($cleanTargetName)' : 'Sayang';
  }
}
