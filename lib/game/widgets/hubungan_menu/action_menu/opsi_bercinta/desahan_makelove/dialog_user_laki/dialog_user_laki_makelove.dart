// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/dialog_user_laki/dialog_user_laki_makelove.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class DialogUserLakiMakeLove {
  /// Dialog pembuka ketika USER Laki-Laki mengajak pasangan
  static List<VNDialogueNode> getOpeningNodes({
    required Character player,
    required Map<String, dynamic> npc,
    required String chosenLocation,
    required String chosenTime,
    required bool useCondom,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final String condomText = useCondom ? ' (dengan pengaman)' : ' (tanpa pengaman)';

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: '$npcName... suasana di $chosenLocation pada $chosenTime ini sungguh tenang. Maukah kamu bermesraan denganku$condomText? 🔥',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }

  /// Pilihan opsi aksi pemain Laki-Laki saat keintiman berlangsung
  static List<VNChoiceOption> getIntimacyChoices({
    required Character player,
    required Map<String, dynamic> npc,
    required void Function(int happinessBonus, int healthBonus) onChoiceSelected,
  }) {
    return [
      VNChoiceOption(
        text: '🔥 "Bermesraan lembut dan memanjakannya..."',
        onSelect: (p, n) {
          onChoiceSelected(25, 2);
        },
        nextNodeIndex: 2, // Mengarah ke loop desahan
      ),
      VNChoiceOption(
        text: '💋 "Memeluk erat dan memberikan kehangatan..."',
        onSelect: (p, n) {
          onChoiceSelected(20, 1);
        },
        nextNodeIndex: 2, // Mengarah ke loop desahan
      ),
    ];
  }

  // ==========================================================
  // LIBRARY DESAHAN LAKI-LAKI (DIPERBANYAK)
  // ==========================================================
  static const List<String> _shyMoans = [
    "Hah... hah... a-aku merasa sangat canggung...",
    "Mmh... jangan tatap mataku seperti itu...",
    "Hah... sentuhanmu... membuatku gemetar...",
    "Ugh... pelan-pelan ya sayang...",
    "Hah... hah... a-aku tidak bisa berpikir...",
    "Mmh... ahh... jantungku berdebar sangat kencang...",
    "Hah... hah... b-bagaimana jika kita ketahuan?",
    "Ugh... aku sangat malu... tapi ingin terus...",
  ];

  static const List<String> _boldMoans = [
    "Hah! Kamu luar biasa malam ini! Jangan berhenti!",
    "Ugh! Lebih erat lagi! Aku mau kamu sepenuhnya!",
    "Hah! Tepat seperti itu! Teruskan sayang!",
    "Ahh! Kamu membuatku semakin gila!",
    "Hah! Tatap mataku! Kamu milikku malam ini!",
    "Ugh! Ya! Jangan pelan-pelan!",
    "Ahh! Suaramu membuatku semakin bernafsu!",
    "Hah! Kamu tahu persis apa yang aku mau!",
  ];

  static const List<String> _kindMoans = [
    "Hah... aku ingin memastikan kamu nyaman...",
    "Mmh... rasakan kehangatanku ya sayang...",
    "Hah... aku mencintaimu lebih dari apapun...",
    "Ugh... kehangatanmu menyatu dengan kehangatanku...",
    "Hah... peluk aku erat-erat, aku di sini untukmu...",
    "Mmh... aku merasa sangat beruntung memilikimu...",
    "Hah... sandarkan kepalamu di dadaku...",
    "Ugh... nikmati setiap detiknya bersama ya...",
  ];

  /// Desahan User Laki-Laki
  static List<VNDialogueNode> getMoanNodes({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final rand = Random();
    final List<String> playerMoans = player.traits.contains('Pemalu') || player.traits.contains('shy')
        ? _shyMoans
        : player.traits.contains('Ekstrovert') || player.traits.contains('bold')
            ? _boldMoans
            : _kindMoans;

    final String npcName = npc['name'] ?? 'Pasangan';
    final String targetRole = (npc['role'] ?? npc['relation'] ?? npc['targetRole'] ?? 'Pasangan').toString();
    final String npcGender = (npc['gender'] ?? 'Perempuan').toString();
    final String callToNpc = PanggilanManager.getPanggilan(
      targetName: npcName,
      targetRole: targetRole,
      targetGender: npcGender,
      isSpeakerPlayer: true,
      userName: player.name,
      userGender: player.gender,
      isIntimate: true,
    );

    return List.generate(15, (i) {
      final String rawMoan = playerMoans[rand.nextInt(playerMoans.length)];
      final int opt = rand.nextInt(4);
      String textWithCall;
      switch (opt) {
        case 0:
          textWithCall = "$callToNpc... $rawMoan";
          break;
        case 1:
          textWithCall = "$rawMoan, $callToNpc";
          break;
        case 2:
          textWithCall = "$rawMoan, $npcName...";
          break;
        case 3:
        default:
          textWithCall = "Ahh... $npcName... $rawMoan";
          break;
      }

      return VNDialogueNode(
        speakerName: player.name,
        dialogueText: textWithCall,
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      );
    });
  }

  // ==========================================================
  // TAHAP 2: LOOP DESAHAN USER & NPC (Tanpa Henti)
  // ==========================================================
  static List<VNDialogueNode> getIntimacyNodes({
    required Character player,
    required Map<String, dynamic> npc,
    required List<VNDialogueNode> npcMoanNodes,
  }) {
    final Random rand = Random();
    final List<String> playerMoans = player.traits.contains('Pemalu') || player.traits.contains('shy')
        ? _shyMoans
        : player.traits.contains('Ekstrovert') || player.traits.contains('bold')
            ? _boldMoans
            : _kindMoans;

    final List<VNDialogueNode> sequence = [];
    int npcIndex = 0;

    // Loop sebanyak 100 iterasi, node terakhir akan kembali ke awal
    for (int i = 0; i < 100; i++) {
        // Desahan Pemain
        sequence.add(VNDialogueNode(
          speakerName: player.name,
          dialogueText: playerMoans[rand.nextInt(playerMoans.length)],
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ));

        // Desahan NPC (saling bersahutan)
        if (npcIndex < npcMoanNodes.length) {
          sequence.add(npcMoanNodes[npcIndex]);
          npcIndex++;
        } else {
          npcIndex = 0; // Loop NPC
        }
    }

    // Sisipkan Narasi Warm Amber di tengah
    sequence.insert(2, VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Cahaya keemasan memenuhi ruangan. Tubuh kalian saling merapat, dan setiap desahan yang kalian lontarkan menjadi simfoni yang tak pernah usai...) ✨',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));

    return sequence;
  }
}
