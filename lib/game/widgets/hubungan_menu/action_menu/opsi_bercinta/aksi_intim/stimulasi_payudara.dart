// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/stimulasi_payudara.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class StimulasiPayudaraHelper {
  /// Daftar opsi teknik stimulasi payudara
  static const List<Map<String, dynamic>> payudaraOptions = [
    {
      'id': 'pijat_lembut',
      'label': 'Pijat Lembut 🌸',
      'description': 'Memijat payudara dengan sentuhan hangat dan lembut.',
    },
    {
      'id': 'jilat_hisap',
      'label': 'Jilat & Hisap Puting 👄',
      'description': 'Menggunakan lidah dan bibir untuk stimulasi puting yang intens.',
    },
    {
      'id': 'gigit_ringan',
      'label': 'Gigit Ringan Puting 🔥',
      'description': 'Sentuhan gigi ringan yang memancing sensasi tajam.',
    },
    {
      'id': 'goyang_remas',
      'label': 'Remas Penuh Gairah 💜',
      'description': 'Meremas payudara dengan penuh gairah dan nafsu.',
    },
  ];

  /// Menghasilkan VN Dialogue Nodes sesuai teknik stimulasi payudara yang dipilih.
  static List<VNDialogueNode> generateStimulasiPayudaraDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String payudaraId,
    required String payudaraLabel,
    String targetRole = 'Pasangan',
  }) {
    final bool isPlayerMale = character.gender.trim().toLowerCase() == 'laki-laki';

    // Stimulasi dilakukan oleh player (laki-laki) ke pasangan (perempuan)
    // atau pasangan (laki-laki) ke player perempuan
    final String aktifName = isPlayerMale ? character.name : targetName;
    final String pasifName = isPlayerMale ? targetName : character.name;

    // callFromPasif: NPC (pasif) berbicara kepada Player (aktif)
    // isSpeakerPlayer: false karena yang berbicara adalah NPC, bukan player
    final String callFromPasif = PanggilanManager.getPanggilan(
      targetName: aktifName,
      targetRole: targetRole,
      targetGender: isPlayerMale ? character.gender : targetGender,
      isSpeakerPlayer: false,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    // callFromAktif: Player (aktif) berbicara kepada NPC (pasif)
    // isSpeakerPlayer: true karena yang berbicara adalah player
    final String callFromAktif = PanggilanManager.getPanggilan(
      targetName: pasifName,
      targetRole: targetRole,
      targetGender: isPlayerMale ? targetGender : character.gender,
      isSpeakerPlayer: true,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    List<VNDialogueNode> nodes = [];

    switch (payudaraId) {
      case 'pijat_lembut':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName mengulurkan tangan dengan lembut, telapak hangatnya mulai memijat payudara $pasifName dalam gerakan memutar yang menenangkan...) 🌸',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Mmhh... $callFromPasif... tanganmu begitu hangat dan nyaman... rasanya semua tegangan menghilang... 💗',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Payudaramu terasa sangat sempurna $callFromAktif... aku ingin terus memijatnya selamanya... 💕',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Pijatan lembut yang hangat membuat tubuh $pasifName meleleh dalam kenikmatan mesra yang tak terlupakan...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'jilat_hisap':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName mendekatkan bibirnya ke payudara $pasifName, lidahnya mulai menjilat perlahan lalu bibir hangatnya menghisap puting dengan penuh nafsu...) 👄',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Ahh...! $callFromPasif...! Lidahmu... cara hisapmu... membuat seluruh tubuhku bergetar... 💜',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Putingmu begitu reaktif $callFromAktif... aku bisa merasakan gairahmu meningkat dengan setiap hisapanku... 🔥',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Hisapan intens pada puting membuat arus listrik kenikmatan mengalir dari dada $pasifName ke seluruh tubuhnya...) 💥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'gigit_ringan':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName menggigit ringan puting $pasifName dengan presisi yang terukur, menggabungkan rasa perih kecil dan nikmat yang membakar...) 🔥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Mmph...! Itu... menyakitkan tapi nikmat sekali $callFromPasif...! Lakukan lagi... lebih keras sedikit...! 💥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Kamu suka ya $callFromAktif? Gigitan kecil ini membuatmu semakin bergairah... sungguh menggoda... 😈',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Gigitan ringan yang memadukan sakit dan nikmat membangkitkan sensasi unik yang membuat $pasifName semakin lapar akan sentuhan...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      default: // goyang_remas
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName menggenggam kedua payudara $pasifName dengan penuh semangat, meremas dan menggoyang-goyangkan dalam ritme yang penuh gairah...) 💜',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Aaahh... $callFromPasif...! Remasan tanganmu begitu kuat dan bergairah... payudaraku rasanya mau meledak...! 💗',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Payudaramu sangat sempurna $callFromAktif... aku tak bisa berhenti memegangnya... terasa begitu luar biasa... 🔥',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Remasan penuh gairah pada payudara memuncakkan birahi $pasifName, membuat tubuhnya semakin siap untuk kelanjutan yang lebih intens...) 💜',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;
    }

    return nodes;
  }
}
