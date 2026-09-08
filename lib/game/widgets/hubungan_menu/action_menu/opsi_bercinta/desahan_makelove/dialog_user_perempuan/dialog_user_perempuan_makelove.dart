// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/dialog_user_perempuan/dialog_user_perempuan_makelove.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class DialogUserPerempuanMakeLove {
  /// Dialog pembuka ketika USER Perempuan mengajak pasangan
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
        dialogueText: '$npcName... malam $chosenTime di $chosenLocation ini begitu romantis. Maukah kamu memeluk dan menciumku lebih dekat$condomText? 💖',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }

  /// Pilihan opsi aksi pemain Perempuan saat keintiman berlangsung
  static List<VNChoiceOption> getIntimacyChoices({
    required Character player,
    required Map<String, dynamic> npc,
    required void Function(int happinessBonus, int healthBonus) onChoiceSelected,
  }) {
    return [
      VNChoiceOption(
        text: '💖 "Melingkarkan lengan di lehernya dan berbisik manja..."',
        onSelect: (p, n) {
          onChoiceSelected(25, 2);
        },
        nextNodeIndex: 2, // Mengarah ke loop desahan
      ),
      VNChoiceOption(
        text: '🔥 "Membiarkannya memegang tanganmu dengan lembut..."',
        onSelect: (p, n) {
          onChoiceSelected(20, 1);
        },
        nextNodeIndex: 2, // Mengarah ke loop desahan
      ),
    ];
  }

  // ==========================================================
  // LIBRARY DESAHAN PEREMPUAN (DIPERBANYAK)
  // ==========================================================
  static const List<String> _shyMoans = [
    "Hah... h-hah... aku sangat malu...",
    "Mmh... ah... pelan-pelan ya...",
    "Hah... jangan lihat aku... aku malu...",
    "A-aku... ahh... tidak bisa berpikir...",
    "Hah... hah... kamu membuat jantungku berdebar...",
    "Ahh... a-aku mulai... hah... tidak bisa menahannya...",
    "Hah... j-jangan sentuh di sana... ahh...",
    "Mmh... ahh... aku takut... tapi senang...",
  ];

  static const List<String> _boldMoans = [
    "Ahh! Ya, tepat di sana! Jangan berhenti!",
    "Ahh! Lebih cepat! Aku mau lebih!",
    "Hah! Kamu sangat hebat! Ahhh!",
    "Ahh! Jangan pelan-pelan! Hah!",
    "Ahh! Ya! Teruskan! Aku sangat dekat!",
    "Hah! Aku suka saat kamu seperti ini!",
    "Ahh! Kamu membuatku gila!",
    "Hah! Jangan berhenti! Aku tidak bisa berpikir!",
  ];

  static const List<String> _kindMoans = [
    "Ahh... sayang... aku sangat bahagia...",
    "Hah... kamu nyaman? Aku ingin kamu bahagia...",
    "Ahh... aku sayang kamu...",
    "Hah... rasanya... hangat sekali...",
    "Ahh... aku ingin selalu dekat denganmu...",
    "Hah... peluk aku lebih erat...",
    "Ahh... kamu sangat lembut...",
    "Hah... aku ingin tertidur di pelukanmu...",
  ];

  /// Desahan User Perempuan
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
    final String npcGender = (npc['gender'] ?? 'Laki-laki').toString();
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