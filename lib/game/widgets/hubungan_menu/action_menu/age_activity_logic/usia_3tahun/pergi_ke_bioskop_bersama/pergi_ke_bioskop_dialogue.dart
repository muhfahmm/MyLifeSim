// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_3tahun/pergi_ke_bioskop_bersama/pergi_ke_bioskop_dialogue.dart
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class PergiKeBioskopDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Teman';

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName, maukah kamu nonton film bioskop bersamaku hari ini? 🎬🍿',
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.nightCity,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Wah ide bagus! Film genre apa yang ingin kamu tonton bareng?',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.nightCity,
        choices: [
          VNChoiceOption(
            text: '🍿 "Film Komedi Romantis yang manis dan seru!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 12).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '👻 "Film Horor yang menegangkan!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 8).clamp(0, 100);
            },
            nextNodeIndex: 3,
          ),
          VNChoiceOption(
            text: '💥 "Film Laga / Action penuh ledakan!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 10).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
        ],
      ),
      // Branch Index 2 (Film Romantis/Action)
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Film tadi seru banget! Popcorn-nya juga enak. Terima kasih ya sudah mengajakku nonton! 😄🍿',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.nightCity,
      ),
      // Branch Index 3 (Film Horor)
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Aah filmnya kaget-kagetin banget! Tapi seru karena ada kamu di sampingku. 😳',
        emotion: VNEmotionType.surprised,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.nightCity,
      ),
    ];
  }
}
