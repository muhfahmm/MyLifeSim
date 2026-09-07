// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/usia_10tahun/ajak_masturbate/ajak_masturbate_dialogue.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class AjakMasturbateDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    String chosenLocation = 'Kamar Tidur',
    String chosenTime = 'Malam',
    bool isAccepted = true,
  }) {
    final String npcName = npc['name'] ?? 'Target';

    if (!isAccepted) {
      return [
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: '$npcName, maukah kamu mengeksplorasi diri bersama di $chosenLocation pada waktu $chosenTime? 😳✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: npcName,
          dialogueText: 'Aduh... Maaf ya, aku merasa belum nyaman untuk melakukan itu saat ini. 🙈',
          emotion: VNEmotionType.sad,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
          choices: [
            VNChoiceOption(
              text: '😳 "Oh begitu... Maaf ya sudah bertanya..."',
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
        dialogueText: '$npcName, maukah kamu mengeksplorasi diri bersama di $chosenLocation pada waktu $chosenTime? 😳✨',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Waduh... Eksplorasi di $chosenLocation saat $chosenTime ya? Boleh deh kalau kamu yang minta... 😳💕',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '🔥 "Eksplorasi bersama dengan penuh gairah!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 18).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '🙈 "Malu-malu tapi merasa sangat penasaran..."',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 15).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Pengalaman di $chosenLocation tadi bikin jantungku berdebar sangat kencang! Nanti kita bahas lagi ya... 💓',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
