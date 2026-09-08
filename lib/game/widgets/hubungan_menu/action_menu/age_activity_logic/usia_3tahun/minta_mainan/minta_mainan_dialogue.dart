// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_3tahun/minta_mainan/minta_mainan_dialogue.dart
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class MintaMainanDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Orang Tua';

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName... Boleh tidak aku minta mainan baru? Mainanku yang lama sudah bosan 🥺🚗',
        emotion: VNEmotionType.surprised,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Wah, ${player.name} mau mainan apa? Kalau kamu berjanji rajin belajar dan menurut, nanti kita beli bersama ya! 😊',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '🚗 "Mobil-mobilan balap! Aku janji bakal rajin belajar!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 10).clamp(0, 100);
              p.discipline = (p.discipline + 3).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '🧸 "Boneka lucu! Biar bisa aku ajak tidur bareng."',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 10).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '😭 "Aku mau sekarang juga! Nggak mau nunggu besok!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness - 3).clamp(0, 100);
              p.discipline = (p.discipline - 2).clamp(0, 100);
            },
            nextNodeIndex: 3,
          ),
        ],
      ),
      // Branch Index 2 (Pilihan Baik)
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Pintar sekali anakku! Ini $npcName kasih hadiah mainan barunya. Dijaga baik-baik ya! ❤️',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      // Branch Index 3 (Mengecap rewel)
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Jangan rewel begitu ya, anak pintar harus belajar sabar. Nanti kalau sudah waktunya pasti dibelikan.',
        emotion: VNEmotionType.neutral,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
