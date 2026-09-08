import 'package:flutter/material.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class NpcRelationshipHelper {
  /// Memperoleh nilai tingkat hubungan saat ini tanpa mengubah data
  static int getCurrentRelationship({
    required Character character,
    required String targetName,
    String? targetRole,
  }) {
    final res = applyRelationshipChange(
      character: character,
      targetName: targetName,
      targetRole: targetRole,
      delta: 0,
    );
    return res['oldVal'] ?? 50;
  }

  /// Memperbarui nilai tingkat hubungan NPC di dalam objek Character
  static Map<String, int> applyRelationshipChange({
    required Character character,
    required String targetName,
    required int delta,
    String? targetRole,
  }) {
    int oldVal = 50;
    int newVal = 50;

    final String cleanTarget = targetName.toLowerCase().trim();
    final String cleanRole = (targetRole ?? '').toLowerCase().trim();
    final String plainName = AvatarAgeRules.getCleanNPCName(targetName).toLowerCase().trim();

    bool matched = false;

    bool isNameMatch(String? nameInChar) {
      if (nameInChar == null || nameInChar.trim().isEmpty) return false;
      final String cn = nameInChar.toLowerCase().trim();
      return plainName.contains(cn) || cn.contains(plainName) || cleanTarget.contains(cn) || cn.contains(cleanTarget);
    }

    // 1. Cek Orang Tua Kandung & Tiri & Mertua
    if (cleanRole.contains('ibu tiri') || isNameMatch(character.stepMotherName)) {
      oldVal = character.stepMotherRelationship ?? 50;
      newVal = (oldVal + delta).clamp(0, 100);
      character.stepMotherRelationship = newVal;
      matched = true;
    } else if (cleanRole.contains('ayah tiri') || isNameMatch(character.stepFatherName)) {
      oldVal = character.stepFatherRelationship ?? 50;
      newVal = (oldVal + delta).clamp(0, 100);
      character.stepFatherRelationship = newVal;
      matched = true;
    } else if (cleanRole.contains('ibu mertua') || cleanTarget.contains('ibu mertua') || isNameMatch(character.motherInLawName)) {
      oldVal = character.motherInLawRelationship ?? 50;
      newVal = (oldVal + delta).clamp(0, 100);
      character.motherInLawRelationship = newVal;
      matched = true;
    } else if (cleanRole.contains('ayah mertua') || cleanTarget.contains('ayah mertua') || isNameMatch(character.fatherInLawName)) {
      oldVal = character.fatherInLawRelationship ?? 50;
      newVal = (oldVal + delta).clamp(0, 100);
      character.fatherInLawRelationship = newVal;
      matched = true;
    } else if (cleanRole.contains('ibu') || cleanTarget.contains('ibu') || isNameMatch(character.motherName)) {
      oldVal = character.motherRelationship ?? 50;
      newVal = (oldVal + delta).clamp(0, 100);
      character.motherRelationship = newVal;
      matched = true;
    } else if (cleanRole.contains('ayah') || cleanTarget.contains('ayah') || isNameMatch(character.fatherName)) {
      oldVal = character.fatherRelationship ?? 50;
      newVal = (oldVal + delta).clamp(0, 100);
      character.fatherRelationship = newVal;
      matched = true;
    }

    void updateMap(Map<String, dynamic> map) {
      oldVal = int.tryParse(map['relationship']?.toString() ?? '50') ?? 50;
      newVal = (oldVal + delta).clamp(0, 100);
      map['relationship'] = newVal.toString();
      matched = true;
    }

    void updateList(List<Map<String, dynamic>> list) {
      if (matched) return;
      for (var item in list) {
        final String n = (item['name'] ?? '').toString().toLowerCase().trim();
        final String relLabel = '${item['name']} (${item['relation']})'.toLowerCase().trim();
        if (n.isNotEmpty && (n == cleanTarget || cleanTarget.contains(n) || n.contains(cleanTarget) || plainName.contains(n) || n.contains(plainName) || relLabel == cleanTarget || isNameMatch(n))) {
          updateMap(item);
          return;
        }
      }
    }

    // 2. Cek Pasangan Aktif
    if (!matched) {
      for (var p in [character.partner, character.secondPartner, character.thirdPartner, character.fourthPartner, character.fifthPartner]) {
        if (!matched && p != null) {
          final String n = (p['name'] ?? '').toString().toLowerCase().trim();
          if (n.isNotEmpty && (cleanTarget.contains(n) || n.contains(cleanTarget) || plainName.contains(n) || isNameMatch(n))) {
            updateMap(p);
          }
        }
      }
    }

    // 3. Cek Seluruh List NPC
    if (!matched) {
      for (var list in [
        character.siblings,
        character.extendedFamily,
        character.children,
        character.friends,
        character.classmates,
        character.univClassmates,
        character.coworkers,
        character.secretPartners,
        character.exPartners,
      ]) {
        if (!matched) updateList(list);
      }
    }

    if (!matched) {
      oldVal = 50;
      newVal = (oldVal + delta).clamp(0, 100);
    }

    // Sinkronkan ke seluruh list/partner di Character
    character.updateRelationshipValue(targetName, newVal);
    if (plainName.isNotEmpty && plainName != cleanTarget) {
      character.updateRelationshipValue(plainName, newVal);
    }

    return {
      'oldVal': oldVal,
      'newVal': newVal,
      'delta': delta,
    };
  }
}

class HubunganProgressModal {
  /// Menampilkan modal dialog progress perubahan hubungan (naik/turun)
  /// Menggunakan susunan dan gaya visual yang persis sama dengan modal di Beranda
  static Future<void> show({
    required BuildContext context,
    required String actionTitle,
    required String targetName,
    required int oldVal,
    required int newVal,
    required int delta,
    VoidCallback? onComplete,
  }) {
    final bool isPositive = delta >= 0;
    final Color mainColor = isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBgColor = isDark ? const Color(0xFF383848) : Colors.grey.shade100;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color progressBgColor = isDark ? Colors.white10 : Colors.grey.shade300;

    return DialogHelper.show(
      context: context,
      title: isPositive ? '📈 Status Hubungan' : '📉 Status Hubungan',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Box 1: Deskripsi / Hasil aksi (gaya card beranda)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(16),
              border: isDark ? null : Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Text(isPositive ? '😊' : '😔', style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isPositive
                        ? 'Aksi "$actionTitle" membuat $targetName merasa senang dan lebih dekat denganmu!'
                        : 'Aksi "$actionTitle" membuat $targetName merasa kurang nyaman.',
                    style: TextStyle(color: textColor, fontSize: 13, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Box 2: Detail persentase & Progress bar (gaya card beranda)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(16),
              border: isDark ? null : Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        targetName,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$oldVal% ➔ $newVal% (${isPositive ? "+$delta" : "$delta"}%)',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (newVal.clamp(0, 100)) / 100.0,
                    minHeight: 10,
                    backgroundColor: progressBgColor,
                    valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            if (onComplete != null) onComplete();
          },
          child: const Text(
            'Lanjutkan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
