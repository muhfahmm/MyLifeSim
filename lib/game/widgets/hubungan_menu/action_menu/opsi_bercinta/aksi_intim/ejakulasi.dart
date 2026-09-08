// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/ejakulasi.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class EjakulasiHelper {
  /// Daftar opsi lokasi pengeluaran ejakulasi (khusus User Laki-laki)
  static const List<Map<String, dynamic>> ejakulasiOptions = [
    {
      'id': 'vagina_dalam',
      'label': 'Di Dalam Vagina (Creampie) 💦',
      'icon': '💦',
      'description': 'Klimaks dan mengeluarkan benih hangat sepenuhnya di dalam vagina.',
    },
    {
      'id': 'luar_perut',
      'label': 'Di Luar / Di Perut 🧴',
      'icon': '🧴',
      'description': 'Menarik keluar tepat waktu dan menyemprotkan cairan hangat di atas perut.',
    },
    {
      'id': 'wajah',
      'label': 'Di Wajah 👑',
      'icon': '👑',
      'description': 'Klimaks dan menyemprotkan cairan hangat di area wajah pasangan.',
    },
    {
      'id': 'mulut',
      'label': 'Di Dalam Mulut 👄',
      'icon': '👄',
      'description': 'Menyemprotkan cairan hangat di dalam mulut pasangan untuk ditelan.',
    },
    {
      'id': 'anus_dalam',
      'label': 'Di Dalam Anus 🔥',
      'icon': '🔥',
      'description': 'Klimaks dan mengeluarkan kehangatan penuh di dalam saluran anus.',
    },
  ];

  /// Menghasilkan VN Dialogue Nodes sesuai lokasi ejakulasi yang dipilih.
  static List<VNDialogueNode> generateEjakulasiDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String ejakulasiId,
    required String ejakulasiLabel,
    String targetRole = 'Pasangan',
  }) {
    final bool isPlayerMale = character.gender.trim().toLowerCase() == 'laki-laki';
    final String maleName = isPlayerMale ? character.name : targetName;
    final String femaleName = isPlayerMale ? targetName : character.name;

    // callFromFemale: NPC Perempuan berbicara kepada Player (isSpeakerPlayer=false)
    final String callFromFemale = PanggilanManager.getPanggilan(
      targetName: isPlayerMale ? targetName : character.name,
      targetRole: targetRole,
      targetGender: isPlayerMale ? targetGender : character.gender,
      isSpeakerPlayer: false,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    // callFromMale: Player Laki-laki berbicara kepada NPC (isSpeakerPlayer=true)
    final String callFromMale = PanggilanManager.getPanggilan(
      targetName: isPlayerMale ? targetName : character.name,
      targetRole: targetRole,
      targetGender: isPlayerMale ? character.gender : targetGender,
      isSpeakerPlayer: true,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    List<VNDialogueNode> nodes = [];

    switch (ejakulasiId) {
      case 'vagina_dalam':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName mengerang keras, mendorong sekuat tenaga hingga ke dasar vagina $femaleName dan melepaskan semburan benih hangatnya di dalam...) 💦',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Ughhh... hah... hah... hangat sekali di dalam sana! Aku keluar sepenuhnya di dalam vaginamu $callFromMale... 🔥',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Ahhh... nnngghh... $callFromFemale! Terasa hangat dan meluap-luap memenuhi bagian dalamku... nikmat luar biasa... 💗',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Sensasi kehangatan cairan di dalam vagina memberikan kepuasan puncaknya bagi kedua pasangan...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'luar_perut':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName dengan cepat menarik keluar tepat sebelum klimaks, lalu menyemprotkan benih hangatnya melumuri permukaan perut $femaleName...) 🧴',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Hah... hah... hampir saja! Cairan hangatku membasahi perut mulusmu $callFromMale... 💨',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Ouhh... $callFromFemale... cairanmu hangat sekali di perutku... napasmu masih begitu terengah-engah... ☺️',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Letupan klimaks di atas perut diakhiri dengan napas kebersamaan yang hangat dan penuh senyum...) 🌟',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'wajah':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName memegang lembut pipi $femaleName, mengarahkan klimaksnya hingga semburan hangat melumuri area wajahnya...) 👑',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Ugh... luar biasa cantiknya wajahmu terpapar kehangatanku $callFromMale... 💫',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Mmmh... $callFromFemale... hangat sekali mengenai wajahku... kamu beneran puas malam ini ya... 💋',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Semburan kehangatan di wajah memberikan kepuasan sensasional yang penuh gairah...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'mulut':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName memompa hingga detik terakhir, membiarkan semburan benihnya meluap hangat di dalam mulut $femaleName...) 👄',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Mmmph... gluk... gluk... hangat dan kental sekali $callFromFemale... aku menelannya sampai bersih... 😋',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Terima kasih sudah menelannya dengan begitu nikmat $callFromMale... 💖',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Isapan dan kecupan penutup setelah menelan memberikan puncak kepuasan tiada tara...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      default: // anus_dalam
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName erangan makin memuncak, melakukan dorongan penuh hingga benih hangat meluap melimpah di dalam anus $femaleName...) 🔥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Ahh... hah... jepitan anusmu membakar seluruh tubuhku $callFromMale! Aku melepaskannya sepenuhnya di dalam... 💦',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Nnngghh... $callFromFemale... begitu penuh dan hangat meluap di bagian belakangku... nikmatnya sampai ke ubun-ubun... 💗',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Pelepasan benih hangat di dalam anus memberikan klimaks yang begitu hebat dan bergelora...) ✨',
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
