// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_3_6.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/percakapan_dispatcher.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_progress_modal.dart';
import 'age_base.dart';

List<ActionItem> getAge3to6Actions(
  BuildContext context,
  Character character,
  String targetName,
  String targetRole,
  Random random,
  Function(String title, String message, IconData icon, Color color, VoidCallback onConfirm) showDialog,
  Function(int change) updateRelationship,
  VoidCallback updateState, {
  String? targetAvatarUrl,
  String? playerAvatarUrl,
  int? targetAge,
  String? targetGender,
}) {
  void triggerVN(String actionType) {
    final int currentRel = NpcRelationshipHelper.getCurrentRelationship(
      character: character,
      targetName: targetName,
      targetRole: targetRole,
    );
    PercakapanDispatcher.dispatchAction(
      context: context,
      character: character,
      targetName: targetName,
      targetRole: targetRole,
      targetAge: targetAge != null ? '$targetAge tahun' : '3-6 tahun',
      targetRealAge: targetAge,
      targetGender: targetGender,
      targetAvatarUrl: targetAvatarUrl,
      playerAvatarUrl: playerAvatarUrl,
      relationshipValue: currentRel,
      actionType: actionType,
      onActionComplete: updateState,
    );
  }

  final String cleanRole = targetRole.toLowerCase();
  final String cleanName = targetName.toLowerCase();
  final bool isSiblingTarget = character.siblings.any((sib) =>
          '${sib['name']} (${sib['relation']})'.toLowerCase() == cleanName ||
          sib['name']!.toLowerCase() == cleanName ||
          (sib['relation']?.toLowerCase().contains('adik') ?? false)) ||
      cleanRole.contains('saudara') ||
      cleanRole.contains('kandung') ||
      cleanRole.contains('tiri') ||
      cleanName.contains('adik');

  final List<ActionItem> actions = [
    // 1. Minta Mainan
    ActionItem(
      label: 'Minta Mainan',
      icon: Icons.toys,
      color: Colors.orange,
      onTap: () => triggerVN('minta mainan'),
    ),

    // 2. Minta Pelukan
    ActionItem(
      label: 'Minta Pelukan',
      icon: Icons.face,
      color: Colors.pinkAccent,
      onTap: () => triggerVN('minta pelukan'),
    ),

    // 3. Pergi ke Bioskop Bersama
    ActionItem(
      label: 'Pergi ke Bioskop Bersama',
      icon: Icons.movie,
      color: Colors.deepPurple,
      onTap: () => triggerVN('pergi ke bioskop bersama'),
    ),

    // 4. Habiskan Waktu Bersama
    ActionItem(
      label: 'Habiskan Waktu Bersama',
      icon: Icons.people,
      color: Colors.blueAccent,
      onTap: () => triggerVN('habiskan waktu bersama'),
    ),
  ];

  final bool isYoungerSiblingTarget = character.siblings.any((sib) =>
          ('${sib['name']} (${sib['relation']})'.toLowerCase() == cleanName ||
          sib['name']!.toLowerCase() == cleanName ||
          (sib['relation']?.toLowerCase().contains('adik') ?? false)) &&
          (sib['relation']?.toLowerCase().contains('adik') ?? false)) ||
      cleanName.contains('adik') ||
      cleanRole.contains('adik');

  final bool isOlderSiblingTarget = character.siblings.any((sib) =>
          ('${sib['name']} (${sib['relation']})'.toLowerCase() == cleanName ||
          sib['name']!.toLowerCase() == cleanName ||
          (sib['relation']?.toLowerCase().contains('kakak') ?? false)) &&
          (sib['relation']?.toLowerCase().contains('kakak') ?? false)) ||
      cleanName.contains('kakak') ||
      cleanRole.contains('kakak');

  if (isSiblingTarget) {
    if (character.age < 10 && isYoungerSiblingTarget) {
      actions.removeWhere((item) =>
          item.label == 'Minta Mainan' ||
          item.label.contains('Minta Uang') ||
          item.label.contains('Minta Uang Saku') ||
          item.label.contains('Bioskop'));
    }

    // Ubah "Minta Pelukan" menjadi "Berikan Pelukan" jika berinteraksi dengan adik,
    // dan tetap "Minta Pelukan" jika berinteraksi dengan kakak.
    for (int i = 0; i < actions.length; i++) {
      if (actions[i].label == 'Minta Pelukan' || actions[i].label == 'Berikan Pelukan') {
        final String labelText = isOlderSiblingTarget ? 'Minta Pelukan' : (isYoungerSiblingTarget ? 'Berikan Pelukan' : actions[i].label);
        final String actionTypeValue = labelText.toLowerCase();
        actions[i] = ActionItem(
          label: labelText,
          icon: Icons.face,
          color: Colors.pinkAccent,
          onTap: () => triggerVN(actionTypeValue),
        );
      }
    }
  }

  return actions;
}