// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/dialog_user_laki/dialog_user_laki_makelove.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class DialogUserLakiMakeLove {
  /// Dialog pembuka ketika USER Laki-Laki mengajak pasangan
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
        dialogueText: '$npcName... suasana di $chosenLocation pada $chosenTime ini sungguh tenang. Maukah kamu bermesraan denganku$condomText? 🔥',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }

  /// Pilihan opsi aksi pemain Laki-Laki saat keintiman berlangsung
  static List<VNChoiceOption> getIntimacyChoices({
    required Character player,
    required Map<String, dynamic> npc,
    required void Function(int happinessBonus, int healthBonus) onChoiceSelected,
  }) {
    return [
      VNChoiceOption(
        text: '🔥 "Bermesraan lembut dan memanjakannya..."',
        onSelect: (p, n) {
          onChoiceSelected(25, 2);
        },
      ),
      VNChoiceOption(
        text: '💋 "Memeluk erat dan memberikan kehangatan..."',
        onSelect: (p, n) {
          onChoiceSelected(20, 1);
        },
      ),
    ];
  }

  /// Desahan & Rintihan dari sisi USER Laki-Laki (Tahap 2 Climax)
  static List<VNDialogueNode> getMoanNodes({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    
    String textMoan;
    if (player.traits.contains('Pemalu') || player.traits.contains('shy')) {
      textMoan = 'Hah... hah... a-aku malu... $npcName... tapi ahh... jangan berhenti... (Napasmu tersengal lembut)';
    } else if (player.traits.contains('Ekstrovert') || player.traits.contains('bold')) {
      textMoan = 'Ahh! $npcName... kamu sangat hebat... ahhh...! Teruskan! (Suara napasmu berat dan menggelegar)';
    } else {
      // Baik Hati / Default
      textMoan = 'Ahh... $npcName... hah... aku merasa sangat nyaman bersamamu... ahhh... (Suaramu lembut dan hangat)';
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
