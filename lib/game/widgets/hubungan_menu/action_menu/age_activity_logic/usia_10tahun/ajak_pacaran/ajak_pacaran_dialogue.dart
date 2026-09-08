// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_10tahun/ajak_pacaran/ajak_pacaran_dialogue.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class AjakPacaranDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    bool isAccepted = true,
  }) {
    final String npcName = npc['name'] ?? 'Target';

    if (!isAccepted) {
      return [
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: '$npcName... Aku suka banget sama kamu. Maukah kamu jadi pacarku? 💖✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.park,
        ),
        VNDialogueNode(
          speakerName: npcName,
          dialogueText: 'Maaf ya... Saat ini aku merasa kita lebih cocok sebatas teman biasa saja. 😔💔',
          emotion: VNEmotionType.sad,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.park,
          choices: [
            VNChoiceOption(
              text: '💔 "Oh... Begitu ya. Tidak apa-apa kok..."',
              onSelect: (p, n) {
                p.happiness = (p.happiness - 10).clamp(0, 100);
              },
            ),
          ],
        ),
      ];
    }

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName... Aku suka banget sama kamu. Maukah kamu jadi pacarku? 💖✨',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Wah... Aku juga udah lama suka sama kamu! Tentu saja aku mau jadi pacarmu! 💕',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
        choices: [
          VNChoiceOption(
            text: '💖 "Hore! Hari ini hari paling membahagiakan!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 20).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '🥰 "Janji kita bakal selalu bersama ya!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 18).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Iya! Mari kita jalani hari-hari bersama dengan bahagia! ❤️✨',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
      ),
    ];
  }
}
