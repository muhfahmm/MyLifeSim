// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_10tahun/ajak_makelove/ajak_makelove_dialogue.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/dialog_user_laki/dialog_user_laki_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/dialog_user_perempuan/dialog_user_perempuan_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/dialog_npc_laki/dialog_npc_laki_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/dialog_npc_perempuan/dialog_npc_perempuan_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/ciuman.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/penetrasi.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/posisi.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/oral.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/ejakulasi.dart';

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
    final String partnerName = npc['name'] ?? 'Pasangan';

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

      return [
        VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Suasana di $chosenLocation pada $chosenTime ini terasa tenang, namun saat ${player.name} mendekat, $partnerName menggelengkan kepala...) 🌙',
          emotion: VNEmotionType.neutral,
          isPlayerSpeaking: false,
          outfit: VNOutfitType.casual,
          background: VNBackgroundType.bedroom,
        ),
        rejectionNode,
      ];
    }

    final List<VNDialogueNode> allNodes = [];

    // =========================================================================
    // INDEX BUILDER LAYOUT:
    // Index 0: Opening Narasi & Menu Utama 4 Tombol Aksi Intim
    // Index 1: Menu Ciuman
    // Index 2: Menu Oral Seks
    // Index 3: Menu Penetrasi
    // Index 4: Menu Posisi Seks
    // Index 5: Menu Ejakulasi / Klimaks
    // =========================================================================

    // List Pilihan Sub-Aksi
    final List<VNChoiceOption> subCiumChoices = CiumanHelper.ciumOptions.map((opt) {
      final String partLabel = opt['label'] as String;
      final String partId = opt['id'] as String;
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
      VNChoiceOption(text: '💦 Keluar di Dalam Vagina', nextNodeIndex: 62),
      VNChoiceOption(text: '🧴 Keluar di Perut / Luar', nextNodeIndex: 66),
      VNChoiceOption(text: '👑 Keluar di Wajah', nextNodeIndex: 70),
      VNChoiceOption(text: '👄 Keluar di Mulut', nextNodeIndex: 74),
      VNChoiceOption(text: '🔥 Keluar di Dalam Anus', nextNodeIndex: 78),
    ];

    // 5 Button Utama setelah Narasi Pertama (ciuman, oral, penetrasi, posisi seks, ejakulasi)
    final List<VNChoiceOption> mainActionButtons = [
      VNChoiceOption(text: '💋 1. Ciuman', nextNodeIndex: 1),
      VNChoiceOption(text: '👅 2. Oral Seks', nextNodeIndex: 2),
      VNChoiceOption(text: '🌸 3. Penetrasi', nextNodeIndex: 3),
      VNChoiceOption(text: '👩‍❤️‍👨 4. Posisi Seks', nextNodeIndex: 4),
      VNChoiceOption(text: '💦 5. Ejakulasi / Klimaks', nextNodeIndex: 5),
    ];

    // NODE 0: Narasi Pertama (Menampilkan 5 Button Utama)
    allNodes.add(VNDialogueNode(
      speakerName: 'Narasi',
      dialogueText: '(Suasana di $chosenLocation pada $chosenTime ini terasa begitu hangat dan romantis. Kehangatan mesra menyelimuti ${player.name} dan $partnerName. Pilih aksi intim yang ingin kamu lakukan...) ✨',
      emotion: VNEmotionType.neutral,
      isPlayerSpeaking: false,
      outfit: VNOutfitType.casual,
      background: VNBackgroundType.bedroom,
      choices: mainActionButtons,
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
          choices: isLast ? mainActionButtons : null,
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
        choices: isLast ? mainActionButtons : null,
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
        choices: isLast ? mainActionButtons : null,
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
        choices: isLast ? mainActionButtons : null,
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
          choices: isLast ? mainActionButtons : null,
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
        final n = eNodes[k];
        allNodes.add(VNDialogueNode(
          speakerName: n.speakerName,
          dialogueText: n.dialogueText,
          emotion: n.emotion,
          outfit: n.outfit,
          isPlayerSpeaking: n.isPlayerSpeaking,
          background: n.background,
        ));
      }
    }

    return allNodes;
  }
}
