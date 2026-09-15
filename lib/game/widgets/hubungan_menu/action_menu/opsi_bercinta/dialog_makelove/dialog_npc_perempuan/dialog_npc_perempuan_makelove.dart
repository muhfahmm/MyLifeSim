// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/dialog_makelove/dialog_npc_perempuan/dialog_npc_perempuan_makelove.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_npc_perempuan/desahan_npc_perempuan_makelove.dart';

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
  // LIBRARY 50 DIALOG PERCAKAPAN INTIM PEREMPUAN SHY (PEMALU)
  // ==========================================================
  static const List<String> _shyDialogues = [
    "Mmh... pelan-pelan ya sayang... w-wajahku rasanya memerah sekali...",
    "Hah... jangan tatap mataku terlalu dekat, aku merasa sangat malu...",
    "A-aku... ahh... rasanya jantungku berdegup tak karuan di dekatmu...",
    "Hah... bisakah kita saling berpelukan erat seperti ini lebih lama?",
    "Mmh... sentuhan lembut jemarimu membuat seluruh ragaku menjadi lemas...",
    "Hah... jangan tinggalkan aku... aku merasa sangat nyaman bersamamu...",
    "Aah... peluk aku dari belakang ya, aku ingin merasakan kehangatanmu...",
    "Hah... kamu membuatku tidak bisa berpikir selain tentangmu malam ini...",
    "Ahh... k-kamu mendengar desahan manjaku? Aduh malu sekali...",
    "Mmh... genggam tanganku hangat-hangat, jangan dilepas ya...",
    "Hah... bisikkan kata-kata manjamu lagi, aku sangat menyukainya...",
    "Ahh... k-kamu terlihat sangat tampan malam ini... membuat hatiku berdebar...",
    "Hah... bisakah kamu mencium pipiku perlahan dengan penuh kasih?",
    "Mmh... aku sangat sensitif di bagian ini... tapi aku menyukainya...",
    "Hah... rasakan betapa hangatnya dekapan kita di tengah keheningan malam...",
    "Ahh... jangan sentuh terlalu cepat, aku ingin menikmati detik demi detik...",
    "Hah... m-mata kita saling bertemu... membuat dadaku makin bergetar...",
    "Mmh... merinding rasanya setiap kali bibirmu menyentuh leherku...",
    "Hah... aku malu jika kamu terus memujiku seperti itu...",
    "Ahh... s-sentuh rambutku pelan-pelan, aku merasa sangat dimanja...",
    "Hah... aku tidak berani bersuara keras... takut ada yang mendengar...",
    "Mmh... pelukanmu begitu hangat bagaikan selimut di tengah dinginnya malam...",
    "Hah... aku lelah tapi sangat bahagia bisa bersamamu di sini...",
    "Ahh... tubuhku gemetar setiap kali kamu mendekapku erat-erat...",
    "Mmh... rasanya begitu damai bisa bersandar di dada bidangmu...",
    "Hah... jangan berhenti memelukku... aku merasa sangat aman...",
    "Ahh... kamu selalu berhasil membuatku merasa menjadi wanita paling spesial...",
    "Hah... bisakah kita tetap seperti ini hingga esok pagi?",
    "Mmh... kamu... kamu sungguh pintar membuatku terbuai...",
    "Hah... aku ingin selalu berada di dalam jangkauan pelukanmu...",
    "Ahh... detak jantungmu terdengar begitu menenangkan di telingaku...",
    "Mmh... aku takut momen indah ini cepat berlalu... peluk aku lagi...",
    "Hah... k-kamu... jangan buat aku makin tersipu malu...",
    "Hah... aku ingin menangis karena merasa begitu bahagia bersamamu...",
    "Mmh... jangan pernah lepaskan ikatan kasih sayang di antara kita...",
    "Hah... bisikan mesramu membuat seluruh persendianku serasa luluh...",
    "Ahh... aku ingin kamu memelukku lebih erat lagi...",
    "Mmh... rasanya seperti melayang di atas awan kebahagiaan...",
    "Hah... bersamamu adalah tempat terbaik bagi hatiku untuk berlabuh...",
    "Ahh... senyuman tipismu di kegelapan ini sungguh memikat jiwaku...",
    "Mmh... terima kasih sudah memperlakukanku dengan sangat lembut...",
    "Hah... usap jemariku pelan, aku menyukai kehangatan usapanmu...",
    "Ahh... rasa hangat ini menjalar ke seluruh lubuk hatiku yang terdalam...",
    "Mmh... bersandarlah padaku juga, aku ingin memberi kenyamanan untukmu...",
    "Hah... embusan napasmu yang hangat begitu menyejukkan rasa...",
    "Ahh... setiap rintihan bahagiaku adalah bukti betapa aku mengasihimu...",
    "Mmh... belai punggungku perlahan, rasa nyaman ini sungguh luar biasa...",
    "Hah... kebersamaan intim ini membuatku makin tak bisa jauh darimu...",
    "Ahh... tatapan ketulusan matamu selalu berhasil luluhkan hatiku...",
    "Mmh... mari kita tidur dalam dekapan pelukan penuh cinta ini..."
  ];

  // ==========================================================
  // LIBRARY 50 DIALOG PERCAKAPAN INTIM PEREMPUAN BOLD (PERCAYA DIRI / GAIRAH)
  // ==========================================================
  static const List<String> _boldDialogues = [
    "Ahh! Ya, tepat seperti itu sayang! Kamu membuatku semakin gila!",
    "Hah! Lebih erat lagi peluk aku! Aku menginginkanmu sepenuhnya malam ini!",
    "Ahh! Kamu sangat luar biasa! Jangan pernah berhenti memanjakanku!",
    "Hah! Dekatkan tubuhmu tanpa jarak! Biarkan gairah kita membara!",
    "Ahh! Kecupanmu di bibirku sungguh memabukkan dan penuh gairah!",
    "Hah! Aku suka caramu memegang pinggangku! Teruskan sayang!",
    "Ahh! Kamu membuat seluruh raga ini terbakar oleh percikan cinta!",
    "Hah! Ya, jangan takut! Bawa aku ke puncak kebahagiaan malam ini!",
    "Ahh! Aku ingin merasakan seluruh kehangatanmu menyatu denganku!",
    "Hah! Kamu tahu persis bagaimana cara membuatku tak berdaya!",
    "Ahh! Bisikkan kata-kata manjamu tepat di telingaku! Aku menyukainya!",
    "Hah! Tatap mataku saat kamu menciumku! Biarkan aku melihat cintamu!",
    "Ahh! Ya, di sana! Sentuhanmu sungguh sempurna dan tepat sasaran!",
    "Hah! Aku tidak akan melepaskanmu malam ini! Kamu milikku sepenuhnya!",
    "Ahh! Kamu pria paling hebat yang pernah memenangkan seluruh hatiku!",
    "Hah! Lebih cepat dan lebih meyakinkan! Buat malam ini tak terlupakan!",
    "Ahh! Suaramu yang berat saat berbisik membuat gairahku memuncak!",
    "Hah! Jangan berhenti sampai kita berdua merasa benar-benar puas!",
    "Ahh! Ya! Tepat seperti itu! Rasanya sungguh nikmat luar biasa!",
    "Hah! Aku suka saat kamu bersikap dominan dan penuh keyakinan!",
    "Ahh! Jangan biarkan momen penuh gairah ini berakhir begitu cepat!",
    "Hah! Kamu terlihat begitu seksi dan memikat di bawah remang lampu ini!",
    "Ahh! Aku ingin mengulangi momen kemesraan ini lagi dan lagi bersamamu!",
    "Hah! Sentuh aku di situ dan rasakan betapa hangatnya respon tubuhku!",
    "Ahh! Kebersamaan kita di sini adalah kombinasi percintaan paling sempurna!",
    "Hah! Kamu selalu tahu apa yang paling kuinginkan tanpa perlu diucapkan!",
    "Ahh! Sempurna! Jangan kurangi sedikitpun kehangatan yang kamu beri!",
    "Hah! Rasakan detak dadaku yang berpacu kencang menyambut hadirmu!",
    "Ahh! Kamu berhasil membuatku kehilangan seluruh kendali diri malam ini!",
    "Hah! Peluk leherku erat-erat dan bawa aku melayang ke awan bahagia!",
    "Ahh! Lebih erat! Biarkan raga kita menyatu dalam simfoni malam ini!",
    "Hah! Kamu membuat gairah dan rasa sayangku meledak bersamaan!",
    "Ahh! Teruskan! Aku sudah sangat dekat dengan puncak kebahagiaan!",
    "Hah! Jangan pernah ragu untuk mengeksplorasi setiap detik keintiman ini!",
    "Ahh! Kehangatan bibirmu membuatku ketagihan untuk selalu memintanya!",
    "Hah! Aku ingin kamu memegang kendali penuh atas kebahagiaanku malam ini!",
    "Ahh! Sentuhan memikatmu membuat seluruh tubuhku merinding kegirangan!",
    "Hah! Kita buat malam sunyi ini menjadi kenangan paling panas dan manis!",
    "Ahh! Rintihan nikmatku adalah hadiah atas kehebatanmu memanjakanku!",
    "Hah! Genggam tanganku kuat-kuat saat kita arungi puncak kemesraan ini!",
    "Ahh! Kamu adalah kebanggaan dan pemilik satu-satunya gairah hatiku!",
    "Hah! Jangan biarkan ada sisa dingin di antara kita, rapatkan tubuhmu!",
    "Ahh! Tatapan penuh gairahmu memberi sinyal betapa hebatnya cinta kita!",
    "Hah! Terus usap punggungku, aku sangat menyukai sensasi tegas jemarimu!",
    "Ahh! Nikmati setiap sentuhan balasan dariku, aku pun menginginkanmu!",
    "Hah! Keberanianmu memelukku membuat suasana semakin memuncak hangat!",
    "Ahh! Kamu membuat malam biasa menjadi pengalaman yang luar biasa!",
    "Hah! Teruslah berbisik manja, aku menyukai keputusasaanmu memilikiku!",
    "Ahh! Kamu telah memenangkan raga dan jiwaku secara mutlak malam ini!",
    "Hah! Mari kita tuntaskan momen intim ini dalam klimaks pelukan mesra!"
  ];

  // ==========================================================
  // LIBRARY 50 DIALOG PERCAKAPAN INTIM PEREMPUAN KIND (PENYAYANG / LEMBUT)
  // ==========================================================
  static const List<String> _kindDialogues = [
    "Ahh... sayang... aku merasa sangat bahagia dan beruntung memilikimu...",
    "Hah... kamu nyaman? Aku hanya ingin memastikan kamu merasa dicintai...",
    "Ahh... aku sangat menyayangimu, lebih dari yang bisa kuungkapkan...",
    "Hah... rasanya... hangat dan menenangkan sekali berada di sisimu...",
    "Ahh... aku ingin selalu berada dekat denganmu, dalam suka maupun duka...",
    "Hah... peluk aku lebih erat ya sayang, kehangatanmu adalah rumahku...",
    "Ahh... caramu memperlakukanku begitu lembut dan penuh rasa hormat...",
    "Hah... aku sangat percaya padamu, menyerahkan seluruh hatiku padamu...",
    "Ahh... malam ini... terasa begitu indah dan penuh kedamaian batin...",
    "Hah... aku merasa sangat dicintai dan dihargai setiap kali bersamamu...",
    "Ahh... jangan pernah pergi jauh... aku ingin bersamamu selamanya...",
    "Hah... aku ingin merasakan ketulusan detak jantungmu di dadaku...",
    "Ahh... tubuhmu... terasa begitu hangat dan memberikan kenyamanan...",
    "Hah... aku ingin selalu melindungimu dan memberikan senyuman untukmu...",
    "Ahh... aku sangat menikmati setiap momen kebersamaan yang kita lalui...",
    "Hah... kamu membuatku merasa sangat aman dari segala kegelisahan dunia...",
    "Ahh... embusan napasmu yang dekat membuat hatiku merasa tenang...",
    "Hah... aku berharap momen manis seperti ini bisa kita ulang selamanya...",
    "Ahh... kamu selalu berhasil membuat hatiku bergetar penuh kebahagiaan...",
    "Hah... aku ingin menyimpan kenangan mesra ini di relung hati terdalam...",
    "Ahh... terima kasih sudah hadir dan menjadi pasangan yang sangat tulus...",
    "Hah... ayo kita nikmati malam romantis ini dengan rasa saling mengasihi...",
    "Ahh... aku merasa sangat utuh dan sempurna berada dalam dekapanmu...",
    "Hah... aku sangat menyayangimu, tidak ada yang bisa menggantikanmu...",
    "Ahh... pelan-pelan saja sayang, aku di sini akan selalu menemanimu...",
    "Hah... jangan ragu... aku menyukai setiap sentuhan hangat darimu...",
    "Ahh... belaian lembut jemarimu membuat hatiku meleleh penuh kasih...",
    "Hah... aku ingin berbisik di telingamu betapa berharganya kamu bagiku...",
    "Ahh... aku sangat beruntung bisa membagikan momen intim ini bersamamu...",
    "Hah... semuanya terasa sangat sempurna saat kita saling memeluk...",
    "Ahh... jangan berhenti mendekapku... aku sangat menyukai ketenangan ini...",
    "Hah... kamu tahu... aku sangat menghargai setiap usaha yang kamu beri...",
    "Ahh... aku ingin tertidur lelap dalam pelukan hangatmu malam ini...",
    "Hah... kamu... adalah segalanya bagiku, jawaban atas doa-doaku...",
    "Ahh... aku merasa sangat bahagia... jangan tinggalkan aku ya sayang...",
    "Hah... aku ingin merasakan hatimu berdetak seirama dengan detak hatiku...",
    "Ahh... kamu membuatku merasa seperti wanita yang paling dicintai...",
    "Hah... jangan pernah berhenti memberikan kasih sayangmu yang tulus...",
    "Ahh... aku ingin memberikan seluruh kebahagiaan terbaik untukmu...",
    "Hah... kita akan selalu saling menopang dan bersama selamanya, kan?",
    "Ahh... kecupan hangat di keningku ini sungguh menyejukkan jiwa...",
    "Hah... tatap mataku sayang, lihatlah betapa besarnya cintaku padamu...",
    "Ahh... bisikan manjamu bagaikan penawar dari segala rasa lelahku...",
    "Hah... bersandarlah di pundakku, biarkan aku ganti memanjakanmu...",
    "Ahh... usapan lembut di pipiku terasa sungguh menentramkan hati...",
    "Hah... terima kasih atas kehangatan dan kelembutan yang selalu kau beri...",
    "Ahh... setiap helaan napasku menyuarakan rasa syukur atas hadirmu...",
    "Hah... kebersamaan ini menjadi ikatan suci yang menguatkan kita...",
    "Ahh... ketulusan cintamu adalah hadiah terbaik dalam hidupku...",
    "Hah... mari kita lelap dalam dekapan penuh cinta yang tak terhingga ini..."
  ];

  static String getRandomDialogue(Map<String, dynamic> npc) {
    final personality = _getNPCPersonality(npc);
    List<String> pool;
    switch (personality) {
      case NPCPerempuanPersonalityType.shy:
        pool = _shyDialogues;
        break;
      case NPCPerempuanPersonalityType.bold:
        pool = _boldDialogues;
        break;
      case NPCPerempuanPersonalityType.kind:
        pool = _kindDialogues;
        break;
    }
    final rand = Random();
    return pool[rand.nextInt(pool.length)];
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
      final String rawMoan = DesahanNpcPerempuanMakeLove.getRandomMoan(npc);
      
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
          moanWithCall = "Ahh... $callNpcToPlayer... $rawMoan";
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
