// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/berikan_pujian/berikan_pujian_dialogue.dart
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class BerikanPujianDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    String? topik,
  }) {
    final String npcName = npc['name'] ?? 'Target';
    final String pujianText = topik != null
        ? '$npcName, soal $topik-mu itu... kamu benar-benar luar biasa! Aku bangga banget! 👍✨'
        : '$npcName, kamu kelihatan hebat dan baik sekali hari ini! Aku bangga memilikimu! 👍✨';
    final String responseText = topik != null
        ? 'Aww, makasih ya ${player.name}! Kamu bilang soal $topik-ku... benar-benar bikin aku semangat! 😊💕'
        : 'Aww... Terima kasih banyak ${player.name}! Pujianmu membuat hariku jadi sangat indah! 😊💕';

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: pujianText,
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: responseText,
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '💖 "Sama-sama! Kamu memang yang terbaik!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 10).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '😄 (Tersenyum gembira melihat kebahagiaannya)',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 8).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Terima kasih atas kebaikan hatimu. Hubungan kita pasti akan selalu harmonis! ❤️',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
