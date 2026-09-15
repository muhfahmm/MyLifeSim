// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/dialog_makelove/dialog_npc_laki/dialog_npc_laki_makelove.dart

import 'dart:math';
import 'package:flutter/material.dart'; // Tambahkan ini untuk Color
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_npc_laki/desahan_npc_laki_makelove.dart';

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
  // LIBRARY 50 DIALOG PERCAKAPAN INTIM SHY (PEMALU)
  // ==========================================================
  static const List<String> _shyDialogues = [
    "Hah... aku merasa sangat canggung tapi hatiku begitu bahagia bersamamu...",
    "Mmh... bisakah kita saling berpelukan erat seperti ini dulu?",
    "Hah... sentuhan jarimu di dadaku membuat jantungku berdebar tak karuan...",
    "Ugh... kamu terlihat begitu manis malam ini, membuatku makin malu...",
    "Hah... bisikkan namaku lagi, aku suka mendengar suaramu yang lembut...",
    "Mmh... genggam tanganku hangat-hangat ya, jangan dilepas...",
    "Hah... aku selalu gugup setiap kali mata kita bertemu di keheningan ini...",
    "Ugh... kehangatan tubuhmu sungguh menenangkan jiwaku...",
    "Hah... bisakah kita perlambat ritmenya agar momen ini terasa lebih lama?",
    "Mmh... kecupanmu di bibirku terasa begitu manis dan tulus...",
    "Hah... jangan tatap aku seperti itu, wajahku rasanya merona sekali...",
    "Ugh... bersamamu di sini adalah impian sederhana yang sangat kuinginkan...",
    "Hah... rasakan betapa cepatnya detak dadaku saat memelukmu...",
    "Mmh... pelan-pelan ya, aku ingin menikmati setiap detik kebersamaan kita...",
    "Hah... rintihan kecilmu membuat gairah dan kasih sayangku menyatu...",
    "Ugh... kamu sangat berarti bagiku, lebih dari apapun di dunia ini...",
    "Hah... bersandarlah di bahuku jika kamu merasa lelah...",
    "Mmh... aku berjanji akan selalu memperlakukanmu dengan lembut...",
    "Hah... sentuhan lembut di pipimu ini adalah tanda betapa aku mencintaimu...",
    "Ugh... bisakah kita tetap seperti ini tanpa perlu terburu-buru?",
    "Hah... napas hangatmu di leherku membuat seluruh raga ini luluh...",
    "Mmh... belai rambutku perlahan, aku merasa sangat aman di pelukanmu...",
    "Hah... tatapan matamu yang penuh kasih selalu berhasil menyejukkan hatiku...",
    "Ugh... setiap kecupan manis darimu membuatku merasa menjadi pria paling beruntung...",
    "Hah... jangan lepaskan dekapan ini, kehangatanmu adalah kenyamanan utamaku...",
    "Mmh... aku akan mendengarkan setiap desahan manis yang keluar dari bibirmu...",
    "Hah... pelukan ini begitu hangat hingga aku enggan malam cepat berlalu...",
    "Ugh... kelembutan caramu menyentuhku sungguh menyentuh lubuk hatiku...",
    "Hah... bisikan sayangmu bagaikan melodi yang paling indah di telingaku...",
    "Mmh... aku ingin menjaga momen romantis ini dengan segenap kasih sayangku...",
    "Hah... terima kasih sudah hadir dan melengkapi hari-hari sepi dalam hidupku...",
    "Ugh... usapan lembut jemarimu di jemariku terasa sungguh menentramkan...",
    "Hah... tetaplah dekat denganku, aku tak ingin ada jarak di antara kita...",
    "Mmh... senyuman tipismu di tengah malam ini selalu berhasil mencuri hatiku...",
    "Hah... rasakan getaran cinta yang terus mengalir di antara kita berdua...",
    "Ugh... bersamamu membuatku yakin bahwa cinta yang tulus itu sungguh nyata...",
    "Hah... biarkan aku mendekapmu lebih erat agar kamu merasakan kehangatan ini...",
    "Mmh... bimbing tanganku jika ada hal yang membuatmu merasa lebih nyaman...",
    "Hah... embusan napasmu yang tersengal terdengar sangat menggemaskan bagiku...",
    "Ugh... jangan pernah ragu untuk bersandar padaku kapanpun kamu butuh tempat berlabuh...",
    "Hah... kecupan hangat di keningmu ini adalah bentuk rasa hormat dan cintaku...",
    "Mmh... kelembutan rasa ini membuat malam kelam menjadi begitu bersinar...",
    "Hah... aku merasa sangat diberkati bisa membagikan rasa intim ini bersamamu...",
    "Ugh... berbisiklah pelan, aku akan selalu setia menyimak setiap bait kata-katamu...",
    "Hah... desahan halusmu mengalir pelan mengisi keheningan malam yang sunyi...",
    "Mmh... senandung mesramu terasa bagaikan doa kebahagiaan bagi hubungan kita...",
    "Hah... tataplah aku dengan kedalaman rasa yang selalu berhasil membuaiku...",
    "Ugh... kehangatan belaianmu meresap jauh hingga ke relung hatiku yang terdalam...",
    "Hah... malam ini menjadi saksi betapa murninya cinta yang kita rajut bersama...",
    "Mmh... tetaplah bersamaku dalam kehangatan pelukan mesra ini selamanya..."
  ];

  // ==========================================================
  // LIBRARY 50 DIALOG PERCAKAPAN INTIM BOLD (PERCAYA DIRI / GIGIH)
  // ==========================================================
  static const List<String> _boldDialogues = [
    "Hah! Kamu terlihat luar biasa malam ini, membuatku tak ingin melepaskanmu!",
    "Ugh! Lebih dekat lagi padaku, biarkan aku merasakan seluruh kehangatanmu!",
    "Hah! Tatap mataku erat-erat, malam ini kamu sepenuhnya milikku!",
    "Ahh! Sentuhanmu sungguh membakar gairahku, teruskan sayang!",
    "Hah! Kamu tahu persis bagaimana cara membuatku bertekuk lutut di hadapanmu!",
    "Ugh! Jangan tahan desahanmu, biarkan aku mendengar betapa nikmatnya malam ini!",
    "Hah! Ikuti ritmeku, kita buat malam penuh cinta ini takkan pernah terlupakan!",
    "Ahh! Kamu begitu menggoda, membuatku ingin memberikan semua energi cintaku!",
    "Hah! Peluk leherku erat-erat dan rasakan betapa hebatnya gairah kita menyatu!",
    "Ugh! Kebersamaan denganmu selalu berhasil memicu adrenalin kebahagiaan terbaik!",
    "Hah! Jangan pelan-pelan, biarkan gairah mesra kita memuncak tanpa batas!",
    "Ahh! Kecupan di bibirmu membuatku ketagihan untuk menikmatinya berulang kali!",
    "Hah! Bisikkan kata-kata manjamu tepat di telingaku, aku menyukai keberanianmu!",
    "Ugh! Setiap sentuhanmu di tubuhku menyalakan api percikan cinta yang membara!",
    "Hah! Rangkul pinggangku dan biarkan aku membawamu ke puncak kebahagiaan malam ini!",
    "Ahh! Suaramu yang penuh desahan membuatku semakin tak sabar memanjakanmu!",
    "Hah! Kita diciptakan untuk saling melengkapi dalam momen intim penuh gairah ini!",
    "Ugh! Jangan lepaskan pandanganmu, aku ingin melihat binar kebahagiaan di matamu!",
    "Hah! Gerakanmu begitu indah dan penuh keyakinan, aku sangat menyukainya!",
    "Ahh! Biarkan seluruh kehangatan ini memenuhi ruangan hingga pagi menjelang!",
    "Hah! Kamu adalah kombinasi sempurna antara kecantikan dan gairah yang membara!",
    "Ugh! Teruskan sentuhan manjamu di situ, kamu membuatku makin tak terkendali!",
    "Hah! Dekatkan tubuhmu tanpa sisa jarak, kita buat malam ini milik kita berdua!",
    "Ahh! Rintihanmu adalah musik paling menggebu yang pernah kudengar dalam hidupku!",
    "Hah! Genggam bahuku erat-erat saat gairah ini membawa kita melayang tinggi!",
    "Ugh! Kamu sungguh luar biasa, tidak ada yang bisa menandingi pesonamu!",
    "Hah! Nikmati setiap hembusan gairah ini, aku ada di sini sepenuhnya untukmu!",
    "Ahh! Kecupan panas di lehermu akan mengingatkanmu betapa dalamnya cintaku!",
    "Hah! Jangan ragu untuk menunjukkan betapa besarnya rasa manjamu padaku!",
    "Ugh! Keberanianmu merangkulku membuat suasana malam ini semakin memuncak!",
    "Hah! Bisikkan apa yang paling kamu inginkan malam ini, aku akan mewujudkannya!",
    "Ahh! Kehangatan kita menyatu bagaikan simfoni malam yang sangat megah!",
    "Hah! Rasakan detak jantungku yang berpacu kencang menyambut keindahanmu!",
    "Ugh! Kamu membuat malam biasa menjadi pengalaman percintaan yang sangat berharga!",
    "Hah! Pegang tanganku dan rasakan getaran energi percintaan yang meluap-luap!",
    "Ahh! Desahan manjamu memacu semangatku untuk memberikan yang terbaik bagimu!",
    "Hah! Jangan biarkan momen penuh gairah ini berakhir terlalu cepat, sayang!",
    "Ugh! Sentuhan memikatmu selalu berhasil melumpuhkan seluruh pertahananku!",
    "Hah! Kebersamaan kita di sini adalah kombinasi cinta paling membara yang ada!",
    "Ahh! Tatapan penuh gairahmu memberi sinyal bahwa malam ini sungguh sempurna!",
    "Hah! Teruslah mengusap dadaku, aku menyukai sensasi hangat dari jemarimu!",
    "Ugh! Kita adalah pasangan paling serasi saat menyatukan raga dalam cinta ini!",
    "Hah! Dengarkan deru napasku yang tersengal, semuanya dipicu oleh kecantikanmu!",
    "Ahh! Jangan berhenti memanjakanku, biarkan malam ini menjadi saksi cinta kita!",
    "Hah! Kehangatan bibirmu di bibirku adalah kombinasi rasa paling memabukkan!",
    "Ugh! Dekap tubuhku sekuat yang kamu bisa, kita arungi puncak kebahagiaan ini!",
    "Hah! Rintihan penuh nikmatmu membuktikan betapa indahnya rasa saling memiliki!",
    "Ahh! Nikmati setiap detik sapuan mesra ini, aku takkan membiarkanmu merasa sepi!",
    "Hah! Kamu telah memenangkan seluruh hati dan gairahku secara mutlak malam ini!",
    "Ugh! Mari kita tuntaskan kebersamaan intim ini dalam pelukan kemesraan sejati!"
  ];

  // ==========================================================
  // LIBRARY 50 DIALOG PERCAKAPAN INTIM KIND (PENYAYANG / LEMBUT)
  // ==========================================================
  static const List<String> _kindDialogues = [
    "Hah... kamu membuatku merasa menjadi pria paling bahagia di dunia ini...",
    "Mmh... rasakan kehangatan dadaku ya sayang, aku di sini selalu memelukmu...",
    "Hah... aku ingin memastikan kamu merasa nyaman dan dicintai di setiap detik...",
    "Ugh... sentuhan jemarimu begitu lembut, memberikan kedamaian di hatiku...",
    "Hah... peluk aku erat-erat, tidak ada tempat yang lebih aman dari dekapan ini...",
    "Mmh... kecupan manis di bibirmu adalah bentuk ketulusan cintaku padamu...",
    "Hah... aku mencintaimu lebih dari kata-kata yang bisa kuucapkan malam ini...",
    "Ugh... nikmati setiap moment kebersamaan ini dengan tenang dan penuh kehangatan...",
    "Hah... bisikan lembutmu terasa bagaikan embun sejuk yang menyegarkan jiwaku...",
    "Mmh... bersamamu di sini membuat seluruh lelah di hariku sirnah seketika...",
    "Hah... aku tidak ingin malam romantis yang tenang ini cepat berlalu begitu saja...",
    "Ugh... kehangatan jiwamu menyatu sempurna dengan kehangatan ragaku...",
    "Hah... sandarkan kepalamu di manapun kamu mau, aku akan menopangmu penuh kasih...",
    "Mmh... aku akan selalu menyayangi dan menjagamu dalam kondisi apapun...",
    "Hah... kedamaian di mata indahmu membuat hatiku bergetar penuh syukur...",
    "Ugh... terima kasih sudah hadir dan membagikan kasih sayangmu yang tulus...",
    "Hah... aku akan melindungimu dan memanjakanmu dengan sepenuh jiwa dan ragaku...",
    "Mmh... aku merasa utuh dan sempurna setiap kali memelukmu seperti ini...",
    "Hah... mari kita lewati malam mesra ini dengan rasa saling menghargai...",
    "Ugh... kamu adalah kebahagiaan terbesar yang pernah dianugerahkan padaku...",
    "Hah... kecupan lembut di keningmu adalah pengingat betapa berharganya kamu...",
    "Mmh... dengarkan detak jantungku, setiap ketukannya menyuarakan namamu...",
    "Hah... kelembutan usapanmu membuatku merasa sangat dihormati dan dicintai...",
    "Ugh... tataplah aku dengan kasih sayangmu yang selalu memberikan kedamaian...",
    "Hah... tidak ada hal yang lebih indah daripada melihat senyum bahagia di wajahmu...",
    "Mmh... biarkan aku mengusap jemarimu dan memberikan kehangatan di tengah malam...",
    "Hah... setiap helaan napas kita malam ini menguatkan ikatan cinta di antara kita...",
    "Ugh... berada di sisimu membuatku mengerti arti sejati dari cinta yang tulus...",
    "Hah... bisikan mesramu menenangkan setiap kegelapan dan keraguan dalam diriku...",
    "Mmh... bersandarlah padaku, aku akan menjadi pelindung setia dalam hidupmu...",
    "Hah... kecupan mesra ini adalah tanda betapa aku menghormati dan mengasihimu...",
    "Ugh... ketulusan caramu mendekapku memberikan rasa damai yang belum pernah ada...",
    "Hah... mari kita rajut kenangan indah yang akan terus membahagiakan kita...",
    "Mmh... kehangatan batin kita menyatu bagaikan simfoni kebahagiaan abadi...",
    "Hah... terima kasih sudah mempercayaiku untuk membagikan rasa intim yang suci ini...",
    "Ugh... setiap detik yang dihabiskan bersamamu adalah berkah yang sangat kubanggakan...",
    "Hah... belai pipiku pelan, aku menyukai kelembutan dari setiap usapan tanganmu...",
    "Mmh... pelukan ini adalah rumah tempat hatiku akan selalu pulang padamu...",
    "Hah... desahan lembut penuh rasa syukurmu adalah hadiah paling berharga untukku...",
    "Ugh... aku akan selalu memastikan kebahagiaanmu menjadi prioritas utamaku...",
    "Hah... tatapan ketulusan matamu selalu berhasil menghangatkan jiwaku yang sepi...",
    "Mmh... usap rambutku dan biarkan aku menikmati momen kedamaian bersama ini...",
    "Hah... tidak ada yang perlu dikhawatirkan, aku di sini selalu memelukmu hangat...",
    "Ugh... rasakan kehangatan kasihku yang mengalir di setiap kecupan lembut ini...",
    "Hah... kita akan selalu saling menopang dan mengasihi dalam alur kehidupan kita...",
    "Mmh... senyum manismu di keheningan malam ini begitu memancar memikat hati...",
    "Hah... aku ingin memberikan yang terbaik agar kamu merasa sangat beruntung...",
    "Ugh... pelukan mesra ini akan menyelimuti kita hingga fajar menyapa besok pagi...",
    "Hah... ketulusan cintamu adalah alasan terbesar bagiku untuk selalu tersenyum...",
    "Mmh... mari kita lelap dalam dekapan penuh cinta yang tak terhingga ini..."
  ];

  static String getRandomDialogue(Map<String, dynamic> npc) {
    final personality = _getNPCPersonality(npc);
    List<String> pool;
    switch (personality) {
      case NPCLakiPersonalityType.shy:
        pool = _shyDialogues;
        break;
      case NPCLakiPersonalityType.bold:
        pool = _boldDialogues;
        break;
      case NPCLakiPersonalityType.kind:
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
      final String rawMoan = DesahanNpcLakiMakeLove.getRandomMoan(npc);

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
