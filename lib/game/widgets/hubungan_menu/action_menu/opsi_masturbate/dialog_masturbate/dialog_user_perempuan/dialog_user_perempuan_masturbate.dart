import 'dart:math';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/desahan_user_perempuan/desahan_user_perempuan_masturbate.dart';

class DialogUserPerempuanMasturbate {
  // 50 Dialogue Pemalu / Malu-malu (Shy)
  static final List<String> _shyDialogues = [
    "Ah... menyentuh diriku sendiri seperti ini rasanya malu sekali... ngh...",
    "Membayangkanmu sambil jemariku bergerak... ahh... nakal sekali ya aku...",
    "Ngh... dadaku berdebar kencang saat membayangkan sentuhanmu...",
    "Uuh... pelan-pelan jari ini menyentuh area sensitifku... ahh...",
    "Ngh... membayangkan wajah tampanmu membuat vaginaku semakin basah...",
    "Ah... malunya... tapi rasanya nikmat sekali, ngh...",
    "Setiap kali memejamkan mata, hanya senyummu yang kubayangkan... ahh...",
    "Ngh... napasku jadi pendek-pendek... malu kalau ada yang dengar...",
    "Uuh... menyentuh titik peka ini sambil bisikkan namamu... ahh...",
    "Ngh... menggigit bibirku sendiri biar tak mendesah keras-keras...",
    "Ah... kehangatan jari-jariku membuatku makin tak tahan... ngh...",
    "Membayangkan pelukanmu di malam yang dingin ini... ahh...",
    "Ngh... perlahan mengusap bagian dalam paha... malunya...",
    "Uuh... rasanya makin geli dan basah... ahh...",
    "Ngh... hatiku berdesir saat membayangkanmu menatapku...",
    "Ah... andai kamu ada di sini untuk menyentuhku... ngh...",
    "Mata tertutup rapat, hanya fantasi bersamamu yang ada... ahh...",
    "Ngh... remasan lembut di payudaraku sendiri... uuh...",
    "Ah... jari-jariku makin cepat bergerak... malu tapi nikmat...",
    "Ngh... rasa hangat ini meluap dari dalam diriku... ahh...",
    "Uuh... pipiku pasti merah padam sekarang... ngh...",
    "Ngh... bisikan manjamu seolah terdengar di telingaku... ahh...",
    "Ah... meremas bantal sambil membayangkan tubuhmu... ngh...",
    "Ngh... detak jantungku makin tak beraturan... ahh...",
    "Uuh... rasanya makin peka setiap kali jemariku mengusap... ngh...",
    "Ngh... membayangkan kehangatan sentuhanmu di tubuhku... ahh...",
    "Ah... rasanya membuatku lemas dan tak berdaya... ngh...",
    "Ngh... gigitan kecil di bibir bawahku agar tetap meredam desah... ahh...",
    "Uuh... sentuhan lembut ini membuatku membayangkanmu... ngh...",
    "Ngh... ahh... membayangkan jemarimu menggantikan jemariku...",
    "Ah... desir nikmat ini semakin memuncak... ngh...",
    "Ngh... meremas sprei dengan erat... malunya diriku... ahh...",
    "Uuh... rasa hangat berdenyut di area intimku... ngh...",
    "Ngh... menutup wajahku dengan sebelah tangan... ahh...",
    "Ah... betapa inginnya aku disentuh olehmu langsung... ngh...",
    "Ngh... detak desahku semakin pelan namun makin dalam... ahh...",
    "Uuh... mengusap lembut dadaku yang berdebar... ngh...",
    "Ngh... sensasi gatal nikmat ini makin terasa... ahh...",
    "Ah... membayangkan usapan manismu di pipiku... ngh...",
    "Ngh... napas memburu sambil menikmati rasa hangat ini... ahh...",
    "Uuh... jemariku makin licin oleh cairan manisku sendiri... ngh...",
    "Ngh... ahh... hampir tak mampu menahan denyutan ini...",
    "Ah... bayanganmu begitu nyata di benakku... ngh...",
    "Ngh... rasanya malu tapi tubuhku begitu menginginkannya... ahh...",
    "Uuh... perlahan-lahan makin mendekati puncak... ngh...",
    "Ngh... desahan halus lolos dari bibirku... ahh...",
    "Ah... menyentuh klitorisku dengan sangat perlahan... ngh...",
    "Ngh... kehangatan ini membuat mataku berkaca-kaca... ahh...",
    "Uuh... sungguh fantasi indah bersamamu... ngh...",
    "Ngh... ahh... desahan malu ini hanya untuk bayanganmu...",
  ];

  // 50 Dialogue Berani / Liar (Bold)
  static final List<String> _boldDialogues = [
    "Ah... jari-jariku menari liar di dalam kewanitaanku... nikmat sekali!",
    "Membayangkan tubuh kekar milikmu membuatku meremas diriku makin keras... ahh!",
    "Ngh... makin dalam jemariku merasuk, makin memuncak gairahku!",
    "Uuh... lihat betapa basahnya aku saat membayangkanmu memuaskanku... ahh!",
    "Ngh... aku ingin merintih keras-keras memanggil namamu malam ini!",
    "Ah... usapan di clit ini membuat seluruh tubuhku gemetar hebat... ngh!",
    "Membayangkan lidahmu menyapu area sensitifku... ahh... begitu panas!",
    "Ngh... jemariku mengocok cairan hangatku yang melimpah ini!",
    "Uuh... tak bisa berhentii... sentuhan ini begitu nikmat dan liar... ahh!",
    "Ngh... membayangkanmu menatapku penuh nafsu saat aku masturbasi!",
    "Ah... tekan lebih dalam... ahh... rasanya memabukkan sekali!",
    "Ngh... seluruh tubuhku menegang menanti klimaks yang dahsyat ini!",
    "Uuh... betapa haus dan gilanya aku akan sentuhanmu... ahh!",
    "Ngh... jari-jariku bergerak semakin cepat tanpa henti... ngh!",
    "Ah... basah, hangat, dan gatal nikmat ini makin membakar... ahh!",
    "Ngh... fantasi tentangmu membuat kewanitaanku berdenyut kencang!",
    "Uuh... remasan di dadaku makin kencang seiring hembusan napas liarku... ahh!",
    "Ngh... aku ingin kamu tahu betapa nakalnya aku di atas ranjang ini!",
    "Ah... desahan keras ini tak bisa lagi kutahan... ngh... ahh!",
    "Ngh... membayangkan posisi kita yang saling mengunci rapat!",
    "Uuh... cairan manisku mengalir makin deras... ahh... nikmatnya!",
    "Ngh... jari-jari ini merangsang titik ternikmat dalam diriku!",
    "Ah... ayolah, puncaknya makin dekat... sentuh lebih liar... ngh!",
    "Ngh... memejamkan mata sambil membayangkan hentakanmu yang intens!",
    "Uuh... tubuhku melengkung menikmati pacuan jemariku sendiri... ahh!",
    "Ngh... gairah ini begitu membara hingga membakar seluruh sukmaku!",
    "Ah... merintih pasrah pada kenikmatan buatan jemariku sendiri... ngh!",
    "Ngh... membayangkan kamu memaksa masuk dan memuaskanku sepenuhnya!",
    "Uuh... sentuhan tak sabar ini makin membuatku meledak... ahh!",
    "Ngh... ahh... nikmat tiada tara saat membayangkan cintamu!",
    "Ah... gesekan hangat ini benar-benar membuatku gila... ngh!",
    "Ngh... membayangkan genggaman tanganmu yang kuat di pinggulku!",
    "Uuh... makin cepat... makin dalam... ahh... nikmat sekali!",
    "Ngh... keringat dingin menetes saat gairah ini mencapai puncak!",
    "Ah... lubang kewanitaanku menjepit erat jemariku sendiri... ngh!",
    "Ngh... betapa inginnya aku membuang semua rasa malu malam ini!",
    "Uuh... sentuhan langsung di titik sensitif ini sungguh intens... ahh!",
    "Ngh... merintih nikmat membayangkan kamu memperhatikan setiap gerakanku!",
    "Ah... guncangan gairah ini membuat paha dan kakiku berguncang hebat... ngh!",
    "Ngh... tak ada yang bisa menghentikan kenikmatan liar ini... ahh!",
    "Uuh... membayangkan gigitan manismu di leherku saat aku mengusap kewanitaanku!",
    "Ngh... ahh... puncaknya semakin mendekat dengan sangat cepat!",
    "Ah... rasanya ingin meledak dalam kenikmatan gila ini... ngh!",
    "Ngh... meliukkan badanku mengikuti irama cepat jemariku!",
    "Uuh... betapa indahnya rasa panas yang merayap di tubuhku... ahh!",
    "Ngh... meremas sprei dan menjerit halus menahan nikmatnya gairah!",
    "Ah... bayanganmu membuatku menjadi wanita paling liar... ngh!",
    "Ngh... gesekan ini... sentuhan ini... benar-benar memabukkan... ahh!",
    "Uuh... sebentar lagi puncak gila ini akan menyergapku... ngh!",
    "Ngh... ahh... kenikmatan panas ini melelehkan seluruh kesadaranku!",
  ];

  // 50 Dialogue Penyayang / Manis (Kind)
  static final List<String> _kindDialogues = [
    "Ah... sentuhan lembut ini mengingatkanku pada hangatnya kasih sayangmu...",
    "Membayangkan senyum manismu membuat hati dan tubuhku merasa tenang... ahh...",
    "Ngh... betapa beruntungnya aku memiliki bayangan dirimu di benakku...",
    "Uuh... usapan perlahan ini penuh dengan kehangatan cinta untukmu... ahh...",
    "Ngh... merindukanmu sambil menyentuh diriku dengan penuh kelembutan...",
    "Ah... rasanya begitu damai dan nikmat saat membayangkan pelukanmu... ngh...",
    "Setiap desahan ini adalah bukti betapa besarnya cintaku padamu... ahh...",
    "Ngh... jemariku bergerak lembut seakan kamu sedang membelai diriku...",
    "Uuh... perasaan hangat ini mengalir indah di dalam dada dan tubuhku... ahh...",
    "Ngh... memikirkan kebaikan dan kelembutanmu membuatku terbuai...",
    "Ah... sentuhan hangat ini tercipta dari rinduku padamu... ngh...",
    "Ngh... membayangkan bisikan manismu yang menenangkan jiwaku... ahh...",
    "Uuh... begitu indah meresapi rasa cinta ini saat menyentuh diriku... ngh...",
    "Ngh... napas teratur dan lembut mengiringi fantasi indah kita...",
    "Ah... senyumanmu selalu berhasil menghangatkan malam-malamku... ngh...",
    "Ngh... mengusap perut dan paha dengan penuh kasih sayang... ahh...",
    "Uuh... kelembutan sentuhanmu selalu terpatri jelas di hatiku... ngh...",
    "Ngh... memejamkan mata sambil mengucap syukur atas cintamu... ahh...",
    "Ah... kenikmatan ini begitu manis dan penuh kehangatan jiwa... ngh...",
    "Ngh... betapa bahagianya aku bisa mencintaimu sepenuh hatiku...",
    "Uuh... getaran nikmat ini terasa begitu lembut dan menenangkan... ahh...",
    "Ngh... meresapi setiap detik kehangatan yang mengalir indah ini...",
    "Ah... mengelus dada sendiri sambil membayangkan sandaran bahumu... ngh...",
    "Ngh... rasa rindu yang membuncah ini tercipta indah... ahh...",
    "Uuh... jemariku bergerak pelan dengan kasih sayang yang tulus... ngh...",
    "Ngh... membayangkan kamu menatapku dengan mata yang penuh kedamaian...",
    "Ah... kehangatan cinta ini melapisi setiap sentuhan jemariku... ngh...",
    "Ngh... desahan pelan ini membawa sejuta kebahagiaan bersamamu... ahh...",
    "Uuh... mengusap titik peka dengan rasa sayang yang mendalam... ngh...",
    "Ngh... ahh... betapa indahnya rasa cinta saat membayangkan hadirmu...",
    "Ah... getaran lembut ini sungguh menentramkan hatiku... ngh...",
    "Ngh... membayangkan kecupan manismu di keningku saat aku terpejam...",
    "Uuh... kehangatan alami ini menyebar ke seluruh tubuhku... ahh...",
    "Ngh... tersenyum kecil di sela desahan manis untukmu...",
    "Ah... betapa bahagianya membayangkan kita saling memiliki... ngh...",
    "Ngh... sentuhan pelan yang menghanyutkan dalam keindahan cinta... ahh...",
    "Uuh... rasa kasihmu selalu memberi kehangatan tiada tara... ngh...",
    "Ngh... membayangkan kelembutan usapan tanganmu di jemariku...",
    "Ah... kenikmatan yang manis dan tenang mengalun perlahan... ngh...",
    "Ngh... setiap embusan napas ini menyuarakan rasa rinduku... ahh...",
    "Uuh... menyentuh area intimku dengan kedamaian di dalam jiwa... ngh...",
    "Ngh... ahh... keindahan fantasi cinta yang begitu suci dan manis...",
    "Ah... rasa hangat di dalam dadaku kian mengembang indah... ngh...",
    "Ngh... membiarkan diriku larut dalam hangatnya ingatan tentangmu... ahh...",
    "Uuh... perlahan dan lembut menuju puncak kebahagiaan ini... ngh...",
    "Ngh... bisikan rasa cintaku selalu ada di setiap desahan ini... ahh...",
    "Ah... betapa indahnya saat hati dan tubuh saling menyatu... ngh...",
    "Ngh... kehangatan cinta milikmu selalu menyertaiku... ahh...",
    "Uuh... perasaan bersyukur yang mendalam memenuhi sanubariku... ngh...",
    "Ngh... ahh... rintihan manis ini penuh dengan cinta untukmu...",
  ];

  static String getRandomDialogue([dynamic player]) {
    final rand = Random();
    int trait = 0; // 0: Shy, 1: Bold, 2: Kind
    if (player != null) {
      try {
        final personality = player.personality;
        if (personality != null) {
          int maxVal = personality.pemalu;
          if (personality.liar > maxVal) {
            maxVal = personality.liar;
            trait = 1;
          }
          if (personality.penyayang > maxVal) {
            trait = 2;
          }
        }
      } catch (_) {}
    }

    if (trait == 1) {
      return _boldDialogues[rand.nextInt(_boldDialogues.length)];
    } else if (trait == 2) {
      return _kindDialogues[rand.nextInt(_kindDialogues.length)];
    } else {
      return _shyDialogues[rand.nextInt(_shyDialogues.length)];
    }
  }

  static List<VNDialogueNode> getMoanNodes({
    required Character player,
    required Map<String, dynamic> npc,
    int count = 3,
  }) {
    final List<VNDialogueNode> nodes = [];

    final String npcName = npc['name'] ?? 'Pasangan';
    final String targetRole = npc['role'] ?? 'Pasangan';
    final String npcGender = npc['gender'] ?? 'Laki-laki';

    final String callPlayerToNpc = PanggilanManager.getPanggilan(
      targetName: npcName,
      targetRole: targetRole,
      targetGender: npcGender,
      isSpeakerPlayer: true,
      userName: player.name,
      userGender: player.gender,
      isIntimate: true,
    );

    for (int i = 0; i < count; i++) {
      final String rawMoan = DesahanUserPerempuanMasturbate.getRandomMoan(player);
      final String moanWithCall = "$rawMoan $callPlayerToNpc...";

      nodes.add(
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: moanWithCall,
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      );
    }

    return nodes;
  }
}

