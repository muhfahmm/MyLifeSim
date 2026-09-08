// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/aksi_intim/stimulasi_manual.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_manager.dart';

class StimulasiManualMasturbateHelper {
  static List<VNDialogueNode> generateStimulasiManualDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    String targetRole = 'Pasangan',
  }) {
    final String callNpcToPlayer = PanggilanManager.getPanggilan(
      targetName: targetName,
      targetRole: targetRole,
      targetGender: targetGender,
      isSpeakerPlayer: false,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    return [
      VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '($targetName tersenyum manis, mendekat perlahan dan membelai lembut area intim ${character.name}. Gerakan jarinya yang terlatih dan hangat mulai memberikan stimulasi nikmat...) 🖐️',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: targetName,
        dialogueText: 'Biar aku yang memanjakanmu hari ini, $callNpcToPlayer... Rasakan sentuhan hangat jariku yang melingkar mesra... 💗',
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: character.name,
        dialogueText: 'Ahh... nnnggh... nikmat sekali sentuhan jarimu, $targetName! Gairahku rasanya semakin meluap-luap... 🔥',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Stimulasi manual dari $targetName berhasil meningkatkan sensasi dan gairah intim hingga ke puncaknya! Choose next action...) ✨',
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
