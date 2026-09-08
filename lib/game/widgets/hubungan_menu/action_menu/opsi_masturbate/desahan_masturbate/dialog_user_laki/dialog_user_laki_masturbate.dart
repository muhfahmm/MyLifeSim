// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/dialog_user_laki/dialog_user_laki_masturbate.dart

import 'dart:math';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class DialogUserLakiMasturbate {
  static const List<String> _userMaleMoans = [
    "Hah... tatapanmu membuat gairahku makin tak terkendali...",
    "Ugh... lihat apa yang terjadi padaku saat bersamamu...",
    "Hah... ritme gerakanmu indah sekali...",
    "Mmh... ah... aku senang kita melakukan ini bersama...",
    "Hah... hah... aku sudah mau sampai...",
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
    final String npcGender = npc['gender'] ?? 'Perempuan';

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
      final String rawMoan = _userMaleMoans[random.nextInt(_userMaleMoans.length)];
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
