// lib/game/widgets/vn_dialogue/vn_dialogue_preset.dart
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class VNDialoguePreset {
  /// 1. Skrip Percakapan Kencan / Gombalan Romantis
  static List<VNDialogueNode> getDatingDialogue({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Teman Kencan';

    return [
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Terima kasih ya sudah meluangkan waktu kencan bersamaku di tempat seindah ini! 😊',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.cafe,
      ),
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: 'Tentu saja! Aku selalu senang bisa menghabiskan waktu bersamamu.',
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: true,
        background: VNBackgroundType.cafe,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Bolehkah aku menanyakan sesuatu? Apa yang membuatmu tertarik padaku selama ini?',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.cafe,
        choices: [
          VNChoiceOption(
            text: '❤️ "Kebaikan hati dan senyuman manismu."',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 8).clamp(0, 100);
            },
            nextNodeIndex: 3,
          ),
          VNChoiceOption(
            text: '😉 "Tentu saja karena penampilanmu yang begitu menarik!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 5).clamp(0, 100);
            },
            nextNodeIndex: 4,
          ),
          VNChoiceOption(
            text: '😐 "Biasa saja sih, aku hanya sedang senggang."',
            onSelect: (p, n) {
              p.happiness = (p.happiness - 5).clamp(0, 100);
            },
            nextNodeIndex: 5,
          ),
        ],
      ),
      // Branch Index 3 (Respon Manis)
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Aww... Kamu selalu tahu cara membuat jantungku berdebar lebih cepat! 😳💕',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.cafe,
      ),
      // Branch Index 4 (Respon Gombal)
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Kamu ini pandai sekali merayu! Tapi aku menghargai pujianmu. 😊',
        emotion: VNEmotionType.happy,
        background: VNBackgroundType.cafe,
      ),
      // Branch Index 5 (Respon Dingin)
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Oh... Begitu ya. Kuharap kencan kita tidak membuatmu merasa terpaksa.',
        emotion: VNEmotionType.sad,
        background: VNBackgroundType.cafe,
      ),
    ];
  }

  /// 2. Skrip Percakapan Sekolah / Teman Sekelas
  static List<VNDialogueNode> getSchoolFriendDialogue({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Teman Sekolah';

    return [
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Hei ${player.name}! Bagaimana persiapanmu menghadapi ujian besok?',
        emotion: VNEmotionType.neutral,
        outfit: VNOutfitType.school,
        background: VNBackgroundType.classroom,
      ),
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: 'Aku sudah belajar sedikit. Bagaimana denganmu?',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: true,
        background: VNBackgroundType.classroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Maukah kamu belajar kelompok denganku sore nanti di perpustakaan?',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.school,
        background: VNBackgroundType.classroom,
        choices: [
          VNChoiceOption(
            text: '📚 "Tentu! Ayo kita belajar bersama agar nilai kita bagus!"',
            onSelect: (p, n) {
              p.intelligence = (p.intelligence + 3).clamp(0, 100);
              p.discipline = (p.discipline + 2).clamp(0, 100);
            },
            nextNodeIndex: 3,
          ),
          VNChoiceOption(
            text: '🎮 "Maaf, aku mau main game dulu sore ini."',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 3).clamp(0, 100);
            },
            nextNodeIndex: 4,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Hebat! Sampai jumpa di perpustakaan sore nanti ya! 📖✨',
        emotion: VNEmotionType.happy,
        background: VNBackgroundType.classroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Baiklah kalau begitu. Jangan lupa belajar mandiri ya!',
        emotion: VNEmotionType.neutral,
        background: VNBackgroundType.classroom,
      ),
    ];
  }
}
