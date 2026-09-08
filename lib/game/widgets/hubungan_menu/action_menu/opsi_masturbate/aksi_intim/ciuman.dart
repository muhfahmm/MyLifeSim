// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/aksi_intim/ciuman.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_manager.dart';

class CiumanMasturbateHelper {
  static const List<Map<String, String>> ciumOptions = [
    {'id': 'bibir', 'label': 'Bibir'},
    {'id': 'leher', 'label': 'Leher'},
    {'id': 'pipi', 'label': 'Pipi'},
    {'id': 'dahi', 'label': 'Dahi'},
    {'id': 'telinga', 'label': 'Telinga'},
    {'id': 'tangan', 'label': 'Tangan'},
  ];

  static List<VNDialogueNode> generateCiumDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String partId,
    required String partLabel,
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
        dialogueText: '(${character.name} mendekatkan wajahnya perlahan, mendaratkan ciuman hangat di area $partLabel $targetName sambil terus melakukan masturbasi bersama...) 💋✨',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: isPlayerMale,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: character.name,
        dialogueText: 'Sentuhan ciumanku di $partLabel membuatmu semakin hangat kan, $targetName? 💖',
        emotion: VNEmotionType.happy,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: targetName,
        dialogueText: 'Mmh... $callNpcToPlayer... kecupanmu terasa sangat manis dan membuat gairahku makin membara... 🙈💕',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Kehangatan ciuman di $partLabel berpadu indah dengan ritme sentuhan intim yang kian mesra...) ✨',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }
}
