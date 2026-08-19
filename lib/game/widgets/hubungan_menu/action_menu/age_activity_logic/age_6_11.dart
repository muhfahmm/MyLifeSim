// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_6_11.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'age_base.dart';

List<ActionItem> getAge6to11Actions(
  BuildContext context,
  Character character,
  String targetName,
  String targetRole,
  Random random,
  Function(String title, String message, IconData icon, Color color, VoidCallback onConfirm) showDialogCallback,
  Function(int change) updateRelationship,
  VoidCallback updateState,
) {
  final String relation = targetName.split(' ')[0];

  // --- Helper untuk meminta barang ---
  void _requestItem(String itemName, int successRate, int happinessGain, int relationshipGain) {
    if (random.nextInt(100) < successRate) {
      int relBonus = relationshipGain + random.nextInt(4);
      showDialogCallback(
        'Berhasil Mendapatkan $itemName!',
        '$relation membelikanmu $itemName yang kamu inginkan. Kamu sangat senang! (+${relBonus.abs()}% hubungan)',
        Icons.check_circle, Colors.green, () {
          character.happiness = (character.happiness + happinessGain).clamp(0, 100);
          updateRelationship(relBonus);
          updateState();
        }
      );
    } else {
      int relPenalty = random.nextInt(6) + 5; // 5–10%
      showDialogCallback(
        'Permintaan Ditolak',
        '$relation menolak membelikan $itemName untukmu. Hubunganmu merenggang (-$relPenalty%).',
        Icons.block, Colors.red, () {
          character.happiness = (character.happiness - 5).clamp(0, 100);
          updateRelationship(-relPenalty);
          updateState();
        }
      );
    }
  }

  // --- Daftar aksi interaksi (menu yang sudah ada tetap dipertahankan) ---
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
          showDialogCallback(
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
          int relPenalty = random.nextInt(5) + 1;
          showDialogCallback(
            'Uang Saku Ditolak',
            '$relation tidak memberimu uang saku kali ini. Hubunganmu merenggang (-$relPenalty%).',
            Icons.money_off, Colors.red, () {
              character.happiness = (character.happiness - 2).clamp(0, 100);
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
          showDialogCallback(
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
          showDialogCallback(
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
        showDialogCallback(
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
        showDialogCallback(
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
        showDialogCallback(
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
        showDialogCallback(
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
          showDialogCallback(
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
          showDialogCallback(
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
          showDialogCallback(
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
          showDialogCallback(
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

    // ★ MENU BARU: Minta Barang (gunakan showDialog bawaan Flutter)
    ActionItem(
      label: 'Minta Barang',
      icon: Icons.shopping_bag,
      color: Colors.purple,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Pilih Barang yang Diinginkan'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.shopping_bag, color: Colors.blue),
                    title: const Text('Tas'),
                    onTap: () {
                      Navigator.pop(context);
                      _requestItem('Tas', 70, 15, 5);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.directions_walk, color: Colors.orange),
                    title: const Text('Sepatu'),
                    onTap: () {
                      Navigator.pop(context);
                      _requestItem('Sepatu', 65, 10, 6);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.checkroom, color: Colors.purple),
                    title: const Text('Jaket'),
                    onTap: () {
                      Navigator.pop(context);
                      _requestItem('Jaket', 55, 12, 4);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.face, color: Colors.green),
                    title: const Text('Topi'),
                    onTap: () {
                      Navigator.pop(context);
                      _requestItem('Topi', 80, 8, 3);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.watch, color: Colors.amber),
                    title: const Text('Jam Tangan'),
                    onTap: () {
                      Navigator.pop(context);
                      _requestItem('Jam Tangan', 40, 20, 8);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_balance_wallet, color: Colors.brown),
                    title: const Text('Dompet'),
                    onTap: () {
                      Navigator.pop(context);
                      _requestItem('Dompet', 60, 10, 5);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
            ],
          ),
        );
      },
    ),
  ];
}