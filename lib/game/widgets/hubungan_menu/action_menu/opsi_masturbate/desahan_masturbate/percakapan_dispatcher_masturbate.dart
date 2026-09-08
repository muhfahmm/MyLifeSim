import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_overlay.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';

import 'dialog_npc_perempuan/dialog_npc_perempuan_masturbate.dart';
import 'dialog_npc_laki/dialog_npc_laki_masturbate.dart';
import 'dialog_user_perempuan/dialog_user_perempuan_masturbate.dart';
import 'dialog_user_laki/dialog_user_laki_masturbate.dart';

class PercakapanDispatcherMasturbate {
  static void dispatchAction({
    required BuildContext context,
    required Character character,
    required Map<String, dynamic> npc,
    required String chosenLocation,
    required String chosenTime,
    required VoidCallback onActionComplete,
  }) {
    final String myGender = character.gender.trim().toLowerCase();
    final String npcGender = (npc['gender'] ?? 'Perempuan').toString().trim().toLowerCase();

    List<VNDialogueNode> playerMoanNodes = [];
    if (myGender == 'perempuan') {
      playerMoanNodes = DialogUserPerempuanMasturbate.getMoanNodes(
        player: character,
        npc: npc,
        count: 3,
      );
    } else {
      playerMoanNodes = DialogUserLakiMasturbate.getMoanNodes(
        player: character,
        npc: npc,
        count: 3,
      );
    }

    List<VNDialogueNode> sequenceNodes = [];
    VNDialogueNode aftercareNode;

    if (npcGender == 'perempuan') {
      sequenceNodes = DialogNpcPerempuanMasturbate.getMoanSequence(
        player: character,
        npc: npc,
        playerMoanNodes: playerMoanNodes,
        nodeCount: 3,
      );
      aftercareNode = DialogNpcPerempuanMasturbate.getAftercareNode(npc: npc);
    } else {
      sequenceNodes = DialogNpcLakiMasturbate.getMoanSequence(
        player: character,
        npc: npc,
        playerMoanNodes: playerMoanNodes,
        nodeCount: 3,
      );
      aftercareNode = DialogNpcLakiMasturbate.getAftercareNode(npc: npc);
    }

    final List<VNDialogueNode> finalDialogueNodes = [
      ...sequenceNodes,
      aftercareNode,
    ];

    final String plainName = AvatarAgeRules.getCleanNPCName(npc['name'] ?? 'Target');
    final String npcAvatarUrl = npc['avatarUrl'] ?? AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: plainName,
      gender: npcGender == 'perempuan' ? 'Perempuan' : 'Laki-laki',
      age: int.tryParse(npc['age']?.toString() ?? '18') ?? 18,
    );

    VNDialogueOverlay.show(
      context: context,
      player: character,
      npc: npc,
      nodes: finalDialogueNodes,
      npcAvatarUrl: npcAvatarUrl,
      customLocation: chosenLocation,
      onFinished: onActionComplete,
    );
  }
}
