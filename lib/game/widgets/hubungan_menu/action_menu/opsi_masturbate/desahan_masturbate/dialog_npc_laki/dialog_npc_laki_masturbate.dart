// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/dialog_npc_laki/dialog_npc_laki_masturbate.dart

import 'dart:math';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

enum NPCLakiPersonalityType { cool, aggressive, gentle }

class DialogNpcLakiMasturbate {
  static NPCLakiPersonalityType _getNPCPersonality(Map<String, dynamic> npc) {
    final String trait = (npc['personality'] ?? npc['trait'] ?? '').toString().toLowerCase();
    if (trait.contains('cool') || trait.contains('pendiam') || trait.contains('jutek')) {
      return NPCLakiPersonalityType.cool;
    }
    if (trait.contains('agresif') || trait.contains('bold') || trait.contains('gairah') || trait.contains('dominan')) {
      return NPCLakiPersonalityType.aggressive;
    }
    return NPCLakiPersonalityType.gentle;
  }

  static const List<String> _coolMoans = [
    "Hah... kamu membuatku sulit menahan diri...",
    "Mmh... lihat apa yang kamu lakukan padaku...",
    "Hah... ritmemu... buat aku makin bergairah...",
    "Ugh... sentuh dirimu lebih cepat...",
    "Hah... desahanmu membakar fokusku...",
    "Mmh... aku tidak bisa berpaling...",
  ];

  static const List<String> _aggressiveMoans = [
    "Ugh! Tatap mataku saat kamu melakukannya!",
    "Hah! Lakukan lebih cepat untukku!",
    "Ugh! Sensasi ini gila sekali saat bersamamu!",
    "Hah! Jangan berani-berani berhenti!",
    "Ugh... ya, nikmati setiap detik bersamaku!",
  ];

  static const List<String> _gentleMoans = [
    "Hah... kamu manis sekali saat seperti ini...",
    "Mmh... aku akan menyesuaikan kecepatan denganmu...",
    "Hah... rileks ya... nikmati momen kita...",
    "Ugh... suaramu merdu sekali...",
    "Hah... aku senang bisa melakukan ini bersamamu...",
  ];

  static const List<String> _narrations = [
    "(Suasana makin intim saat kalian saling bertukar tatapan hangat dan melakukan masturbasi bersama...)",
    "(Setiap desahan tertahan terdengar jelas, menciptakan kehangatan yang mengalir di seluruh ruangan...)",
    "(Gerakan tangan yang selaras membuat ketegangan dan gairah memuncak bersamaan...)",
  ];

  static List<VNDialogueNode> getMoanSequence({
    required Character player,
    required Map<String, dynamic> npc,
    required List<VNDialogueNode> playerMoanNodes,
    int nodeCount = 3,
  }) {
    final Random random = Random();
    final List<VNDialogueNode> sequence = [];

    final String npcName = npc['name'] ?? 'Pasangan';
    final String targetRole = npc['role'] ?? 'Pasangan';
    final String npcGender = npc['gender'] ?? 'Laki-laki';

    final bool isPlayerFemale = player.gender.trim().toLowerCase() == 'perempuan';

    final String callNpcToPlayer = PanggilanManager.getPanggilan(
      targetName: isPlayerFemale ? npcName : player.name,
      targetRole: targetRole,
      targetGender: isPlayerFemale ? npcGender : player.gender,
      isSpeakerPlayer: false,
      userName: player.name,
      userGender: player.gender,
      isIntimate: true,
    );

    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);

    List<String> selectedMoanList;
    switch (personality) {
      case NPCLakiPersonalityType.cool:
        selectedMoanList = _coolMoans;
        break;
      case NPCLakiPersonalityType.aggressive:
        selectedMoanList = _aggressiveMoans;
        break;
      case NPCLakiPersonalityType.gentle:
        selectedMoanList = _gentleMoans;
        break;
    }

    int playerIndex = 0;

    for (int i = 0; i < nodeCount; i++) {
      final String rawMoan = selectedMoanList[random.nextInt(selectedMoanList.length)];
      final String narrationText = _narrations[random.nextInt(_narrations.length)];

      String moanWithCall = "$rawMoan, $callNpcToPlayer...";

      final VNDialogueNode narrationNode = VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: narrationText,
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      );

      final VNDialogueNode npcLakiNode = VNDialogueNode(
        speakerName: '$npcName ($targetRole)',
        dialogueText: moanWithCall,
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      );

      final VNDialogueNode playerNode = playerMoanNodes.isNotEmpty
          ? playerMoanNodes[playerIndex % playerMoanNodes.length]
          : VNDialogueNode(
              speakerName: player.name,
              dialogueText: "Ahh... hah... ini nikmat sekali...",
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: true,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            );
      playerIndex++;

      sequence.add(narrationNode);
      if (isPlayerFemale) {
        sequence.add(playerNode);
        sequence.add(npcLakiNode);
      } else {
        sequence.add(npcLakiNode);
        sequence.add(playerNode);
      }
    }

    return sequence;
  }

  static VNDialogueNode getAftercareNode({
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);

    String textAftercare;
    switch (personality) {
      case NPCLakiPersonalityType.cool:
        textAftercare = 'Hah... tak kusangka melakukan masturbasi bersamamu bisa sebikin ini ketagihan... 🔥';
        break;
      case NPCLakiPersonalityType.aggressive:
        textAftercare = 'Ugh... itu luar biasa! Lain kali kita harus mencobanya lagi di tempat yang lebih menantang! 😈';
        break;
      case NPCLakiPersonalityType.gentle:
        textAftercare = 'Hah... kamu tidak apa-apa kan? Mengamati ekspresimu tadi sungguh membuat hatiku meleleh... ❤️';
        break;
    }

    return VNDialogueNode(
      speakerName: npcName,
      dialogueText: textAftercare,
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    );
  }
}
