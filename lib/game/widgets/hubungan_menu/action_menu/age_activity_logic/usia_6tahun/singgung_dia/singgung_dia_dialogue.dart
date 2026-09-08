// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/singgung_dia/singgung_dia_dialogue.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class SinggungDiaDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    String? topik,
  }) {
    final String npcName = npc['name'] ?? 'Target';
    final String singgungText = topik != null
        ? 'Eh $npcName, soal $topik-mu itu... jujur aja ya, kurang banget deh! 😐'
        : '$npcName, kok kamu hari ini payah banget sih? Mainnya nggak seru! 😤';

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: singgungText,
        emotion: VNEmotionType.angry,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Hmph! Kenapa kamu ngomong kasar begitu? Aku nggak suka ya! 😡',
        emotion: VNEmotionType.angry,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
        choices: [
          VNChoiceOption(
            text: '😤 "Ya habisnya kamu emang gitu!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness - 10).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '😅 "Maaf deh, aku cuma bercanda..."',
            onSelect: (p, n) {
              p.happiness = (p.happiness - 3).clamp(0, 100);
            },
            nextNodeIndex: 3,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Nggak mau main sama kamu lagi! Aku mau pulang saja! 🚪💥',
        emotion: VNEmotionType.angry,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Lain kali jangan bercanda kayak begitu ya, bikin kesal tau! 😤',
        emotion: VNEmotionType.neutral,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
      ),
    ];
  }
}
