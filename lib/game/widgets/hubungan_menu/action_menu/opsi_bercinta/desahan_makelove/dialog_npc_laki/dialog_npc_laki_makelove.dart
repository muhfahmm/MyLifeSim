// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/dialog_npc_laki/dialog_npc_laki_makelove.dart

import 'dart:math';
import 'package:flutter/material.dart'; // Tambahkan ini untuk Color
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

enum NPCLakiPersonalityType { shy, bold, kind }

// Warna Warm Amber / Gold
const Color kAmberGoldColor = Color(0xFFB45309);

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
  // LIBRARY DESAHAN LAKI-LAKI (DIPERBANYAK)
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
    // Tambahan desahan baru
    "Hah... hah... a-aku ingin bersandar padamu...",
    "Mmh... ah... tubuhku gemetar karena sentuhanmu...",
    "Ugh... hah... pelukanmu sangat hangat...",
    "Hah... hah... a-aku merasa aman bersamamu...",
    "Mmh... ahh... jangan tinggalkan aku malam ini...",
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
    // Tambahan desahan baru
    "Ugh! Hah! Lebih cepat, lebih kuat!",
    "Ahh! Kamu membuatku kehilangan kendali!",
    "Hah! Aku ingin merasakan seluruh tubuhmu!",
    "Ugh! Ahh! Jangan berhenti sampai aku puas!",
    "Ahh! Kamu tahu persis bagaimana membuatku bergairah!",
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
    // Tambahan desahan baru
    "Mmh... ahh... rasanya seperti mimpi...",
    "Hah... setiap sentuhanmu adalah doa...",
    "Ugh... aku ingin mengabadikan momen ini...",
    "Hah... tubuhmu dan jiwaku menyatu...",
    "Mmh... tenanglah, aku akan selalu di sini...",
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

  // ==========================================================
  // TAHAP 2: LOOP INTIMACY (Narasi -> Dialog Laki -> Dialog Perempuan berulang)
  // ==========================================================
  static List<VNDialogueNode> getIntimacyNodes({
    required Character player,
    required Map<String, dynamic> npc,
    required List<VNDialogueNode> playerMoanNodes,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCLakiPersonalityType personality = _getNPCPersonality(npc);
    final List<String> npcMoans = _getMoanSequence(personality, 50);
    final Random rand = Random();
    final bool isPlayerMale = player.gender.trim().toLowerCase().contains('laki');

    final List<String> narrationLines = [
      "(Cahaya keemasan meredup hangat di dalam ruangan... Tubuh kalian saling merapat di bawah selimut, menyatukan kehangatan yang mendalam...) ✨",
      "(Desahan dan rintihan bernada manja terdengar bersahutan di keheningan malam...) 🌙",
      "(Setiap sentuhan dan kecupan lembut membuat suasana semakin panas dan penuh gairah...) 🔥",
      "(Jantung kalian berdegup kencang secara bersahutan, menyatu dalam malam yang penuh cinta...) 💖",
      "(Cahaya samar menerangi momen intim kalian, setiap hembusan napas terasa begitu dekat dan mesra...) 🕯️",
      "(Kalian saling berpelukan erat, menikmati setiap detik momen keintiman tanpa henti...) ✨",
      "(Deru napas tersengal dan getaran kasih sayang memenuhi seluruh ruangan...) 🌹",
      "(Kemesraan kalian kian memuncak, menyisakan kehangatan jiwa dan raga yang tak terlupakan...) 💫",
    ];

    final List<VNDialogueNode> sequence = [];
    int playerIndex = 0;

    // Pattern Wajib: 1. Narasi -> 2. Dialog Laki-Laki -> 3. Dialog Perempuan
    for (int i = 0; i < 35; i++) {
      final String targetRole = (npc['role'] ?? npc['relation'] ?? npc['targetRole'] ?? 'Pasangan').toString();
      final String npcGender = (npc['gender'] ?? 'Laki-laki').toString();
      final String callNpcToPlayer = PanggilanManager.getPanggilan(
        targetName: npcName,
        targetRole: targetRole,
        targetGender: npcGender,
        isSpeakerPlayer: false,
        userName: player.name,
        userGender: player.gender,
        isIntimate: true,
      );

      final String narrationText = narrationLines[i % narrationLines.length];
      final String rawMoan = npcMoans[rand.nextInt(npcMoans.length)];

      final int opt = rand.nextInt(4);
      String moanWithCall;
      switch (opt) {
        case 0:
          moanWithCall = "$callNpcToPlayer... $rawMoan";
          break;
        case 1:
          moanWithCall = "$rawMoan, $callNpcToPlayer";
          break;
        case 2:
          moanWithCall = "$rawMoan, $callNpcToPlayer...";
          break;
        case 3:
        default:
          moanWithCall = "Hah... $callNpcToPlayer... $rawMoan";
          break;
      }

      final VNDialogueNode narrationNode = VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: narrationText,
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      );

      final VNDialogueNode npcLakiNode = VNDialogueNode(
        speakerName: '$npcName ($targetRole)',
        dialogueText: moanWithCall,
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      );

      final VNDialogueNode playerNode = playerMoanNodes.isNotEmpty
          ? playerMoanNodes[playerIndex % playerMoanNodes.length]
          : VNDialogueNode(
              speakerName: player.name,
              dialogueText: "Ahh... hah... aku menyukaimu...",
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: true,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            );
      playerIndex++;

      // 1. Narasi
      sequence.add(narrationNode);

      // 2. Dialog Laki-Laki -> 3. Dialog Perempuan
      if (isPlayerMale) {
        sequence.add(playerNode);
        sequence.add(npcLakiNode);
      } else {
        sequence.add(npcLakiNode);
        sequence.add(playerNode);
      }
    }

    return sequence;
  }

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