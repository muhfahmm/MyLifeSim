// lib/game/widgets/vn_dialogue/vn_dialogue_models.dart
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';

enum VNBackgroundType {
  classroom,
  cafe,
  park,
  nightCity,
  office,
  snowStreet,
  bedroom,
  restaurant,
}

class VNChoiceOption {
  final String text;
  final Function(Character player, Map<String, dynamic> npc)? onSelect;
  final int? nextNodeIndex;

  VNChoiceOption({
    required this.text,
    this.onSelect,
    this.nextNodeIndex,
  });
}

class VNDialogueNode {
  final String speakerName;
  final String dialogueText;
  final VNEmotionType emotion;
  final VNOutfitType outfit;
  final bool isPlayerSpeaking;
  final VNBackgroundType background;
  final List<VNChoiceOption>? choices;
  final int? nextIndex;

  VNDialogueNode({
    required this.speakerName,
    required this.dialogueText,
    this.emotion = VNEmotionType.neutral,
    this.outfit = VNOutfitType.casual,
    this.isPlayerSpeaking = false,
    this.background = VNBackgroundType.cafe,
    this.choices,
    this.nextIndex,
  });
}

class VNLogItem {
  final String speakerName;
  final String text;

  VNLogItem({
    required this.speakerName,
    required this.text,
  });
}
