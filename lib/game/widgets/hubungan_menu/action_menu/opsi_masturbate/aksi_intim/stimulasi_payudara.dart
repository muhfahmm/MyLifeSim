// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/aksi_intim/stimulasi_payudara.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_manager.dart';

class StimulasiPayudaraMasturbateHelper {
  static const List<Map<String, dynamic>> payudaraOptions = [
    {
      'id': 'massage',
      'label': 'Pijatan Lembut 🌸',
      'description': 'Pijatan melingkar yang halus dan hangat pada payudara.',
    },
    {
      'id': 'squeeze',
      'label': 'Remasan Mesra 🔥',
      'description': 'Remasan lembut nan bersemangat yang membangkitkan gairah.',
    },
    {
      'id': 'kiss_nipple',
      'label': 'Kecup & Isap Puting 💋',
      'description': 'Kecupan dan isapan lembut pada area puting sensitif.',
    },
    {
      'id': 'dual',
      'label': 'Kehangatan Ganda 💫',
      'description': 'Kombinasi belaian dan ciuman simultan.',
    },
  ];

  static List<VNDialogueNode> generateStimulasiPayudaraDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String payudaraId,
    required String payudaraLabel,
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
        dialogueText: '(${character.name} membelai dan memberikan $payudaraLabel pada payudara $targetName dengan mesra...) 🍑✨',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: isPlayerMale,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: character.name,
        dialogueText: 'Sensasi di payudaramu terasa begitu hangat dan lembut, $targetName... 💗',
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: targetName,
        dialogueText: 'Mmh... ah... $callNpcToPlayer... sentuhanmu di dada membuat desahanku tak bisa ditahan... 🙈🔥',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Stimulasi payudara membawa getaran kenikmatan meluap ke seluruh tubuh...) 💫',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
