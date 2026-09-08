// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/aksi_intim/oral.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_manager.dart';

class OralMasturbateHelper {
  static List<VNDialogueNode> generateOralDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String oralId,
    required String oralLabel,
    String targetRole = 'Pasangan',
  }) {
    final bool isPlayerMale = character.gender.trim().toLowerCase() == 'laki-laki';
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
        dialogueText: '(${character.name} merendahkan tubuhnya, memberikan stimulasi $oralLabel yang begitu nikmat dan intens pada $targetName...) 👅🔥',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: isPlayerMale,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: targetName,
        dialogueText: 'Ahhh... $callNpcToPlayer...! Sentuhan lidahmu sungguh luar biasa... gairahku tak tertahankan lagi! 😍',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: character.name,
        dialogueText: 'Nikmati setiap detiknya $targetName... aku senang melihatmu terbuai oleh sensasi ini... 💫',
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Aksi $oralLabel berhasil membakar gairah intim hingga ke puncak kejenuhan kenikmatan...) ✨',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
