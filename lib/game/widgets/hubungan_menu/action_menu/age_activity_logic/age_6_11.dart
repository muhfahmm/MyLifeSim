// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_6_11.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'age_base.dart';

import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/percakapan_dispatcher.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_progress_modal.dart';

// Gunakan helper yang sama dari age_12_plus
void _showPickerBottomSheet6({
  required BuildContext context,
  required String title,
  required IconData titleIcon,
  required Color titleColor,
  required List<Map<String, dynamic>> options,
  required void Function(String value) onPicked,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
      final Color bgColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
      final Color handleColor = isDark ? Colors.white24 : Colors.grey.shade300;
      final Color cardBgColor = isDark ? const Color(0xFF2A2A3D) : Colors.grey.shade100;

      return Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: handleColor, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Icon(titleIcon, color: titleColor, size: 22),
              const SizedBox(width: 10),
              Text(title, style: TextStyle(color: titleColor, fontSize: 17, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 16),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: options.length,
                itemBuilder: (_, i) {
                  final opt = options[i];
                  final Color c = opt['color'] as Color? ?? Colors.blue;
                  return InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      onPicked(opt['value'] as String);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? c.withValues(alpha: 0.15) : cardBgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? c.withValues(alpha: 0.4) : c.withValues(alpha: 0.6)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(children: [
                        Icon(opt['icon'] as IconData? ?? Icons.circle, color: c, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            opt['label'] as String,
                            style: TextStyle(
                              color: isDark ? c : (c == Colors.amber ? Colors.amber.shade900 : c),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

List<ActionItem> getAge6to11Actions(
  BuildContext context,
  Character character,
  String targetName,
  String targetRole,
  Random random,
  Function(String title, String message, IconData icon, Color color, VoidCallback onConfirm) showDialogCallback,
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
      targetAge: targetAge != null ? '$targetAge tahun' : '6Tahun',
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
    ActionItem(
      label: 'Minta Uang Saku',
      icon: Icons.monetization_on,
      color: Colors.amber,
      onTap: () => triggerVN('Minta Uang Saku'),
    ),
    ActionItem(
      label: 'Minta Sepeda',
      icon: Icons.directions_bike,
      color: Colors.green,
      onTap: () => triggerVN('Minta Sepeda'),
    ),
    ActionItem(
      label: 'Pujian',
      icon: Icons.thumb_up,
      color: Colors.blue,
      onTap: () {
        _showPickerBottomSheet6(
          context: context,
          title: 'Pilih Topik Pujian',
          titleIcon: Icons.thumb_up,
          titleColor: Colors.blue,
          options: [
            {'label': 'Penampilan', 'icon': Icons.star, 'color': Colors.amber, 'value': 'Penampilan'},
            {'label': 'Kebaikan', 'icon': Icons.thumb_up, 'color': Colors.blue, 'value': 'Kebaikan'},
            {'label': 'Kepintaran', 'icon': Icons.psychology, 'color': Colors.purple, 'value': 'Kepintaran'},
            {'label': 'Prestasi', 'icon': Icons.emoji_events, 'color': Colors.orange, 'value': 'Prestasi'},
          ],
          onPicked: (topik) => triggerVN('Pujian - $topik'),
        );
      },
    ),
    ActionItem(
      label: 'Hadiah',
      icon: Icons.card_giftcard,
      color: Colors.pink,
      onTap: () {
        _showPickerBottomSheet6(
          context: context,
          title: 'Pilih Hadiah',
          titleIcon: Icons.card_giftcard,
          titleColor: Colors.pink,
          options: [
            {'label': 'Lukisan', 'icon': Icons.brush, 'color': Colors.orange, 'value': 'Lukisan'},
            {'label': 'Camilan', 'icon': Icons.cake, 'color': Colors.pink, 'value': 'Camilan'},
            {'label': 'Kerajinan', 'icon': Icons.card_giftcard, 'color': Colors.purple, 'value': 'Kerajinan'},
          ],
          onPicked: (hadiah) => triggerVN('Hadiah - $hadiah'),
        );
      },
    ),
    ActionItem(
      label: 'Menyinggung',
      icon: Icons.sentiment_very_dissatisfied,
      color: Colors.red,
      onTap: () {
        _showPickerBottomSheet6(
          context: context,
          title: 'Pilih Cara Menyinggung',
          titleIcon: Icons.sentiment_very_dissatisfied,
          titleColor: Colors.red,
          options: [
            {'label': 'Penampilan', 'icon': Icons.face, 'color': Colors.pink, 'value': 'Penampilan'},
            {'label': 'Kepribadian', 'icon': Icons.psychology, 'color': Colors.purple, 'value': 'Kepribadian'},
            {'label': 'Kebiasaan', 'icon': Icons.loop, 'color': Colors.brown, 'value': 'Kebiasaan'},
            {'label': 'Nilai Sekolah', 'icon': Icons.school, 'color': Colors.orange, 'value': 'Nilai Sekolah'},
          ],
          onPicked: (topik) => triggerVN('Menyinggung - $topik'),
        );
      },
    ),
    ActionItem(
      label: 'Pergi ke Bioskop Bersama',
      icon: Icons.movie,
      color: Colors.deepPurple,
      onTap: () => triggerVN('Pergi ke Bioskop Bersama'),
    ),
    ActionItem(
      label: 'Habiskan Waktu Bersama',
      icon: Icons.family_restroom,
      color: Colors.orange,
      onTap: () {
        _showPickerBottomSheet6(
          context: context,
          title: 'Pilih Aktivitas Bersama',
          titleIcon: Icons.family_restroom,
          titleColor: Colors.orange,
          options: [
            {'label': 'Bermain di Taman', 'icon': Icons.sports_soccer, 'color': Colors.green, 'value': 'Bermain di Taman'},
            {'label': 'Mewarnai', 'icon': Icons.palette, 'color': Colors.pink, 'value': 'Mewarnai'},
            {'label': 'Dongeng', 'icon': Icons.menu_book, 'color': Colors.blue, 'value': 'Dongeng'},
            {'label': 'Masak Bersama', 'icon': Icons.lunch_dining, 'color': Colors.orange, 'value': 'Masak Bersama'},
          ],
          onPicked: (aktivitas) => triggerVN('Habiskan Waktu Bersama - $aktivitas'),
        );
      },
    ),
    ActionItem(
      label: 'Minta Barang',
      icon: Icons.shopping_bag,
      color: Colors.purple,
      onTap: () {
        _showPickerBottomSheet6(
          context: context,
          title: 'Pilih Barang yang Diminta',
          titleIcon: Icons.shopping_bag,
          titleColor: Colors.purple,
          options: [
            {'label': 'Tas', 'icon': Icons.shopping_bag, 'color': Colors.blue, 'value': 'Tas'},
            {'label': 'Sepatu', 'icon': Icons.directions_walk, 'color': Colors.orange, 'value': 'Sepatu'},
            {'label': 'Jaket', 'icon': Icons.checkroom, 'color': Colors.purple, 'value': 'Jaket'},
            {'label': 'Topi', 'icon': Icons.face, 'color': Colors.green, 'value': 'Topi'},
            {'label': 'Jam Tangan', 'icon': Icons.watch, 'color': Colors.amber, 'value': 'Jam Tangan'},
            {'label': 'Dompet', 'icon': Icons.account_balance_wallet, 'color': Colors.brown, 'value': 'Dompet'},
          ],
          onPicked: (barang) => triggerVN('Minta Barang - $barang'),
        );
      },
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

    for (int i = 0; i < actions.length; i++) {
      if (actions[i].label == 'Minta Pelukan' || actions[i].label == 'Berikan Pelukan') {
        final String labelText = isOlderSiblingTarget ? 'Minta Pelukan' : (isYoungerSiblingTarget ? 'Berikan Pelukan' : actions[i].label);
        actions[i] = ActionItem(
          label: labelText,
          icon: Icons.face,
          color: Colors.pinkAccent,
          onTap: () => triggerVN(labelText),
        );
      }
    }
  }

  return actions;
}