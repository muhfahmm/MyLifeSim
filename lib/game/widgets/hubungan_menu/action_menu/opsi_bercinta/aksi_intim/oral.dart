// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/oral.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class OralSeksHelper {
  /// Mendapatkan daftar opsi oral seks sesuai gender player & target.
  static List<Map<String, dynamic>> getOralOptions({
    required String playerGender,
    required String targetGender,
  }) {
    final bool isPlayerMale = playerGender.trim().toLowerCase() == 'laki-laki';
    final bool isTargetMale = targetGender.trim().toLowerCase() == 'laki-laki';

    if (isPlayerMale && !isTargetMale) {
      // User Laki-laki + NPC Perempuan -> Cunnilingus (Laki-laki menjilat Perempuan)
      return [
        {
          'id': 'cunnilingus',
          'label': 'Cunnilingus (Oral Wanita) 👅',
          'icon': '👅',
          'description': 'Memberikan jilatan lembut dan hangat pada area sensitif pasangan wanita.',
        },
      ];
    } else if (!isPlayerMale && isTargetMale) {
      // User Perempuan + NPC Laki-laki -> Fellatio (Perempuan mengisap Laki-laki)
      return [
        {
          'id': 'fellatio',
          'label': 'Fellatio (Oral Pria) 👄',
          'icon': '👄',
          'description': 'Memberikan isapan dan kuluman penuh kehangatan pada area sensitif pasangan pria.',
        },
      ];
    } else {
      // Pasangan Sesama Jenis (Gay / Lesbian)
      return [
        {
          'id': 'cunnilingus',
          'label': 'Oral Seks (Jilatan Intim) 👅',
          'icon': '👅',
          'description': 'Memberikan sentuhan dan jilatan penuh gairah di area intim pasangan.',
        },
        {
          'id': 'fellatio',
          'label': 'Oral Seks (Kuluman Intim) 👄',
          'icon': '👄',
          'description': 'Memberikan kuluman dan isapan hangat penuh kenikmatan.',
        },
      ];
    }
  }

  /// Menghasilkan VN Dialogue Nodes sesuai pilihan oral seks.
  static List<VNDialogueNode> generateOralDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String oralId,
    required String oralLabel,
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

    if (oralId == 'cunnilingus') {
      // Cunnilingus: Laki-laki melakukan oral pada Wanita
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '($maleName merebahkan $femaleName perlahan, lalu berlutut di antara kedua pahanya dan memberikan jilatan hangat nan lembut di area kewanitaannya...) 👅',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: femaleName,
          dialogueText: 'Ahhh... ahh! $callFromFemale... sentuhan lidahmu di sana... nikmat sekali, membuat seluruh tubuhku lemas merinding! 💗',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: !isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: maleName,
          dialogueText: 'Aroma dan kehangatan tubuhmu sungguh manis... biarkan aku memanjakanmu lebih lama $callFromMale... 🔥',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Jilatan ritmis dari Cunnilingus membawa gelombang desahan manis yang semakin menggebu-gebu...) ✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else {
      // Fellatio: Perempuan melakukan oral pada Laki-laki
      nodes = [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '($femaleName berlutut perlahan di hadapan $maleName, menatap matanya penuh gairah lalu memberikan isapan dan cecapan hangat di area intim pria...) 👄',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: maleName,
          dialogueText: 'Ughhh... hah... isapan bibir dan hangatnya lidahmu di sana sungguh nikmat luar biasa... 💦',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: femaleName,
          dialogueText: 'Mmmphh... nnnggh... aku suka melihat ekspresi nikmat di wajahmu saat aku melakukannya... 💖',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: !isPlayerMale,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Gerakan lembut dari Fellatio menghantarkan getaran kenikmatan mendalam yang tak terlupakan...) 🌟',
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
