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
  /// Pilihan yang MEMBLOKIR tombol selanjutnya (misal: pilihan cerita biasa)
  final List<VNChoiceOption>? choices;
  /// [Deprecated gunakan persistentCiumChoices / persistentPenetrasiChoices]
  final List<VNChoiceOption>? secondaryChoices;
  final int? nextIndex;

  /// Dropdown Ciuman yang PERSISTEN (tidak memblokir tombol selanjutnya)
  final List<VNChoiceOption>? persistentCiumChoices;
  /// Dropdown Penetrasi yang PERSISTEN (tidak memblokir tombol selanjutnya)
  final List<VNChoiceOption>? persistentPenetrasiChoices;
  /// Dropdown Posisi Seks yang PERSISTEN (khusus User Laki-laki)
  final List<VNChoiceOption>? persistentPosisiChoices;
  /// Dropdown Oral Seks yang PERSISTEN (Cunnilingus untuk Laki-laki, Fellatio untuk Perempuan)
  final List<VNChoiceOption>? persistentOralChoices;
  /// Dropdown Ejakulasi / Klimaks yang PERSISTEN (khusus User Laki-laki)
  final List<VNChoiceOption>? persistentEjakulasiChoices;

  VNDialogueNode({
    required this.speakerName,
    required this.dialogueText,
    this.emotion = VNEmotionType.neutral,
    this.outfit = VNOutfitType.casual,
    this.isPlayerSpeaking = false,
    this.background = VNBackgroundType.cafe,
    this.choices,
    this.secondaryChoices,
    this.nextIndex,
    this.persistentCiumChoices,
    this.persistentPenetrasiChoices,
    this.persistentPosisiChoices,
    this.persistentOralChoices,
    this.persistentEjakulasiChoices,
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
