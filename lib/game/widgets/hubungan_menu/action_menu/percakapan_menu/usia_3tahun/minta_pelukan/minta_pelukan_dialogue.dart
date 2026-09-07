// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/usia_3tahun/minta_pelukan/minta_pelukan_dialogue.dart
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class MintaPelukanDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Orang Tua';

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName... Boleh minta peluk erat-erat? Aku merasa ingin dipeluk hangat hari ini 👶❤️',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Tentu saja sayang! Sini dekat-dekat $npcName, pelukan hangat selalu ada untukmu kapan saja! 🤗💕',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '💖 (Memeluk erat dan merasa sangat bahagia)',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 15).clamp(0, 100);
              p.health = (p.health + 2).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '😊 "Terima kasih banyak $npcName! Aku sayang banget!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 12).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Kamu adalah anak tercantik/tertampan yang paling menggemaskan! Selalu jadi anak yang berbakti ya! ❤️',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
