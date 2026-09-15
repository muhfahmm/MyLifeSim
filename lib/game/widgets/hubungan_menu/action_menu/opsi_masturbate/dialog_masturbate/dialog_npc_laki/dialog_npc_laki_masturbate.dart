// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/dialog_masturbate/dialog_npc_laki/dialog_npc_laki_masturbate.dart

import 'dart:math';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/desahan_npc_laki/desahan_npc_laki_masturbate.dart';

enum NPCLakiPersonalityType { cool, aggressive, gentle }

class DialogNpcLakiMasturbate {
  static NPCLakiPersonalityType _getNPCPersonality(Map<String, dynamic> npc) {
    final String trait = (npc['personality'] ?? npc['trait'] ?? '').toString().toLowerCase();
    if (trait.contains('cool') || trait.contains('pendiam') || trait.contains('jutek')) {
      return NPCLakiPersonalityType.cool;
    }
    if (trait.contains('agresif') || trait.contains('bold') || trait.contains('gairah') || trait.contains('dominan')) {
      return NPCLakiPersonalityType.aggressive;
    }
    return NPCLakiPersonalityType.gentle;
  }

  static final Random _random = Random();

  // ==========================================================
  // LIBRARY 50 DIALOG MASTURBASI PERCAKAPAN COOL (PEMALU / PENDIAM)
  // ==========================================================
  static const List<String> _coolDialogues = [
    "Hah... kamu membuatku sulit menahan diri saat membayangkan kita bersama...",
    "Mmh... lihat apa yang terjadi padaku saat berada di dekatmu seperti ini...",
    "Hah... ritme gerakan jemarimu sungguh membuat gairahku makin membara...",
    "Ugh... aku merasa canggung tapi mengeksplorasi diri bersamamu terasa indah...",
    "Hah... bisikan suara halusmu membakar fokusku malam ini...",
    "Mmh... aku tak bisa berpaling dari tatapan matamu yang begitu memikat...",
    "Hah... rasakan betapa cepatnya detak dadaku saat menatapmu mesra...",
    "Ugh... kamu selalu berhasil membuatku tersipu malu dan bergairah...",
    "Hah... ikuti kecepatanku, mari kita nikmati momen eksklusif ini bersama...",
    "Mmh... sentuhan lembut ini adalah caraku menikmati hadirmu...",
    "Hah... tatap mataku sayang, jangan ada rasa malu di antara kita...",
    "Ugh... kehangatan kebersamaan ini selalu berhasil meluluhkan hatiku...",
    "Hah... aku suka saat kamu memberikan perhatian manjamu padaku...",
    "Mmh... ritme yang kita bagikan malam ini sungguh harmonis...",
    "Hah... aku ingin memastikan kamu merasakan kebahagiaan yang sama...",
    "Ugh... bersamamu membuat momen solo ini terasa sepuluh kali lebih intim...",
    "Hah... bisikkan namaku lagi, aku menyukai kepolosan nada suaramu...",
    "Mmh... gerakanmu begitu tenang namun sangat memikat hatiku...",
    "Hah... jangan berhenti menatapku, itu memberikan dorongan semangat bagiku...",
    "Ugh... kehangatan ruangan ini menyatu sempurna dengan pesonamu...",
    "Hah... aku tidak menyangka bisa berbagi momen sensitif ini bersamamu...",
    "Mmh... perhatikan betapa tulusnya aku mengagumi setiap inci dirimu...",
    "Hah... ayo kita perlambat ritmenya agar bisa kita nikmati lebih lama...",
    "Ugh... kehadiranmu di sisiku memberikan kenyamanan luar biasa...",
    "Hah... rasa canggung ini perlahan sirnah digantikan kasih sayang...",
    "Mmh... aku menyukai saat kamu tersenyum tipis di tengah kepasrahan ini...",
    "Hah... bisikkan katamu pelan, aku menyimak setiap bait cintamu...",
    "Ugh... sentuhan ini menjadi saksi betapa besarnya daya tarikmu padaku...",
    "Hah... mari kita nikmati momen privasi ini tanpa perlu terburu-buru...",
    "Mmh... setiap helaan napasku menyuarakan rasa syukur atas hadirmu...",
    "Hah... senyuman manismu membuat malam sunyi ini menjadi sangat hangat...",
    "Ugh... aku ingin kamu selalu merasa aman dan nyaman berada di dekatku...",
    "Hah... pandangan matamu yang syahdu sungguh meruntuhkan kekakuanku...",
    "Mmh... genggam tanganku sebentar jika kamu butuh kepastian cinta...",
    "Hah... kebersamaan ini menguatkan ikatan spesial yang kita miliki...",
    "Ugh... bersandarlah padaku saat kamu merasa lelah mengeksplorasi rasa...",
    "Hah... kecupan manis di keningmu ini adalah hadiah ketulusanku...",
    "Mmh... aku akan selalu menjaga kerahasiaan momen indah yang kita bagi...",
    "Hah... desahan halusmu bagaikan musik malam yang menentramkan...",
    "Ugh... aku merasa sangat beruntung bisa memiliki pasangan sepertimu...",
    "Hah... jangan lepaskan pandanganmu, mari kita selesaikan ini bersama...",
    "Mmh... kelembutan rasa ini membuktikan betapa dalam rasa cinta kita...",
    "Hah... setiap detik yang kita lalui bersama selalu bernilai tinggi...",
    "Ugh... belai bahuku pelan saat gairah ini mulai menyelimuti raga...",
    "Hah... aku ingin memberikan respon terbaik atas kehangatanmu...",
    "Mmh... bersamamu di sini adalah keputusan terbaik yang kuambil...",
    "Hah... nikmati getaran kasih yang mengalir pelan di antara kita...",
    "Ugh... aku akan selalu berada di sisimu dalam setiap kondisi apapun...",
    "Hah... tatapan mesramu adalah penguat jiwa bagiku malam ini...",
    "Mmh... mari kita tidur lelap setelah berbagi momen intim yang manis ini..."
  ];

  // ==========================================================
  // LIBRARY 50 DIALOG MASTURBASI PERCAKAPAN AGGRESSIVE (BOLD / GAIRAH)
  // ==========================================================
  static const List<String> _aggressiveDialogues = [
    "Ugh! Tatap mataku saat kamu melakukannya! Kamu terlihat begitu seksi!",
    "Hah! Lakukan lebih cepat untukku! Biarkan aku melihat kebahagiaanmu!",
    "Ugh! Sensasi ini gila sekali saat mengeksplorasi diri bersamamu!",
    "Hah! Jangan berani-berani berhenti sebelum kita mencapai puncak bersama!",
    "Ugh! Ya, nikmati setiap detik kehangatan yang kita bagikan malam ini!",
    "Hah! Gerakanmu sungguh memikat dan membuat gairahku membara tinggi!",
    "Ugh! Tunjukkan padaku betapa besarnya rasa menginginkanmu padaku!",
    "Hah! Bisikkan kata manjamu dengan lantang, aku ingin mendengarnya!",
    "Ugh! Kebersamaan ini benar-benar memicu adrenalin percintaan terbaik!",
    "Hah! Terus ikuti ritmeku, kita buat momen intim ini sangat panas!",
    "Ugh! Kamu luar biasa! Tidak ada yang bisa menandingi pesonamu!",
    "Hah! Jangan sembunyikan desahanmu, aku menyukai kepasrahan suaramu!",
    "Ugh! Lihat betapa hebatnya efek dirimu terhadap gairahku malam ini!",
    "Hah! Dekatkan dirimu padaku, biarkan raga kita saling menyentuh!",
    "Ugh! Aku suka saat kamu menunjukkan keberanianmu di hadapanku!",
    "Hah! Kita buat malam sunyi ini bergetar oleh gairah cinta kita!",
    "Ugh! Teruskan sentuhanmu, kamu membuatku makin tak berdaya!",
    "Hah! Kebersamaan kita di sini adalah kombinasi kepuasan paling ampuh!",
    "Ugh! Jangan berikan sisa jarak, aku ingin merasakan seluruh hangatmu!",
    "Hah! Tatapan nakalmu memberi sinyal bahwa kamu sangat menyukainya!",
    "Ugh! Kamu berhasil memenangkan seluruh perhatian dan gairahku!",
    "Hah! Pacu kecepatannya! Aku ingin melihatmu klimaks bersamaku!",
    "Ugh! Kehebatanmu memanjakan diri sungguh membuatku terkesima!",
    "Hah! Genggam bahuku kuat-kuat saat sensasi nikmat itu datang!",
    "Ugh! Kamu adalah pemilik gairah terbaik yang pernah kutemui!",
    "Hah! Biarkan desahan nikmat kita bersahutan memenuhi ruangan ini!",
    "Ugh! Terus tatap aku! Aku tidak akan melepaskan pandanganku darimu!",
    "Hah! Kamu terlihat begitu menggoda di bawah pencahayaan remang ini!",
    "Ugh! Sensasi ini luar biasa membara, teruskan usapan manjamu!",
    "Hah! Aku ingin kamu mengingat betapa indahnya momen intim kita!",
    "Ugh! Jangan biarkan energi percintaan ini padam terlalu cepat!",
    "Hah! Tunjukkan padaku bagian mana yang paling membuatmu terbuai!",
    "Ugh! Gerakan selaras kita membuktikan betapa cocoknya kita berdua!",
    "Hah! Kamu membuat malam biasa menjadi pengalaman yang sangat panas!",
    "Ugh! Rasakan ketegangan mesra yang makin memuncak di antara kita!",
    "Hah! Bisikkan keinginanmu, aku akan menyamakan ritmeku untukmu!",
    "Ugh! Kamu sungguh memikat, membuatku ingin mengulangnya lagi!",
    "Hah! Nikmati setiap dorongan kebahagiaan yang mengalir di tubuhmu!",
    "Ugh! Aku tidak akan membiarkanmu merasa kesepian malam ini!",
    "Hah! Posisikan dirimu agar aku bisa melihat senyum bahagiamu!",
    "Ugh! Keberanianmu berbagi rasa sensitif ini membuatku kagum!",
    "Hah! Teruslah memanjakan dirimu, aku mendukung setiap gerakanmu!",
    "Ugh! Kita adalah tim terbaik dalam urusan memberikan kebahagiaan!",
    "Hah! Suara rintihanmu adalah dorongan terbesar bagi gairahku!",
    "Ugh! Dekap aku erat-erat saat puncak nikmat itu menyapa raga!",
    "Hah! Kamu telah membuktikan betapa indahnya rasa saling memiliki!",
    "Ugh! Mari kita tuntaskan eksplorasi intim ini dengan sangat sempurna!",
    "Hah! Rasakan getaran cinta penuh gairah yang menyelimuti kita!",
    "Ugh! Kamu adalah yang terbaik, tidak ada yang bisa menggantikanmu!",
    "Hah! Mari kita nikmati puncak kebahagiaan ini bersama-sama!"
  ];

  // ==========================================================
  // LIBRARY 50 DIALOG MASTURBASI PERCAKAPAN GENTLE (PENYAYANG / LEMBUT)
  // ==========================================================
  static const List<String> _gentleDialogues = [
    "Hah... kamu manis sekali saat mengeksplorasi diri di dekatku...",
    "Mmh... aku akan menyesuaikan kecepatan dengan kenyamananmu sayang...",
    "Hah... rileks ya... nikmati setiap momen kedamaian yang kita bagi...",
    "Ugh... suaramu merdu sekali saat berbisik lembut di telingaku...",
    "Hah... aku sangat senang bisa melakukan hal sensitif ini bersamamu...",
    "Mmh... rasa percaya di antara kita membuat momen ini terasa suci...",
    "Hah... sentuh dirimu dengan lembut, aku di sini selalu mendampingimu...",
    "Ugh... kamu tidak apa-apa kan? Ekspresimu sungguh membuatku meleleh...",
    "Hah... kecupan hangat di pipimu ini adalah tanda kasih sayangku...",
    "Mmh... tidak ada yang perlu ditakutkan, aku mencintaimu apa adanya...",
    "Hah... pelan-pelan saja ya, kita punya banyak waktu malam ini...",
    "Ugh... kehangatan jiwamu terasa sungguh menentramkan hatiku...",
    "Hah... tatap mataku yang penuh tulus, aku selalu ada untukmu...",
    "Mmh... bersandarlah padaku jika kamu merasa lelah di tengah alur ini...",
    "Hah... aku merasa sangat beruntung diberi kepercayaan mendampingimu...",
    "Ugh... setiap gerakan halusmu memancarkan keindahan yang luar biasa...",
    "Hah... bisikkan jika ada hal yang membuatmu merasa lebih rileks...",
    "Mmh... aku menyukai ketenangan yang mengalir di antara kita berdua...",
    "Hah... belai tanganku pelan, biarkan kita rasakan hangatnya cinta...",
    "Ugh... kesederhanaan momen intim ini menjadi kenangan yang sangat manis...",
    "Hah... senyuman bahagiamu adalah hadiah terbaik bagi perasaanku...",
    "Mmh... aku berjanji akan selalu memperlakukanmu dengan penuh rasa hormat...",
    "Hah... ikuti insting bahagiamu, aku akan menyamakan langkah denganku...",
    "Ugh... kelembutan caramu menatapku menghapuskan seluruh beban di kepala...",
    "Hah... terima kasih sudah mau membagikan kehangatan pribadi ini padaku...",
    "Mmh... rasakan betapa dalamnya rasa mengasihi yang kupunya untukmu...",
    "Hah... usap jemariku hangat-warm, kita jalani momen ini bersama...",
    "Ugh... rintihan lembutmu terasa bagaikan doa kedamaian bagi hubungan kita...",
    "Hah... jangan sungkan untuk mengekspresikan apa yang kamu rasakan...",
    "Mmh... kebersamaan ini mempererat tali kasih sayang di antara kita...",
    "Hah... aku akan selalu menjaga dan menyayangimu sepenuh hatiku...",
    "Ugh... binar ketulusan matamu selalu berhasil menghangatkan jiwaku...",
    "Hah... mari kita nikmati setiap detik dengan penuh rasa bersyukur...",
    "Mmh... pelukan hangat ini akan selalu siap menampung seluruh keluhmu...",
    "Hah... kecupan manis di keningmu menandai betapa sucinya ikatan ini...",
    "Ugh... aku merasa utuh saat melihatmu merasa nyaman dan bahagia...",
    "Hah... bisikkan katamu pelan, suara lembutmu adalah penawar lelahku...",
    "Mmh... tetaplah bersamaku dalam kedamaian malam yang indah ini...",
    "Hah... kesetiaan dan kasih cintaku akan selalu mengiringi langkahmu...",
    "Ugh... rasakan kehangatan alami dari dekapan yang kuberi untukmu...",
    "Hah... tidak ada hal yang lebih berharga selain kebahagiaan batinmu...",
    "Mmh... belai rambutku perlahan, aku merasa sangat dimanja olehmu...",
    "Hah... setiap momen yang kita lalui bersama selalu menyisakan kesan manis...",
    "Ugh... aku bahagia bisa menjadi tempatmu berbagi rasa yang paling intim...",
    "Hah... tataplah aku dengan rasa cinta yang selalu menenangkan jiwaku...",
    "Mmh... ketulusan caramu tersenyum membuat malam kelam jadi terang...",
    "Hah... mari kita selesaikan momen indah ini dengan pelukan hangat...",
    "Ugh... terima kasih atas kebaikan dan rasa percaya yang kau berikan...",
    "Hah... cintaku padamu takkan pernah berkurang sedikitpun sayang...",
    "Mmh... mari kita lelap bersama dalam dekapan penuh kasih sayang ini..."
  ];

  static String getRandomDialogue(Map<String, dynamic> npc) {
    final personality = _getNPCPersonality(npc);
    List<String> pool;
    switch (personality) {
      case NPCLakiPersonalityType.cool:
        pool = _coolDialogues;
        break;
      case NPCLakiPersonalityType.aggressive:
        pool = _aggressiveDialogues;
        break;
      case NPCLakiPersonalityType.gentle:
        pool = _gentleDialogues;
        break;
    }
    return pool[_random.nextInt(pool.length)];
  }



  static const List<String> _narrations = [
    "(Suasana makin intim saat kalian saling bertukar tatapan hangat dan melakukan masturbasi bersama...)",
    "(Setiap desahan tertahan terdengar jelas, menciptakan kehangatan yang mengalir di seluruh ruangan...)",
    "(Gerakan tangan yang selaras membuat ketegangan dan gairah memuncak bersamaan...)",
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
    final String npcGender = npc['gender'] ?? 'Laki-laki';

    final bool isPlayerFemale = player.gender.trim().toLowerCase() == 'perempuan';

    final String callNpcToPlayer = PanggilanManager.getPanggilan(
      targetName: isPlayerFemale ? npcName : player.name,
      targetRole: targetRole,
      targetGender: isPlayerFemale ? npcGender : player.gender,
      isSpeakerPlayer: false,
      userName: player.name,
      userGender: player.gender,
      isIntimate: true,
    );

    int playerIndex = 0;

    for (int i = 0; i < nodeCount; i++) {
      final String rawMoan = DesahanNpcLakiMasturbate.getRandomMoan(npc);
      final String narrationText = _narrations[random.nextInt(_narrations.length)];

      String moanWithCall = "$rawMoan, $callNpcToPlayer...";

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
              dialogueText: "Ahh... hah... ini nikmat sekali...",
              emotion: VNEmotionType.blush,
              isPlayerSpeaking: true,
              outfit: VNOutfitType.casual,
              background: VNBackgroundType.bedroom,
            );
      playerIndex++;

      sequence.add(narrationNode);
      if (isPlayerFemale) {
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
      case NPCLakiPersonalityType.cool:
        textAftercare = 'Hah... tak kusangka melakukan masturbasi bersamamu bisa sebikin ini ketagihan... 🔥';
        break;
      case NPCLakiPersonalityType.aggressive:
        textAftercare = 'Ugh... itu luar biasa! Lain kali kita harus mencobanya lagi di tempat yang lebih menantang! 😈';
        break;
      case NPCLakiPersonalityType.gentle:
        textAftercare = 'Hah... kamu tidak apa-apa kan? Mengamati ekspresimu tadi sungguh membuat hatiku meleleh... ❤️';
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
