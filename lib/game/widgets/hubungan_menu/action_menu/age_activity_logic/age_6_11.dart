// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_6_11.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'age_base.dart';

List<ActionItem> getAge6to11Actions(
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
    // 1. Minta Uang Saku
    ActionItem(
      label: 'Minta Uang Saku',
      icon: Icons.monetization_on,
      color: Colors.amber,
      onTap: () {
        if (random.nextBool()) {
          int gotMoney = random.nextInt(10) + 5;
          int relBonus = random.nextInt(6) + 5;
          showDialog(
            'Dapat Uang Saku!',
            '$relation memberimu uang saku sebesar \$$gotMoney! (+$relBonus% hubungan).',
            Icons.monetization_on, Colors.green, () {
              character.money += gotMoney;
              character.happiness = (character.happiness + 10).clamp(0, 100);
              updateRelationship(relBonus);
              updateState();
            }
          );
        } else {
          int relPenalty = random.nextInt(4) + 2;
          showDialog(
            'Uang Saku Ditolak',
            '$relation tidak memberimu uang saku kali ini. Hubunganmu merenggang (-$relPenalty%).',
            Icons.money_off, Colors.red, () {
              character.happiness = (character.happiness - 5).clamp(0, 100);
              updateRelationship(-relPenalty);
              updateState();
            }
          );
        }
      },
    ),

    // 2. Minta Sepeda
    ActionItem(
      label: 'Minta Sepeda',
      icon: Icons.directions_bike,
      color: Colors.green,
      onTap: () {
        if (random.nextBool()) {
          int relBonus = random.nextInt(6) + 10;
          showDialog(
            'Minta Sepeda Sukses!',
            '$relation membelikanmu sepeda baru! Hubunganmu membaik (+$relBonus%).',
            Icons.directions_bike, Colors.green, () {
              character.happiness = (character.happiness + 25).clamp(0, 100);
              updateRelationship(relBonus);
              updateState();
            }
          );
        } else {
          int relPenalty = random.nextInt(4) + 2;
          showDialog(
            'Minta Sepeda Gagal',
            '$relation menolak permintaanmu. Hubunganmu merenggang (-$relPenalty%).',
            Icons.block, Colors.red, () {
              character.happiness = (character.happiness - 10).clamp(0, 100);
              updateRelationship(-relPenalty);
              updateState();
            }
          );
        }
      },
    ),

    // 3. Pujian
    ActionItem(
      label: 'Pujian',
      icon: Icons.thumb_up,
      color: Colors.blue,
      onTap: () {
        int relBonus = random.nextInt(6) + 5;
        showDialog(
          'Memberi Pujian',
          'Kamu memuji $relation. Hubungan kalian menjadi lebih hangat! (+$relBonus% hubungan)',
          Icons.thumb_up, Colors.blue, () {
            character.happiness = (character.happiness + 10).clamp(0, 100);
            updateRelationship(relBonus);
            updateState();
          }
        );
      },
    ),

    // 4. Percakapan
    ActionItem(
      label: 'Percakapan',
      icon: Icons.chat,
      color: Colors.teal,
      onTap: () {
        int relBonus = random.nextInt(4) + 2;
        showDialog(
          'Bercakap-cakap',
          'Kamu mengobrol dengan $relation. Percakapan berjalan menyenangkan! (+$relBonus% hubungan)',
          Icons.chat, Colors.teal, () {
            character.happiness = (character.happiness + 5).clamp(0, 100);
            character.intelligence = (character.intelligence + 2).clamp(0, 100);
            updateRelationship(relBonus);
            updateState();
          }
        );
      },
    ),

    // 5. Hadiah
    ActionItem(
      label: 'Hadiah',
      icon: Icons.card_giftcard,
      color: Colors.pink,
      onTap: () {
        int relBonus = random.nextInt(8) + 5;
        showDialog(
          'Memberi Hadiah',
          'Kamu memberikan hadiah kecil buatan sendiri. $relation sangat tersentuh! (+$relBonus% hubungan)',
          Icons.card_giftcard, Colors.pink, () {
            character.happiness = (character.happiness + 15).clamp(0, 100);
            updateRelationship(relBonus);
            updateState();
          }
        );
      },
    ),

    // 6. Menyinggung
    ActionItem(
      label: 'Menyinggung',
      icon: Icons.sentiment_very_dissatisfied,
      color: Colors.red,
      onTap: () {
        int relPenalty = random.nextInt(11) + 5;
        showDialog(
          'Menyinggung',
          'Kamu mengatakan sesuatu yang kasar kepada $relation. Hubungan menjadi tegang (-$relPenalty% hubungan).',
          Icons.sentiment_very_dissatisfied, Colors.red, () {
            character.happiness = (character.happiness - 15).clamp(0, 100);
            updateRelationship(-relPenalty);
            updateState();
          }
        );
      },
    ),

    // 7. Pergi ke Bioskop Bersama
    ActionItem(
      label: 'Pergi ke Bioskop Bersama',
      icon: Icons.movie,
      color: Colors.deepPurple,
      onTap: () {
        if (random.nextDouble() < 0.75) {
          int relBonus = random.nextInt(6) + 10;
          showDialog(
            'Menonton Bioskop',
            'Kamu pergi menonton film bersama $relation. Sangat menyenangkan! (+$relBonus% hubungan)',
            Icons.movie, Colors.green, () {
              character.happiness = (character.happiness + 20).clamp(0, 100);
              updateRelationship(relBonus);
              updateState();
            }
          );
        } else {
          int relPenalty = random.nextInt(6) + 5;
          showDialog(
            'Ajakan Ditolak',
            '$relation menolak ajakan menonton karena sedang sibuk (-$relPenalty% hubungan).',
            Icons.block, Colors.red, () {
              updateRelationship(-relPenalty);
              updateState();
            }
          );
        }
      },
    ),

    // 8. Habiskan Waktu Bersama
    ActionItem(
      label: 'Habiskan Waktu Bersama',
      icon: Icons.family_restroom,
      color: Colors.orange,
      onTap: () {
        if (random.nextDouble() < 0.8) {
          int relBonus = random.nextInt(5) + 8;
          showDialog(
            'Bermain Bersama',
            'Kamu bermain board game di ruang tamu bersama $relation (+$relBonus% hubungan).',
            Icons.family_restroom, Colors.orange, () {
              character.happiness = (character.happiness + 12).clamp(0, 100);
              updateRelationship(relBonus);
              updateState();
            }
          );
        } else {
          int relPenalty = random.nextInt(6) + 5;
          showDialog(
            'Ajakan Ditolak',
            '$relation menolak diajak bermain (-$relPenalty% hubungan).',
            Icons.block, Colors.red, () {
              updateRelationship(-relPenalty);
              updateState();
            }
          );
        }
      },
    ),
  ];
}