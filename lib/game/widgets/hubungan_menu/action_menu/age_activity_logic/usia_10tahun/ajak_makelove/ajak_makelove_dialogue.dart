// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_10tahun/ajak_makelove/ajak_makelove_dialogue.dart

import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/dialog_npc_laki/dialog_npc_laki_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/dialog_npc_perempuan/dialog_npc_perempuan_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/ciuman.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/penetrasi.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/posisi.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/oral.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/ejakulasi.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/fingering.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/stimulasi_payudara.dart';

import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class AjakMakeLoveDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    String chosenLocation = 'Kamar Tidur',
    String chosenTime = 'Malam',
    bool useCondom = false,
    bool isAccepted = true,
  }) {
    final bool isMalePlayer = player.gender.trim().toLowerCase() == 'laki-laki';
    final String npcGender = (npc['gender'] ?? 'Perempuan').toString().trim().toLowerCase();
    final bool isMaleNPC = npcGender == 'laki-laki';
    final String targetRole = (npc['role'] ?? npc['relation'] ?? npc['targetRole'] ?? 'Pasangan').toString();
    final String rawPartnerName = (npc['name'] ?? 'Pasangan').toString();
    final String partnerName = AvatarAgeRules.getCleanNPCName(rawPartnerName);

    final String callNpcToPlayer = PanggilanManager.getPanggilan(
      targetName: partnerName,
      targetRole: targetRole,
      targetGender: npcGender,
      isSpeakerPlayer: false,
      userName: player.name,
      userGender: player.gender,
      isIntimate: true,
    );

    // 1. Jika ditolak oleh NPC
    if (!isAccepted) {
      final VNDialogueNode rejectionNode = isMaleNPC
          ? DialogNpcLakiMakeLove.getRejectionNode(
              npc: npc,
              chosenLocation: chosenLocation,
              chosenTime: chosenTime,
            )
          : DialogNpcPerempuanMakeLove.getRejectionNode(
              npc: npc,
              chosenLocation: chosenLocation,
              chosenTime: chosenTime,
            );

      return [rejectionNode];
    }

    final List<VNDialogueNode> allNodes = [];

    // =========================================================================
    // INDEX BUILDER LAYOUT:
    // Index 0 : Opening Narasi & Menu Utama Awal
    // Index 1 : Menu Ciuman
    // Index 2 : Menu Oral Seks
    // Index 3 : Menu Penetrasi
    // Index 4 : Menu Posisi Seks
    // Index 5 : Menu Ejakulasi / Klimaks
    // Index 6 - 29  : Sub-Nodes Ciuman (6×4)
    // Index 30 - 33 : Sub-Nodes Oral (1×4)
    // Index 34 - 41 : Sub-Nodes Penetrasi (2×4)
    // Index 42 - 61 : Sub-Nodes Posisi (5×4)
    // Index 62 - 81 : Sub-Nodes Ejakulasi (5×4)
    // Index 82 - 85 : Sub-Nodes Stimulasi Manual
    // Index 86      : Re-choice card (loop utama)
    // Index 87      : Menu Fingering
    // Index 88 -103 : Sub-Nodes Fingering (4×4)
    // Index 104     : Menu Stimulasi Payudara
    // Index 105-120 : Sub-Nodes Stimulasi Payudara (4×4)
    // =========================================================================
    // NOTE: Node 86 is appended LAST so indices 87+ are correct.
    // =========================================================================

    // List Pilihan Sub-Aksi
    final List<VNChoiceOption> subCiumChoices = CiumanHelper.ciumOptions.map((opt) {
      final String partLabel = opt['label'] as String;
      return VNChoiceOption(
        text: '💋 $partLabel',
        nextNodeIndex: 6 + (CiumanHelper.ciumOptions.indexOf(opt) * 4),
      );
    }).toList();

    final List<VNChoiceOption> subOralChoices = [
      VNChoiceOption(
        text: isMalePlayer ? '👅 Oral Seks: Cunnilingus (Wanita)' : '👄 Oral Seks: Fellatio (Blowjob)',
        nextNodeIndex: 30,
      ),
    ];

    final List<VNChoiceOption> subPenetrasiChoices = [
      VNChoiceOption(
        text: '🌸 Penetrasi: Vagina',
        nextNodeIndex: 34,
      ),
      VNChoiceOption(
        text: '🔥 Penetrasi: Anus',
        nextNodeIndex: 38,
      ),
    ];

    final List<VNChoiceOption> subPosisiChoices = [
      VNChoiceOption(text: '👩‍❤️‍👨 Posisi: Missionary', nextNodeIndex: 42),
      VNChoiceOption(text: '🐾 Posisi: Doggy Style', nextNodeIndex: 46),
      VNChoiceOption(text: '💃 Posisi: Cowgirl', nextNodeIndex: 50),
      VNChoiceOption(text: '🔄 Posisi: 69 (Oral)', nextNodeIndex: 54),
      VNChoiceOption(text: '🌙 Posisi: Spooning', nextNodeIndex: 58),
    ];

    final List<VNChoiceOption> subEjakulasiChoices = [
      VNChoiceOption(
        text: '💦 Keluar di Dalam Vagina',
        nextNodeIndex: 62,
        // Hanya pilihan ini yang memungkinkan kehamilan
        onSelect: (p, n) { p.didCreampieThisSession = true; },
      ),
      VNChoiceOption(
        text: '🧴 Keluar di Perut / Luar',
        nextNodeIndex: 66,
        onSelect: (p, n) { p.didCreampieThisSession = false; },
      ),
      VNChoiceOption(
        text: '👑 Keluar di Wajah',
        nextNodeIndex: 70,
        onSelect: (p, n) { p.didCreampieThisSession = false; },
      ),
      VNChoiceOption(
        text: '👄 Keluar di Mulut',
        nextNodeIndex: 74,
        onSelect: (p, n) { p.didCreampieThisSession = false; },
      ),
      VNChoiceOption(
        text: '🔥 Keluar di Dalam Anus',
        nextNodeIndex: 78,
        onSelect: (p, n) { p.didCreampieThisSession = false; },
      ),
    ];

    // Sub-choices Fingering (node 87 = sub-menu, node 88-103 = isi)
    final List<VNChoiceOption> subFingeringChoices = FingeringHelper.fingeringOptions.asMap().entries.map((e) {
      return VNChoiceOption(
        text: e.value['label'] as String,
        nextNodeIndex: 88 + (e.key * 4),
      );
    }).toList();

    // Sub-choices Stimulasi Payudara (node 104 = sub-menu, node 105-120 = isi)
    final List<VNChoiceOption> subPayudaraChoices = StimulasiPayudaraHelper.payudaraOptions.asMap().entries.map((e) {
      return VNChoiceOption(
        text: e.value['label'] as String,
        nextNodeIndex: 105 + (e.key * 4),
      );
    }).toList();

    // Button Utama awal (7 Tombol: Ciuman, Oral, Penetrasi, Posisi, Fingering, Stimulasi Payudara, Stimulasi Manual)
    final List<VNChoiceOption> initialMainActionButtons = [
      VNChoiceOption(text: '💋 1. Ciuman', nextNodeIndex: 1),
      VNChoiceOption(text: '👅 2. Oral Seks', nextNodeIndex: 2),
      VNChoiceOption(text: '🌸 3. Penetrasi', nextNodeIndex: 3),
      VNChoiceOption(text: '👩‍❤️‍👨 4. Posisi Seks', nextNodeIndex: 4),
      VNChoiceOption(text: '🖐️ 5. Minta $partnerName lakukan stimulasi manual', nextNodeIndex: 82),
      VNChoiceOption(text: '👆 6. Fingering (Stimulasi Wanita)', nextNodeIndex: 87),
      VNChoiceOption(text: '🍑 7. Stimulasi Payudara', nextNodeIndex: 104),
    ];

    // Button Utama unlocked (8 Tombol: + Ejakulasi / Klimaks)
    final List<VNChoiceOption> unlockedMainActionButtons = [
      VNChoiceOption(text: '💋 1. Ciuman', nextNodeIndex: 1),
      VNChoiceOption(text: '👅 2. Oral Seks', nextNodeIndex: 2),
      VNChoiceOption(text: '🌸 3. Penetrasi', nextNodeIndex: 3),
      VNChoiceOption(text: '👩‍❤️‍👨 4. Posisi Seks', nextNodeIndex: 4),
      VNChoiceOption(text: '🖐️ 5. Minta $partnerName lakukan stimulasi manual', nextNodeIndex: 82),
      VNChoiceOption(text: '👆 6. Fingering (Stimulasi Wanita)', nextNodeIndex: 87),
      VNChoiceOption(text: '🍑 7. Stimulasi Payudara', nextNodeIndex: 104),
      VNChoiceOption(text: '💦 8. Ejakulasi / Klimaks', nextNodeIndex: 5),
    ];

    // NODE 0: Narasi Pertama (Menampilkan 5 Button Utama awal dengan Stimulasi Manual menggantikan Ejakulasi)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Suasana di $chosenLocation pada $chosenTime ini terasa begitu hangat dan romantis. Kehangatan mesra menyelimuti ${player.name} dan $partnerName. Pilih aksi intim yang ingin kamu lakukan...) ✨',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: initialMainActionButtons,
    ));

    // NODE 1: Sub-Menu Ciuman
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih bagian tubuh pasangan yang ingin kamu kecup...) 💋',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subCiumChoices,
    ));

    // NODE 2: Sub-Menu Oral Seks
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih aksi oral seks yang ingin dilakukan...) 👅',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subOralChoices,
    ));

    // NODE 3: Sub-Menu Penetrasi
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih jalur penetrasi yang ingin kamu lakukan...) 🌸',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subPenetrasiChoices,
    ));

    // NODE 4: Sub-Menu Posisi Seks
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih posisi bercinta yang kamu inginkan...) 👩‍❤️‍👨',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subPosisiChoices,
    ));

    // NODE 5: Sub-Menu Ejakulasi
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih lokasi pengeluaran cairan klimaks...) 💦',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subEjakulasiChoices,
    ));

    // =========================================================================
    // POPULATE NODES DENGAN SETIAP AKSI HANYA DIMAINKAN JIKA DIPILIH USER
    // =========================================================================

    // Sub-Nodes Ciuman (6 Opsi x 4 Nodes = 24 Nodes: Index 6 - 29)
    for (final opt in CiumanHelper.ciumOptions) {
      final partId = opt['id'] as String;
      final partLabel = opt['label'] as String;
      final ciumNodes = CiumanHelper.generateCiumDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        partId: partId,
        partLabel: partLabel,
        targetRole: targetRole,
      );
      for (int k = 0; k < ciumNodes.length; k++) {
        final isLast = k == ciumNodes.length - 1;
        final n = ciumNodes[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          // Ciuman → kembali ke menu LOCKED (tanpa Ejakulasi)
          nextIndex: isLast ? 121 : null,
          choices: null,
        ));
      }
    }

    // Sub-Nodes Oral (1 Opsi x 4 Nodes = 4 Nodes: Index 30 - 33)
    final oralId = isMalePlayer ? 'cunnilingus' : 'fellatio';
    final oralLabel = isMalePlayer ? 'Cunnilingus 👅' : 'Fellatio 👄';
    final oralNodes = OralSeksHelper.generateOralDialogueNodes(
      character: player,
      targetName: partnerName,
      targetGender: npcGender,
      oralId: oralId,
      oralLabel: oralLabel,
      targetRole: targetRole,
    );
    for (int k = 0; k < oralNodes.length; k++) {
      final isLast = k == oralNodes.length - 1;
      final n = oralNodes[k];
      allNodes.add(VNDialogueNode(
        speakerName: n.speakerName,
        dialogueText: n.dialogueText,
        emotion: n.emotion,
        outfit: n.outfit,
        isPlayerSpeaking: n.isPlayerSpeaking,
        background: n.background,
        nextIndex: isLast ? 86 : null,
        choices: null,
      ));
    }

    // Sub-Nodes Penetrasi Vagina (Index 34 - 37) & Anus (Index 38 - 41)
    final vaginaNodes = PenetrasiHelper.generatePenetrasiDialogueNodes(
      character: player,
      targetName: partnerName,
      targetGender: npcGender,
      targetPartId: 'vagina',
      partLabel: 'Vagina 🌸',
      targetRole: targetRole,
    );
    for (int k = 0; k < vaginaNodes.length; k++) {
      final isLast = k == vaginaNodes.length - 1;
      final n = vaginaNodes[k];
      allNodes.add(VNDialogueNode(
        speakerName: n.speakerName,
        dialogueText: n.dialogueText,
        emotion: n.emotion,
        outfit: n.outfit,
        isPlayerSpeaking: n.isPlayerSpeaking,
        background: n.background,
        nextIndex: isLast ? 86 : null,
        choices: null,
      ));
    }

    final anusNodes = PenetrasiHelper.generatePenetrasiDialogueNodes(
      character: player,
      targetName: partnerName,
      targetGender: npcGender,
      targetPartId: 'anus',
      partLabel: 'Anus 🔥',
      targetRole: targetRole,
    );
    for (int k = 0; k < anusNodes.length; k++) {
      final isLast = k == anusNodes.length - 1;
      final n = anusNodes[k];
      allNodes.add(VNDialogueNode(
        speakerName: n.speakerName,
        dialogueText: n.dialogueText,
        emotion: n.emotion,
        outfit: n.outfit,
        isPlayerSpeaking: n.isPlayerSpeaking,
        background: n.background,
        nextIndex: isLast ? 86 : null,
        choices: null,
      ));
    }

    // Sub-Nodes Posisi (5 Opsi x 4 Nodes = 20 Nodes: Index 42 - 61)
    final List<String> posisiIds = ['missionary', 'doggy', 'cowgirl', 'posisi_69', 'spooning'];
    final List<String> posisiLabels = ['Missionary 👩‍❤️‍👨', 'Doggy Style 🐾', 'Cowgirl 💃', 'Posisi 69 🔄', 'Spooning 🌙'];

    for (int p = 0; p < posisiIds.length; p++) {
      final pNodes = PosisiSeksHelper.generatePosisiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        posisiId: posisiIds[p],
        posisiLabel: posisiLabels[p],
        targetRole: targetRole,
      );
      for (int k = 0; k < pNodes.length; k++) {
        final isLast = k == pNodes.length - 1;
        final n = pNodes[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? 86 : null,
          choices: null,
        ));
      }
    }

    // Sub-Nodes Ejakulasi (5 Opsi x 4 Nodes = 20 Nodes: Index 62 - 81)
    final List<String> ejakulasiIds = ['vagina_dalam', 'luar_perut', 'wajah', 'mulut', 'anus_dalam'];
    final List<String> ejakulasiLabels = ['Di Dalam Vagina 💦', 'Di Perut / Luar 🧴', 'Di Wajah 👑', 'Di Mulut 👄', 'Di Dalam Anus 🔥'];

    for (int e = 0; e < ejakulasiIds.length; e++) {
      final eNodes = EjakulasiHelper.generateEjakulasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        ejakulasiId: ejakulasiIds[e],
        ejakulasiLabel: ejakulasiLabels[e],
        targetRole: targetRole,
      );
      for (int k = 0; k < eNodes.length; k++) {
        final isLast = k == eNodes.length - 1;
        final n = eNodes[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? -1 : null,
          choices: null,
        ));
      }
    }

    // Sub-Nodes Stimulasi Manual (Masturbasi Pasangan: Index 82 - 85)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '($partnerName tersenyum manis, mendekat perlahan dan membelai lembut area intim ${player.name}. Gerakan jarinya yang terlatih dan hangat mulai memberikan stimulasi nikmat...) 🖐️',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));

    allNodes.add(VNDialogueNode(
      speakerName: partnerName,
      dialogueText: 'Biar aku yang memanjakanmu hari ini, $callNpcToPlayer... Rasakan sentuhan hangat jariku yang melingkar mesra... 💗',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));

    allNodes.add(VNDialogueNode(
      speakerName: player.name,
      dialogueText: 'Ahh... nnnggh... nikmat sekali sentuhan jarimu, $partnerName! Gairahku rasanya semakin meluap-luap... 🔥',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: true,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));

    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Stimulasi manual dari $partnerName berhasil meningkatkan sensasi dan gairah intim hingga ke puncaknya! Pilih langkah selanjutnya...) ✨',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      // Stimulasi Manual → kembali ke menu LOCKED (tanpa Ejakulasi)
      nextIndex: 121,
      choices: null,
    ));

    // NODE 86: Re-usable UNLOCKED Choice Card (8 Tombol, termasuk Ejakulasi)
    // Dicapai setelah Oral / Penetrasi / Posisi
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Gairah bercinta semakin memuncak! Pilih tindakan intim selanjutnya...) ✨',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: unlockedMainActionButtons,
    ));

    // NODE 87: Sub-Menu Fingering
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih teknik fingering yang ingin kamu lakukan...) 👆',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subFingeringChoices,
    ));

    // Sub-Nodes Fingering (4 Opsi x 4 Nodes = 16 Nodes: Index 88 - 103)
    final List<String> fingeringIds = FingeringHelper.fingeringOptions
        .map((e) => e['id'] as String)
        .toList();
    final List<String> fingeringLabels = FingeringHelper.fingeringOptions
        .map((e) => e['label'] as String)
        .toList();

    for (int fi = 0; fi < fingeringIds.length; fi++) {
      final fNodes = FingeringHelper.generateFingeringDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        fingeringId: fingeringIds[fi],
        fingeringLabel: fingeringLabels[fi],
        targetRole: targetRole,
      );
      for (int k = 0; k < fNodes.length; k++) {
        final isLast = k == fNodes.length - 1;
        final n = fNodes[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          // Fingering → kembali ke menu LOCKED (tanpa Ejakulasi)
          nextIndex: isLast ? 121 : null,
          choices: null,
        ));
      }
    }

    // NODE 104: Sub-Menu Stimulasi Payudara
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih teknik stimulasi payudara yang ingin kamu lakukan...) 🍑',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subPayudaraChoices,
    ));

    // Sub-Nodes Stimulasi Payudara (4 Opsi x 4 Nodes = 16 Nodes: Index 105 - 120)
    final List<String> payudaraIds = StimulasiPayudaraHelper.payudaraOptions
        .map((e) => e['id'] as String)
        .toList();
    final List<String> payudaraLabels = StimulasiPayudaraHelper.payudaraOptions
        .map((e) => e['label'] as String)
        .toList();

    for (int pi = 0; pi < payudaraIds.length; pi++) {
      final pNodes = StimulasiPayudaraHelper.generateStimulasiPayudaraDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        payudaraId: payudaraIds[pi],
        payudaraLabel: payudaraLabels[pi],
        targetRole: targetRole,
      );
      for (int k = 0; k < pNodes.length; k++) {
        final isLast = k == pNodes.length - 1;
        final n = pNodes[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          // Stimulasi Payudara → kembali ke menu LOCKED (tanpa Ejakulasi)
          nextIndex: isLast ? 121 : null,
          choices: null,
        ));
      }
    }

    // NODE 121: Re-usable LOCKED Choice Card (7 Tombol, TANPA Ejakulasi)
    // Dicapai setelah Ciuman / Fingering / Stimulasi Payudara / Stimulasi Manual
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Suasana semakin menghangat! Pilih aksi intim selanjutnya...) 💕',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: initialMainActionButtons,
    ));

    return allNodes;
  }
}
