// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/dialog_npc_laki/dialog_npc_laki_makelove.dart

import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

enum NPCLakiPersonalityType { shy, bold, kind }

class DialogNpcLakiMakeLove {
  static NPCLakiPersonalityType _getNPCPersonality(Map<String, dynamic> npc) {
    final String trait = (npc['personality'] ?? npc['trait'] ?? '').toString().toLowerCase();
    if (trait.contains('pemalu') || trait.contains('shy') || trait.contains('pendiam')) {
      return NPCLakiPersonalityType.shy;
    }
    if (trait.contains('ekstrovert') || trait.contains('bold') || trait.contains('gairah') || trait.contains('percaya diri')) {
      return NPCLakiPersonalityType.bold;
    }
    return NPCLakiPersonalityType.kind;
  }

  /// Dialog penolakan NPC Laki-Laki
  static VNDialogueNode getRejectionNode({
    required Map<String, dynamic> npc,
    required String chosenLocation,
    required String chosenTime,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);

    String text;
    switch (personality) {
      case NPCLakiPersonalityType.shy:
        text = 'M-maafkan aku ya... aku sedang sangat canggung dan belum siap malam ini di $chosenLocation. Lain kali pasti ya... 😔';
        break;
      case NPCLakiPersonalityType.bold:
        text = 'Haha maaf ya cantik, aku sedang kehabisan energi setelah seharian beraktivitas. Nanti kita ganti momen yang lebih panas di $chosenLocation ya! 💥';
        break;
      case NPCLakiPersonalityType.kind:
        text = 'Maafkan aku ya sayang... Aku sedang merasa kurang fit dan lelah saat ini. Kamu tetap yang terbaik, ayo kita beristirahat dulu... 🌿';
        break;
    }

    return VNDialogueNode(
      speakerName: npcName,
      dialogueText: text,
      emotion: VNEmotionType.sad,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: [
        VNChoiceOption(
          text: '😔 "Baiklah sayang, istirahatlah dulu..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 5).clamp(0, 100);
          },
        ),
      ],
    );
  }

  /// TAHAP 1: Penerimaan & Foreplay NPC Laki-Laki
  static VNDialogueNode getAcceptanceNode({
    required Map<String, dynamic> npc,
    required String chosenLocation,
    required String chosenTime,
    required List<VNChoiceOption> intimacyChoices,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);

    String text;
    switch (personality) {
      case NPCLakiPersonalityType.shy:
        text = 'M-maukah kamu... berpegangan denganku? Tempat di $chosenLocation saat $chosenTime ini sungguh membuat jantungku berdebar... 💕';
        break;
      case NPCLakiPersonalityType.bold:
        text = 'Aww... aku sudah menunggu momen ini! Tempat di $chosenLocation saat $chosenTime ini sempurna sekali... Kemarilah sayang... 🔥❤️';
        break;
      case NPCLakiPersonalityType.kind:
        text = 'Tentu saja sayang... Berada di $chosenLocation saat $chosenTime bersamamu adalah kebahagiaan bagiku. Mari kita nikmati malam ini... ❤️✨';
        break;
    }

    return VNDialogueNode(
      speakerName: npcName,
      dialogueText: text,
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: intimacyChoices,
    );
  }

  /// TAHAP 2: Desahan NPC Laki-Laki & Interaksi (Fade to Black)
  static List<VNDialogueNode> getIntimacyNodes({
    required Character player,
    required Map<String, dynamic> npc,
    required List<VNDialogueNode> playerMoanNodes,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);

    String textMoanNPC;
    switch (personality) {
      case NPCLakiPersonalityType.shy:
        textMoanNPC = 'Hah... hah... sentuhanmu sungguh hangat... ${player.name}... ugh... aku mencintaimu... ahh...! 💖';
        break;
      case NPCLakiPersonalityType.bold:
        textMoanNPC = 'Hah! Sentuhanmu luar biasa! ${player.name}... ugh... lebih dekat lagi... ahhhhh...! 🔥💥';
        break;
      case NPCLakiPersonalityType.kind:
        textMoanNPC = 'Ahh... kamu membuatku begitu bahagia... ${player.name}... hah... rasakan kehangatanku... ahh...! ❤️✨';
        break;
    }

    return [
      // Desahan NPC Laki-Laki
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: textMoanNPC,
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      // Desahan Player
      ...playerMoanNodes,
      // Fade to Black
      VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Lampu kamar meredup pekat... Tubuh kalian saling merapat di bawah selimut hangat. Hanya deru napas tersengal dan rintihan lembut yang saling bersahutan...) 🌙✨',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }

  /// TAHAP 3: Aftercare NPC Laki-Laki
  static VNDialogueNode getAftercareNode({
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);

    String textAftercare;
    switch (personality) {
      case NPCLakiPersonalityType.shy:
        textAftercare = 'Hah... hah... a-aku merasa sangat beruntung memilikimu... Istirahatlah dalam pelukanku ya... ❤️ (Sambil mengusap dahi kamu)';
        break;
      case NPCLakiPersonalityType.bold:
        textAftercare = 'Hah... itu tadi sungguh luar biasa! Kamu selalu berhasil membuatku kagum... Malam ini milik kita! 🔥 (Tersenyum bangga sambil merangkulmu)';
        break;
      case NPCLakiPersonalityType.kind:
        textAftercare = 'Hah... napasku masih tersengal-sengal... Berada di sisimu seperti ini adalah perasaan terbaik. Peluk aku erat-erat ya... ❤️✨';
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
