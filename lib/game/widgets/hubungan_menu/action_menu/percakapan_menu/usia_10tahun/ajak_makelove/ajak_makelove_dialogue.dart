// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/usia_10tahun/ajak_makelove/ajak_makelove_dialogue.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/percakapan_menu/dialog_user_laki/dialog_user_laki_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/percakapan_menu/dialog_user_perempuan/dialog_user_perempuan_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/percakapan_menu/dialog_npc_laki/dialog_npc_laki_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/percakapan_menu/dialog_npc_perempuan/dialog_npc_perempuan_makelove.dart';

class AjakMakeLoveDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    String chosenLocation = 'Kamar Tidur',
    String chosenTime = 'Malam',
    bool useCondom = false,
    bool isAccepted = true,
  }) {
    final bool isMalePlayer = player.gender.trim().toLowerCase() == 'laki-laki';
    final String npcGender = (npc['gender'] ?? 'Perempuan').toString().trim().toLowerCase();
    final bool isMaleNPC = npcGender == 'laki-laki';

    // 1. Dialog Pembuka User
    final List<VNDialogueNode> userOpeningNodes = isMalePlayer
        ? DialogUserLakiMakeLove.getOpeningNodes(
            player: player,
            npc: npc,
            chosenLocation: chosenLocation,
            chosenTime: chosenTime,
            useCondom: useCondom,
          )
        : DialogUserPerempuanMakeLove.getOpeningNodes(
            player: player,
            npc: npc,
            chosenLocation: chosenLocation,
            chosenTime: chosenTime,
            useCondom: useCondom,
          );

    // 2. Jika ditolak oleh NPC
    if (!isAccepted) {
      final VNDialogueNode rejectionNode = isMaleNPC
          ? DialogNpcLakiMakeLove.getRejectionNode(
              npc: npc,
              chosenLocation: chosenLocation,
              chosenTime: chosenTime,
            )
          : DialogNpcPerempuanMakeLove.getRejectionNode(
              npc: npc,
              chosenLocation: chosenLocation,
              chosenTime: chosenTime,
            );

      return [
        ...userOpeningNodes,
        rejectionNode,
      ];
    }

    // 3. Pilihan Interaksi Keintiman User
    void onChoiceSelected(int happinessBonus, int healthBonus) {
      player.happiness = (player.happiness + happinessBonus).clamp(0, 100);
      player.health = (player.health + healthBonus).clamp(0, 100);
    }

    final List<VNChoiceOption> intimacyChoices = isMalePlayer
        ? DialogUserLakiMakeLove.getIntimacyChoices(
            player: player,
            npc: npc,
            onChoiceSelected: onChoiceSelected,
          )
        : DialogUserPerempuanMakeLove.getIntimacyChoices(
            player: player,
            npc: npc,
            onChoiceSelected: onChoiceSelected,
          );

    // 4. Node Penerimaan NPC
    final VNDialogueNode npcAcceptanceNode = isMaleNPC
        ? DialogNpcLakiMakeLove.getAcceptanceNode(
            npc: npc,
            chosenLocation: chosenLocation,
            chosenTime: chosenTime,
            intimacyChoices: intimacyChoices,
          )
        : DialogNpcPerempuanMakeLove.getAcceptanceNode(
            npc: npc,
            chosenLocation: chosenLocation,
            chosenTime: chosenTime,
            intimacyChoices: intimacyChoices,
          );

    // 5. Node Desahan User
    final List<VNDialogueNode> playerMoanNodes = isMalePlayer
        ? DialogUserLakiMakeLove.getMoanNodes(player: player, npc: npc)
        : DialogUserPerempuanMakeLove.getMoanNodes(player: player, npc: npc);

    // 6. Node Intim & Fade to Black NPC
    final List<VNDialogueNode> intimacyNodes = isMaleNPC
        ? DialogNpcLakiMakeLove.getIntimacyNodes(
            player: player,
            npc: npc,
            playerMoanNodes: playerMoanNodes,
          )
        : DialogNpcPerempuanMakeLove.getIntimacyNodes(
            player: player,
            npc: npc,
            playerMoanNodes: playerMoanNodes,
          );

    // 7. Node Aftercare NPC
    final VNDialogueNode aftercareNode = isMaleNPC
        ? DialogNpcLakiMakeLove.getAftercareNode(npc: npc)
        : DialogNpcPerempuanMakeLove.getAftercareNode(npc: npc);

    return [
      ...userOpeningNodes,
      npcAcceptanceNode,
      ...intimacyNodes,
      aftercareNode,
    ];
  }
}


