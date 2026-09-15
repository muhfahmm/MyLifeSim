// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/dialog_masturbate/dialog_npc_perempuan/dialog_npc_perempuan_masturbate.dart

import 'dart:math';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/desahan_npc_perempuan/desahan_npc_perempuan_masturbate.dart';

enum NPCPerempuanPersonalityType { shy, bold, kind }

class DialogNpcPerempuanMasturbate {
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

  static final Random _random = Random();

  // ==========================================================
  // LIBRARY 50 DIALOG MASTURBASI PERCAKAPAN SHY (PEMALU)
  // ==========================================================
  static const List<String> _shyDialogues = [
    "Mmh... pelan-pelan ya sayang... w-wajahku rasanya memerah sekali saat kamu menatapku...",
    "Hah... jangan lihat aku terlalu dekat saat mengeksplorasi diri... aku malu...",
    "A-aku... ahh... rasanya jantungku berdegup tak karuan melihatmu di dekatku...",
    "Hah... bisakah kita saling berpelukan erat seperti ini di sela momen intim?",
    "Mmh... sentuhan lembut jemarimu membuat seluruh ragaku menjadi lemas...",
    "Hah... jangan tinggalkan aku... aku merasa sangat nyaman bersamamu...",
    "Aah... mendekatlah padaku, aku ingin merasakan kehangatan hadirmu...",
    "Hah... kamu membuatku tidak bisa berpikir selain tentangmu malam ini...",
    "Ahh... k-kamu mendengar suara manjaku? Aduh malu sekali...",
    "Mmh... genggam tanganku hangat-hangat di antara gerakan ini ya...",
    "Hah... bisikkan kata-kata manjamu lagi, aku sangat menyukainya...",
    "Ahh... k-kamu terlihat sangat memikat malam ini... membuat hatiku berdebar...",
    "Hah... bisakah kamu mencium pipiku perlahan dengan penuh kasih?",
    "Mmh... aku sangat sensitif di bagian ini... tapi aku menyukainya...",
    "Hah... rasakan betapa hangatnya dekapan kita di tengah keheningan malam...",
    "Ahh... jangan terburu-buru, aku ingin menikmati detik demi detik kebersamaan ini...",
    "Hah... m-mata kita saling bertemu... membuat dadaku makin bergetar...",
    "Mmh... merinding rasanya setiap kali kamu berbisik lembut padaku...",
    "Hah... aku malu jika kamu terus memperhatikan reaksimu seperti itu...",
    "Ahh... s-sentuh rambutku pelan-pelan, aku merasa sangat dimanja...",
    "Hah... aku tidak berani bersuara keras... takut ada yang mendengar...",
    "Mmh... kehadiranmu begitu hangat bagaikan selimut di tengah dinginnya malam...",
    "Hah... aku lelah tapi sangat bahagia bisa berbagi momen rahasia ini bersamamu...",
    "Ahh... tubuhku gemetar setiap kali kamu mendekapku erat-erat...",
    "Mmh... rasanya begitu damai bisa mengeksplorasi rasa di sisimu...",
    "Hah... jangan berhenti menatapku... aku merasa sangat aman...",
    "Ahh... kamu selalu berhasil membuatku merasa menjadi wanita paling spesial...",
    "Hah... bisakah kita tetap saling menemani seperti ini hingga esok pagi?",
    "Mmh... kamu... kamu sungguh pintar membuatku tersipu malu...",
    "Hah... aku ingin selalu berada di dalam jangkauan pelukanmu...",
    "Ahh... detak jantungmu terdengar begitu menenangkan di telingaku...",
    "Mmh... aku takut momen indah ini cepat berlalu... peluk aku lagi...",
    "Hah... k-kamu... jangan buat aku makin tersipu malu...",
    "Hah... aku ingin menangis karena merasa begitu bahagia bersamamu...",
    "Mmh... jangan pernah lepaskan ikatan kasih sayang di antara kita...",
    "Hah... bisikan mesramu membuat seluruh persendianku serasa luluh...",
    "Ahh... aku ingin kamu mendekapku lebih erat lagi...",
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
  // LIBRARY 50 DIALOG MASTURBASI PERCAKAPAN BOLD (PERCAYA DIRI / GAIRAH)
  // ==========================================================
  static const List<String> _boldDialogues = [
    "Ahh! Ya, lihat aku mengeksplorasi diriku! Kamu membuatku semakin gila!",
    "Hah! Lakukan lebih cepat untukku! Biarkan aku melihat kebahagiaanmu!",
    "Ahh! Sensasi ini makin menggila saat bersamamu! Luar biasa!",
    "Hah! Jangan lepas pandanganmu dariku! Aku menginginkanmu malam ini!",
    "Ahh... ahh... ya! Teruskan eksplorasi intimmu bersama denganku!",
    "Hah! Aku suka caramu menyentuh dirimu sendiri saat menatapku!",
    "Ahh! Kamu membuatku bergairah sekali! Gairahku membara tinggi!",
    "Hah! Tunjukkan padaku betapa nikmatnya momen sensitif yang kita bagi!",
    "Ahh! Aku ingin merasakan seluruh kehangatanmu menyatu denganku!",
    "Hah! Kamu tahu persis bagaimana cara membuatku tak berdaya!",
    "Ahh! Bisikkan kata-kata manjamu tepat di telingaku! Aku menyukainya!",
    "Hah! Tatap mataku saat kamu memanjakan dirimu! Biarkan aku melihat cintamu!",
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
    "Hah! Sentuh dirimu di situ dan biarkan aku menyaksikan keindahanmu!",
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
    "Ahh! Kehangatan hadirmu membuatku ketagihan untuk selalu bersama!",
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
    "Hah! Keberanianmu merangkulku membuat suasana semakin memuncak hangat!",
    "Ahh! Kamu membuat malam biasa menjadi pengalaman yang luar biasa!",
    "Hah! Teruslah berbisik manja, aku menyukai keputusasaanmu memilikiku!",
    "Ahh! Kamu telah memenangkan raga dan jiwaku secara mutlak malam ini!",
    "Hah! Mari kita tuntaskan momen intim ini dalam klimaks pelukan mesra!"
  ];

  // ==========================================================
  // LIBRARY 50 DIALOG MASTURBASI PERCAKAPAN KIND (PENYAYANG / LEMBUT)
  // ==========================================================
  static const List<String> _kindDialogues = [
    "Mmh... ah... kamu menikmati momen rahasia ini kan, sayang?",
    "Hah... bersamamu... rasanya begitu rileks dan menentramkan batin...",
    "Ahh... ah... mari kita nikmati momen mesra yang damai ini bersama...",
    "Hah... hah... aku senang bisa berbagi rasa sensitif ini denganmu...",
    "Mmh... ahh... rasanya sungguh manis dan hangat berada di dekatmu...",
    "Ahh... hah... ikuti suara manjamu ya, aku ada di sini menemanimu...",
    "Mmh... rasa percaya di antara kita membuat momen ini terasa begitu indah...",
    "Hah... tidak ada yang perlu kamu khawatirkan, aku mencintaimu apa adanya...",
    "Ahh... kecupan hangat di pipimu ini adalah tanda ketulusan cintaku...",
    "Hah... pelan-pelan saja sayang, kita punya seluruh malam untuk dinikmati...",
    "Mmh... kehangatan jiwamu terasa menyatu dengan ketenangan ragaku...",
    "Hah... tatap mataku yang penuh kasih, aku akan selalu mendampingimu...",
    "Ahh... bersandarlah padaku jika kamu merasa lelah di tengah alur ini...",
    "Hah... aku merasa sangat beruntung bisa berbagi rasa intim bersamamu...",
    "Mmh... setiap gerakan halusmu memancarkan keindahan yang luar biasa...",
    "Hah... bisikkan jika ada hal yang membuatmu merasa lebih nyaman...",
    "Ahh... aku menyukai ketenangan yang mengalir di antara kita berdua...",
    "Hah... belai tanganku pelan, biarkan kita rasakan hangatnya cinta...",
    "Mmh... kesederhanaan momen intim ini menjadi kenangan yang sangat manis...",
    "Hah... senyuman bahagiamu adalah hadiah terbaik bagi perasaanku...",
    "Ahh... aku berjanji akan selalu memperlakukanku dengan penuh rasa hormat...",
    "Hah... ikuti insting bahagiamu, aku akan menyamakan langkah denganmu...",
    "Mmh... kelembutan caramu menatapku menghapuskan seluruh beban lelahku...",
    "Hah... terima kasih sudah mau membagikan kehangatan pribadi ini padaku...",
    "Ahh... rasakan betapa dalamnya rasa mengasihi yang kupunya untukmu...",
    "Hah... usap jemariku hangat-warm, kita jalani momen intim ini bersama...",
    "Mmh... rintihan lembutmu terasa bagaikan doa kedamaian bagi hubungan kita...",
    "Hah... jangan sungkan untuk mengekspresikan apa yang kamu rasakan...",
    "Ahh... kebersamaan ini mempererat tali kasih sayang di antara kita...",
    "Hah... aku akan selalu menjaga dan menyayangimu sepenuh hatiku...",
    "Mmh... binar ketulusan matamu selalu berhasil menghangatkan jiwaku...",
    "Hah... mari kita nikmati setiap detik dengan penuh rasa bersyukur...",
    "Ahh... pelukan hangat ini akan selalu siap menampung seluruh keluhmu...",
    "Hah... kecupan manis di keningmu menandai betapa sucinya ikatan ini...",
    "Mmh... aku merasa utuh saat melihatmu merasa nyaman dan bahagia...",
    "Hah... bisikkan katamu pelan, suara lembutmu adalah penawar lelahku...",
    "Ahh... tetaplah bersamaku dalam kedamaian malam yang indah ini...",
    "Hah... kesetiaan dan kasih cintaku akan selalu mengiringi langkahmu...",
    "Mmh... rasakan kehangatan alami dari dekapan yang kuberi untukmu...",
    "Hah... tidak ada hal yang lebih berharga selain kebahagiaan batinmu...",
    "Ahh... belai rambutku perlahan, aku merasa sangat dimanja olehmu...",
    "Hah... setiap momen yang kita lalui bersama selalu menyisakan kesan manis...",
    "Mmh... aku bahagia bisa menjadi tempatmu berbagi rasa yang paling intim...",
    "Hah... tataplah aku dengan rasa cinta yang selalu menenangkan jiwaku...",
    "Ahh... ketulusan caramu tersenyum membuat malam kelam jadi terang...",
    "Hah... mari kita selesaikan momen indah ini dengan pelukan hangat...",
    "Mmh... terima kasih atas kebaikan dan rasa percaya yang kau berikan...",
    "Hah... cintaku padamu takkan pernah berkurang sedikitpun sayang...",
    "Ahh... mari kita lelap bersama dalam dekapan penuh kasih sayang ini...",
    "Mmh... aku milikmu selamanya sayang..."
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
    return pool[_random.nextInt(pool.length)];
  }



  static const List<String> _narrations = [
    "(Suasana makin panas saat kalian berdua saling menatap dan melakukan masturbasi bersama secara perlahan...)",
    "(Gerakan tangan yang makin cepat membuat napas kalian tersengal-sengal di tengah keheningan...)",
    "(Tatapan mata berbinar penuh gairah mengiringi setiap detik eksplorasi diri bersama...)",
    "(Sensasi nikmat dan desahan tertahan membuncah saat kalian berdua makin mendekati puncak...)",
  ];

  static List<VNDialogueNode> getMoanSequence({
    required Character player,
    required Map<String, dynamic> npc,
    required List<VNDialogueNode> playerMoanNodes,
    int nodeCount = 3,
  }) {
    final Random random = Random();
    final List<VNDialogueNode> sequence = [];

    final String npcName = npc['name'] ?? 'Pasangan';
    final String targetRole = npc['role'] ?? 'Pasangan';
    final String npcGender = npc['gender'] ?? 'Perempuan';

    final bool isPlayerMale = player.gender.trim().toLowerCase() == 'laki-laki';

    final String callNpcToPlayer = PanggilanManager.getPanggilan(
      targetName: isPlayerMale ? npcName : player.name,
      targetRole: targetRole,
      targetGender: isPlayerMale ? npcGender : player.gender,
      isSpeakerPlayer: false,
      userName: player.name,
      userGender: player.gender,
      isIntimate: true,
    );

    int playerIndex = 0;

    for (int i = 0; i < nodeCount; i++) {
      final String rawMoan = DesahanNpcPerempuanMasturbate.getRandomMoan(npc);
      final String narrationText = _narrations[random.nextInt(_narrations.length)];

      String moanWithCall;
      final int callPattern = random.nextInt(4);
      switch (callPattern) {
        case 0:
          moanWithCall = "$rawMoan $callNpcToPlayer...";
          break;
        case 1:
          moanWithCall = "Ahh... $callNpcToPlayer, $rawMoan";
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
              dialogueText: "Ahh... hah... aku sangat menyukai momen ini denganku...",
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: true,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            );
      playerIndex++;

      sequence.add(narrationNode);
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
        textAftercare = 'Hah... hah... jantungku serasa mau melompat keluar... tapi rasanya sungguh lega dan nikmat... 🙈✨';
        break;
      case NPCPerempuanPersonalityType.bold:
        textAftercare = 'Hah... itu tadi fantastis! Masturbasi bersama denganmu memberikan sensasi yang jauh lebih membakar! 🔥';
        break;
      case NPCPerempuanPersonalityType.kind:
        textAftercare = 'Hah... terima kasih sudah menemaniku dan berbagi kehangatan ini ya... aku merasa sangat nyaman... ❤️';
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
