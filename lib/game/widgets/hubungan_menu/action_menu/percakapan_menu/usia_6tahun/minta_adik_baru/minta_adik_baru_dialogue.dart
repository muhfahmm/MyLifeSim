// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/usia_6tahun/minta_adik_baru/minta_adik_baru_dialogue.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class MintaAdikBaruDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    bool? forceSuccess,
  }) {
    final String npcName = npc['name'] ?? 'Ibu';

    // Hitung persentase persetujuan Ibu
    final int motherAge = player.motherAge ?? 30;
    int relationshipVal = 50;
    if (npc['relationship'] != null) {
      relationshipVal = int.tryParse(npc['relationship'].toString()) ?? 50;
    }

    // Persentase sukses dasar
    int consentChance = 50;
    if (relationshipVal >= 80) {
      consentChance += 25;
    } else if (relationshipVal >= 60) {
      consentChance += 10;
    } else if (relationshipVal < 40) {
      consentChance -= 20;
    }

    // Penyesuaian berdasarkan umur Ibu
    if (motherAge >= 42) {
      consentChance -= 30;
    } else if (motherAge >= 38) {
      consentChance -= 15;
    }

    consentChance = consentChance.clamp(10, 90);

    final bool isAccepted = forceSuccess ?? (DateTime.now().millisecondsSinceEpoch % 100 < consentChance);

    if (!isAccepted) {
      return [
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: '$npcName... Aku bosan main sendiri di rumah. Boleh minta adik baru buat teman main? 👶✨',
          emotion: VNEmotionType.surprised,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: npcName,
          dialogueText: 'Aww... Sayang sekali nak, saat ini $npcName dan Ayah belum siap untuk punya adik lagi. Kamu fokus sekolah dan main dulu ya! 😔❤️',
          emotion: VNEmotionType.sad,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
          choices: [
            VNChoiceOption(
              text: '🥺 "Yah... Tidak apa-apa deh Ibu..."',
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
        dialogueText: '$npcName... Aku bosan main sendiri di rumah. Boleh minta adik baru buat teman main? 👶✨',
        emotion: VNEmotionType.surprised,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Aww... Lucunya anak $npcName! Kamu beneran janji bakal bantu jagain dan sayang sama adik barumu nanti?',
        emotion: VNEmotionType.blush,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '💖 "Janji! Aku bakal jadi kakak yang baik dan rajin!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 15).clamp(0, 100);
              p.discipline = (p.discipline + 3).clamp(0, 100);
              p.motherWillTryForBaby = true;
            },
            nextNodeIndex: 2,
          ),
          VNChoiceOption(
            text: '🧸 "Janji! Aku bakal bagi mainanku buat adik!"',
            onSelect: (p, n) {
              p.happiness = (p.happiness + 12).clamp(0, 100);
              p.motherWillTryForBaby = true;
            },
            nextNodeIndex: 2,
          ),
        ],
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Nanti $npcName bicarakan sama Ayah ya. Doakan semoga kamu segera punya adik bayi yang lucu 1-2 tahun ke depan! ❤️👶',
        emotion: VNEmotionType.happy,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '🎉 "Hore! Terima kasih Ibu!"',
            onSelect: (p, n) {
              p.motherWillTryForBaby = true;
            },
          ),
        ],
      ),
    ];
  }
}
