// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/fingering.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class FingeringHelper {
  /// Daftar opsi teknik fingering
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

  /// Menghasilkan VN Dialogue Nodes sesuai teknik fingering yang dipilih.
  static List<VNDialogueNode> generateFingeringDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String fingeringId,
    required String fingeringLabel,
    String targetRole = 'Pasangan',
  }) {
    final bool isPlayerMale = character.gender.trim().toLowerCase() == 'laki-laki';

    // Fingering dilakukan oleh player (laki-laki) ke pasangan (perempuan)
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

    switch (fingeringId) {
      case 'gentle':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName mendekatkan tangannya perlahan, jari-jari lembut mulai membelai area intim $pasifName dengan hati-hati dan penuh perhatian...) 🌸',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Rileks saja $callFromAktif... aku akan membuatmu merasakan sensasi yang indah dan lembut... 💕',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Mmhh... $callFromPasif... jarimu begitu lembut dan hangat... perasaanku mulai melayang... 💗',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Stimulasi lembut nan perlahan berhasil membangkitkan gelombang gairah yang hangat pada $pasifName...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'passionate':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName menggerakkan jari-jarinya dengan penuh semangat, ritme yang semakin cepat membuat $pasifName menahan napas...) 🔥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Ahh... nggh... $callFromPasif! Jangan berhenti... terus... semakin cepat... 😍',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Rasakan setiap sentuhan jari-jariku $callFromAktif... kamu terasa begitu basah dan siap... 🌊',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Gairah $pasifName mencapai titik puncaknya seiring jari-jari lincah $aktifName yang tak berhenti bergerak...) 💥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'clitoris':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName dengan terampil menemukan titik klitoris $pasifName, memijatnya dengan lingkaran kecil yang presisi dan menggoda...) 💜',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Aaahh...! Di sana $callFromPasif...! Tepat di titik itu... jangan pindah... 💜',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Aku tahu cara terbaik membuatmu menikmati ini $callFromAktif... perhatikan tekanan jari-jariku... 💫',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Stimulasi klitoris yang terampil membawa $pasifName menuju gelombang kenikmatan yang tak tertahankan...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      default: // gspot
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName memasukkan jari dengan hati-hati, melengkungkannya perlahan mencari titik G $pasifName yang tersembunyi di dalam...) 💫',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'OH... $callFromPasif...! Itu dia...! Terasa berbeda dari sebelumnya... sensasinya luar biasa kuat...! 💥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Sudah kutemukan titikmu $callFromAktif... biarkan aku memanjakan titik spesialmu ini sampai puas... 🔥',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Stimulasi G-Spot yang intens mengirim gelombang kenikmatan luar biasa ke seluruh tubuh $pasifName...) 💫',
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
