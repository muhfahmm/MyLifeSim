// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/minta_uang_saku/minta_uang_saku_dialogue.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class MintaUangSakuDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    int? amount,
    bool isAccepted = true,
  }) {
    final String npcName = npc['name'] ?? 'Orang Tua';

    if (!isAccepted) {
      return [
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: amount != null
              ? '$npcName... Boleh minta uang sebesar \$$amount untuk kepepet/keperluan? 💵✨'
              : '$npcName... Boleh minta uang saku untuk jajan hari ini? 💵✨',
          emotion: VNEmotionType.surprised,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.classroom,
        ),
        VNDialogueNode(
          speakerName: npcName,
          dialogueText: 'Maaf ya nak, $npcName belum bisa kasih uang sekarang. Hemat dulu ya! 😔',
          emotion: VNEmotionType.sad,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.classroom,
          choices: [
            VNChoiceOption(
              text: '🥺 "Yah... Baik deh..."',
              onSelect: (p, n) {
                p.happiness = (p.happiness - 2).clamp(0, 100);
              },
            ),
          ],
        ),
      ];
    }

    if (amount != null) {
      return [
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: '$npcName... Boleh minta uang sebesar \$$amount untuk keperluanku? 💵✨',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.classroom,
        ),
        VNDialogueNode(
          speakerName: npcName,
          dialogueText: 'Tentu saja sayang! Ini \$$amount untukmu. Gunakan secara bijak dan hemat ya! ❤️',
          emotion: VNEmotionType.blush,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.classroom,
          choices: [
            VNChoiceOption(
              text: '🎉 "Terima kasih banyak!"',
              onSelect: (p, n) {
                p.money += amount;
                p.happiness = (p.happiness + 10).clamp(0, 100);
              },
            ),
          ],
        ),
      ];
    }

    int small = 5;
    int medium = 10;
    int large = 50;

    if (player.age >= 18) {
      small = 50;
      medium = 100;
      large = 500;
    } else if (player.age >= 15) {
      small = 20;
      medium = 50;
      large = 200;
    } else if (player.age >= 12) {
      small = 10;
      medium = 25;
      large = 100;
    }

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName... Boleh minta uang saku untuk jajan dan keperluanku? 💵✨',
        emotion: VNEmotionType.surprised,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.classroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Tentu sayang! Kamu butuh uang saku berapa untuk keperluanmu hari ini?',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.classroom,
        choices: [
          VNChoiceOption(
            text: '💵 "\$$small untuk jajan dan sisanya ditabung!"',
            onSelect: (p, n) {
              p.money += small;
              p.happiness = (p.happiness + 10).clamp(0, 100);
              p.discipline = (p.discipline + 2).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '💰 "\$$medium biar bisa traktir teman!"',
            onSelect: (p, n) {
              p.money += medium;
              p.happiness = (p.happiness + 12).clamp(0, 100);
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '🤑 "\$$large buat beli barang/keperluan mahal!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness - 2).clamp(0, 100);
            },
            nextNodeIndex: 3,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Ini uang sakunya! Gunakan secara bijak dan jangan lupa tetap hemat ya! ❤️',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.classroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Waduh, kebanyakan itu sayang. Ini $npcName kasih \$$small dulu ya, belajar hemat.',
        emotion: VNEmotionType.neutral,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.classroom,
      ),
    ];
  }
}
