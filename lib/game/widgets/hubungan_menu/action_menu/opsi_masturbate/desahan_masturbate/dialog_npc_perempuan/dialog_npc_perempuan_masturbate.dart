// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/dialog_npc_perempuan/dialog_npc_perempuan_masturbate.dart

import 'dart:math';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

enum NPCPerempuanPersonalityType { shy, bold, kind }

class DialogNpcPerempuanMasturbate {
  static NPCPerempuanPersonalityType _getNPCPersonality(Map<String, dynamic> npc) {
    final String trait = (npc['personality'] ?? npc['trait'] ?? '').toString().toLowerCase();
    if (trait.contains('pemalu') || trait.contains('shy') || trait.contains('pendiam')) {
      return NPCPerempuanPersonalityType.shy;
    }
    if (trait.contains('ekstrovert') || trait.contains('bold') || trait.contains('gairah') || trait.contains('percaya diri')) {
      return NPCPerempuanPersonalityType.bold;
    }
    return NPCPerempuanPersonalityType.kind;
  }

  static const List<String> _shyMoans = [
    "Mmh... ah... sentuh dirimu sendiri sambil melihatku...",
    "Hah... jangan tatap aku seperti itu... aku malu...",
    "A-aku... ahh... napasku rasanya sesak...",
    "Hah... hah... ritme kita... sama...",
    "Mmh... ah... ini terasa sangat intim...",
    "Hah... ahh... tanganmu... cepat sekali...",
    "Aah... ah... aku bisa mendengarmu...",
    "Hah... hah... jantungku berdebar kencang sekali...",
    "Ahh... a-aku mulai... hah... hampir mencapai puncaknya...",
    "Mmh... mmmh... ahh... bersama denganmu...",
  ];

  static const List<String> _boldMoans = [
    "Ahh! Ya, lihat aku mengeksplorasi diriku!",
    "Ahh! Lakukan lebih cepat untukku!",
    "Hah! Sensasi ini makin menggila saat bersamamu! Ahhh!",
    "Ahh! Jangan lepas pandanganmu dariku! Hah!",
    "Ahh... ahh... ya! Teruskan masturbasimu!",
    "Hah! Aku suka caramu menyentuh dirimu sendiri!",
    "Ahh! Kamu membuatku bergairah sekali! Hah!",
  ];

  static const List<String> _kindMoans = [
    "Mmh... ah... kamu menikmati ini kan? Sayang...",
    "Hah... bersamamu... rasanya begitu rileks...",
    "Ahh... ah... mari kita nikmati momen rahasia ini bersama...",
    "Hah... hah... aku senang bisa berbagi rasa ini denganmu...",
    "Mmh... ahh... rasanya sungguh manis dan hangat...",
    "Ahh... hah... ikuti desahanku ya...",
  ];

  static const List<String> _narrations = [
    "(Suasana makin panas saat kalian berdua saling menatap dan melakukan masturbasi bersama secara perlahan...)",
    "(Gerakan tangan yang makin cepat membuat napas kalian tersengal-sengal di tengah keheningan...)",
    "(Tatapan mata berbinar penuh gairah mengiringi setiap detik eksplorasi diri bersama...)",
    "(Sensasi nikmat dan desahan tertahan membuncah saat kalian berdua makin mendekati puncak...)",
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
    final String npcGender = npc['gender'] ?? 'Perempuan';

    final bool isPlayerMale = player.gender.trim().toLowerCase() == 'laki-laki';

    final String callNpcToPlayer = PanggilanManager.getPanggilan(
      targetName: isPlayerMale ? npcName : player.name,
      targetRole: targetRole,
      targetGender: isPlayerMale ? npcGender : player.gender,
      isSpeakerPlayer: false,
      userName: player.name,
      userGender: player.gender,
      isIntimate: true,
    );

    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);

    List<String> selectedMoanList;
    switch (personality) {
      case NPCPerempuanPersonalityType.shy:
        selectedMoanList = _shyMoans;
        break;
      case NPCPerempuanPersonalityType.bold:
        selectedMoanList = _boldMoans;
        break;
      case NPCPerempuanPersonalityType.kind:
        selectedMoanList = _kindMoans;
        break;
    }

    int playerIndex = 0;

    for (int i = 0; i < nodeCount; i++) {
      final String rawMoan = selectedMoanList[random.nextInt(selectedMoanList.length)];
      final String narrationText = _narrations[random.nextInt(_narrations.length)];

      String moanWithCall;
      final int callPattern = random.nextInt(4);
      switch (callPattern) {
        case 0:
          moanWithCall = "$rawMoan $callNpcToPlayer...";
          break;
        case 1:
          moanWithCall = "Ahh... $callNpcToPlayer, $rawMoan";
          break;
        case 2:
          moanWithCall = "$rawMoan, $callNpcToPlayer...";
          break;
        case 3:
        default:
          moanWithCall = "Ahh... $callNpcToPlayer... $rawMoan";
          break;
      }

      final VNDialogueNode narrationNode = VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: narrationText,
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      );

      final VNDialogueNode npcPerempuanNode = VNDialogueNode(
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
              dialogueText: "Ahh... hah... aku sangat menyukai momen ini denganku...",
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: true,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            );
      playerIndex++;

      sequence.add(narrationNode);
      if (isPlayerMale) {
        sequence.add(playerNode);
        sequence.add(npcPerempuanNode);
      } else {
        sequence.add(npcPerempuanNode);
        sequence.add(playerNode);
      }
    }

    return sequence;
  }

  static VNDialogueNode getAftercareNode({
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);

    String textAftercare;
    switch (personality) {
      case NPCPerempuanPersonalityType.shy:
        textAftercare = 'Hah... hah... jantungku serasa mau melompat keluar... tapi rasanya sungguh lega dan nikmat... 🙈✨';
        break;
      case NPCPerempuanPersonalityType.bold:
        textAftercare = 'Hah... itu tadi fantastis! Masturbasi bersama denganmu memberikan sensasi yang jauh lebih membakar! 🔥';
        break;
      case NPCPerempuanPersonalityType.kind:
        textAftercare = 'Hah... terima kasih sudah menemaniku dan berbagi kehangatan ini ya... aku merasa sangat nyaman... ❤️';
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
