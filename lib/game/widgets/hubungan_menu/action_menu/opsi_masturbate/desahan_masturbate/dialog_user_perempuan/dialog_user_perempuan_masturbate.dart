// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/dialog_user_perempuan/dialog_user_perempuan_masturbate.dart

import 'dart:math';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class DialogUserPerempuanMasturbate {
  static const List<String> _userFemaleMoans = [
    "Ahh... m-sentuhanku sendiri terasa makin hangat saat kamu menatapku...",
    "Hah... hah... desahanmu membuatku tak bisa menahan diri...",
    "Mmh... ah... jangan berpaling ya...",
    "Hah... ahh... rasanya... nikmat sekali...",
    "Ahh... hah... aku hampir sampai...",
  ];

  static List<VNDialogueNode> getMoanNodes({
    required Character player,
    required Map<String, dynamic> npc,
    int count = 3,
  }) {
    final Random random = Random();
    final List<VNDialogueNode> nodes = [];

    final String npcName = npc['name'] ?? 'Pasangan';
    final String targetRole = npc['role'] ?? 'Pasangan';
    final String npcGender = npc['gender'] ?? 'Laki-laki';

    final String callPlayerToNpc = PanggilanManager.getPanggilan(
      targetName: npcName,
      targetRole: targetRole,
      targetGender: npcGender,
      isSpeakerPlayer: true,
      userName: player.name,
      userGender: player.gender,
      isIntimate: true,
    );

    for (int i = 0; i < count; i++) {
      final String rawMoan = _userFemaleMoans[random.nextInt(_userFemaleMoans.length)];
      final String moanWithCall = "$rawMoan $callPlayerToNpc...";

      nodes.add(
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: moanWithCall,
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      );
    }

    return nodes;
  }
}
