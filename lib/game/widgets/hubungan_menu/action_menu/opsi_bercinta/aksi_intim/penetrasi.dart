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

  /// Menghasilkan VN Dialogue Nodes sesuai pilihan penetrasi dan alat bantu (jika perempuan-perempuan)
  static List<VNDialogueNode> generatePenetrasiDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String targetPartId,
    required String partLabel,
    String targetRole = 'Pasangan',
    String? toolChoice, // 'vibrator' atau 'finger' (opsional)
    bool useLubricant = true, // 'Gunakan Pelumas' vs 'Tanpa Pelumas'
  }) {
    final String myGender = character.gender.trim().toLowerCase();
    final String partnerGender = targetGender.trim().toLowerCase();
    final bool isBothFemale = myGender == 'perempuan' && partnerGender == 'perempuan';
    final bool isPlayerMale = myGender == 'laki-laki';

    final String activeSpeakerName = character.name;
    final String targetSpeakerName = targetName;

    // Panggilan intim
    final String callToNpc = PanggilanManager.getPanggilan(
      targetName: targetName,
      targetRole: targetRole,
      targetGender: targetGender,
      isSpeakerPlayer: true,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    final String callToPlayer = PanggilanManager.getPanggilan(
      targetName: targetName,
      targetRole: targetRole,
      targetGender: targetGender,
      isSpeakerPlayer: false,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    List<VNDialogueNode> nodes = [];

    if (isBothFemale) {
      if (targetPartId == 'vagina') {
        if (toolChoice == 'vibrator') {
          final String narasiText = useLubricant
              ? '($activeSpeakerName mengoleskan pelumas lembut pada alat bantu vibrator dengan getaran halus yang hangat, membelai pelan sebelum perlahan melakukan penetrasi getar...) 🍆⚡'
              : '($activeSpeakerName menyalakan alat bantu vibrator langsung tanpa pelumas, mendorongnya perlahan yang terasa kesat nan intens ke dalam vagina $targetSpeakerName...) 🍆⚡';
          final String npcText = useLubricant
              ? 'Ahhh... nnngghh! Pelumasnya licin dan getaran vibrator ini terasa begitu intens dan nikmat di dalam vaginaku $callToPlayer... 💖'
              : 'Aww-ahh... $callToPlayer! Tanpa pelumas terasa sangat ketat dan kesat... tapi getarannya membuatku makin terangsang... 😳';

          nodes = [
            VNDialogueNode(
              speakerName: 'Narasi',
              dialogueText: narasiText,
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: targetSpeakerName,
              dialogueText: npcText,
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: activeSpeakerName,
              dialogueText: 'Rasakan getaran hangat ini $callToNpc... jepitan vaginamu gemetaran manis di sekitar alat bantu ini... 🔥',
              emotion: VNEmotionType.happy,
              isPlayerSpeaking: true,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: 'Narasi',
              dialogueText: '(Penetrasi getaran vibrator membawa arus sensasi melayang yang tak tertahankan...) ✨',
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
          ];
        } else { // finger
          final String narasiText = useLubricant
              ? '($activeSpeakerName mengoleskan cairan pelumas licin, menyelipkan jarinya yang halus dan hangat membelai pelan sebelum melakukan penetrasi jari ke dalam vagina...) 🖐️🌸'
              : '($activeSpeakerName menyelipkan jarinya yang hangat secara langsung, membelai pelan bibir intim $targetSpeakerName sebelum melakukan penetrasi jari ke dalam vagina...) 🖐️🌸';

          nodes = [
            VNDialogueNode(
              speakerName: 'Narasi',
              dialogueText: narasiText,
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: targetSpeakerName,
              dialogueText: 'Ouhh... sentuhan jarimu hangat sekali $callToPlayer... gerakkan lebih dalam dan cepat di vaginaku... 💗',
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: activeSpeakerName,
              dialogueText: 'Sentuhan jariku menyentuh titik terpeka di dalam sana $callToNpc... desahanmu membuatku makin bersemangat... 🔥',
              emotion: VNEmotionType.happy,
              isPlayerSpeaking: true,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: 'Narasi',
              dialogueText: '(Gerakan ritmis penetrasi jari menghantarkan gelombang kehangatan mesra penuh cinta...) ✨',
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
          ];
        }
      } else { // anus
        if (toolChoice == 'vibrator') {
          final String narasiText = useLubricant
              ? '($activeSpeakerName mengoleskan pelumas lembut pada alat bantu vibrator, mendorongnya perlahan ke dalam anus $targetSpeakerName dengan getaran hangat...) ⚡🔥'
              : '($activeSpeakerName perlahan mendorong alat bantu vibrator tanpa pelumas ke dalam anus $targetSpeakerName, menciptakan gesekan ketat nan menggelitik...) ⚡🔥';
          final String npcText = useLubricant
              ? 'Aww-ahh... $callToPlayer! Jepitan anusku rapat sekali... tapi pelumasnya membuat getarannya makin nikmat... 😳'
              : 'A-awww! Tanpa pelumas jepitan anusku sempit dan kesat sekali $callToPlayer... tapi getarannya membakar gairahku... 😳';

          nodes = [
            VNDialogueNode(
              speakerName: 'Narasi',
              dialogueText: narasiText,
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: targetSpeakerName,
              dialogueText: npcText,
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: activeSpeakerName,
              dialogueText: 'Tahan pelan-pelan ya $callToNpc... getaran alat ini akan membuatmu rileks dan menikmati kehangatannya... 💓',
              emotion: VNEmotionType.happy,
              isPlayerSpeaking: true,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: 'Narasi',
              dialogueText: '(Penetrasi getar di area anus menciptakan letupan sensasi bergetar yang hebat...) ✨',
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
          ];
        } else { // finger
          final String narasiText = useLubricant
              ? '($activeSpeakerName mengelus area belakang $targetSpeakerName dengan pelumas lembut, perlahan menyelipkan jarinya untuk penetrasi anal jari...) 🖐️🔥'
              : '($activeSpeakerName membelai area belakang $targetSpeakerName tanpa pelumas, perlahan meregangkan dan menyelipkan jarinya untuk penetrasi anal...) 🖐️🔥';
          final String npcText = useLubricant
              ? 'Nnnggh... jarimu berpelumas di anusku rapat dan hangat sekali $callToPlayer... rasanya begitu intim... 💗'
              : 'Aww-hh... jarimu di anusku ketat dan kesat sekali $callToPlayer... pelan-pelan yaa... 💗';

          nodes = [
            VNDialogueNode(
              speakerName: 'Narasi',
              dialogueText: narasiText,
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: targetSpeakerName,
              dialogueText: npcText,
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: activeSpeakerName,
              dialogueText: 'Kehangatan bagian belakangmu meremas jariku begitu lembut $callToNpc... nikmati sentuhanku... 💋',
              emotion: VNEmotionType.happy,
              isPlayerSpeaking: true,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: 'Narasi',
              dialogueText: '(Sentuhan lembut penetrasi jari di area belakang menghadirkan kenikmatan mendalam...) ✨',
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
          ];
        }
      }
    } else {
      // Default (Hetero / Male-Male / General)
      final String maleName = isPlayerMale ? character.name : targetName;
      final String femaleName = isPlayerMale ? targetName : character.name;

      if (targetPartId == 'vagina') {
        final String narasiText = useLubricant
            ? '($maleName mengoleskan pelumas lembut pada area intim, memposisikan pinggulnya perlahan sebelum melakukan penetrasi hangat, licin, dan dalam ke dalam vagina $femaleName...) 🌸'
            : '($maleName memposisikan pinggulnya perlahan tanpa pelumas, menyentuh lembut area intim $femaleName sebelum melakukan penetrasi hangat nan kesat ke dalam vaginanya...) 🌸';

        final String femaleText = useLubricant
            ? 'Ahhhhhh... nnngghh... $callToPlayer... Pelumasnya terasa licin dan hangat sekali... vaginaku terasa meleleh... 💗'
            : 'Aww-ahh... $callToPlayer... Tanpa pelumas terasa sangat sempit dan kesat sekali... tapi desakanmu sungguh nikmat... 💗';

        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: narasiText,
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: femaleText,
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Hah... hah... Vaginamu begitu jepitan hangatnya rapat sekali... nikmati setiap sentuhanku $callToNpc... 🔥',
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
        final String narasiText = useLubricant
            ? '($maleName mengoleskan pelumas hangat yang licin, mengelus perlahan area belakang $femaleName sebelum memposisikan diri dan meresap pelan melakukan penetrasi ke dalam anus...) 🔥'
            : '($maleName merenggangkan perlahan area belakang $femaleName tanpa pelumas, mendorong pelan namun pasti melakukan penetrasi kesat nan intens ke dalam anus...) 🔥';

        final String femaleText = useLubricant
            ? 'Ouuuhh... a-awhh... $callToPlayer... pelumasnya membantu, tapi tetap rapat dan ketat sekali! Sensasi hangatnya membakar seluruh tubuhku... 😳'
            : 'Awww-ahh! Tanpa pelumas terasa sangat sempit dan kesat sekali $callToPlayer... pelan-pelan ya... 😳';

        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: narasiText,
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: femaleText,
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Sttt... pelan-pelan ya $callToNpc, jepitan anusmu terasa sangat ketat dan nikmat luar biasa... 💦',
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
    }

    return nodes;
  }
}

