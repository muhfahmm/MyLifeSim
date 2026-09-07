// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/usia_10tahun/ajak_makelove/ajak_makelove_dialogue.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class AjakMakeLoveDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    String chosenLocation = 'Kamar Tidur',
    String chosenTime = 'Malam',
    bool useCondom = false,
    bool isAccepted = true,
  }) {
    final String npcName = npc['name'] ?? 'Target';
    final String condomInfo = useCondom ? ' (memakai pengaman/kondom)' : ' (tanpa pengaman)';

    if (!isAccepted) {
      return [
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: '$npcName, maukah kita menghabiskan waktu berdua di $chosenLocation pada waktu $chosenTime$condomInfo? 🔥❤️',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: npcName,
          dialogueText: 'Maaf ya... Sepertinya saat ini suasananya belum tepat untuk kita berhubungan di $chosenLocation saat $chosenTime. 😔',
          emotion: VNEmotionType.sad,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
          choices: [
            VNChoiceOption(
              text: '😔 "Baiklah, tidak apa-apa..."',
              onSelect: (p, n) {
                p.happiness = (p.happiness - 5).clamp(0, 100);
              },
            ),
          ],
        ),
      ];
    }

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName, maukah kita menghabiskan waktu berdua di $chosenLocation pada waktu $chosenTime$condomInfo? 🔥❤️',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Aww... Tentu saja sayang. Pilihan waktu dan tempat di $chosenLocation saat $chosenTime sungguh pas. Mari kita nikmati momen ini bersama... 🔥💕',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '🔥 "Bercinta dengan mesra dan romantis..."',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 25).clamp(0, 100);
              p.health = (p.health + 2).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '❤️ "Bermanja-manja dan berpelukan hangat..."',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 20).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Momen berdua di $chosenLocation tadi sungguh luar biasa dan membuat hubungan kita semakin erat! ❤️✨',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
