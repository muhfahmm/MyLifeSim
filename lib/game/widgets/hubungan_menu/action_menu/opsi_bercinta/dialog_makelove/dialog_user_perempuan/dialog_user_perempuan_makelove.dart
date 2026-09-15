// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/dialog_makelove/dialog_user_perempuan/dialog_user_perempuan_makelove.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_user_perempuan/desahan_user_perempuan_makelove.dart';

class DialogUserPerempuanMakeLove {
  static final Random _random = Random();

  // ==========================================================
  // LIBRARY 50 DIALOG USER PEREMPUAN SHY (PEMALU)
  // ==========================================================
  static const List<String> _shyDialogues = [
    "Mmh... pelan-pelan ya sayang... w-wajahku rasanya memerah sekali di dekatmu...",
    "Hah... jangan tatap mataku terlalu dekat, aku merasa sangat malu...",
    "A-aku... ahh... rasanya jantungku berdegup tak karuan saat memelukmu...",
    "Hah... bisakah kita saling berpelukan erat seperti ini lebih lama?",
    "Mmh... sentuhan lembut jemarimu membuat seluruh ragaku menjadi lemas...",
    "Hah... jangan tinggalkan aku... aku merasa sangat nyaman bersamamu...",
    "Aah... peluk aku dari belakang ya, aku ingin merasakan kehangatanmu...",
    "Hah... kamu membuatku tidak bisa berpikir selain tentangmu malam ini...",
    "Ahh... k-kamu mendengar suaraku? Aduh malu sekali...",
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
  // LIBRARY 50 DIALOG USER PEREMPUAN BOLD (GAIRAH / PERCAYA DIRI)
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
  // LIBRARY 50 DIALOG USER PEREMPUAN KIND (PENYAYANG / LEMBUT)
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



  /// Desahan User Perempuan
  static List<VNDialogueNode> getMoanNodes({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final rand = Random();

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
      final String rawMoan = DesahanUserPerempuanMakeLove.getRandomMoan(player);
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
          dialogueText: DesahanUserPerempuanMakeLove.getRandomMoan(player),
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
