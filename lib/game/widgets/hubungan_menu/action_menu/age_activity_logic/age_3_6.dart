// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_3_6.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'age_base.dart';

List<ActionItem> getAge3to6Actions(
  Character character,
  String targetName,
  String targetRole,
  Random random,
  Function(String title, String message, IconData icon, Color color, VoidCallback onConfirm) showDialog,
  Function(int change) updateRelationship,
  VoidCallback updateState,
) {
  final String relation = targetName.split(' ')[0];

  return [
    // 1. Minta Mainan
    ActionItem(
      label: 'Minta Mainan',
      icon: Icons.toys,
      color: Colors.orange,
      onTap: () {
        // Tentukan persentase keberhasilan berdasarkan target
        int successRate;
        if (relation == 'Ayah') {
          successRate = 70;
        } else if (relation == 'Ibu') {
          successRate = 70;
        } else {
          successRate = 50; // default untuk target lain (kakak, nenek, dll)
        }

        if (random.nextInt(100) < successRate) {
          int relBonus = random.nextInt(6) + 5;
          showDialog(
            'Minta Mainan Sukses!',
            '$relation membelikanmu mainan baru! Kamu sangat senang (+$relBonus% hubungan).',
            Icons.toys, Colors.orange, () {
              character.happiness = (character.happiness + 20).clamp(0, 100);
              updateRelationship(relBonus);
              updateState();
            }
          );
        } else {
          int relPenalty = random.nextInt(6) + 5;
          showDialog(
            'Minta Mainan Gagal',
            '$relation menolak membelikan mainan untukmu. Hubunganmu merenggang (-$relPenalty%).',
            Icons.block, Colors.red, () {
              character.happiness = (character.happiness - 5).clamp(0, 100);
              updateRelationship(-relPenalty);
              updateState();
            }
          );
        }
      },
    ),

    // 2. Minta Pelukan
    ActionItem(
      label: 'Minta Pelukan',
      icon: Icons.face,
      color: Colors.pinkAccent,
      onTap: () {
        // Tentukan persentase keberhasilan berdasarkan target
        int successRate;
        if (relation == 'Ayah' || relation == 'Ibu') {
          successRate = 70;
        } else if (relation == 'Kakek' || relation == 'Nenek') {
          successRate = 60;
        } else {
          successRate = 50; // Paman, Bibi, atau target lainnya
        }

        if (random.nextInt(100) < successRate) {
          int relBonus = random.nextInt(4) + 3;
          showDialog(
            'Dipenuhi Kasih Sayang',
            '$relation memberimu pelukan hangat yang membuatmu merasa sangat dicintai! (+$relBonus% hubungan)',
            Icons.face, Colors.pinkAccent, () {
              character.happiness = (character.happiness + 15).clamp(0, 100);
              updateRelationship(relBonus);
              updateState();
            }
          );
        } else {
          int relPenalty = random.nextInt(6) + 5;
          showDialog(
            'Pelukan Ditolak',
            '$relation sedang sibuk dan menolak pelukanmu. Kamu merasa sedikit sedih (-$relPenalty%).',
            Icons.sentiment_dissatisfied, Colors.grey, () {
              character.happiness = (character.happiness - 5).clamp(0, 100);
              updateRelationship(-relPenalty);
              updateState();
            }
          );
        }
      },
    ),
  ];
}