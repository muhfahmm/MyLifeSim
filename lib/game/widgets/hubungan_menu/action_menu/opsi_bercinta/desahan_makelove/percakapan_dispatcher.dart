// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/percakapan_dispatcher.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/proposal_percentage_settings.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_overlay.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_preset.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';

// Import skrip dialog Usia 3 Tahun
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_3tahun/minta_mainan/minta_mainan_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_3tahun/minta_pelukan/minta_pelukan_dialogue.dart';

import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_3tahun/habiskan_waktu_bersama/habiskan_waktu_3tahun_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_3tahun/pergi_ke_bioskop_bersama/pergi_ke_bioskop_dialogue.dart';

// Import skrip dialog Usia 6 Tahun
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/minta_uang_saku/minta_uang_saku_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/minta_sepeda/minta_sepeda_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/berikan_pujian/berikan_pujian_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/berikan_hadiah/berikan_hadiah_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/singgung_dia/singgung_dia_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/minta_barang/minta_barang_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/minta_adik_baru/minta_adik_baru_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_6tahun/minta_cerai/minta_cerai_dialogue.dart';

// Import skrip dialog Usia 10 Tahun
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_10tahun/ajak_pacaran/ajak_pacaran_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_10tahun/ajak_makelove/ajak_makelove_dialogue.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/age_activity_logic/usia_10tahun/ajak_masturbate/ajak_masturbate_dialogue.dart';

import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_progress_modal.dart';

class PercakapanDispatcher {
  /// Membuka Layar Percakapan Visual Novel Secara Otomatis Sesuai Aksi Menu Interaksi
  static void dispatchAction({
    required BuildContext context,
    required Character character,
    required String targetName,
    required String targetRole,
    required String targetAge,
    required int relationshipValue,
    required String actionType,
    required VoidCallback onActionComplete,
    String? targetAvatarUrl,
    String? playerAvatarUrl,
    String? targetGender,
    String? targetSkinColor,
    int? targetRealAge,
  }) {
    final String cleanRole = targetRole.toLowerCase();
    final String cleanName = targetName.toLowerCase();
    final String cleanAction = actionType.toLowerCase().trim();

    String npcGender = targetGender ?? 'Perempuan';
    if (targetGender == null) {
      if (cleanRole.contains('ayah') ||
          cleanRole.contains('kakek') ||
          cleanRole.contains('paman') ||
          cleanRole.contains('suami') ||
          cleanRole.contains('kakak laki') ||
          cleanRole.contains('adik laki') ||
          cleanRole.contains('putra') ||
          cleanName.contains('ayah') ||
          cleanName.contains('kakek') ||
          cleanName.contains('paman') ||
          cleanName.contains('mas ') ||
          cleanName.contains('pak ')) {
        npcGender = 'Laki-laki';
      }
    }

    final String plainName = AvatarAgeRules.getCleanNPCName(targetName);
    
    // Resolusi umur asli NPC
    int resolvedTargetAge = targetRealAge ?? int.tryParse(targetAge.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (resolvedTargetAge <= 0 || targetAge.toLowerCase().contains('tahun')) {
      if (targetRealAge != null && targetRealAge > 0) {
        resolvedTargetAge = targetRealAge;
      } else {
        resolvedTargetAge = _lookupTargetAge(character, plainName, targetName, targetRole);
      }
    }

    // Resolusi skinColor
    final String? resolvedSkinColor = targetSkinColor ?? _lookupTargetSkinColor(character, plainName, targetName);

    // Resolusi avatar URL target
    final String effectiveTargetAvatarUrl = targetAvatarUrl ?? AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: plainName,
      gender: npcGender,
      age: resolvedTargetAge,
      happiness: relationshipValue,
      forcedSkinColor: resolvedSkinColor,
    );

    // Resolusi avatar URL player
    final String effectivePlayerAvatarUrl = playerAvatarUrl ?? AvatarAgeRules.getAgeBasedAvatarUrl(
      character,
      happiness: character.happiness,
    );

    final Map<String, dynamic> npcMap = {
      'name': targetName,
      'plainName': plainName,
      'role': targetRole,
      'gender': npcGender,
      'age': resolvedTargetAge.toString(),
      'relationship': relationshipValue.toString(),
      'avatarUrl': effectiveTargetAvatarUrl,
      'skinColor': resolvedSkinColor,
    };

    List<VNDialogueNode> nodes;
    int calculatedDelta = 0;
    String displayActionTitle = actionType;

    final Random random = Random();

    // Pemetaan Aksi Usia 10 Tahun, Usia 6 Tahun & Usia 3 Tahun
    if (cleanAction.contains('ajak pacaran') || cleanAction.contains('pacaran')) {
      final int relVal = int.tryParse(relationshipValue.toString()) ?? 50;
      final double baseRate = ProposalPercentageSettings.getNotifier(targetRole, 'Ajak Pacaran', gender: character.gender).value;
      int acceptanceChance = baseRate.round();
      if (relVal >= 80) {
        acceptanceChance += 20;
      } else if (relVal >= 60) {
        acceptanceChance += 10;
      } else if (relVal < 40) {
        acceptanceChance -= 20;
      }
      acceptanceChance = acceptanceChance.clamp(10, 95);
      final bool isAccepted = (random.nextInt(100)) < acceptanceChance;
      
      if (isAccepted && character.partner == null) {
        character.partner = {
          'name': targetName,
          'relationship': '60',
          'gender': npcGender,
        };
      }
      calculatedDelta = isAccepted ? 20 : -10;
      displayActionTitle = 'Ajak Pacaran (${isAccepted ? "Diterima" : "Ditolak"})';
      nodes = AjakPacaranDialogue.getDialogue(player: character, npc: npcMap, isAccepted: isAccepted);
    } else if (cleanAction.contains('make love') || cleanAction.contains('bercinta') || cleanAction.contains('makelove')) {
      nodes = AjakMakeLoveDialogue.getDialogue(player: character, npc: npcMap);
    } else if (cleanAction.contains('masturbasi') || cleanAction.contains('masturbate')) {
      nodes = AjakMasturbateDialogue.getDialogue(player: character, npc: npcMap);
    } else if (cleanAction.contains('minta uang')) {
      int? amount;
      bool isAccepted = true;
      if (actionType.contains(' - ')) {
        final parts = actionType.split(' - ');
        amount = int.tryParse(parts[1]);
        if (parts.length > 2) {
          isAccepted = parts[2].toLowerCase() == 'true';
        }
      }
      calculatedDelta = isAccepted ? (random.nextInt(10) + 1) : -(random.nextInt(5) + 1);
      displayActionTitle = 'Minta Uang Saku (${isAccepted ? "Diterima" : "Ditolak"})';
      nodes = MintaUangSakuDialogue.getDialogue(
        player: character,
        npc: npcMap,
        amount: amount,
        isAccepted: isAccepted,
      );
    } else if (cleanAction.contains('minta sepeda')) {
      final int relVal = int.tryParse(relationshipValue.toString()) ?? 50;
      int consentChance = 50;
      if (relVal >= 80) {
        consentChance += 25;
      } else if (relVal >= 60) {
        consentChance += 10;
      } else if (relVal < 40) {
        consentChance -= 20;
      }
      consentChance = consentChance.clamp(15, 85);
      final bool isAccepted = (random.nextInt(100)) < consentChance;
      // Minta Sepeda: Diterima (+1 s/d +15%), Ditolak (-1 s/d -10%)
      calculatedDelta = isAccepted ? (random.nextInt(15) + 1) : -(random.nextInt(10) + 1);
      displayActionTitle = 'Minta Sepeda (${isAccepted ? "Diterima" : "Ditolak"})';
      nodes = MintaSepedaDialogue.getDialogue(player: character, npc: npcMap, isAccepted: isAccepted);
    } else if (cleanAction.contains('pujian')) {
      String? topik;
      if (actionType.contains(' - ')) {
        topik = actionType.split(' - ').last;
      }
      // Pujian: Naik +1 s/d +15%
      calculatedDelta = random.nextInt(15) + 1;
      displayActionTitle = topik != null ? 'Pujian ($topik)' : 'Berikan Pujian';
      nodes = BerikanPujianDialogue.getDialogue(player: character, npc: npcMap, topik: topik);
    } else if (cleanAction.contains('hadiah')) {
      String? hadiah;
      if (actionType.contains(' - ')) {
        hadiah = actionType.split(' - ').last;
      }
      // Hadiah: Naik +1 s/d +5%
      calculatedDelta = random.nextInt(5) + 1;
      displayActionTitle = hadiah != null ? 'Hadiah ($hadiah)' : 'Berikan Hadiah';
      nodes = BerikanHadiahDialogue.getDialogue(player: character, npc: npcMap);
    } else if (cleanAction.contains('menyinggung') || cleanAction.contains('singgung')) {
      String? topik;
      if (actionType.contains(' - ')) {
        topik = actionType.split(' - ').last;
      }
      // Menyinggung: Turun -1 s/d -20%
      calculatedDelta = -(random.nextInt(20) + 1);
      displayActionTitle = topik != null ? 'Menyinggung ($topik)' : 'Menyinggung Dia';
      nodes = SinggungDiaDialogue.getDialogue(player: character, npc: npcMap, topik: topik);
    } else if (cleanAction.contains('minta adik')) {
      nodes = MintaAdikBaruDialogue.getDialogue(player: character, npc: npcMap);
    } else if (cleanAction.contains('minta cerai') || cleanAction.contains('cerai')) {
      nodes = MintaCeraiDialogue.getDialogue(player: character, npc: npcMap);
    } else if (cleanAction.contains('bioskop')) {
      calculatedDelta = random.nextInt(10) + 5;
      displayActionTitle = 'Pergi ke Bioskop Bersama';
      nodes = PergiKeBioskopDialogue.getDialogue(player: character, npc: npcMap);
    } else if (cleanAction.contains('habiskan waktu')) {
      String? aktivitas;
      if (actionType.contains(' - ')) {
        aktivitas = actionType.split(' - ').last;
      }
      // Habiskan Waktu Bersama: Naik +1 s/d +20%
      calculatedDelta = random.nextInt(20) + 1;
      displayActionTitle = aktivitas != null ? 'Habiskan Waktu ($aktivitas)' : 'Habiskan Waktu Bersama';
      nodes = HabiskanWaktu3TahunDialogue.getDialogue(player: character, npc: npcMap, aktivitas: aktivitas);
    } else if (cleanAction.contains('minta barang')) {
      String? item;
      if (actionType.contains(' - ')) {
        item = actionType.split(' - ').last;
      }
      final int relVal = int.tryParse(relationshipValue.toString()) ?? 50;
      int consentChance = 50;
      if (relVal >= 80) {
        consentChance += 25;
      } else if (relVal >= 60) {
        consentChance += 10;
      } else if (relVal < 40) {
        consentChance -= 20;
      }
      consentChance = consentChance.clamp(15, 85);
      final bool isAccepted = (random.nextInt(100)) < consentChance;
      // Minta Barang: Diterima (+1 s/d +25%), Ditolak (-1 s/d -10%)
      calculatedDelta = isAccepted ? (random.nextInt(25) + 1) : -(random.nextInt(10) + 1);
      displayActionTitle = item != null ? 'Minta Barang ($item - ${isAccepted ? "Diterima" : "Ditolak"})' : 'Minta Barang (${isAccepted ? "Diterima" : "Ditolak"})';
      nodes = MintaBarangDialogue6Tahun.getDialogue(player: character, npc: npcMap, requestedItem: item, isGranted: isAccepted);
    } else if (cleanAction.contains('minta mainan')) {
      final int relVal = int.tryParse(relationshipValue.toString()) ?? 50;
      final bool isAccepted = (random.nextInt(100)) < (relVal >= 60 ? 70 : 40);
      calculatedDelta = isAccepted ? (random.nextInt(10) + 1) : -(random.nextInt(5) + 1);
      displayActionTitle = 'Minta Mainan (${isAccepted ? "Diterima" : "Ditolak"})';
      nodes = MintaMainanDialogue.getDialogue(player: character, npc: npcMap);
    } else if (cleanAction.contains('minta pelukan') || cleanAction.contains('pelukan')) {
      calculatedDelta = random.nextInt(8) + 3;
      displayActionTitle = 'Pelukan';
      nodes = MintaPelukanDialogue.getDialogue(player: character, npc: npcMap);
    } else if (cleanRole.contains('pacar') || cleanRole.contains('pasangan') || cleanRole.contains('suami') || cleanRole.contains('istri')) {
      nodes = VNDialoguePreset.getDatingDialogue(player: character, npc: npcMap);
    } else if (cleanRole.contains('sekolah') || cleanRole.contains('kuliah') || cleanRole.contains('teman')) {
      nodes = VNDialoguePreset.getSchoolFriendDialogue(player: character, npc: npcMap);
    } else {
      nodes = HabiskanWaktu3TahunDialogue.getDialogue(player: character, npc: npcMap);
    }


    // Luncurkan Tampilan Visual Novel Dialogue Overlay
    VNDialogueOverlay.show(
      context: context,
      player: character,
      npc: npcMap,
      nodes: nodes,
      onFinished: () {
        if (calculatedDelta != 0) {
          // Langsung update perubahan hubungan ke data karakter secara permanen
          final result = NpcRelationshipHelper.applyRelationshipChange(
            character: character,
            targetName: targetName,
            targetRole: targetRole,
            delta: calculatedDelta,
          );
          
          HubunganProgressModal.show(
            context: context,
            actionTitle: displayActionTitle,
            targetName: targetName,
            oldVal: result['oldVal']!,
            newVal: result['newVal']!,
            delta: calculatedDelta,
            onComplete: onActionComplete,
          );
        }
        onActionComplete();
      },
      playerAvatarUrl: effectivePlayerAvatarUrl,
      npcAvatarUrl: effectiveTargetAvatarUrl,
    );
  }

  static int _lookupTargetAge(Character character, String plainName, String targetName, String targetRole) {
    final String cleanPlain = plainName.toLowerCase().trim();
    final String cleanRaw = targetName.toLowerCase().trim();

    if (character.fatherName != null && (cleanPlain.contains(character.fatherName!.toLowerCase()) || cleanRaw.contains(character.fatherName!.toLowerCase()))) {
      return character.fatherAge ?? 45;
    }
    if (character.motherName != null && (cleanPlain.contains(character.motherName!.toLowerCase()) || cleanRaw.contains(character.motherName!.toLowerCase()))) {
      return character.motherAge ?? 42;
    }
    if (character.stepFatherName != null && (cleanPlain.contains(character.stepFatherName!.toLowerCase()) || cleanRaw.contains(character.stepFatherName!.toLowerCase()))) {
      return character.stepFatherAge ?? 48;
    }
    if (character.stepMotherName != null && (cleanPlain.contains(character.stepMotherName!.toLowerCase()) || cleanRaw.contains(character.stepMotherName!.toLowerCase()))) {
      return character.stepMotherAge ?? 45;
    }

    final List<List<Map<String, dynamic>>> allLists = [
      character.siblings,
      character.extendedFamily,
      character.children,
      character.friends,
      character.classmates,
      character.univClassmates,
      character.coworkers,
      character.exPartners,
    ];
    for (var list in allLists) {
      for (var item in list) {
        final String n = (item['name'] ?? '').toString().toLowerCase().trim();
        if (n.isNotEmpty && (cleanPlain.contains(n) || n.contains(cleanPlain) || cleanRaw.contains(n))) {
          final int? parsed = int.tryParse(item['age']?.toString() ?? '');
          if (parsed != null && parsed > 0) return parsed;
        }
      }
    }
    return 25;
  }

  static String? _lookupTargetSkinColor(Character character, String plainName, String targetName) {
    final String cleanPlain = plainName.toLowerCase().trim();
    final String cleanRaw = targetName.toLowerCase().trim();

    if (character.motherName != null && (cleanPlain.contains(character.motherName!.toLowerCase()) || cleanRaw.contains(character.motherName!.toLowerCase()))) {
      return character.motherSkinColor;
    }
    if (character.fatherName != null && (cleanPlain.contains(character.fatherName!.toLowerCase()) || cleanRaw.contains(character.fatherName!.toLowerCase()))) {
      return character.fatherSkinColor;
    }
    for (var p in [character.partner, character.secondPartner, character.thirdPartner, character.fourthPartner, character.fifthPartner]) {
      if (p != null && (p['name'] ?? '').toString().toLowerCase().contains(cleanPlain)) {
        return p['skinColor']?.toString();
      }
    }
    final List<List<Map<String, dynamic>>> allLists = [
      character.friends,
      character.classmates,
      character.univClassmates,
      character.coworkers,
      character.siblings,
      character.extendedFamily,
      character.children,
    ];
    for (var list in allLists) {
      for (var item in list) {
        final String n = (item['name'] ?? '').toString().toLowerCase().trim();
        if (n.isNotEmpty && (cleanPlain.contains(n) || n.contains(cleanPlain) || cleanRaw.contains(n))) {
          if (item['skinColor'] != null && item['skinColor'].toString().isNotEmpty) {
            return item['skinColor'].toString();
          }
        }
      }
    }
    return null;
  }
}
