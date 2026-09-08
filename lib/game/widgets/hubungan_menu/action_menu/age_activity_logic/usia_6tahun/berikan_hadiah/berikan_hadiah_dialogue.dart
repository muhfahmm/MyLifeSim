// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/berikan_hadiah/berikan_hadiah_dialogue.dart
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class BerikanHadiahDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Target';

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName! Ini aku punya hadiah istimewa buatan sendiri khusus untukmu! 🎁✨',
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Wah, benarkah? Hadiah manis ini pasti kamu siapkan dengan penuh kasih sayang! Terima kasih! 🥺🎁',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '🎨 "Iya, aku buat sendiri dengan sepenuh hati!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 15).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '💖 "Semoga kamu menyukainya ya!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 12).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Aku akan menyimpan hadiah ini baik-baik. Terima kasih banyak ${player.name}! 💕',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
