// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/penetrasi.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_npc_laki/desahan_npc_laki_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_npc_perempuan/desahan_npc_perempuan_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_user_laki/desahan_user_laki_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_user_perempuan/desahan_user_perempuan_makelove.dart';

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

    final Map<String, dynamic> npcMap = {
      'name': targetName,
      'gender': targetGender,
      'role': targetRole,
    };

    // Function to get dynamic moan formatted with calls
    String buildFormattedMoan(bool isMale, bool isPlayer, Map<String, dynamic> nMap, Character char, String callName) {
      final String raw = isPlayer
          ? (isMale ? DesahanUserLakiMakeLove.getRandomMoan(char) : DesahanUserPerempuanMakeLove.getRandomMoan(char))
          : (isMale ? DesahanNpcLakiMakeLove.getRandomMoan(nMap) : DesahanNpcPerempuanMakeLove.getRandomMoan(nMap));

      final int style = Random().nextInt(4);
      switch (style) {
        case 0:
          return '"$raw $callName..."';
        case 1:
          return '"$callName... $raw"';
        case 2:
          return '"$raw, $callName..."';
        default:
          return '"Ngh... $raw... $callName..."';
      }
    }

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
              dynamicDialogueText: () => buildFormattedMoan(false, false, npcMap, character, callToPlayer),
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: activeSpeakerName,
              dynamicDialogueText: () => buildFormattedMoan(false, true, npcMap, character, callToNpc),
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
              dynamicDialogueText: () => buildFormattedMoan(false, false, npcMap, character, callToPlayer),
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: activeSpeakerName,
              dynamicDialogueText: () => buildFormattedMoan(false, true, npcMap, character, callToNpc),
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
              dynamicDialogueText: () => buildFormattedMoan(false, false, npcMap, character, callToPlayer),
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: activeSpeakerName,
              dynamicDialogueText: () => buildFormattedMoan(false, true, npcMap, character, callToNpc),
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
              ? '($activeSpeakerName mengoleskan area belakang $targetSpeakerName dengan pelumas lembut, perlahan menyelipkan jarinya untuk penetrasi anal jari...) 🖐️🔥'
              : '($activeSpeakerName membelai area belakang $targetSpeakerName tanpa pelumas, perlahan meregangkan dan menyelipkan jarinya untuk penetrasi anal...) 🖐️🔥';

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
              dynamicDialogueText: () => buildFormattedMoan(false, false, npcMap, character, callToPlayer),
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: false,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            ),
            VNDialogueNode(
              speakerName: activeSpeakerName,
              dynamicDialogueText: () => buildFormattedMoan(false, true, npcMap, character, callToNpc),
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

      final String femaleCall = isPlayerMale ? callToPlayer : callToNpc;
      final String maleCall = isPlayerMale ? callToNpc : callToPlayer;

      if (targetPartId == 'vagina') {
        final List<String> vaginaStartLubeNaration = [
          '($maleName mengoleskan pelumas lembut pada area intim, memposisikan pinggulnya perlahan sebelum melakukan penetrasi hangat, licin, dan dalam ke dalam vagina $femaleName...) 🌸',
          '($maleName meratakan pelumas halus di bibir intim $femaleName, lalu perlahan mendorong pinggulnya masuk dengan penetrasi licin nan mendalam...) 💧🌸',
        ];
        final List<String> vaginaStartNoLubeNaration = [
          '($maleName memposisikan pinggulnya perlahan tanpa pelumas, menyentuh lembut area intim $femaleName sebelum melakukan penetrasi hangat nan kesat ke dalam vaginanya...) 🌸',
          '($maleName merapatkan tubuhnya, membelai intim sebelum menekan perlahan masuk ke dalam vagina $femaleName tanpa pelumas...) 🌸',
        ];
        final List<String> vaginaEndNaration = [
          '(Gerakan ritmis dan penyatuan hangat di area vagina menghantarkan guncangan desahan kenikmatan beruntun bagi keduanya...) ✨',
          '(Hantaman lembut nan dalam di area vagina membangkitkan guncangan gairah yang meluap-luap...) 💖',
        ];

        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dynamicDialogueText: () => (useLubricant ? vaginaStartLubeNaration : vaginaStartNoLubeNaration)[Random().nextInt(useLubricant ? vaginaStartLubeNaration.length : vaginaStartNoLubeNaration.length)],
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dynamicDialogueText: () => buildFormattedMoan(false, !isPlayerMale, npcMap, character, femaleCall),
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dynamicDialogueText: () => buildFormattedMoan(true, isPlayerMale, npcMap, character, maleCall),
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dynamicDialogueText: () => vaginaEndNaration[Random().nextInt(vaginaEndNaration.length)],
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
      } else {
        // anus
        final List<String> anusStartLubeNaration = [
          '($maleName mengoleskan pelumas hangat yang licin, mengelus perlahan area belakang $femaleName sebelum memposisikan diri dan meresap pelan melakukan penetrasi ke dalam anus...) 🔥',
          '($maleName meratakan pelumas lembut di area intim belakang, mendorong masuk secara halus dan licin ke dalam anus $femaleName...) 💧🔥',
        ];
        final List<String> anusStartNoLubeNaration = [
          '($maleName merenggangkan perlahan area belakang $femaleName tanpa pelumas, mendorong pelan namun pasti melakukan penetrasi kesat nan intens ke dalam anus...) 🔥',
          '($maleName memposisikan pinggulnya rapat tanpa pelumas, perlahan menekan masuk melakukan penetrasi anal yang ketat dan penuh gairah...) 🔥',
          '($maleName mengusap lembut panggul $femaleName, mendorong perlahan tanpa pelumas hingga sensasi kesat nan hangat memenuhi area belakang...) 🔥',
        ];
        final List<String> anusEndNaration = [
          '(Penetrasi rapat nan mendalam di area belakang membawa letupan sensasi bergetar yang hebat...) ✨',
          '(Penyatuan intensif di area belakang menghantarkan gelombang kenikmatan membakar bagi keduanya...) 💥',
          '(Gesekan rapat dan ritme dorongan anal menghadirkan sensasi puncaknya yang menggairahkan...) 🔥',
        ];

        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dynamicDialogueText: () => (useLubricant ? anusStartLubeNaration : anusStartNoLubeNaration)[Random().nextInt(useLubricant ? anusStartLubeNaration.length : anusStartNoLubeNaration.length)],
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dynamicDialogueText: () => buildFormattedMoan(false, !isPlayerMale, npcMap, character, femaleCall),
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dynamicDialogueText: () => buildFormattedMoan(true, isPlayerMale, npcMap, character, maleCall),
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dynamicDialogueText: () => anusEndNaration[Random().nextInt(anusEndNaration.length)],
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

