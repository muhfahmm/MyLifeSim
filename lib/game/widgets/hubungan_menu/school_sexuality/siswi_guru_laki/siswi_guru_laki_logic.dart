// lib/game/widgets/hubungan_menu/school_sexuality/siswi_guru_laki/siswi_guru_laki_logic.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class SiswiGuruLakiLogic {
  static final Random _random = Random();

  /// Mengajak pacaran (Siswi Perempuan ke Guru Laki-laki)
  /// Peluang dasar: 35% (dari tabel getSchoolRomanceChance)
  static void ajakPacaran({
    required BuildContext context,
    required Character character,
    required Map<String, String> teacher,
    required VoidCallback onRefresh,
    required Function(String, String) showOutcome,
  }) {
    final String name = teacher['name']!;
    final int rel = int.tryParse(teacher['relationship'] ?? '50') ?? 50;

    final int successChance = (35 + rel) ~/ 2;
    final bool accepted = _random.nextInt(100) < successChance;

    if (accepted) {
      character.partner = {
        'name': name,
        'relation': 'Pacar (Guru)',
        'gender': 'Laki-laki',
        'age': teacher['age'] ?? '35',
        'relationship': '80',
        'isDeceased': 'false',
      };
      teacher['relationship'] = '85';
      onRefresh();

      DialogHelper.show(
        context: context,
        title: 'Pacaran Baru! ❤️',
        content: Text('Guru Laki-laki $name menerima ajakan pacaranmu secara rahasia!'),
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
      teacher['relationship'] = (rel - change).clamp(0, 100).toString();
      onRefresh();
      showOutcome('Ajakan Ditolak 🚫', '$name menolak ajakan pacaranmu.');
    }
  }

  /// Bercinta (Siswi Perempuan ke Guru Laki-laki)
  static void bercinta({
    required BuildContext context,
    required Character character,
    required Map<String, String> teacher,
    required VoidCallback onRefresh,
    required Function(String, String) showOutcome,
  }) {
    final String name = teacher['name']!;
    final int rel = int.tryParse(teacher['relationship'] ?? '50') ?? 50;

    final bool isPartner = character.partner != null && character.partner!['name'] == name;
    int chance = isPartner ? (rel - 30) : (rel - 60);
    if (chance < 0) chance = 0;

    final bool accepted = _random.nextInt(100) < chance;

    if (accepted) {
      character.happiness = (character.happiness + 20).clamp(0, 100);
      teacher['relationship'] = (rel + 10).clamp(0, 100).toString();
      onRefresh();

      // Siswi perempuan bisa hamil
      if (_random.nextInt(100) < 20) {
        character.isPregnant = true;
        character.pregnantByPartnerName = name;
        character.pregnantByPartnerRole = 'Guru';
      }

      showOutcome('Bercinta Sukses 💖', 'Secara rahasia, kamu dan guru laki-laki $name menghabiskan waktu intim bersama.');
    } else {
      final change = 15 + _random.nextInt(11);
      teacher['relationship'] = (rel - change).clamp(0, 100).toString();
      onRefresh();
      showOutcome('Bercinta Ditolak 🚫', '$name menolak ajakanmu.');
    }
  }
}
