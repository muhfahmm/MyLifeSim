// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/posisi.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class PosisiSeksHelper {
  /// Daftar opsi posisi seks
  static const List<Map<String, dynamic>> posisiOptions = [
    {
      'id': 'missionary',
      'label': 'Missionary (Tatap Muka) 👩‍❤️‍👨',
      'icon': '👩‍❤️‍👨',
      'description': 'Posisi klasik bertatap muka dengan tatapan mata intim dan kontak dada yang hangat.',
    },
    {
      'id': 'doggy',
      'label': 'Doggy Style (Dari Belakang) 🐾',
      'icon': '🐾',
      'description': 'Penetrasi mendalam dari belakang dengan tempo ritmis yang bergairah.',
    },
    {
      'id': 'cowgirl',
      'label': 'Cowgirl (Wanita Di Atas) 💃',
      'icon': '💃',
      'description': 'Pasangan wanita memegang kendali tempo dengan goyangan pinggul di atas tubuhmu.',
    },
    {
      'id': 'posisi_69',
      'label': 'Posisi 69 (Oral Saling Berhadapan) 🔄',
      'icon': '🔄',
      'description': 'Saling memberikan kenikmatan oral secara bersamaan dari posisi berbalik arah.',
    },
    {
      'id': 'spooning',
      'label': 'Spooning (Menyamping) 🌙',
      'icon': '🌙',
      'description': 'Posisi menyamping santai sambil mendekap erat tubuh pasangan dari belakang.',
    },
  ];

  /// Menghasilkan VN Dialogue Nodes sesuai posisi seks yang dipilih.
  static List<VNDialogueNode> generatePosisiDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String posisiId,
    required String posisiLabel,
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

    switch (posisiId) {
      case 'missionary':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName merebahkan $femaleName dengan lembut di atas ranjang, memegang kedua tangannya sambil bertatap mata penuh cinta dalam posisi Missionary...) 👩‍❤️‍👨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Tatapan matamu hangat sekali... dorong lebih dalam sayang, aku ingin merasakan seluruh tubuhmu menempel padaku... 💗',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Aku menyukainya ketika mata kita saling mengunci seperti ini... senyuman dan desahanmu terasa sangat dekat... 🔥',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Entakan ritmis dalam posisi bertatap muka menciptakan keintiman romantis yang begitu mendalam bagi keduanya...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'doggy':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName memposisikan $femaleName merangkak di ranjang, memegang pinggulnya dari belakang dan melakukan pendorongan mendalam dalam gaya Doggy Style...) 🐾',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Ahhh... ahh! Dalam sekali... entakan dari belakang ini membuatku gemetaran tak tertahankan! 💥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Goyangan pinggulmu dari belakang ini sangat menggairahkan... tahan sebentar ya sayang! 🔥',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Entakan cepat dari belakang memicu gelombang desahan keras yang menggebu-gebu di dalam kamar tidur...) 🌟',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'cowgirl':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($femaleName naik ke atas tubuh $maleName, memegang kendali ritme sambil memutar pinggulnya naik turun dalam posisi Cowgirl...) 💃',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Ughhh... pemandangan dirimu di atasku terlihat luar biasa seksi... gerakkan lebih cepat lagi sayang! 💦',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Nnnggh... rasanya begitu dalam saat aku mengendalikannya sendiri... nikmati sentuhanku di atasmu ya... 💋',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Goyangan indah di atas tubuh membawa sensasi kenikmatan melayang yang penuh daya pikat...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'posisi_69':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName dan $femaleName merebahkan diri berbalik arah dalam posisi 69, saling memberikan kenikmatan oral yang intens secara simultan...) 🔄',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Mmmphh... nnnggh... $callFromFemale... sentuhan lidahmu di bawah sana membuat seluruh tubuhku merinding lemas... 💗',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Mmmh... $callFromMale... isapanmu juga sungguh nikmat tiada tanding... hah... hah... 🔥',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Kenikmatan balasan beruntun dari posisi 69 membawa letupan kepuasan ganda yang sensasional...) 🌟',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      default: // spooning
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName memeluk erat $femaleName dari belakang dalam posisi Spooning, melakukan pendorongan lembut secara menyamping...) 🌙',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Dekapanmu dari belakang hangat dan nyaman sekali... bisikan napasmu di leherku bikin geli tapi enak... 😳',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Aku suka memelukmu seperti ini... terasa santai tapi begitu intim dan dalam... 💋',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Penyatuan hangat dalam dekapan menyamping menghadirkan suasana romantis yang menenangkan...) ✨',
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
