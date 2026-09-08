// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_3tahun/habiskan_waktu_bersama/habiskan_waktu_3tahun_dialogue.dart
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class HabiskanWaktu3TahunDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    String? aktivitas,
  }) {
    final String npcName = npc['name'] ?? 'Keluarga';
    final String ajakText = aktivitas != null
        ? '$npcName, ayo kita $aktivitas bersama! Seru pasti! 😄'
        : '$npcName, ayo kita main bersama! Aku bosan sendirian ⚽🎨';
    final String responseText = aktivitas != null
        ? 'Boleh boleh! Kamu mau $aktivitas bareng aku? Seru tuh! Ayo kita mulai! 🌟'
        : 'Asyik! Maukah kamu main petak umpet atau mewarnai gambar hewan bersama $npcName?';
    final String endText = aktivitas != null
        ? 'Wah $aktivitas bersama-mu tadi seru banget! Nanti kita lakukan lagi ya! 🌟'
        : 'Wah seru sekali! Waktu bermain bersamamu rasanya cepat sekali berlalu. Nanti kita main lagi ya! 🌟';

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: ajakText,
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: responseText,
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
        choices: [
          VNChoiceOption(
            text: '🎨 "Yuk, aku semangat banget!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 8).clamp(0, 100);
              p.intelligence = (p.intelligence + 2).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '🏃 "Asyik, langsung mulai aja!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 10).clamp(0, 100);
              p.health = (p.health + 3).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: endText,
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
      ),
    ];
  }
}
