// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_10tahun/ajak_masturbate/ajak_masturbate_dialogue.dart

import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/dialog_npc_laki/dialog_npc_laki_masturbate.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/dialog_npc_perempuan/dialog_npc_perempuan_masturbate.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/dialog_user_laki/dialog_user_laki_masturbate.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/dialog_user_perempuan/dialog_user_perempuan_masturbate.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/panggilan_logic/panggilan_manager.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/aksi_intim/ciuman.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/aksi_intim/oral.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/aksi_intim/stimulasi_manual.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/aksi_intim/fingering.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/aksi_intim/stimulasi_payudara.dart';

class AjakMasturbateDialogue {
  static List<VNDialogueNode> getDialogue({
    required Character player,
    required Map<String, dynamic> npc,
    String chosenLocation = 'Kamar Tidur',
    String chosenTime = 'Malam',
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

    if (!isAccepted) {
      return [
        VNDialogueNode(
          speakerName: player.name,
          dialogueText: '$partnerName, maukah kamu mengeksplorasi diri bersama di $chosenLocation pada waktu $chosenTime? 😳✨',
          emotion: VNEmotionType.blush,
          isPlayerSpeaking: true,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        VNDialogueNode(
          speakerName: partnerName,
          dialogueText: 'Aduh... Maaf ya $callNpcToPlayer, aku merasa belum nyaman untuk melakukan itu saat ini. 🙈',
          emotion: VNEmotionType.sad,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
          choices: [
            VNChoiceOption(
              text: '😳 "Oh begitu... Maaf ya sudah bertanya..."',
              onSelect: (p, n) {
                p.happiness = (p.happiness - 5).clamp(0, 100);
              },
            ),
          ],
        ),
      ];
    }

    final List<VNDialogueNode> playerMoans = isMalePlayer
        ? DialogUserLakiMasturbate.getMoanNodes(player: player, npc: npc, count: 5)
        : DialogUserPerempuanMasturbate.getMoanNodes(player: player, npc: npc, count: 5);

    final List<VNDialogueNode> npcMoanSequence = isMaleNPC
        ? DialogNpcLakiMasturbate.getMoanSequence(player: player, npc: npc, playerMoanNodes: playerMoans, nodeCount: 2)
        : DialogNpcPerempuanMasturbate.getMoanSequence(player: player, npc: npc, playerMoanNodes: playerMoans, nodeCount: 2);

    final List<VNDialogueNode> allNodes = [];

    // =========================================================================
    // PILIHAN UTAMA & STRUKTUR INDEKS FIX MASTURBASI BERSAMA:
    // Index 0: Card Menu Pilihan Utama (6 Tombol)
    // Index 1: Sub-Menu Ciuman
    // Index 2: Sub-Menu Oral Seks
    // Index 3..26: Sub-Nodes Ciuman (6 opsi x 4 nodes) -> nextIndex: 77
    // Index 27..30: Sub-Nodes Oral (1 opsi x 4 nodes) -> nextIndex: 77
    // Index 31..34: Sub-Nodes Stimulasi Manual (4 nodes) -> nextIndex: 77
    // Index 35: Sub-Menu Fingering
    // Index 36..51: Sub-Nodes Fingering (4 opsi x 4 nodes) -> nextIndex: 77
    // Index 52: Sub-Menu Stimulasi Payudara
    // Index 53..68: Sub-Nodes Stimulasi Payudara (4 opsi x 4 nodes) -> nextIndex: 77
    // Index 69..76: Sub-Nodes Klimaks & Aftercare
    // Index 77: Re-Choice Card Menu (6 Tombol Pilihan Utama yang sama)
    // =========================================================================

    final List<VNChoiceOption> mainMasturbateChoices = [
      VNChoiceOption(text: '💋 1. Ciuman', nextNodeIndex: 1),
      VNChoiceOption(text: '👅 2. Oral Seks', nextNodeIndex: 2),
      VNChoiceOption(text: '🖐️ 3. Minta $partnerName lakukan stimulasi manual', nextNodeIndex: 31),
      VNChoiceOption(text: '👆 4. Lakukan fingering ke $partnerName', nextNodeIndex: 35),
      VNChoiceOption(text: '🍑 5. Stimulasi Payudara', nextNodeIndex: 52),
      VNChoiceOption(text: '💦 6. Mencapai Puncak / Klimaks Bersama', nextNodeIndex: 69),
    ];

    final List<VNChoiceOption> subCiumChoices = CiumanMasturbateHelper.ciumOptions.map((opt) {
      final String partLabel = opt['label'] as String;
      final int idx = CiumanMasturbateHelper.ciumOptions.indexOf(opt);
      return VNChoiceOption(
        text: '💋 $partLabel',
        nextNodeIndex: 3 + (idx * 4),
      );
    }).toList();

    final List<VNChoiceOption> subOralChoices = [
      VNChoiceOption(
        text: isMalePlayer ? '👅 Oral Seks: Cunnilingus (Wanita)' : '👄 Oral Seks: Fellatio (Blowjob)',
        nextNodeIndex: 27,
      ),
    ];

    final List<VNChoiceOption> subFingeringChoices = FingeringMasturbateHelper.fingeringOptions.asMap().entries.map((e) {
      return VNChoiceOption(
        text: e.value['label'] as String,
        nextNodeIndex: 36 + (e.key * 4),
      );
    }).toList();

    final List<VNChoiceOption> subPayudaraChoices = StimulasiPayudaraMasturbateHelper.payudaraOptions.asMap().entries.map((e) {
      return VNChoiceOption(
        text: e.value['label'] as String,
        nextNodeIndex: 53 + (e.key * 4),
      );
    }).toList();

    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Suasana di $chosenLocation pada waktu $chosenTime ini terasa begitu hangat dan privat. Tatapan mesra menyelimuti ${player.name} dan $partnerName. Pilih aksi masturbasi bersama yang ingin kamu lakukan...) 😳✨',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: mainMasturbateChoices,
    ));

    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih bagian tubuh pasangan yang ingin kamu kecup...) 💋',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subCiumChoices,
    ));

    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih aksi oral seks yang ingin dilakukan...) 👅',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subOralChoices,
    ));

    for (final opt in CiumanMasturbateHelper.ciumOptions) {
      final partId = opt['id'] as String;
      final partLabel = opt['label'] as String;
      final ciumNodes = CiumanMasturbateHelper.generateCiumDialogueNodes(
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
          nextIndex: isLast ? 73 : null,
          choices: null,
        ));
      }
    }

    final oralId = isMalePlayer ? 'cunnilingus' : 'fellatio';
    final oralLabel = isMalePlayer ? 'Cunnilingus 👅' : 'Fellatio 👄';
    final oralNodes = OralMasturbateHelper.generateOralDialogueNodes(
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
        nextIndex: isLast ? 73 : null,
        choices: null,
      ));
    }

    final manualNodes = StimulasiManualMasturbateHelper.generateStimulasiManualDialogueNodes(
      character: player,
      targetName: partnerName,
      targetGender: npcGender,
      targetRole: targetRole,
    );
    for (int k = 0; k < manualNodes.length; k++) {
      final isLast = k == manualNodes.length - 1;
      final n = manualNodes[k];
      allNodes.add(VNDialogueNode(
        speakerName: n.speakerName,
        dialogueText: n.dialogueText,
        emotion: n.emotion,
        outfit: n.outfit,
        isPlayerSpeaking: n.isPlayerSpeaking,
        background: n.background,
        nextIndex: isLast ? 73 : null,
        choices: null,
      ));
    }

    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih teknik fingering yang ingin kamu lakukan ke $partnerName...) 👆',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subFingeringChoices,
    ));

    final List<String> fingeringIds = FingeringMasturbateHelper.fingeringOptions
        .map((e) => e['id'] as String)
        .toList();
    final List<String> fingeringLabels = FingeringMasturbateHelper.fingeringOptions
        .map((e) => e['label'] as String)
        .toList();

    for (int fi = 0; fi < fingeringIds.length; fi++) {
      final fNodes = FingeringMasturbateHelper.generateFingeringDialogueNodes(
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
          nextIndex: isLast ? 73 : null,
          choices: null,
        ));
      }
    }

    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Pilih teknik stimulasi payudara yang ingin kamu lakukan...) 🍑',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: subPayudaraChoices,
    ));

    final List<String> payudaraIds = StimulasiPayudaraMasturbateHelper.payudaraOptions
        .map((e) => e['id'] as String)
        .toList();
    final List<String> payudaraLabels = StimulasiPayudaraMasturbateHelper.payudaraOptions
        .map((e) => e['label'] as String)
        .toList();

    for (int pi = 0; pi < payudaraIds.length; pi++) {
      final pNodes = StimulasiPayudaraMasturbateHelper.generateStimulasiPayudaraDialogueNodes(
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
          nextIndex: isLast ? 73 : null,
          choices: null,
        ));
      }
    }

    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Tempo gerakan kalian berdua makin cepat dan tak tertahankan. Sensasi hangat membuncah bersamaan saat kalian berdua mencapai puncak kenikmatan bersama...) 💦🔥',
      emotion: VNEmotionType.blush,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      nextIndex: 70,
    ));

    final pMoan0 = playerMoans[0];
    allNodes.add(VNDialogueNode(
      speakerName: pMoan0.speakerName,
      dialogueText: pMoan0.dialogueText,
      emotion: pMoan0.emotion,
      isPlayerSpeaking: pMoan0.isPlayerSpeaking,
      outfit: pMoan0.outfit,
      background: pMoan0.background,
      nextIndex: 71,
    ));

    final npcMoan0 = npcMoanSequence[0];
    allNodes.add(VNDialogueNode(
      speakerName: npcMoan0.speakerName,
      dialogueText: npcMoan0.dialogueText,
      emotion: npcMoan0.emotion,
      isPlayerSpeaking: npcMoan0.isPlayerSpeaking,
      outfit: npcMoan0.outfit,
      background: npcMoan0.background,
      nextIndex: 72,
    ));

    final VNDialogueNode aftercareNode = isMaleNPC
        ? DialogNpcLakiMasturbate.getAftercareNode(npc: npc)
        : DialogNpcPerempuanMasturbate.getAftercareNode(npc: npc);

    allNodes.add(VNDialogueNode(
      speakerName: aftercareNode.speakerName,
      dialogueText: aftercareNode.dialogueText,
      emotion: aftercareNode.emotion,
      isPlayerSpeaking: aftercareNode.isPlayerSpeaking,
      outfit: aftercareNode.outfit,
      background: aftercareNode.background,
    ));

    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Sensasi kehangatan dan gairah intim masih terasa membara... Apakah kamu ingin melanjutkan aksi masturbasi lainnya dengan $partnerName?) 😳💭',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: mainMasturbateChoices,
    ));

    return allNodes;
  }
}

