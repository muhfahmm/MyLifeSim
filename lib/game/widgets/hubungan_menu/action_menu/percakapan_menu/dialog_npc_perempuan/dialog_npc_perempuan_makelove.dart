// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/dialog_npc_perempuan/dialog_npc_perempuan_makelove.dart

import 'dart:math';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

enum NPCPerempuanPersonalityType { shy, bold, kind }

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
  // LIBRARY 100 DESAHAN WANITA (DIKATEGORIKAN BERDASARKAN KEPRIBADIAN)
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
    "Hah... hah... k-kamu... jangan... ahh..."
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
    "Ahh! Ya! Teruskan! Aku sangat dekat! Hah!"
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
    "Ahh... aku sudah di puncak... hah... jangan tinggalkan aku..."
  ];

  // ==========================================================
  // FUNGSI UNTUK MEMBANGUN URUTAN DESAHAN
  // ==========================================================
  static List<String> _getMoanSequence(NPCPerempuanPersonalityType type, int count) {
    final List<String> pool = type == NPCPerempuanPersonalityType.shy
        ? _shyMoans
        : type == NPCPerempuanPersonalityType.bold
            ? _boldMoans
            : _kindMoans;

    final Random rand = Random();
    final List<String> result = [];
    final List<int> indices = List.generate(pool.length, (i) => i)..shuffle(rand);

    // Ambil sesuai count, pastikan tidak melebihi pool (100)
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
  // TAHAP 2: MEMBANGUN SEQUENCE INTIMACY (100 DESAHAN)
  // ==========================================================
  static List<VNDialogueNode> getIntimacyNodes({
    required Character player,
    required Map<String, dynamic> npc,
    required List<VNDialogueNode> playerMoanNodes,
  }) {
    final String npcName = npc['name'] ?? 'Pasangan';
    final NPCPerempuanPersonalityType personality = _getNPCPersonality(npc);

    // Pilih 15-20 desahan unik dari pool 100 desahan
    final int moanCount = 15 + Random().nextInt(6); // Antara 15-20 baris
    final List<String> moanLines = _getMoanSequence(personality, moanCount);

    final List<VNDialogueNode> sequence = [];

    // Tambahkan desahan NPC secara bergantian dengan desahan Player (saling bersahutan)
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

      // Selang-seling dengan desahan player (jika tersedia)
      if (playerMoanIndex < playerMoanNodes.length) {
        sequence.add(playerMoanNodes[playerMoanIndex]);
        playerMoanIndex++;
      }
    }

    // Jika masih ada sisa desahan player, tambahkan di akhir (sebelum Fade to Black)
    while (playerMoanIndex < playerMoanNodes.length) {
      sequence.add(playerMoanNodes[playerMoanIndex]);
      playerMoanIndex++;
    }

    // Fade to Black - Layar Hitam (Momen Puncak)
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