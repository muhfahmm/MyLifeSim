// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/dialog_makelove/dialog_user_laki/dialog_user_laki_makelove.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_user_laki/desahan_user_laki_makelove.dart';

class DialogUserLakiMakeLove {
  static final Random _random = Random();

  // ==========================================================
  // LIBRARY 50 DIALOG USER LAKI-LAKI SHY (PEMALU)
  // ==========================================================
  static const List<String> _shyDialogues = [
    "Hah... aku merasa sangat canggung tapi membayangkanmu membuat jantungku berdebar...",
    "Mmh... bisakah kita saling berpegangan erat seperti ini dulu?",
    "Hah... sentuhan jariku sendiri terasa gemetar saat mengingat senyumanmu...",
    "Ugh... kamu begitu indah malam ini, membuatku tersipu malu di dekatmu...",
    "Hah... bisikkan namaku lagi, aku selalu suka mendengar suaramu yang lembut...",
    "Mmh... genggam tanganku hangat-hangat ya, jangan pernah dilepas...",
    "Hah... aku selalu gugup setiap kali mata kita bertemu dalam keheningan ini...",
    "Ugh... kehangatan dekapanmu sungguh menenangkan jiwaku...",
    "Hah... bisakah kita perlambat momen mesra ini agar terasa lebih lama?",
    "Mmh... kecupan manis di bibirmu terasa begitu lembut dan tulus...",
    "Hah... jangan lihat aku seperti itu, aku merasa sangat malu...",
    "Ugh... bersamamu di sini adalah impian yang selalu kuinginkan...",
    "Hah... rasakan betapa cepatnya detak dadaku saat mendekapmu...",
    "Mmh... pelan-pelan ya, aku ingin menikmati detik demi detik kebersamaan kita...",
    "Hah... senyuman tipismu membuat kasih sayangku makin meluap...",
    "Ugh... kamu sangat berarti bagiku, lebih dari apapun di dunia ini...",
    "Hah... bersandarlah di dadaku jika kamu merasa lelah...",
    "Mmh... aku berjanji akan selalu memperlakukanmu dengan lembut...",
    "Hah... sentuhan di pipimu ini adalah tanda betapa dalamnya cintaku...",
    "Ugh... bisakah kita tetap seperti ini tanpa perlu terburu-buru?",
    "Hah... napas hangatmu di leherku membuat seluruh ragaku luluh...",
    "Mmh... belai rambutku perlahan, aku merasa sangat aman di dekatmu...",
    "Hah... tatapan matamu yang penuh kasih selalu berhasil menyejukkan hatiku...",
    "Ugh... setiap kali menciummu, aku merasa menjadi pria paling beruntung...",
    "Hah... jangan lepaskan dekapan ini, kehangatanmu adalah kenyamananku...",
    "Mmh... aku akan selalu mendengarkan setiap desahan manis dari bibirmu...",
    "Hah... pelukan ini begitu hangat hingga aku tak ingin malam berakhir...",
    "Ugh... kelembutan caramu menyentuhku sungguh menyentuh hatiku...",
    "Hah... bisikan sayangmu bagaikan melodi terindah di telingaku...",
    "Mmh... aku ingin menjaga momen romantis ini dengan segenap cintaku...",
    "Hah... terima kasih sudah hadir dan melengkapi seluruh hidupku...",
    "Ugh... genggaman jemarimu terasa sungguh menentramkan jiwa...",
    "Hah... tetaplah dekat denganku, aku tak ingin ada jarak di antara kita...",
    "Mmh... senyumanmu di tengah malam ini selalu berhasil mencuri hatiku...",
    "Hah... rasakan getaran cinta yang terus mengalir di antara kita berdua...",
    "Ugh... bersamamu membuatku yakin bahwa cinta tulus itu sungguh nyata...",
    "Hah... biarkan aku mendekapmu lebih erat agar kamu merasakan hangatku...",
    "Mmh... bimbing tanganku jika ada hal yang membuatmu lebih nyaman...",
    "Hah... embusan napasmu yang tersengal terdengar begitu menggemaskan...",
    "Ugh... bersandarlah padaku kapanpun kamu butuh tempat berlabuh...",
    "Hah... kecupan hangat di keningmu adalah bentuk rasa cintaku...",
    "Mmh... kelembutan rasa ini membuat malam kelam menjadi bersinar...",
    "Hah... aku merasa diberkati bisa membagikan rasa intim ini bersamamu...",
    "Ugh... berbisiklah pelan, aku akan selalu setia menyimak katamu...",
    "Hah... desahan halusmu mengalir mengisi keheningan malam...",
    "Mmh... senandung mesramu terasa bagaikan doa kebahagiaan kita...",
    "Hah... tataplah aku dengan kedalaman rasa yang selalu membuaiku...",
    "Ugh... kehangatan belaianmu meresap jauh hingga ke relung hatiku...",
    "Hah... malam ini menjadi saksi betapa murninya cinta kita bersama...",
    "Mmh... tetaplah bersamaku dalam kehangatan pelukan ini selamanya..."
  ];

  // ==========================================================
  // LIBRARY 50 DIALOG USER LAKI-LAKI BOLD (GAIRAH / PERCAYA DIRI)
  // ==========================================================
  static const List<String> _boldDialogues = [
    "Hah! Kamu luar biasa malam ini, membuatku tak ingin melepaskanmu!",
    "Ugh! Lebih erat lagi padaku, biarkan aku merasakan kehangatanmu!",
    "Hah! Tatap mataku erat-erat, malam ini kamu sepenuhnya milikku!",
    "Ahh! Sentuhanmu sungguh membakar gairahku, teruskan sayang!",
    "Hah! Kamu tahu persis bagaimana cara membuatku tak berdaya di hadapanmu!",
    "Ugh! Jangan tahan desahanmu, biarkan aku mendengar suara manjamu!",
    "Hah! Ikuti ritmeku, kita buat malam penuh cinta ini takkan terlupakan!",
    "Ahh! Kamu begitu menggoda, membuatku ingin memberikan segalanya!",
    "Hah! Peluk leherku erat-erat dan rasakan betapa hebatnya gairah kita!",
    "Ugh! Kebersamaan denganmu selalu memicu kebahagiaan terbaik!",
    "Hah! Jangan pelan-pelan, biarkan gairah mesra kita memuncak!",
    "Ahh! Kecupan di bibirmu membuatku ketagihan untuk memintanya lagi!",
    "Hah! Bisikkan kata manjamu di telingaku, aku menyukai keberanianmu!",
    "Ugh! Setiap sentuhanmu menyalakan api percikan cinta yang membara!",
    "Hah! Rangkul pinggangku dan biarkan aku membawamu ke puncak bahagia!",
    "Ahh! Suaramu yang penuh desahan membuatku semakin tak sabar!",
    "Hah! Kita diciptakan untuk saling melengkapi dalam momen intim ini!",
    "Ugh! Jangan lepaskan pandanganmu, aku ingin melihat kebahagiaanmu!",
    "Hah! Gerakanmu begitu indah dan penuh keyakinan, aku suka!",
    "Ahh! Biarkan seluruh kehangatan ini memenuhi ruangan hingga pagi!",
    "Hah! Kamu adalah kombinasi sempurna antara kecantikan dan gairah!",
    "Ugh! Teruskan sentuhanmu di situ, kamu membuatku makin tak terkendali!",
    "Hah! Dekatkan tubuhmu tanpa sisa jarak, kita buat malam ini milik kita!",
    "Ahh! Rintihanmu adalah musik paling menggebu yang pernah kudengar!",
    "Hah! Genggam bahuku erat-erat saat gairah ini membawa kita melayang!",
    "Ugh! Kamu sungguh luar biasa, tidak ada yang bisa menandingi pesonamu!",
    "Hah! Nikmati setiap hembusan gairah ini, aku ada untukmu sepenuhnya!",
    "Ahh! Kecupan panas di lehermu akan mengingatkanmu betapa dalamnya cintaku!",
    "Hah! Jangan ragu untuk menunjukkan betapa besarnya rasa manjamu!",
    "Ugh! Keberanianmu merangkulku membuat suasana semakin memuncak!",
    "Hah! Bisikkan apa yang paling kamu inginkan, aku akan mewujudkannya!",
    "Ahh! Kehangatan kita menyatu bagaikan simfoni malam yang megah!",
    "Hah! Rasakan detak jantungku yang berpacu kencang menyambutmu!",
    "Ugh! Kamu membuat malam biasa menjadi pengalaman percintaan berharga!",
    "Hah! Pegang tanganku dan rasakan getaran energi percintaan ini!",
    "Ahh! Desahan manjamu memacu semangatku untuk memanjakanmu!",
    "Hah! Jangan biarkan momen penuh gairah ini berakhir terlalu cepat!",
    "Ugh! Sentuhan memikatmu selalu berhasil melumpuhkan pertahananku!",
    "Hah! Kebersamaan kita di sini adalah kombinasi cinta paling membara!",
    "Ahh! Tatapan penuh gairahmu memberi sinyal bahwa malam ini sempurna!",
    "Hah! Teruslah mengusap dadaku, aku menyukai sensasi hangat jemarimu!",
    "Ugh! Kita adalah pasangan paling serasi saat menyatukan raga ini!",
    "Hah! Dengarkan deru napasku, semuanya dipicu oleh kecantikanmu!",
    "Ahh! Jangan berhenti memanjakanku, biarkan malam jadi saksi cinta!",
    "Hah! Kehangatan bibirmu di bibirku adalah rasa paling memabukkan!",
    "Ugh! Dekap tubuhku sekuat yang kamu bisa, kita arungi kebahagiaan!",
    "Hah! Rintihan penuh nikmatmu membuktikan indahnya rasa memiliki!",
    "Ahh! Nikmati setiap detik sapuan mesra ini, aku di sisimu selalu!",
    "Hah! Kamu telah memenangkan seluruh hati dan gairahku malam ini!",
    "Ugh! Mari kita tuntaskan kebersamaan intim ini dalam pelukan mesra!"
  ];

  // ==========================================================
  // LIBRARY 50 DIALOG USER LAKI-LAKI KIND (PENYAYANG / LEMBUT)
  // ==========================================================
  static const List<String> _kindDialogues = [
    "Hah... kamu membuatku merasa menjadi pria paling bahagia di dunia...",
    "Mmh... rasakan kehangatan dadaku ya sayang, aku selalu memelukmu...",
    "Hah... aku ingin memastikan kamu merasa nyaman dan dicintai...",
    "Ugh... sentuhan jemarimu begitu lembut, memberikan kedamaian...",
    "Hah... peluk aku erat-erat, tidak ada tempat lebih aman dari dekapan ini...",
    "Mmh... kecupan manis di bibirmu adalah bentuk ketulusan cintaku...",
    "Hah... aku mencintaimu lebih dari kata-kata yang bisa kuucapkan...",
    "Ugh... nikmati setiap moment kebersamaan ini dengan tenang...",
    "Hah... bisikan lembutmu terasa bagaikan embun sejuk yang menyegarkan...",
    "Mmh... bersamamu di sini membuat seluruh lelah di hariku sirnah...",
    "Hah... aku tidak ingin malam romantis ini cepat berlalu begitu saja...",
    "Ugh... kehangatan jiwamu menyatu sempurna dengan kehangatan ragaku...",
    "Hah... sandarkan kepalamu di manapun kamu mau, aku menopangmu...",
    "Mmh... aku akan selalu menyayangi dan menjagamu dalam kondisi apapun...",
    "Hah... kedamaian di mata indahmu membuat hatiku bergetar penuh syukur...",
    "Ugh... terima kasih sudah hadir dan membagikan kasih sayang tulusmu...",
    "Hah... aku akan melindungimu dan memanjakanmu dengan sepenuh jiwa...",
    "Mmh... aku merasa utuh dan sempurna setiap kali memelukmu...",
    "Hah... mari kita lewati malam mesra ini dengan rasa saling menghargai...",
    "Ugh... kamu adalah kebahagiaan terbesar yang pernah kutemui...",
    "Hah... kecupan lembut di keningmu adalah pengingat betapa berharganya kamu...",
    "Mmh... dengarkan detak jantungku, setiap ketukannya menyuarakan namamu...",
    "Hah... kelembutan usapanmu membuatku merasa dicintai sepenuhnya...",
    "Ugh... tataplah aku dengan kasih sayangmu yang memberikan kedamaian...",
    "Hah... tidak ada hal yang lebih indah daripada melihat senyum bahagiamu...",
    "Mmh... biarkan aku mengusap jemarimu dan memberikan kehangatan...",
    "Hah... setiap helaan napas kita menguatkan ikatan cinta di antara kita...",
    "Ugh... berada di sisimu membuatku mengerti arti sejati cinta tulus...",
    "Hah... bisikan mesramu menenangkan setiap keraguan dalam diriku...",
    "Mmh... bersandarlah padaku, aku akan menjadi pelindung setia hidupmu...",
    "Hah... kecupan mesra ini adalah tanda betapa aku mengasihimu...",
    "Ugh... ketulusan caramu mendekapku memberikan rasa damai mendalam...",
    "Hah... mari kita rajut kenangan indah yang terus membahagiakan kita...",
    "Mmh... kehangatan batin kita menyatu bagaikan simfoni kebahagiaan...",
    "Hah... terima kasih sudah mempercayaiku membagikan rasa intim ini...",
    "Ugh... setiap detik yang dihabiskan bersamamu adalah berkah kubanggakan...",
    "Hah... belai pipiku pelan, aku menyukai kelembutan usapan tanganmu...",
    "Mmh... pelukan ini adalah rumah tempat hatiku selalu pulang padamu...",
    "Hah... desahan lembut penuh rasa syukurmu adalah hadiah berharga...",
    "Ugh... aku akan selalu memastikan kebahagiaanmu jadi prioritas utamaku...",
    "Hah... tatapan ketulusan matamu selalu menghangatkan jiwaku...",
    "Mmh... usap rambutku dan biarkan aku menikmati momen kedamaian ini...",
    "Hah... tidak ada yang perlu dikhawatirkan, aku selalu memelukmu...",
    "Ugh... rasakan kehangatan kasihku yang mengalir di kecupan lembut ini...",
    "Hah... kita akan selalu saling menopang dan mengasihi selamanya...",
    "Mmh... senyum manismu di keheningan malam ini sungguh memikat hati...",
    "Hah... aku ingin memberikan yang terbaik agar kamu merasa beruntung...",
    "Ugh... pelukan mesra ini akan menyelimuti kita hingga fajar menyapa...",
    "Hah... ketulusan cintamu adalah alasan terbesar bagiku tersenyum...",
    "Mmh... mari kita lelap dalam dekapan penuh cinta yang tak terhingga..."
  ];

  static String getRandomDialogue([dynamic player]) {
    String trait = '';
    if (player is Character) {
      trait = player.traits.join(' ').toLowerCase();
    } else if (player is Map<String, dynamic>) {
      trait = (player['personality'] ?? player['trait'] ?? '').toString().toLowerCase();
    }
    if (trait.contains('pemalu') || trait.contains('shy') || trait.contains('pendiam')) {
      return _shyDialogues[_random.nextInt(_shyDialogues.length)];
    }
    if (trait.contains('ekstrovert') || trait.contains('bold') || trait.contains('gairah') || trait.contains('percaya diri')) {
      return _boldDialogues[_random.nextInt(_boldDialogues.length)];
    }
    if (trait.contains('penyayang') || trait.contains('kind') || trait.contains('baik')) {
      return _kindDialogues[_random.nextInt(_kindDialogues.length)];
    }
    final int category = _random.nextInt(3);
    if (category == 0) return _shyDialogues[_random.nextInt(_shyDialogues.length)];
    if (category == 1) return _boldDialogues[_random.nextInt(_boldDialogues.length)];
    return _kindDialogues[_random.nextInt(_kindDialogues.length)];
  }
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



  /// Desahan User Laki-Laki
  static List<VNDialogueNode> getMoanNodes({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final rand = Random();

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
      final String rawMoan = DesahanUserLakiMakeLove.getRandomMoan(player);
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
    final List<VNDialogueNode> sequence = [];
    int npcIndex = 0;

    // Loop sebanyak 100 iterasi, node terakhir akan kembali ke awal
    for (int i = 0; i < 100; i++) {
        // Desahan Pemain
        sequence.add(VNDialogueNode(
          speakerName: player.name,
          dialogueText: DesahanUserLakiMakeLove.getRandomMoan(player),
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
