// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/penetrasi.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class PenetrasiHelper {
  /// Opsi penetrasi
  static const List<Map<String, dynamic>> penetrasiOptions = [
    {
      'id': 'vagina',
      'label': 'Vagina 🌸',
      'icon': '🌸',
      'description': 'Penetrasi lembut dan penuh gairah di area kewanitaan.',
    },
    {
      'id': 'anus',
      'label': 'Anus 🔥',
      'icon': '🔥',
      'description': 'Penetrasi menggoda dan sensasional melalui jalur belakang.',
    },
  ];

  /// Menghasilkan VN Dialogue Nodes sesuai pilihan penetrasi.
  static List<VNDialogueNode> generatePenetrasiDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String targetPartId,
    required String partLabel,
    String targetRole = 'Pasangan',
  }) {
    final bool isPlayerMale = character.gender.trim().toLowerCase() == 'laki-laki';
    final String maleName = isPlayerMale ? character.name : targetName;
    final String femaleName = isPlayerMale ? targetName : character.name;

    final String callFromFemale = PanggilanManager.getPanggilan(
      targetName: isPlayerMale ? targetName : character.name,
      targetRole: targetRole,
      targetGender: isPlayerMale ? targetGender : character.gender,
      isSpeakerPlayer: !isPlayerMale,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    final String callFromMale = PanggilanManager.getPanggilan(
      targetName: isPlayerMale ? targetName : character.name,
      targetRole: targetRole,
      targetGender: isPlayerMale ? character.gender : targetGender,
      isSpeakerPlayer: isPlayerMale,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    List<VNDialogueNode> nodes = [];

    if (targetPartId == 'vagina') {
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '($maleName memposisikan pinggulnya perlahan, menyentuh lembut area intim $femaleName sebelum melakukan penetrasi hangat dan dalam ke dalam vaginanya...) 🌸',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: femaleName,
          dialogueText: 'Ahhhhhh... nnngghh... $callFromFemale... Terasa sangat sempit, hangat, dan dalam sekali... rasanya seperti meleleh... 💗',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: !isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: maleName,
          dialogueText: 'Hah... hah... Vaginamu begitu jepitan hangatnya rapat sekali... nikmati setiap sentuhanku $callFromMale... 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Gerakan ritmis dan penyatuan hangat di area vagina menghantarkan guncangan desahan kenikmatan beruntun bagi keduanya...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else {
      // anus
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '($maleName mengoleskan sedikit pelumas hangat, mengelus perlahan area belakang $femaleName sebelum mendorong pelan melakukan penetrasi ke dalam anus...) 🔥',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: femaleName,
          dialogueText: 'Ouuuhh... a-awhh... $callFromFemale... rapat dan ketat sekali! Tapi sensasi hangatnya membuat seluruh tubuhku merinding... 😳',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: !isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: maleName,
          dialogueText: 'Sttt... pelan-pelan ya $callFromMale, jepitan anusmu terasa sangat ketat dan nikmat luar biasa... 💦',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Penetrasi rapat nan mendalam di area belakang membawa letupan sensasi bergetar yang hebat...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    }

    return nodes;
  }
}
