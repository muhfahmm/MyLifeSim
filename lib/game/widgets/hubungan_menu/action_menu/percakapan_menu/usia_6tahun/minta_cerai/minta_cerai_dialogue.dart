// lib/game/widgets/hubungan_menu/action_menu/percakapan_menu/usia_6tahun/minta_cerai/minta_cerai_dialogue.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

class MintaCeraiDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
  }) {
    final String npcName = npc['name'] ?? 'Orang Tua';
    final String npcRole = npc['role'] ?? 'Orang Tua';

    final bool isStepParent = npcRole.toLowerCase().contains('tiri') ||
        (player.stepFatherName != null && player.stepFatherName == npcName) ||
        (player.stepMotherName != null && player.stepMotherName == npcName);

    final bool isDivorcedOrRemarried = player.isFatherDivorced || player.isMotherDivorced || isStepParent;

    final int argCount = player.parentArgumentCount;

    final List<String> playerOpenings;
    final List<VNChoiceOption> allChoices;

    if (isDivorcedOrRemarried) {
      // Narasi & Pembukaan Khusus jika bicara tentang/dengan Orang Tua Tiri / Pasangan Pernikahan Kembali
      playerOpenings = [
        '$npcName... Ada hal penting yang ingin kukatakan tentang pernikahan kalian di rumah ini... 💔',
        '$npcName... Aku merasa pernikahan kalian kurang cocok dan hubungan di rumah terasa canggung... 🥺',
        '$npcName... Bisakah kita bicara jujur? Aku merasa kamu dan pasanganku lebih baik berpisah saja... 🧊',
        '$npcName... Suasana pernikahan ini makin terasa membebankan bagi kita semua... 🌧️',
        '$npcName... Kurasa perpisahan kalian adalah jalan terbaik agar rumah tangga ini tak makin rumit... 💔',
      ];

      allChoices = [
        VNChoiceOption(
          text: '💔 "Aku rasa hubungan kalian kurang serasi dan tidak cocok bersama..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 4).clamp(0, 100);
          },
          nextNodeIndex: 2,
        ),
        VNChoiceOption(
          text: '🏠 "Suasana rumah terasa canggung sejak pernikahan baru ini..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 3).clamp(0, 100);
          },
          nextNodeIndex: 3,
        ),
        VNChoiceOption(
          text: '⚡ "Kalian berdua sering tidak sejalan dan tampak tidak bahagia..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 5).clamp(0, 100);
          },
          nextNodeIndex: 4,
        ),
        VNChoiceOption(
          text: '🌧️ "Aku merasa demi kebaikan bersama, perpisahan adalah opsi terbaik..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 4).clamp(0, 100);
          },
          nextNodeIndex: 5,
        ),
        VNChoiceOption(
          text: '🛑 "Tolong pertimbangkan untuk mengakhiri pernikahan ini demi kenyamanan..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 5).clamp(0, 100);
          },
          nextNodeIndex: 6,
        ),
      ];
    } else {
      // 5 Variasi dialog pembuka standar untuk orang tua kandung (pertengkaran berulang ke-N)
      playerOpenings = [
        '$npcName... Ada hal penting yang ingin kukatakan soal hubungan kalian di rumah... 💔',
        '$npcName... Kenapa kalian harus selalu bertengkar setiap hari? Aku tidak tahan lagi... 😢',
        '$npcName... Pertengkaran kalian tadi sangat menakutkan. Apakah kalian tidak bisa akur lagi? 💥',
        '$npcName... Suasana rumah ini terasa makin dingin dan menyiksa. Bisakah kita bicara jujur? 🧊',
        '$npcName... Ini pertengkaran ke-$argCount yang kudengar. Bisakah kita akhiri perselisihan ini? 💔',
      ];

      allChoices = [
        VNChoiceOption(
          text: '💥 "Kalian sering bertengkar dan suasana rumah tidak tenang..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 5).clamp(0, 100);
          },
          nextNodeIndex: 2,
        ),
        VNChoiceOption(
          text: '🏡 "Aku rasa lebih baik hanya tinggal bersama satu orang tua saja..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 3).clamp(0, 100);
          },
          nextNodeIndex: 3,
        ),
        VNChoiceOption(
          text: '💔 "Kalian berdua terlihat sudah tidak bahagia lagi bersama..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 4).clamp(0, 100);
          },
          nextNodeIndex: 4,
        ),
        VNChoiceOption(
          text: '🌪️ "Pertengkaran kalian terus berulang dan membuatku sangat tertekan..."',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 6).clamp(0, 100);
          },
          nextNodeIndex: 5,
        ),
        VNChoiceOption(
          text: '🛑 "Hentikan sandiwara ini... Jika memang tidak cocok, lebih baik pisah saja!"',
          onSelect: (p, n) {
            p.happiness = (p.happiness - 5).clamp(0, 100);
          },
          nextNodeIndex: 6,
        ),
      ];
    }

    final String playerDialogueText = playerOpenings[(argCount - 1).clamp(0, playerOpenings.length - 1)];

    // Acak dan ambil 2 pilihan secara random dari 5 pilihan yang ada
    allChoices.shuffle();
    final selectedChoices = allChoices.take(2).toList();

    return [
      VNDialogueNode(
        speakerName: player.name,
        dialogueText: playerDialogueText,
        emotion: VNEmotionType.sad,
        isPlayerSpeaking: true,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Kenapa sayang? Ada apa? Kamu kelihatan sedih sekali... Bicara jujur pada $npcName.',
        emotion: VNEmotionType.surprised,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: selectedChoices,
      ),
      // Index 2: Opsi 1 - Pertengkaran Suasana Rumah
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Maafkan $npcName ya nak... $npcName tidak sadar pertengkaran ini membuatmu tertekan. Bagaimana tanggapanmu jika $npcName membicarakannya sekarang?',
        emotion: VNEmotionType.sad,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '💔 "Ya, tolong bercerai sekarang demi ketenangan rumah."',
            onSelect: (p, n) {
              p.parentsDivorceYearsLeft = 1;
              p.inbox.add('💔 Permintaan Cerai: Orang tuamu akan memproses perpisahan mereka 1 tahun ke depan.');
            },
            nextNodeIndex: 7,
          ),
          VNChoiceOption(
            text: '⏳ "Tolong pikirkan baik-baik dulu 2-3 tahun ke depan..."',
            onSelect: (p, n) {
              final int years = 2 + (DateTime.now().millisecondsSinceEpoch % 2);
              p.parentsDivorceYearsLeft = years;
              p.inbox.add('⏳ Pertimbangan Cerai: Orang tuamu akan memikirkan opsi bercerai dalam $years tahun ke depan.');
            },
            nextNodeIndex: 8,
          ),
        ],
      ),
      // Index 3: Opsi 2 - Satu Orang Tua
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Begitu ya... Jika kamu merasa lebih nyaman dengan satu orang tua, apakah kamu ingin $npcName mengambil keputusan saat ini juga?',
        emotion: VNEmotionType.sad,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '💔 "Ya, langsung putuskan pisah sekarang."',
            onSelect: (p, n) {
              p.parentsDivorceYearsLeft = 1;
              p.inbox.add('💔 Permintaan Cerai: Orang tuamu menyetujui untuk memproses perpisahan 1 tahun ke depan.');
            },
            nextNodeIndex: 7,
          ),
          VNChoiceOption(
            text: '⏳ "Pertimbangkan dulu baik-baik 2-3 tahun ke depan..."',
            onSelect: (p, n) {
              final int years = 2 + (DateTime.now().millisecondsSinceEpoch % 2);
              p.parentsDivorceYearsLeft = years;
              p.inbox.add('⏳ Pertimbangan Cerai: Orang tuamu mempertimbangkan opsi bercerai dalam $years tahun ke depan.');
            },
            nextNodeIndex: 8,
          ),
        ],
      ),
      // Index 4: Opsi 3 - Tidak Bahagia
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Kamu peka sekali nak... Memang hubungan kami sudah hambar. Apakah menurutmu kami harus langsung berpisah atau memikirkannya dulu?',
        emotion: VNEmotionType.sad,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '💔 "Ya, berpisah sekarang adalah keputusan terbaik."',
            onSelect: (p, n) {
              p.parentsDivorceYearsLeft = 1;
              p.inbox.add('💔 Permintaan Cerai: Orang tuamu sepakat berpisah 1 tahun ke depan.');
            },
            nextNodeIndex: 7,
          ),
          VNChoiceOption(
            text: '⏳ "Tolong dipikirkan dulu 2-3 tahun ke depan..."',
            onSelect: (p, n) {
              final int years = 2 + (DateTime.now().millisecondsSinceEpoch % 2);
              p.parentsDivorceYearsLeft = years;
              p.inbox.add('⏳ Pertimbangan Cerai: Orang tuamu berjanji akan memikirkannya dalam $years tahun ke depan.');
            },
            nextNodeIndex: 8,
          ),
        ],
      ),
      // Index 5: Opsi 4 - Pertengkaran Berulang & Tertekan
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Aduh nak... $npcName sangat menyesal membuat mentalmu terganggu. Apakah kamu benar-benar ingin kami menyudahi pernikahan ini?',
        emotion: VNEmotionType.sad,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '💔 "Ya, sudahi pernikahan ini demi kebaikan bersama."',
            onSelect: (p, n) {
              p.parentsDivorceYearsLeft = 1;
              p.inbox.add('💔 Permintaan Cerai: Orang tuamu akan menyudahi pernikahan 1 tahun ke depan.');
            },
            nextNodeIndex: 7,
          ),
          VNChoiceOption(
            text: '⏳ "Tolong berikan waktu 2-3 tahun lagi untuk menimbang..."',
            onSelect: (p, n) {
              final int years = 2 + (DateTime.now().millisecondsSinceEpoch % 2);
              p.parentsDivorceYearsLeft = years;
              p.inbox.add('⏳ Pertimbangan Cerai: Orang tuamu sepakat menimbang ulang dalam $years tahun.');
            },
            nextNodeIndex: 8,
          ),
        ],
      ),
      // Index 6: Opsi 5 - Hentikan Sandiwara & Pisah
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Kata-katamu sangat menohok $npcName... Kamu benar, berpura-pura baik-baik saja hanya memperparah keadaan. Bagaimana langkah selanjutnya?',
        emotion: VNEmotionType.surprised,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(
            text: '💔 "Putuskan perpisahan sekarang juga!"',
            onSelect: (p, n) {
              p.parentsDivorceYearsLeft = 1;
              p.inbox.add('💔 Permintaan Cerai: Orang tuamu memutuskan untuk berpisah 1 tahun ke depan.');
            },
            nextNodeIndex: 7,
          ),
          VNChoiceOption(
            text: '⏳ "Beri waktu 2-3 tahun lagi sebelum mengambil keputusan akhir..."',
            onSelect: (p, n) {
              final int years = 2 + (DateTime.now().millisecondsSinceEpoch % 2);
              p.parentsDivorceYearsLeft = years;
              p.inbox.add('⏳ Pertimbangan Cerai: Orang tuamu menahan keputusan akhir selama $years tahun.');
            },
            nextNodeIndex: 8,
          ),
        ],
      ),
      // Index 7: Penutup Ya (1 Tahun Ke Depan)
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Baiklah nak... Kami mendengar permintaanmu. Berikan kami waktu 1 tahun untuk memproses dan memutuskan perpisahan ini secara matang. ❤️',
        emotion: VNEmotionType.neutral,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
      // Index 8: Penutup Memikirkan (2-3 Tahun)
      VNDialogueNode(
        speakerName: npcName,
        dialogueText: 'Terima kasih nak. Kami akan memikirkannya secara matang selama 2-3 tahun ke depan demi kebaikan bersama. ❤️',
        emotion: VNEmotionType.neutral,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
      ),
    ];
  }

  /// Dialog Keputusan Perceraian (Setelah 1-3 Tahun Masa Pertimbangan)
  static List<VNDialogueNode> getDecisionDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    required bool isDivorced,
  }) {
    final String npcName = npc['name'] ?? 'Orang Tua';

    if (isDivorced) {
      return [
        VNDialogueNode(
          speakerName: npcName,
          dialogueText: 'Nak... Setelah mempertimbangkan dengan matang selama ini, $npcName dan pasangan akhirnya memutuskan bahwa berpisah adalah jalan terbaik. 💔',
          emotion: VNEmotionType.sad,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: 'Aku mengerti... Semoga ini jadi keputusan terbaik untuk kebahagiaan kalian berdua. 🥺',
          emotion: VNEmotionType.sad,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    } else {
      return [
        VNDialogueNode(
          speakerName: npcName,
          dialogueText: 'Nak... Setelah kami pikirkan baik-baik selama ini, kami memutuskan untuk saling memperbaiki diri dan tetap bersama. Kami tidak jadi bercerai! 💖',
          emotion: VNEmotionType.happy,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: 'Wah... Aku senang sekali mendengarnya! Terima kasih sudah bertahan demi rumah kita! 🎉✨',
          emotion: VNEmotionType.happy,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
      ];
    }
  }
}
