// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/minta_sepeda/minta_sepeda_dialogue.dart
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class MintaSepedaDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    bool isAccepted = true,
  }) {
    final String npcName = npc['name'] ?? 'Orang Tua';

    if (!isAccepted) {
      return [
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: '$npcName... Teman-temanku di sekolah sudah punya sepeda baru. Boleh belikan aku sepeda juga? 🚲✨',
          emotion: VNEmotionType.surprised,
          isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
          background: VNBackgroundType.park,
        ),
        VNDialogueNode(
          speakerName: npcName,
          dialogueText: 'Maaf ya nak, saat ini $npcName belum ada cukup uang untuk membelikan sepeda baru. Nanti kalau ada rezeki lebih ya! 😔❤️',
          emotion: VNEmotionType.sad,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.park,
          choices: [
            VNChoiceOption(
              text: '🥺 "Yah... Baik deh Ibu/Ayah..."',
              onSelect: (p, n) {
                p.happiness = (p.happiness - 5).clamp(0, 100);
              },
            ),
          ],
        ),
      ];
    }

    final bool isFemale = player.gender.trim().toLowerCase() == 'perempuan' ||
        player.gender.trim().toLowerCase() == 'female';

    final List<VNChoiceOption> genderChoices = isFemale
        ? [
            VNChoiceOption(
              text: '🚲 "Sepeda Mini Cantik warna Pink keranjang bunga!"',
              onSelect: (p, n) {
                p.happiness = (p.happiness + 20).clamp(0, 100);
                p.discipline = (p.discipline + 5).clamp(0, 100);
              },
              nextNodeIndex: 2,
            ),
            VNChoiceOption(
              text: '🚴 "Sepeda Lipat Cantik buat keliling komplek bareng teman!"',
              onSelect: (p, n) {
                p.happiness = (p.happiness + 18).clamp(0, 100);
                p.health = (p.health + 4).clamp(0, 100);
              },
              nextNodeIndex: 2,
            ),
          ]
        : [
            VNChoiceOption(
              text: '🚲 "Sepeda Roda Dua keren warna favoritku! Janji rajin belajar!"',
              onSelect: (p, n) {
                p.happiness = (p.happiness + 20).clamp(0, 100);
                p.discipline = (p.discipline + 5).clamp(0, 100);
              },
              nextNodeIndex: 2,
            ),
            VNChoiceOption(
              text: '🚴 "Sepeda BMX Gagah buat dipakai atraksi bareng teman!"',
              onSelect: (p, n) {
                p.happiness = (p.happiness + 18).clamp(0, 100);
                p.health = (p.health + 4).clamp(0, 100);
              },
              nextNodeIndex: 2,
            ),
          ];

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName... Teman-temanku di sekolah sudah punya sepeda baru. Boleh belikan aku sepeda juga? 🚲✨',
        emotion: VNEmotionType.surprised,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Wah, sepeda model apa yang kamu inginkan? Kalau kamu rajin dan nurut, $npcName belikan ya!',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
        choices: genderChoices,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Hore! Ini sepeda barunya! Hati-hati ya saat bersepeda di luar dan selalu pakai helm keselamatan! 🚲❤️',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.park,
      ),
    ];
  }
}
