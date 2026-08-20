// lib/game/widgets/hubungan_menu/school_sexuality/siswi_siswi/siswi_siswi_logic.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class SiswiSiswiLogic {
  static final Random _random = Random();

  /// Mengajak pacaran sesama siswi perempuan (Lesbian)
  static void ajakPacaran({
    required BuildContext context,
    required Character character,
    required Map<String, String> classmate,
    required VoidCallback onRefresh,
    required Function(String, String) showOutcome,
  }) {
    final String name = classmate['name']!;
    final int rel = int.tryParse(classmate['relationship'] ?? '50') ?? 50;

    final int successChance = (30 + rel) ~/ 2; // Lesbian base chance: 30%
    final bool accepted = _random.nextInt(100) < successChance;

    if (accepted) {
      character.partner = {
        'name': name,
        'relation': 'Pacar (Lesbian)',
        'gender': 'Perempuan',
        'age': classmate['age'] ?? character.age.toString(),
        'relationship': '80',
        'isDeceased': 'false',
      };
      classmate['relationship'] = '85';
      onRefresh();

      DialogHelper.show(
        context: context,
        title: 'Pacaran Baru! 🏳️‍🌈',
        content: Text('Teman sekelasmu, $name menerima ajakan pacaran sesama jenis (Lesbian) secara rahasia!'),
        actions: [
          Builder(
            builder: (dialogContext) => TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          )
        ],
      );
    } else {
      final change = 15 + _random.nextInt(11);
      classmate['relationship'] = (rel - change).clamp(0, 100).toString();
      onRefresh();
      showOutcome('Ajakan Ditolak 🚫', '$name menolak ajakan pacaranmu.');
    }
  }

  /// Bercinta Lesbian sesama siswi
  static void bercinta({
    required BuildContext context,
    required Character character,
    required Map<String, String> classmate,
    required VoidCallback onRefresh,
    required Function(String, String) showOutcome,
  }) {
    final String name = classmate['name']!;
    final int rel = int.tryParse(classmate['relationship'] ?? '50') ?? 50;

    final bool isPartner = character.partner != null && character.partner!['name'] == name;
    int chance = isPartner ? (rel - 20) : (rel - 50);
    if (chance < 0) chance = 0;

    final bool accepted = _random.nextInt(100) < chance;

    if (accepted) {
      character.happiness = (character.happiness + 20).clamp(0, 100);
      classmate['relationship'] = (rel + 10).clamp(0, 100).toString();
      onRefresh();
      showOutcome('Bercinta Sukses 💖', 'Secara rahasia, kamu dan $name menghabiskan waktu intim bersama.');
    } else {
      final change = 15 + _random.nextInt(11);
      classmate['relationship'] = (rel - change).clamp(0, 100).toString();
      onRefresh();
      showOutcome('Bercinta Ditolak 🚫', '$name menolak ajakanmu.');
    }
  }
}
