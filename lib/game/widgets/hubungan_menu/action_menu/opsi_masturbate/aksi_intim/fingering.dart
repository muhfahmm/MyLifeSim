// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/aksi_intim/fingering.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_manager.dart';

class FingeringMasturbateHelper {
  static const List<Map<String, dynamic>> fingeringOptions = [
    {
      'id': 'gentle',
      'label': 'Lembut & Perlahan 🌸',
      'description': 'Stimulasi perlahan dengan tekanan lembut yang membangun gairah.',
    },
    {
      'id': 'passionate',
      'label': 'Penuh Gairah 🔥',
      'description': 'Gerakan cepat dan bersemangat menuju puncak kenikmatan.',
    },
    {
      'id': 'clitoris',
      'label': 'Fokus Klitoris 💜',
      'description': 'Stimulasi terfokus pada titik paling sensitif.',
    },
    {
      'id': 'gspot',
      'label': 'Stimulasi G-Spot 💫',
      'description': 'Eksplorasi titik G yang memberikan sensasi luar biasa.',
    },
  ];

  static List<VNDialogueNode> generateFingeringDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String fingeringId,
    required String fingeringLabel,
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
        dialogueText: '(${character.name} menggerakkan jari-jarinya dengan terampil untuk $fingeringLabel ke $targetName...) 👆✨',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: isPlayerMale,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: character.name,
        dialogueText: 'Rasakan sentuhan jariku $targetName... rileks dan nikmati getaran gairah ini... 💕',
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: targetName,
        dialogueText: 'Ahh... nggh... $callNpcToPlayer! Jarimu terasa begitu nikmat dan membuatku melayang... 😍',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Sentuhan jari yang lincah nan sensitif membawa $targetName mendekati gelombang kehangatan puncak...) 💥',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
