// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/dialog_npc_perempuan/dialog_npc_perempuan_makelove.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

enum NPCPerempuanPersonalityType { shy, bold, kind }

const Color kAmberGoldColor = Color(0xFFB45309);

class DialogNpcPerempuanMakeLove {
  static NPCPerempuanPersonalityType _getNPCPersonality(Map<String, dynamic> npc) {
    final String trait = (npc['personality'] ?? npc['trait'] ?? '').toString().toLowerCase();
    if (trait.contains('pemalu') || trait.contains('shy') || trait.contains('pendiam')) {
      return NPCPerempuanPersonalityType.shy;
    }
    if (trait.contains('ekstrovert') || trait.contains('bold') || trait.contains('gairah') || trait.contains('percaya diri')) {
      return NPCPerempuanPersonalityType.bold;
    }
    return NPCPerempuanPersonalityType.kind;
  }

  // ==========================================================
  // LIBRARY 100+ DESAHAN WANITA (DIPERBANYAK)
  // ==========================================================
  static const List<String> _shyMoans = [
    "Mmh... ah... pelan-pelan ya...",
    "Hah... jangan lihat aku... aku malu...",
    "A-aku... ahh... tidak bisa berpikir...",
    "Hah... hah... sentuh aku lagi...",
    "Mmh... ah... itu terasa... aneh tapi enak...",
    "Hah... ahh... jangan terlalu cepat...",
    "Aah... ah... peluk aku...",
    "Hah... hah... kamu membuat jantungku berdebar...",
    "Ahh... a-aku mulai... hah... tidak bisa menahannya...",
    "Mmh... mmmh... ahh...",
    "Hah... hah... jangan berhenti... tapi malu...",
    "Ahh... k-kamu mendengar suaraku? Malu...",
    "Hah... ahh... aku ingin bersembunyi...",
    "Mmh... ah... a-aku sangat sensitif...",
    "Hah... hah... apaan ini... rasanya... ahh...",
    "Ahh... ahh... m-mata kita bertemu... jangan...",
    "Hah... j-jangan sentuh di sana... ahh...",
    "Mmh... aah... m-merinding...",
    "Hah... hah... a-aku malu tapi ingin lebih...",
    "Ahh... ah... s-sentuh rambutku...",
    "Hah... h-hah... aku tidak berani teriak...",
    "Mmh... ah... ahh... pelan-pelan...",
    "Hah... aku... ahh... aku sangat lemah...",
    "Ahh... hah... tubuhku... hah... gemetar...",
    "Mmh... mmm... ahh...",
    "Hah... hah... aku... aku tidak tahan...",
    "Ahh... ahhh... aku leleh...",
    "Hah... j-jangan berhenti...",
    "Mmh... ahh... kamu... kamu jahat...",
    "Hah... hah... a-aku ingin... ahh...",
    "Ahh... hah... a-aku sudah dekat...",
    "Mmh... ahh... aku takut... tapi senang...",
    "Hah... hah... k-kamu... jangan... ahh...",
    // Tambahan baru
    "Hah... hah... aku ingin menangis karena bahagia...",
    "Mmh... ahh... jangan pergi dari pelukanku...",
    "Hah... hah... bisikanmu membuatku lemas...",
    "Ahh... hah... a-aku ingin kau peluk lebih erat...",
    "Mmh... ah... rasanya seperti melayang...",
  ];

  static const List<String> _boldMoans = [
    "Ahh! Ya, tepat di sana! Jangan berhenti!",
    "Ahh! Lebih cepat! Aku mau lebih!",
    "Hah! Kamu sangat hebat! Ahhh!",
    "Ahh! Jangan pelan-pelan! Hah!",
    "Ahh... ahh... ya! Teruskan!",
    "Hah! Aku suka ini! Lebih dalam!",
    "Ahh! Kamu membuatku gila! Hah!",
    "Hah! Ya, jangan takut! Lakukan saja!",
    "Ahh! Aku ingin semua ini! Hah!",
    "Hah! Kamu tahu cara menyentuhku! Ahh!",
    "Ahh! Jangan main-main! Aku dekat!",
    "Hah! Hah! Lihat aku! Ahh!",
    "Ahh! Ya, di sana! Jangan pindah!",
    "Hah! Aku tidak akan tahan lama! Ahh!",
    "Ahh! Kamu hebat! Malam ini milik kita!",
    "Hah! Ahh! Lebih cepat! Lebih kuat!",
    "Ahh! Aku ingin mendengar suaramu juga!",
    "Hah! Jangan berhenti! Aku mau klimaks!",
    "Ahh! Ya! Tepat seperti itu!",
    "Hah! Aku suka saat kamu seperti ini! Ahh!",
    "Ahh! Jangan berhenti! Aku tidak bisa berpikir!",
    "Hah! Ahh! Kamu seksi banget!",
    "Ahh! Aku ingin mengulanginya lagi! Hah!",
    "Hah! Sentuh aku di sana! Ahh!",
    "Ahh! Lebih dalam lagi! Hah!",
    "Hah! Kamu tahu apa yang aku mau!",
    "Ahh! Sempurna! Jangan berhenti!",
    "Hah! Ahh! Aku sudah mau!",
    "Ahh! Ya! Kamu hebat!",
    "Hah! Ahh! Aku tidak sabar!",
    "Ahh! Lebih! Lebih! Hah!",
    "Hah! Kamu membuatku makin bernafsu! Ahh!",
    "Ahh! Ya! Teruskan! Aku sangat dekat! Hah!",
    // Tambahan baru
    "Ahh! Jangan takut membuatku kesakitan, aku suka!",
    "Hah! Aku ingin kamu menjadi milikku selamanya!",
    "Ahh! Ya! Jangan berhenti! Kamu sempurna!",
    "Hah! Aku suka saat kamu kasar dan lembut sekaligus!",
    "Ahh! Aku akan selalu mengingat malam ini!",
  ];

  static const List<String> _kindMoans = [
    "Ahh... sayang... aku sangat bahagia...",
    "Hah... kamu nyaman? Aku ingin kamu bahagia...",
    "Ahh... aku sayang kamu...",
    "Hah... rasanya... hangat sekali...",
    "Ahh... aku ingin selalu dekat denganmu...",
    "Hah... peluk aku lebih erat...",
    "Ahh... kamu sangat lembut...",
    "Hah... aku percaya padamu...",
    "Ahh... malam ini... sangat indah...",
    "Hah... aku merasa sangat dicintai...",
    "Ahh... jangan pergi... aku ingin bersamamu...",
    "Hah... aku ingin merasakanmu...",
    "Ahh... tubuhmu... sangat hangat...",
    "Hah... aku ingin melindungimu...",
    "Ahh... aku sangat menikmati ini...",
    "Hah... kamu membuatku merasa sangat aman...",
    "Ahh... napasmu... sangat dekat...",
    "Hah... aku ingin ini selamanya...",
    "Ahh... kamu membuat hatiku bergetar...",
    "Hah... aku ingin mengingat momen ini...",
    "Ahh... terima kasih sudah bersamaku...",
    "Hah... ayo kita nikmati bersama...",
    "Ahh... aku merasa sangat utuh...",
    "Hah... aku sangat menyayangimu...",
    "Ahh... pelan-pelan saja, aku di sini...",
    "Hah... jangan takut... aku ikut merasakan...",
    "Ahh... sentuhanmu... sangat lembut...",
    "Hah... aku ingin berbisik di telingamu...",
    "Ahh... aku sangat beruntung...",
    "Hah... semuanya sempurna...",
    "Ahh... jangan berhenti... aku suka ini...",
    "Hah... kamu tahu... aku sangat menghargaimu...",
    "Ahh... aku ingin tertidur di pelukanmu...",
    "Hah... kamu... adalah segalanya...",
    "Ahh... aku sudah di puncak... hah... jangan tinggalkan aku...",
    // Tambahan baru
    "Hah... aku ingin merasakan hatimu berdetak bersama hatiku...",
    "Ahh... kamu membuatku merasa seperti ratu...",
    "Hah... jangan pernah berhenti mencintaiku...",
    "Ahh... aku ingin memberikan segalanya untukmu...",
    "Hah... kita akan selalu bersama, kan?",
  ];

  static List<String> _getMoanSequence(NPCPerempuanPersonalityType type, int count) {
    final List<String> pool = type == NPCPerempuanPersonalityType.shy
        ? _shyMoans
        : type == NPCPerempuanPersonalityType.bold
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
    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);

    String text;
    switch (personality) {
      case NPCPerempuanPersonalityType.shy:
        text = 'M-maaf ya... aku merasa sangat malu dan gugup saat ini. Suasana di $chosenLocation pada waktu $chosenTime belum pas untukku... 🥺';
        break;
      case NPCPerempuanPersonalityType.bold:
        text = 'Sayang, malam ini di $chosenLocation gairahku sedang kurang menyala. Kita obrolkan yang lain dulu ya! 😉';
        break;
      case NPCPerempuanPersonalityType.kind:
        text = 'Maaf ya sayang... Hati dan pikiranku sedang kurang tenang hari ini. Mari kita berpelukan saja dulu di $chosenLocation saat $chosenTime. 💖';
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
          text: '😔 "Baiklah sayang, tidak apa-apa..."',
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
    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);

    String text;
    switch (personality) {
      case NPCPerempuanPersonalityType.shy:
        text = 'Mmh... ah... s-sentuh aku di sana... pelan-pelan ya... Wajahku rasanya memerah sekali... 💕';
        break;
      case NPCPerempuanPersonalityType.bold:
        text = 'Hah! Ya, tepat di sana! Jangan berhenti! Suasana di $chosenLocation saat $chosenTime ini membuat gairahku membara! 🔥💥';
        break;
      case NPCPerempuanPersonalityType.kind:
        text = 'Ahh... kamu nyaman? Hah... aku hanya ingin kamu bahagia dan merasa dicintai malam ini... ❤️✨';
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
    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);
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
      final String npcGender = (npc['gender'] ?? 'Perempuan').toString();
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
          moanWithCall = "$rawMoan, ${player.name}...";
          break;
        case 3:
        default:
          moanWithCall = "Ahh... ${player.name}... $rawMoan";
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

      final VNDialogueNode npcPerempuanNode = VNDialogueNode(
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
        sequence.add(npcPerempuanNode);
      } else {
        sequence.add(npcPerempuanNode);
        sequence.add(playerNode);
      }
    }

    return sequence;
  }

  static VNDialogueNode getAftercareNode({
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);

    String textAftercare;
    switch (personality) {
      case NPCPerempuanPersonalityType.shy:
        textAftercare = 'Hah... hah... m-merasa malu sekali... jangan lihat aku terus seperti itu... 🙈❤️ (Sambil menutupi wajahnya dengan bantal)';
        break;
      case NPCPerempuanPersonalityType.bold:
        textAftercare = 'Hah... itu tadi sungguh luar biasa! Aku tidak sabar untuk mengulanginya lagi denganku! 🔥 (Tersenyum lebar sambil mengusap rambutmu)';
        break;
      case NPCPerempuanPersonalityType.kind:
        textAftercare = 'Hah... kamu tidak merasa lelah atau sakit kan? Hah... aku sangat sayang padamu... ayo pelukan sampai pagi... ❤️ (Menyatukan keningnya denganmu)';
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