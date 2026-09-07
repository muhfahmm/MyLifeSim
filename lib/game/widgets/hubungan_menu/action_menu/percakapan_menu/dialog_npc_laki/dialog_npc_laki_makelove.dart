// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/dialog_npc_laki/dialog_npc_laki_makelove.dart

import 'dart:math';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

enum NPCLakiPersonalityType { shy, bold, kind }

class DialogNpcLakiMakeLove {
  static NPCLakiPersonalityType _getNPCPersonality(Map<String, dynamic> npc) {
    final String trait = (npc['personality'] ?? npc['trait'] ?? '').toString().toLowerCase();
    if (trait.contains('pemalu') || trait.contains('shy') || trait.contains('pendiam')) {
      return NPCLakiPersonalityType.shy;
    }
    if (trait.contains('ekstrovert') || trait.contains('bold') || trait.contains('gairah') || trait.contains('percaya diri')) {
      return NPCLakiPersonalityType.bold;
    }
    return NPCLakiPersonalityType.kind;
  }

  // ==========================================================
  // LIBRARY DESAHAN LAKI-LAKI (DIKATEGORIKAN BERDASARKAN KEPRIBADIAN)
  // ==========================================================
  static const List<String> _shyMoans = [
    "Hah... hah... a-aku merasa sangat canggung...",
    "Mmh... jangan tatap mataku seperti itu...",
    "Hah... sentuhanmu... membuatku gemetar...",
    "Ugh... pelan-pelan ya sayang...",
    "Hah... hah... aku... aku gugup sekali...",
    "Mmh... ahh... bisakah kita pelukan saja dulu?",
    "Hah... hah... jantungku berdegup sangat kencang...",
    "Ugh... kamu... kamu sangat indah malam ini...",
    "Hah... jangan berhenti... tapi aku malu...",
    "Mmh... ahh... napasku... tersengal...",
    "Hah... hah... a-aku mencintaimu...",
    "Ugh... jangan di situ... terasa sensitif...",
    "Hah... hah... genggam tanganku erat-erat...",
    "Mmh... ah... aku tidak biasa seperti ini...",
    "Hah... hah... kamu membuatku leleh...",
    "Ugh... s-sentuh aku lagi...",
    "Hah... hah... b-bagaimana jika ada yang mendengar?",
    "Mmh... ahh... aku sangat menyukaimu...",
    "Hah... hah... a-aku sudah tidak kuat...",
    "Ugh... ahh... berbisiklah padaku...",
  ];

  static const List<String> _boldMoans = [
    "Hah! Kamu luar biasa malam ini! Jangan berhenti!",
    "Ugh! Lebih erat lagi! Aku mau kamu sepenuhnya!",
    "Hah! Tepat seperti itu! Teruskan sayang!",
    "Ahh! Kamu membuatku semakin gila!",
    "Hah! Sentuhanmu selalu berhasil membakarku!",
    "Ugh! Jangan pelan-pelan! Aku tidak sabar!",
    "Hah! Tatap mataku! Kamu milikku malam ini!",
    "Ahh! Ya! Seperti itu! Sungguh nikmat!",
    "Hah! Aku suka saat kamu memegangku seperti ini!",
    "Ugh! Hah! Suaramu membuatku semakin bernafsu!",
    "Ahh! Biarkan aku memimpin ritmenya!",
    "Hah! Kamu terasa sangat hangat dan sempurna!",
    "Ugh! Aku tidak akan melepaskanmu malam ini!",
    "Ahh! Terus dekatkan tubuhmu padaku!",
    "Hah! Kamu sungguh hebat, sayang!",
    "Ugh! Hah! Aku hampir sampai pada puncaknya!",
    "Ahh! Rasakan detak jantungku yang membara!",
    "Hah! Kita buat malam ini tak tertandingi!",
    "Ugh! Ya! Jangan berhenti sampai kita lelah!",
    "Ahh! Kamu adalah milikku yang paling berharga!",
  ];

  static const List<String> _kindMoans = [
    "Hah... kamu membuatku merasa sangat beruntung...",
    "Mmh... rasakan kehangatanku ya sayang...",
    "Hah... aku ingin kamu merasa bahagia malam ini...",
    "Ugh... sentuhanmu begitu lembut dan menenangkan...",
    "Hah... peluk aku erat-erat, aku di sini untukmu...",
    "Mmh... ahh... kamu sangat cantik dan sempurna...",
    "Hah... aku mencintaimu lebih dari apapun...",
    "Ugh... nikmati setiap detiknya bersama ya...",
    "Hah... bisikanmu terasa sangat manis di telingaku...",
    "Mmh... bersamamu terasa sangat damai dan indah...",
    "Hah... aku tidak ingin malam ini cepat berakhir...",
    "Ugh... kehangatanmu menyatu dengan kehangatanku...",
    "Hah... sandarkan kepalamu di dadaku...",
    "Mmh... aku akan selalu menyayangimu...",
    "Hah... ketenangan ini sungguh luar biasa...",
    "Ugh... terima kasih sudah hadir di hidupku...",
    "Hah... aku akan menjagamu dengan sepenuh hati...",
    "Mmh... aku merasa utuh saat bersamamu...",
    "Hah... mari kita lewati malam romantis ini...",
    "Ugh... kamu adalah kebahagiaan terbesarku...",
  ];

  static List<String> _getMoanSequence(NPCLakiPersonalityType type, int count) {
    final List<String> pool = type == NPCLakiPersonalityType.shy
        ? _shyMoans
        : type == NPCLakiPersonalityType.bold
            ? _boldMoans
            : _kindMoans;

    final Random rand = Random();
    final List<String> result = [];
    final List<int> indices = List.generate(pool.length, (i) => i)..shuffle(rand);

    for (int i = 0; i < count && i < pool.length; i++) {
      result.add(pool[indices[i]]);
    }
    return result;
  }

  /// Dialog penolakan NPC Laki-Laki
  static VNDialogueNode getRejectionNode({
    required Map<String, dynamic> npc,
    required String chosenLocation,
    required String chosenTime,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);

    String text;
    switch (personality) {
      case NPCLakiPersonalityType.shy:
        text = 'M-maafkan aku ya... aku sedang sangat canggung dan belum siap malam ini di $chosenLocation. Lain kali pasti ya... 😔';
        break;
      case NPCLakiPersonalityType.bold:
        text = 'Haha maaf ya cantik, aku sedang kehabisan energi setelah seharian beraktivitas. Nanti kita ganti momen yang lebih panas di $chosenLocation ya! 💥';
        break;
      case NPCLakiPersonalityType.kind:
        text = 'Maafkan aku ya sayang... Aku sedang merasa kurang fit dan lelah saat ini. Kamu tetap yang terbaik, ayo kita beristirahat dulu... 🌿';
        break;
    }

    return VNDialogueNode(
      speakerName: npcName,
      dialogueText: text,
      emotion: VNEmotionType.sad,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: [
        VNChoiceOption(
          text: '😔 "Baiklah sayang, istirahatlah dulu..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 5).clamp(0, 100);
          },
        ),
      ],
    );
  }

  /// TAHAP 1: Penerimaan & Foreplay NPC Laki-Laki
  static VNDialogueNode getAcceptanceNode({
    required Map<String, dynamic> npc,
    required String chosenLocation,
    required String chosenTime,
    required List<VNChoiceOption> intimacyChoices,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);

    String text;
    switch (personality) {
      case NPCLakiPersonalityType.shy:
        text = 'M-maukah kamu... berpegangan denganku? Tempat di $chosenLocation saat $chosenTime ini sungguh membuat jantungku berdebar... 💕';
        break;
      case NPCLakiPersonalityType.bold:
        text = 'Aww... aku sudah menunggu momen ini! Tempat di $chosenLocation saat $chosenTime ini sempurna sekali... Kemarilah sayang... 🔥❤️';
        break;
      case NPCLakiPersonalityType.kind:
        text = 'Tentu saja sayang... Berada di $chosenLocation saat $chosenTime bersamamu adalah kebahagiaan bagiku. Mari kita nikmati malam ini... ❤️✨';
        break;
    }

    return VNDialogueNode(
      speakerName: npcName,
      dialogueText: text,
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: intimacyChoices,
    );
  }

  /// TAHAP 2: Desahan NPC Laki-Laki & Interaksi (Fade to Black)
  static List<VNDialogueNode> getIntimacyNodes({
    required Character player,
    required Map<String, dynamic> npc,
    required List<VNDialogueNode> playerMoanNodes,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);

    final int moanCount = 12 + Random().nextInt(5);
    final List<String> moanLines = _getMoanSequence(personality, moanCount);

    final List<VNDialogueNode> sequence = [];
    int playerMoanIndex = 0;

    for (String line in moanLines) {
      sequence.add(VNDialogueNode(
        speakerName: npcName,
        dialogueText: line,
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ));

      if (playerMoanIndex < playerMoanNodes.length) {
        sequence.add(playerMoanNodes[playerMoanIndex]);
        playerMoanIndex++;
      }
    }

    while (playerMoanIndex < playerMoanNodes.length) {
      sequence.add(playerMoanNodes[playerMoanIndex]);
      playerMoanIndex++;
    }

    sequence.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Lampu kamar meredup pekat... Tubuh kalian saling merapat di bawah selimut hangat. Hanya deru napas tersengal dan rintihan lembut yang saling bersahutan...) 🌙✨',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));

    return sequence;
  }

  /// TAHAP 3: Aftercare NPC Laki-Laki
  static VNDialogueNode getAftercareNode({
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);

    String textAftercare;
    switch (personality) {
      case NPCLakiPersonalityType.shy:
        textAftercare = 'Hah... hah... a-aku merasa sangat beruntung memilikimu... Istirahatlah dalam pelukanku ya... ❤️ (Sambil mengusap dahi kamu)';
        break;
      case NPCLakiPersonalityType.bold:
        textAftercare = 'Hah... itu tadi sungguh luar biasa! Kamu selalu berhasil membuatku kagum... Malam ini milik kita! 🔥 (Tersenyum bangga sambil merangkulmu)';
        break;
      case NPCLakiPersonalityType.kind:
        textAftercare = 'Hah... napasku masih tersengal-sengal... Berada di sisimu seperti ini adalah perasaan terbaik. Peluk aku erat-erat ya... ❤️✨';
        break;
    }

    return VNDialogueNode(
      speakerName: npcName,
      dialogueText: textAftercare,
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    );
  }
}
