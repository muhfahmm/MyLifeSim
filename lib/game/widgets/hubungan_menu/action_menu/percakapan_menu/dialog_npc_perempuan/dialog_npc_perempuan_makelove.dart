// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/dialog_npc_perempuan/dialog_npc_perempuan_makelove.dart

import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

enum NPCPerempuanPersonalityType { shy, bold, kind }

class DialogNpcPerempuanMakeLove {
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

  /// Dialog penolakan NPC Perempuan
  static VNDialogueNode getRejectionNode({
    required Map<String, dynamic> npc,
    required String chosenLocation,
    required String chosenTime,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);

    String text;
    switch (personality) {
      case NPCPerempuanPersonalityType.shy:
        text = 'M-maaf ya... aku merasa sangat malu dan gugup saat ini. Suasana di $chosenLocation pada waktu $chosenTime belum pas untukku... 🥺';
        break;
      case NPCPerempuanPersonalityType.bold:
        text = 'Sayang, malam ini di $chosenLocation gairahku sedang kurang menyala. Kita obrolkan yang lain dulu ya! 😉';
        break;
      case NPCPerempuanPersonalityType.kind:
        text = 'Maaf ya sayang... Hati dan pikiranku sedang kurang tenang hari ini. Mari kita berpelukan saja dulu di $chosenLocation saat $chosenTime. 💖';
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
          text: '😔 "Baiklah sayang, tidak apa-apa..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 5).clamp(0, 100);
          },
        ),
      ],
    );
  }

  /// TAHAP 1: Penerimaan & Foreplay NPC Perempuan
  static VNDialogueNode getAcceptanceNode({
    required Map<String, dynamic> npc,
    required String chosenLocation,
    required String chosenTime,
    required List<VNChoiceOption> intimacyChoices,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);

    String text;
    switch (personality) {
      case NPCPerempuanPersonalityType.shy:
        text = 'Mmh... ah... s-sentuh aku di sana... pelan-pelan ya... Wajahku rasanya memerah sekali... 💕';
        break;
      case NPCPerempuanPersonalityType.bold:
        text = 'Hah! Ya, tepat di sana! Jangan berhenti! Suasana di $chosenLocation saat $chosenTime ini membuat gairahku membara! 🔥💥';
        break;
      case NPCPerempuanPersonalityType.kind:
        text = 'Ahh... kamu nyaman? Hah... aku hanya ingin kamu bahagia dan merasa dicintai malam ini... ❤️✨';
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

  /// TAHAP 2: Desahan NPC Perempuan & Interaksi (Fade to Black)
  static List<VNDialogueNode> getIntimacyNodes({
    required Character player,
    required Map<String, dynamic> npc,
    required List<VNDialogueNode> playerMoanNodes,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);

    String textMoanNPC;
    switch (personality) {
      case NPCPerempuanPersonalityType.shy:
        textMoanNPC = 'Ah... ah... a-aku tidak bisa berpikir jernih lagi... hah... ${player.name}... ahhhhh...! 💖';
        break;
      case NPCPerempuanPersonalityType.bold:
        textMoanNPC = 'Ahh! Ya, di sana! Jangan pelan! Aku... ahhhhh... ${player.name}...! 🔥💥';
        break;
      case NPCPerempuanPersonalityType.kind:
        textMoanNPC = 'Ahh... rintihan ini... hah... kamu membuatku sangat bahagia... ${player.name}... ahh...! ❤️✨';
        break;
    }

    return [
      // Desahan NPC Perempuan
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

  /// TAHAP 3: Aftercare NPC Perempuan
  static VNDialogueNode getAftercareNode({
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);

    String textAftercare;
    switch (personality) {
      case NPCPerempuanPersonalityType.shy:
        textAftercare = 'Hah... hah... m-merasa malu sekali... jangan lihat aku terus seperti itu... 🙈❤️ (Sambil menutupi wajahnya dengan bantal)';
        break;
      case NPCPerempuanPersonalityType.bold:
        textAftercare = 'Hah... itu tadi sungguh luar biasa! Aku tidak sabar untuk mengulanginya lagi denganku! 🔥 (Tersenyum lebar sambil mengusap rambutmu)';
        break;
      case NPCPerempuanPersonalityType.kind:
        textAftercare = 'Hah... kamu tidak merasa lelah atau sakit kan? Hah... aku sangat sayang padamu... ayo pelukan sampai pagi... ❤️ (Menyatukan keningnya denganmu)';
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
