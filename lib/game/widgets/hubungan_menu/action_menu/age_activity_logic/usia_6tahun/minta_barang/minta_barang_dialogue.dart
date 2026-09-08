// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/minta_barang/minta_barang_dialogue.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class MintaBarangDialogue6Tahun {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    String? requestedItem,
    bool isGranted = true,
  }) {
    final String npcName = npc['name'] ?? 'Orang Tua';
    final String item = requestedItem ?? 'Barang Impian';

    if (!isGranted) {
      return [
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: '$npcName... Aku boleh minta $item tidak? 🥺👉👈',
          emotion: VNEmotionType.surprised,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: npcName,
          dialogueText: 'Maaf ya nak, untuk saat ini belum bisa belikan $item. Hemat dulu ya! 😔',
          emotion: VNEmotionType.sad,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    }

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName... Aku boleh minta $item tidak? Aku pengen banget! 🛍️✨',
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Boleh dong sayang! Pilihan yang sangat bagus. Yuk nanti kita beli $item buat kamu! 🎁❤️',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
