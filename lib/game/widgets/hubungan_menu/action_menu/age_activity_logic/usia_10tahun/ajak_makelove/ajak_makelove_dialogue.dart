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
  static VNBackgroundType _getBackgroundTypeFromLocation(String location) {
    final String locLower = location.toLowerCase();
    if (locLower.contains('mobil')) {
      return VNBackgroundType.nightCity;
    } else if (locLower.contains('hotel') || locLower.contains('restoran') || locLower.contains('kafe')) {
      return VNBackgroundType.restaurant;
    } else if (locLower.contains('taman')) {
      return VNBackgroundType.park;
    } else if (locLower.contains('kantor')) {
      return VNBackgroundType.office;
    } else {
      return VNBackgroundType.bedroom;
    }
  }

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
    final bool isGay = isMalePlayer && isMaleNPC;
    final String targetRole = (npc['role'] ?? npc['relation'] ?? npc['targetRole'] ?? 'Pasangan').toString();
    final String rawPartnerName = (npc['name'] ?? 'Pasangan').toString();
    final String partnerName = AvatarAgeRules.getCleanNPCName(rawPartnerName);
    final VNBackgroundType chosenBgType = _getBackgroundTypeFromLocation(chosenLocation);

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

    final bool isBothFemale = !isMalePlayer && (npcGender.trim().toLowerCase() == 'perempuan');

    // List choices penetrasi
    final List<VNChoiceOption> subPenetrasiChoices;
    if (isBothFemale) {
      subPenetrasiChoices = [
        VNChoiceOption(
          text: '🌸 Lakukan Penetrasi: Vagina',
          nextNodeIndex: 34, // Node 34: Sub-menu Pilihan Alat Vagina (Vibrator / Jari)
        ),
        VNChoiceOption(
          text: '🔥 Lakukan Penetrasi: Anus',
          nextNodeIndex: 53, // Node 53: Sub-menu Pilihan Alat Anus (Vibrator / Jari)
        ),
      ];
    } else {
      subPenetrasiChoices = [
        VNChoiceOption(
          text: '🌸 Lakukan Penetrasi: Vagina',
          nextNodeIndex: 34, // Node 34: Sub-menu Pilihan Pelumas Vagina
        ),
        VNChoiceOption(
          text: '🔥 Lakukan Penetrasi: Anus',
          nextNodeIndex: 43, // Node 43: Sub-menu Pilihan Pelumas Anus
        ),
      ];
    }

    final List<Map<String, dynamic>> dynamicPosisiOptions = PosisiSeksHelper.getPosisiOptions(
      myGender: player.gender,
      partnerGender: npcGender,
      location: chosenLocation,
    );

    // Menghitung offset penetrasi:
    // Jika both female: 34 (start) + 38 nodes = 72. 72 = start Posisi.
    // Jika normal: 34 (start) + 1 (choice vag lube) + 4 (vag lube) + 4 (vag no lube) + 1 (choice anus lube) + 4 (anus lube) + 4 (anus no lube) = 52. 52 = start Posisi.
    final int startPosisiIndex = isBothFemale ? 72 : 52;
    final int startEjakulasiIndex = startPosisiIndex + (dynamicPosisiOptions.length * 4);
    final int startManualIndex = startEjakulasiIndex + 20; // 5 opsi ejakulasi * 4 nodes
    final int reChoiceCardIndex = startManualIndex + 19; // 19 nodes stimulasi vagina/anal alat

    final List<Map<String, dynamic>> dynamicFingeringOptions = FingeringHelper.getFingeringOptions(
      targetGender: npcGender,
    );

    final int fingeringSubMenuIndex = reChoiceCardIndex + 1;
    final List<VNChoiceOption> subFingeringChoices = dynamicFingeringOptions.asMap().entries.map((e) {
      return VNChoiceOption(
        text: e.value['label'] as String,
        nextNodeIndex: (fingeringSubMenuIndex + 1) + (e.key * 4),
      );
    }).toList();

    final int payudaraSubMenuIndex = fingeringSubMenuIndex + 1 + (dynamicFingeringOptions.length * 4);
    final List<VNChoiceOption> subPayudaraChoices = StimulasiPayudaraHelper.payudaraOptions.asMap().entries.map((e) {
      return VNChoiceOption(
        text: e.value['label'] as String,
        nextNodeIndex: (payudaraSubMenuIndex + 1) + (e.key * 4),
      );
    }).toList();

    final int lockedCardIndex = payudaraSubMenuIndex + 1 + (StimulasiPayudaraHelper.payudaraOptions.length * 4);

    final List<VNChoiceOption> subPosisiChoices = dynamicPosisiOptions.asMap().entries.map((e) {
      final String label = e.value['label'] as String;
      return VNChoiceOption(
        text: '${e.value['icon']} Posisi: $label',
        nextNodeIndex: startPosisiIndex + (e.key * 4),
        onSelect: (p, n) {
          p.currentPosisiSeks = label;
        },
      );
    }).toList();

    final List<VNChoiceOption> subEjakulasiChoices = [
      VNChoiceOption(
        text: isGay ? '💦 Keluar di Dalam Anus' : '💦 Keluar di Dalam Vagina',
        nextNodeIndex: startEjakulasiIndex,
        onSelect: (p, n) { p.didCreampieThisSession = true; },
      ),
      VNChoiceOption(
        text: '🧴 Keluar di Perut / Luar',
        nextNodeIndex: startEjakulasiIndex + 4,
        onSelect: (p, n) { p.didCreampieThisSession = false; },
      ),
      VNChoiceOption(
        text: '👑 Keluar di Wajah',
        nextNodeIndex: startEjakulasiIndex + 8,
        onSelect: (p, n) { p.didCreampieThisSession = false; },
      ),
      VNChoiceOption(
        text: '👄 Keluar di Mulut',
        nextNodeIndex: startEjakulasiIndex + 12,
        onSelect: (p, n) { p.didCreampieThisSession = false; },
      ),
      VNChoiceOption(
        text: '🔥 Keluar di Dalam Anus',
        nextNodeIndex: startEjakulasiIndex + 16,
        onSelect: (p, n) { p.didCreampieThisSession = false; },
      ),
    ];

    // Label Posisi Seks dengan Badge jika posisi sudah dipilih
    final String currentPosBadge = (player.currentPosisiSeks != null && player.currentPosisiSeks!.isNotEmpty)
        ? ' [${player.currentPosisiSeks}] 🔄 Ganti'
        : '';
    final String posisiBtnText = '4. Pilih Posisi Seks$currentPosBadge';

    final bool isFemaleWithMale = !isMalePlayer && (npcGender.trim().toLowerCase() == 'laki-laki');

    final String penetrasiBtnLabel = isFemaleWithMale
        ? '🌸 3. Minta $partnerName melakukan penetrasi'
        : '🌸 3. Lakukan Penetrasi';

    final String askFingeringLabel = isMalePlayer
        ? '🖐️ 5. Minta $partnerName melakukan stimulasi penis/anal'
        : '🖐️ 5. Minta $partnerName melakukan stimulasi vagina/anal';

    final String doFingeringLabel = isBothFemale 
        ? '👆 6. Lakukan fingering kepada $partnerName'
        : '👆 6. Lakukan onani kepada $partnerName';

    // Button Utama awal
    final List<VNChoiceOption> initialMainActionButtons = [
      VNChoiceOption(text: '💋 1. Ciuman', nextNodeIndex: 1),
      VNChoiceOption(text: '👅 2. Oral Seks', nextNodeIndex: 2),
      VNChoiceOption(text: penetrasiBtnLabel, nextNodeIndex: 3),
      VNChoiceOption(text: posisiBtnText, nextNodeIndex: 4),
      VNChoiceOption(text: askFingeringLabel, nextNodeIndex: startManualIndex),
      VNChoiceOption(text: doFingeringLabel, nextNodeIndex: fingeringSubMenuIndex),
      if (!isGay) VNChoiceOption(text: '🍑 7. Minta $partnerName melakukan stimulasi payudara', nextNodeIndex: payudaraSubMenuIndex),
    ];

    final String ejakulasiBtnLabel = isFemaleWithMale
        ? '💦 8. Suruh $partnerName segera ejakulasi'
        : (isGay ? '💦 7. Ejakulasi / Klimaks' : '💦 8. Ejakulasi / Klimaks');

    // Button Utama unlocked (Sembunyikan tombol ejakulasi jika Lesbian)
    final List<VNChoiceOption> unlockedMainActionButtons = [
      VNChoiceOption(text: '💋 1. Ciuman', nextNodeIndex: 1),
      VNChoiceOption(text: '👅 2. Oral Seks', nextNodeIndex: 2),
      VNChoiceOption(text: penetrasiBtnLabel, nextNodeIndex: 3),
      VNChoiceOption(text: posisiBtnText, nextNodeIndex: 4),
      VNChoiceOption(text: askFingeringLabel, nextNodeIndex: startManualIndex),
      VNChoiceOption(text: doFingeringLabel, nextNodeIndex: fingeringSubMenuIndex),
      if (!isGay) VNChoiceOption(text: '🍑 7. Minta $partnerName melakukan stimulasi payudara', nextNodeIndex: payudaraSubMenuIndex),
      if (!isBothFemale)
        VNChoiceOption(
          text: ejakulasiBtnLabel,
          nextNodeIndex: isFemaleWithMale
              ? (startEjakulasiIndex + ((DateTime.now().millisecondsSinceEpoch % 5) * 4))
              : 5,
          onSelect: isFemaleWithMale
              ? (p, n) {
                  // NPC Pria memilih tempat ejakulasi secara acak (Random)
                  final random = DateTime.now().millisecondsSinceEpoch % 5;
                  if (random == 0) {
                    p.didCreampieThisSession = true;
                  } else {
                    p.didCreampieThisSession = false;
                  }
                }
              : null,
        ),
    ];

    // NODE 0: Narasi Pertama (Menampilkan 5 Button Utama awal dengan Stimulasi Manual menggantikan Ejakulasi)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Suasana di $chosenLocation pada $chosenTime ini terasa begitu hangat dan romantis. Kehangatan mesra menyelimuti ${player.name} dan $partnerName. Pilih aksi intim yang ingin kamu lakukan...) ✨',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: chosenBgType,
      choices: initialMainActionButtons,
    ));

    // NODE 1: Sub-Menu Ciuman
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih bagian tubuh pasangan yang ingin kamu kecup...) 💋',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: chosenBgType,
      choices: subCiumChoices,
    ));

    // NODE 2: Sub-Menu Oral Seks
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih aksi oral seks yang ingin dilakukan...) 👅',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: chosenBgType,
      choices: subOralChoices,
    ));

    // NODE 3: Sub-Menu Penetrasi
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih jalur penetrasi yang ingin kamu lakukan...) 🌸',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: chosenBgType,
      choices: subPenetrasiChoices,
    ));

    // NODE 4: Sub-Menu Posisi Seks
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih posisi bercinta yang kamu inginkan...) 👩‍❤️‍👨',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: chosenBgType,
      choices: subPosisiChoices,
    ));

    // NODE 5: Sub-Menu Ejakulasi
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih lokasi pengeluaran cairan klimaks...) 💦',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: chosenBgType,
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
          nextIndex: isLast ? lockedCardIndex : null,
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
        nextIndex: isLast ? reChoiceCardIndex : null,
        choices: null,
      ));
    }

    // Sub-Nodes Penetrasi
    if (isBothFemale) {
      // Untuk Perempuan x Perempuan:
      // Node 34: Sub-menu pilihan alat untuk Vagina (Vibrator vs Jari)
      // Node 35-38: Sub-nodes Penetrasi Vagina (Vibrator)
      // Node 39-42: Sub-nodes Penetrasi Vagina (Jari)
      // Node 43: Sub-menu pilihan alat untuk Anus (Vibrator vs Jari)
      // Node 44-47: Sub-nodes Penetrasi Anus (Vibrator)
      // Node 48-51: Sub-nodes Penetrasi Anus (Jari)

      // Node 34: Choices Alat Vagina
      allNodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih metode penetrasi vagina yang ingin digunakan...) 🌸',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🍆 Gunakan Alat Bantu (Vibrator)', nextNodeIndex: 35),
          VNChoiceOption(text: '🖐️ Gunakan Jari', nextNodeIndex: 44),
        ],
      ));

      // Node 35: Sub-Menu Pelumas Vagina Vibrator
      allNodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Apakah ingin menggunakan pelumas untuk penetrasi vagina vibrator?) 🧴🌸',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🧴 1. Gunakan Pelumas', nextNodeIndex: 36),
          VNChoiceOption(text: '🚫 2. Tanpa Pelumas', nextNodeIndex: 40),
        ],
      ));

      // Node 36-39: Vagina - Vibrator (Dengan Pelumas)
      final vVibNodesLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'vagina',
        partLabel: 'Vagina (Vibrator) 🍆',
        targetRole: targetRole,
        toolChoice: 'vibrator',
        useLubricant: true,
      );
      for (int k = 0; k < vVibNodesLube.length; k++) {
        final isLast = k == vVibNodesLube.length - 1;
        final n = vVibNodesLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }

      // Node 40-43: Vagina - Vibrator (Tanpa Pelumas)
      final vVibNodesNoLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'vagina',
        partLabel: 'Vagina (Vibrator) 🍆',
        targetRole: targetRole,
        toolChoice: 'vibrator',
        useLubricant: false,
      );
      for (int k = 0; k < vVibNodesNoLube.length; k++) {
        final isLast = k == vVibNodesNoLube.length - 1;
        final n = vVibNodesNoLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }

      // Node 44: Sub-Menu Pelumas Vagina Jari
      allNodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Apakah ingin menggunakan pelumas untuk penetrasi vagina jari?) 🧴🌸',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🧴 1. Gunakan Pelumas', nextNodeIndex: 45),
          VNChoiceOption(text: '🚫 2. Tanpa Pelumas', nextNodeIndex: 49),
        ],
      ));

      // Node 45-48: Vagina - Jari (Dengan Pelumas)
      final vFinNodesLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'vagina',
        partLabel: 'Vagina (Jari) 🖐️',
        targetRole: targetRole,
        toolChoice: 'finger',
        useLubricant: true,
      );
      for (int k = 0; k < vFinNodesLube.length; k++) {
        final isLast = k == vFinNodesLube.length - 1;
        final n = vFinNodesLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }

      // Node 49-52: Vagina - Jari (Tanpa Pelumas)
      final vFinNodesNoLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'vagina',
        partLabel: 'Vagina (Jari) 🖐️',
        targetRole: targetRole,
        toolChoice: 'finger',
        useLubricant: false,
      );
      for (int k = 0; k < vFinNodesNoLube.length; k++) {
        final isLast = k == vFinNodesNoLube.length - 1;
        final n = vFinNodesNoLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }

      // Node 53: Choices Alat Anus
      allNodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih metode penetrasi anus yang ingin digunakan...) 🔥',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🍆 Gunakan Alat Bantu (Vibrator)', nextNodeIndex: 54),
          VNChoiceOption(text: '🖐️ Gunakan Jari', nextNodeIndex: 63),
        ],
      ));

      // Node 54: Sub-Menu Pelumas Anus Vibrator
      allNodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Apakah ingin menggunakan pelumas untuk penetrasi anus vibrator?) 🧴🔥',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🧴 1. Gunakan Pelumas', nextNodeIndex: 55),
          VNChoiceOption(text: '🚫 2. Tanpa Pelumas', nextNodeIndex: 59),
        ],
      ));

      // Node 55-58: Anus - Vibrator (Dengan Pelumas)
      final aVibNodesLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'anus',
        partLabel: 'Anus (Vibrator) 🍆',
        targetRole: targetRole,
        toolChoice: 'vibrator',
        useLubricant: true,
      );
      for (int k = 0; k < aVibNodesLube.length; k++) {
        final isLast = k == aVibNodesLube.length - 1;
        final n = aVibNodesLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }

      // Node 59-62: Anus - Vibrator (Tanpa Pelumas)
      final aVibNodesNoLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'anus',
        partLabel: 'Anus (Vibrator) 🍆',
        targetRole: targetRole,
        toolChoice: 'vibrator',
        useLubricant: false,
      );
      for (int k = 0; k < aVibNodesNoLube.length; k++) {
        final isLast = k == aVibNodesNoLube.length - 1;
        final n = aVibNodesNoLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }

      // Node 63: Sub-Menu Pelumas Anus Jari
      allNodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Apakah ingin menggunakan pelumas untuk penetrasi anus jari?) 🧴🔥',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🧴 1. Gunakan Pelumas', nextNodeIndex: 64),
          VNChoiceOption(text: '🚫 2. Tanpa Pelumas', nextNodeIndex: 68),
        ],
      ));

      // Node 64-67: Anus - Jari (Dengan Pelumas)
      final aFinNodesLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'anus',
        partLabel: 'Anus (Jari) 🖐️',
        targetRole: targetRole,
        toolChoice: 'finger',
        useLubricant: true,
      );
      for (int k = 0; k < aFinNodesLube.length; k++) {
        final isLast = k == aFinNodesLube.length - 1;
        final n = aFinNodesLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }

      // Node 68-71: Anus - Jari (Tanpa Pelumas)
      final aFinNodesNoLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'anus',
        partLabel: 'Anus (Jari) 🖐️',
        targetRole: targetRole,
        toolChoice: 'finger',
        useLubricant: false,
      );
      for (int k = 0; k < aFinNodesNoLube.length; k++) {
        final isLast = k == aFinNodesNoLube.length - 1;
        final n = aFinNodesNoLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }
    } else {
      // Node 34: Sub-Menu Pilihan Pelumas Vagina (Normal / General)
      allNodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Apakah ingin menggunakan pelumas untuk penetrasi vagina?) 🧴🌸',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🧴 1. Gunakan Pelumas', nextNodeIndex: 35),
          VNChoiceOption(text: '🚫 2. Tanpa Pelumas', nextNodeIndex: 39),
        ],
      ));

      // Node 35-38: Penetrasi Vagina (Dengan Pelumas)
      final vaginaNodesLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'vagina',
        partLabel: 'Vagina 🌸',
        targetRole: targetRole,
        useLubricant: true,
      );
      for (int k = 0; k < vaginaNodesLube.length; k++) {
        final isLast = k == vaginaNodesLube.length - 1;
        final n = vaginaNodesLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }

      // Node 39-42: Penetrasi Vagina (Tanpa Pelumas)
      final vaginaNodesNoLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'vagina',
        partLabel: 'Vagina 🌸',
        targetRole: targetRole,
        useLubricant: false,
      );
      for (int k = 0; k < vaginaNodesNoLube.length; k++) {
        final isLast = k == vaginaNodesNoLube.length - 1;
        final n = vaginaNodesNoLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }

      // Node 43: Sub-Menu Pilihan Pelumas Anus
      allNodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Apakah ingin menggunakan pelumas untuk penetrasi anus?) 🧴🔥',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        outfit: VNOutfitType.casual,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🧴 1. Gunakan Pelumas', nextNodeIndex: 44),
          VNChoiceOption(text: '🚫 2. Tanpa Pelumas', nextNodeIndex: 48),
        ],
      ));

      // Node 44-47: Anus (Dengan Pelumas)
      final anusNodesLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'anus',
        partLabel: 'Anus 🔥',
        targetRole: targetRole,
        useLubricant: true,
      );
      for (int k = 0; k < anusNodesLube.length; k++) {
        final isLast = k == anusNodesLube.length - 1;
        final n = anusNodesLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }

      // Node 48-51: Anus (Tanpa Pelumas)
      final anusNodesNoLube = PenetrasiHelper.generatePenetrasiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        targetPartId: 'anus',
        partLabel: 'Anus 🔥',
        targetRole: targetRole,
        useLubricant: false,
      );
      for (int k = 0; k < anusNodesNoLube.length; k++) {
        final isLast = k == anusNodesNoLube.length - 1;
        final n = anusNodesNoLube[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }
    }

    // Sub-Nodes Posisi (Dinamis sesuai Pasangan, 4 Nodes per Pilihan)
    for (int p = 0; p < dynamicPosisiOptions.length; p++) {
      final opt = dynamicPosisiOptions[p];
      final pNodes = PosisiSeksHelper.generatePosisiDialogueNodes(
        character: player,
        targetName: partnerName,
        targetGender: npcGender,
        posisiId: opt['id'] as String,
        posisiLabel: opt['label'] as String,
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
          nextIndex: isLast ? reChoiceCardIndex : null,
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
          // Ejakulasi -> kembali ke reChoiceCardIndex agar pemain dapat memilih aksi lain atau menekan Selesai
          nextIndex: isLast ? reChoiceCardIndex : null,
          choices: null,
        ));
      }
    }

    // Sub-Menu Stimulasi Vagina/Anal Pasangan (Node = startManualIndex)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih jenis stimulasi intim yang ingin kamu minta dari $partnerName...) 🖐️',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: [
        VNChoiceOption(
          text: '🌸 Stimulasi Vagina',
          nextNodeIndex: startManualIndex + 1,
        ),
        VNChoiceOption(
          text: '🔥 Stimulasi Anal',
          nextNodeIndex: startManualIndex + 10,
        ),
      ],
    ));

    // Sub-Menu Alat Vagina (Node = startManualIndex + 1)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih metode stimulasi vagina yang kamu inginkan dari $partnerName...) 🌸',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: [
        VNChoiceOption(
          text: '⚡ Gunakan Vibrator / Mainan Sex',
          nextNodeIndex: startManualIndex + 2,
        ),
        VNChoiceOption(
          text: '🖐️ Menggunakan Jari / Manual (Tanpa Mainan)',
          nextNodeIndex: startManualIndex + 6,
        ),
      ],
    ));

    // Nodes Vibrator Vagina (startManualIndex + 2 .. + 5)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '($partnerName mengambil vibrator, menyalakannya pada getaran hangat, lalu perlahan menempelkannya ke area vagina sensitif ${player.name}...) ⚡',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: partnerName,
      dialogueText: 'Rasakan getaran nikmat mainan ini $callNpcToPlayer... Aku akan mengaturnya sampai kamu terpesona... ⚡',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: player.name,
      dialogueText: 'Aaahhh...! Getarannya kuat sekali $partnerName...! Tubuhku rasanya ingin melayang ke udara... 💜',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: true,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Getaran intens vibrator dari $partnerName membawa sensasi kenikmatan luar biasa pada area vagina!) ✨',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      nextIndex: lockedCardIndex,
    ));

    // Nodes Jari Vagina (startManualIndex + 6 .. + 9)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '($partnerName mendekat dengan mesra, mengusap dan membelai area vagina ${player.name} menggunakan kehangatan jari-jarinya yang lembut...) 🖐️',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: partnerName,
      dialogueText: 'Sentuhan jariku khusus untuk memanjakanmu hari ini $callNpcToPlayer... Rasakan setiap usapan hangatnya... 💗',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: player.name,
      dialogueText: 'Ahh... nnnggh... jari-jarimu terasa begitu hangat dan lihai $partnerName! Aku sangat menyukainya... 🔥',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: true,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Stimulasi jari manual pada vagina dari $partnerName membakar gairah hingga semakin memuncak!) ✨',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      nextIndex: lockedCardIndex,
    ));

    // Sub-Menu Alat Anal (Node = startManualIndex + 10)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih metode stimulasi anal yang kamu inginkan dari $partnerName...) 🔥',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: [
        VNChoiceOption(
          text: '⚡ Gunakan Vibrator / Butt Plug Vibrating',
          nextNodeIndex: startManualIndex + 11,
        ),
        VNChoiceOption(
          text: '🖐️ Menggunakan Jari / Manual (Tanpa Mainan)',
          nextNodeIndex: startManualIndex + 15,
        ),
      ],
    ));

    // Nodes Vibrator Anal (startManualIndex + 11 .. + 14)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '($partnerName menyiapkan mainan getar anal dengan lembut, menempelkan getaran hangatnya ke titik sensitif anal ${player.name}...) ⚡',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: partnerName,
      dialogueText: 'Rileks ya $callNpcToPlayer... Getaran lembut ini akan memberikan sensasi terlarang yang sangat nikmat... 🔥',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: player.name,
      dialogueText: 'Ohh... hah... hah...! Sensasi getaran di sana sungguh tak terduga dan sangat meledakkan gairahku! ⚡',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: true,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Stimulasi vibrator anal dari $partnerName memberikan getaran hangat yang membakar sensasi!) ✨',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      nextIndex: lockedCardIndex,
    ));

    // Nodes Jari Anal (startManualIndex + 15 .. + 18)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '($partnerName mengoleskan sentuhan lembut, membelai dan memberikan pijatan jari yang halus pada titik sensitif anal ${player.name}...) 🖐️',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: partnerName,
      dialogueText: 'Biarkan aku memanjakanmu dengan penuh perhatian $callNpcToPlayer... Rasakan setiap belaian perlahan jariku... 💗',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: player.name,
      dialogueText: 'Nngghh... $partnerName... sentuhan halus jarimu di sana membuat seluruh tubuhku merinding nikmat... 🔥',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: true,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
    ));
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pijatan jari manual pada area anal dari $partnerName berhasil membangun gairah yang begitu hangat!) ✨',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      nextIndex: lockedCardIndex,
    ));

    // RE-CHOICE UNLOCKED CARD (Indeks = reChoiceCardIndex)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Gairah bercinta semakin memuncak! Pilih tindakan intim selanjutnya...) ✨',
      emotion: VNEmotionType.happy,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: unlockedMainActionButtons,
    ));

    // Sub-Menu Fingering / Stimulasi (Indeks = reChoiceCardIndex + 1)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: isBothFemale 
          ? '(Pilih teknik fingering yang ingin kamu lakukan...) 👆'
          : '(Pilih teknik stimulasi yang ingin kamu lakukan...) 👆',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subFingeringChoices,
    ));

    // Sub-Nodes Fingering / Stimulasi
    final List<String> fingeringIds = dynamicFingeringOptions
        .map((e) => e['id'] as String)
        .toList();
    final List<String> fingeringLabels = dynamicFingeringOptions
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
          // Fingering → kembali ke lockedCardIndex (menu tanpa Ejakulasi)
          nextIndex: isLast ? lockedCardIndex : null,
          choices: null,
        ));
      }
    }

    // Sub-Menu Stimulasi Payudara
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih teknik stimulasi payudara yang ingin kamu lakukan...) 🍑',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subPayudaraChoices,
    ));

    // Sub-Nodes Stimulasi Payudara
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
          // Stimulasi Payudara → kembali ke lockedCardIndex (menu tanpa Ejakulasi)
          nextIndex: isLast ? lockedCardIndex : null,
          choices: null,
        ));
      }
    }

    // RE-CHOICE LOCKED CARD (Indeks = lockedCardIndex)
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
