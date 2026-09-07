// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/dialog_user_perempuan/dialog_user_perempuan_makelove.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class DialogUserPerempuanMakeLove {
  /// Dialog pembuka ketika USER Perempuan mengajak pasangan
  static List<VNDialogueNode> getOpeningNodes({
    required Character player,
    required Map<String, dynamic> npc,
    required String chosenLocation,
    required String chosenTime,
    required bool useCondom,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final String condomText = useCondom ? ' (dengan pengaman)' : ' (tanpa pengaman)';

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName... malam $chosenTime di $chosenLocation ini begitu romantis. Maukah kamu memeluk dan menciumku lebih dekat$condomText? 💖',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }

  /// Pilihan opsi aksi pemain Perempuan saat keintiman berlangsung
  static List<VNChoiceOption> getIntimacyChoices({
    required Character player,
    required Map<String, dynamic> npc,
    required void Function(int happinessBonus, int healthBonus) onChoiceSelected,
  }) {
    return [
      VNChoiceOption(
        text: '💖 "Melingkarkan lengan di lehernya dan berbisik manja..."',
        onSelect: (p, n) {
          onChoiceSelected(25, 2);
        },
      ),
      VNChoiceOption(
        text: '🔥 "Membiarkannya memegang tanganmu dengan lembut..."',
        onSelect: (p, n) {
          onChoiceSelected(20, 1);
        },
      ),
    ];
  }

  /// Desahan & Rintihan dari sisi USER Perempuan (Tahap 2 Climax)
  static List<VNDialogueNode> getMoanNodes({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    
    String textMoan;
    if (player.traits.contains('Pemalu') || player.traits.contains('shy')) {
      textMoan = 'Hah... h-hah... m-merasa sangat aneh... $npcName... ahh... tapi aku suka... (Suaramu terdengar malu-malu)';
    } else if (player.traits.contains('Ekstrovert') || player.traits.contains('bold')) {
      textMoan = 'Ahh! Ya, di sana! $npcName... ahhh...! Jangan berhenti! (Suaramu lantang dan penuh gairah)';
    } else {
      // Baik Hati / Default
      textMoan = 'Ahh... $npcName... hah... aku ingin selalu dekat denganmu malam ini... ahh... (Suaramu lembut dan hangat)';
    }

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: textMoan,
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
