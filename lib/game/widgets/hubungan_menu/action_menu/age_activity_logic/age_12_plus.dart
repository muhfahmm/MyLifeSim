// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_12_plus.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/bercinta.dart';
import 'age_base.dart';

String _getPartnerGender(String targetName) {
  if (targetName.startsWith('Ayah')) return 'Laki-laki';
  if (targetName.startsWith('Ibu')) return 'Perempuan';
  final int startIndex = targetName.indexOf('(');
  final int endIndex = targetName.indexOf(')');
  if (startIndex != -1 && endIndex != -1) {
    final String relationText = targetName.substring(startIndex + 1, endIndex).toLowerCase();
    if (relationText.contains('perempuan')) return 'Perempuan';
    if (relationText.contains('laki-laki')) return 'Laki-laki';
  }
  return 'Laki-laki';
}

List<ActionItem> getAge12PlusActions(
  BuildContext context,
  Character character,
  String targetName,
  String targetRole,
  int age,
  Random random,
  Function(String title, String message, IconData icon, Color color, VoidCallback onConfirm) showDialog,
  Function(int change) updateRelationship,
  VoidCallback updateState,
) {
  final String relation = targetName.split(' ')[0];
  final String myGender = character.gender.trim().toLowerCase();
  final String partnerGender = _getPartnerGender(targetName).toLowerCase();
  final bool isPartnerRole = targetRole == 'Pacar' || targetRole == 'Tunangan' || targetRole == 'Suami' || targetRole == 'Istri';
  final bool isAlreadyPartner = character.partner != null && character.partner!['name'] == targetName;
  final bool isChild = targetRole == 'Laki-laki' || targetRole == 'Perempuan';

  // Helper untuk mendapatkan nilai hubungan saat ini
  int _getCurrentRelationshipValue() {
    return int.tryParse(character.partner?['relationship'] ?? '50') ?? 50;
  }

  List<ActionItem> actions = [];

  if (isChild) {
    // Jika target adalah anak kita (usia 12 ke atas):
    // Jika sudah usia 12 maka berikan pelukannya akan hilang (tidak ditambahkan).
    // Dan buat ketika anak sudah usia yang sama seperti yang lain (12 tahun ke atas) maka juga akan ada make love juga.
    actions.add(ActionItem(
      label: 'Bercinta / Make Love',
      icon: Icons.favorite,
      color: Colors.pink,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BercintaScreen(
              character: character,
              targetName: targetName,
              targetRole: targetRole,
              onActionComplete: () {
                updateState();
              },
            ),
          ),
        );
      },
    ));

    actions.add(ActionItem(
      label: 'Bercakap-cakap',
      icon: Icons.chat,
      color: Colors.teal,
      onTap: () {
        int relBonus = random.nextInt(5) + 5;
        showDialog(
          'Berbincang dengan Anak',
          'Kamu duduk bersama $targetName dan mengobrol tentang kesehariannya serta impian masa depannya. (+$relBonus% hubungan)',
          Icons.chat,
          Colors.teal,
          () {
            updateRelationship(relBonus);
            updateState();
          },
        );
      },
    ));

    actions.add(ActionItem(
      label: 'Beri Uang Jajan',
      icon: Icons.monetization_on,
      color: Colors.green,
      onTap: () {
        if (character.money < 20) {
          showDialog(
            'Uang Tidak Cukup',
            'Kamu tidak memiliki cukup uang untuk memberikan uang jajan (\$20).',
            Icons.money_off,
            Colors.red,
            () {},
          );
        } else {
          int relBonus = random.nextInt(6) + 8;
          showDialog(
            'Beri Uang Jajan',
            'Kamu memberikan uang jajan sebesar \$20 kepada $targetName. Dia sangat berterima kasih! (+$relBonus% hubungan)',
            Icons.monetization_on,
            Colors.green,
            () {
              character.money -= 20;
              updateRelationship(relBonus);
              updateState();
            },
          );
        }
      },
    ));

    actions.add(ActionItem(
      label: 'Beri Hadiah Spesial',
      icon: Icons.card_giftcard,
      color: Colors.purple,
      onTap: () {
        if (character.money < 100) {
          showDialog(
            'Uang Tidak Cukup',
            'Kamu tidak memiliki cukup uang untuk membelikan hadiah (\$100).',
            Icons.money_off,
            Colors.red,
            () {},
          );
        } else {
          int relBonus = random.nextInt(11) + 12;
          showDialog(
            'Beri Hadiah',
            'Kamu membelikan hadiah spesial seharga \$100 untuk $targetName. Anakmu sangat senang! (+$relBonus% hubungan)',
            Icons.card_giftcard,
            Colors.purple,
            () {
              character.money -= 100;
              updateRelationship(relBonus);
              updateState();
            },
          );
        }
      },
    ));

    actions.add(ActionItem(
      label: 'Ajak Liburan Bersama',
      icon: Icons.flight,
      color: Colors.blue,
      onTap: () {
        if (character.money < 250) {
          showDialog(
            'Uang Tidak Cukup',
            'Kamu tidak memiliki cukup uang untuk mengajak liburan (\$250).',
            Icons.money_off,
            Colors.red,
            () {},
          );
        } else {
          int relBonus = random.nextInt(16) + 15;
          showDialog(
            'Liburan Bersama',
            'Kamu mengajak $targetName pergi berlibur bersama akhir pekan ini. Momen ini mempererat keakraban kalian! (+$relBonus% hubungan)',
            Icons.flight,
            Colors.blue,
            () {
              character.money -= 250;
              character.happiness = (character.happiness + 20).clamp(0, 100);
              updateRelationship(relBonus);
              updateState();
            },
          );
        }
      },
    ));

    actions.add(ActionItem(
      label: 'Puji Anak',
      icon: Icons.thumb_up,
      color: Colors.blueAccent,
      onTap: () {
        int relBonus = random.nextInt(5) + 8;
        showDialog(
          'Pujian Orang Tua',
          'Kamu memuji pencapaian dan kedewasaan $targetName. (+$relBonus% hubungan)',
          Icons.thumb_up,
          Colors.blueAccent,
          () {
            updateRelationship(relBonus);
            updateState();
          },
        );
      },
    ));

    return actions;
  }

  // 1. Bercinta / Make Love
  actions.add(ActionItem(
    label: 'Bercinta / Make Love',
    icon: Icons.favorite,
    color: Colors.pink,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BercintaScreen(
            character: character,
            targetName: targetName,
            targetRole: targetRole,
            onActionComplete: () {
              updateState();
            },
          ),
        ),
      );
    },
  ));

  // 2. Ajak Pacaran
  if (!isAlreadyPartner && !isPartnerRole) {
    actions.add(ActionItem(
      label: 'Ajak Pacaran',
      icon: Icons.favorite_border,
      color: Colors.redAccent,
      onTap: () {
        int currentRel = _getCurrentRelationshipValue();
        bool accepted = false;
        String targetNameLower = targetName.toLowerCase();

        // Cek apakah target adalah saudara (Kakak/Adik)
        bool isSibling = targetRole.contains('Saudara') || 
                         targetNameLower.contains('kakak') || 
                         targetNameLower.contains('adik');

        // --- LOGIKA BARU: AYAH & IBU ---
        if (targetNameLower.startsWith('ayah')) {
          // Jika target adalah Ayah (atau Ayah Tiri)
          if (myGender == 'perempuan') {
            accepted = random.nextInt(100) < 30; // Anak perempuan ajak ayah: 30%
          } else {
            accepted = random.nextInt(100) < 10; // Anak laki-laki ajak ayah: 10%
          }
        } else if (targetNameLower.startsWith('ibu')) {
          // Jika target adalah Ibu
          if (myGender == 'perempuan') {
            accepted = random.nextInt(100) < 5; // Anak perempuan ajak ibu: 5%
          } else {
            accepted = random.nextInt(100) < 10; // Anak laki-laki ajak ibu: 10%
          }
        } 
        // --- LOGIKA SAUDARA ---
        else if (isSibling) {
          bool isTargetOlder = targetNameLower.contains('kakak');
          bool isTargetMale = partnerGender == 'laki-laki';

          if (myGender == 'perempuan' && isTargetOlder && !isTargetMale) {
            accepted = random.nextInt(100) < 30;
          } else if (myGender == 'perempuan' && isTargetOlder && isTargetMale) {
            accepted = random.nextInt(100) < 50;
          } else if (myGender == 'perempuan' && !isTargetOlder && !isTargetMale) {
            accepted = random.nextInt(100) < 30;
          } else if (myGender == 'perempuan' && !isTargetOlder && isTargetMale) {
            accepted = random.nextInt(100) < 40;
          } else if (myGender == 'laki-laki' && isTargetOlder && !isTargetMale) {
            accepted = random.nextInt(100) < 30;
          } else if (myGender == 'laki-laki' && isTargetOlder && isTargetMale) {
            accepted = random.nextInt(100) < 20;
          } else if (myGender == 'laki-laki' && !isTargetOlder && !isTargetMale) {
            accepted = random.nextInt(100) < 30;
          } else if (myGender == 'laki-laki' && !isTargetOlder && isTargetMale) {
            accepted = random.nextInt(100) < 20;
          } else {
            accepted = random.nextInt(100) < 20;
          }
        } 
        // --- BUKAN SAUDARA DAN BUKAN ORANG TUA ---
        else {
          accepted = currentRel >= 50 ? (random.nextInt(100) < 75) : (random.nextInt(100) < 25);
        }

        if (accepted) {
          showDialog(
            'Cinta Diterima! 💖',
            '$targetName menerima ajakanmu untuk berpacaran! Sekarang kalian resmi berpacaran.',
            Icons.favorite, Colors.pink, () {
              character.partner = {
                'name': targetName,
                'gender': partnerGender,
                'age': '0',
                'relationship': currentRel.toString(),
                'relation': 'Pacar',
              };
              character.happiness = (character.happiness + 25).clamp(0, 100);
              updateState();
            }
          );
        } else {
          int relPenalty = random.nextInt(6) + 10;
          showDialog(
            'Ajakan Ditolak 💔',
            '$targetName menolak ajakanmu untuk berpacaran. Hubungan kalian menjadi canggung (-$relPenalty%).',
            Icons.heart_broken, Colors.red, () {
              character.happiness = (character.happiness - 15).clamp(0, 100);
              updateRelationship(-relPenalty);
              updateState();
            }
          );
        }
      },
    ));
  }

  // 3. Lamar
  if (isPartnerRole && targetRole == 'Pacar' && age >= 18) {
    actions.add(ActionItem(
      label: 'Lamar',
      icon: Icons.diamond,
      color: Colors.amber,
      onTap: () {
        int currentRel = _getCurrentRelationshipValue();
        bool accepted = currentRel >= 60 ? (random.nextInt(100) < 80) : (random.nextInt(100) < 30);

        if (accepted) {
          showDialog(
            'Lamaran Diterima! 💍',
            '$targetName menerima lamaran pernikahanmu dengan air mata bahagia! Status hubungan kalian kini adalah Tunangan.',
            Icons.diamond, Colors.pink, () {
              if (character.partner != null) {
                character.partner!['relation'] = 'Tunangan';
              }
              character.happiness = (character.happiness + 30).clamp(0, 100);
              updateState();
            }
          );
        } else {
          int relPenalty = random.nextInt(6) + 15;
          showDialog(
            'Lamaran Ditolak 💔',
            '$targetName menolak lamaranmu karena merasa hubungan kalian belum cukup matang (-$relPenalty%).',
            Icons.heart_broken, Colors.red, () {
              character.happiness = (character.happiness - 20).clamp(0, 100);
              updateRelationship(-relPenalty);
              updateState();
            }
          );
        }
      },
    ));
  }

  // 4. Rencanakan Pernikahan
  if (isPartnerRole && targetRole == 'Tunangan' && age >= 18) {
    actions.add(ActionItem(
      label: 'Rencanakan Pernikahan',
      icon: Icons.wc,
      color: Colors.indigo,
      onTap: () {
        if (character.money < 100) {
          showDialog(
            'Uang Tidak Cukup 💸',
            'Biaya pendaftaran dan persiapan pernikahan minimal adalah \$100. Kumpulkan uang terlebih dahulu!',
            Icons.money_off, Colors.red, () {
              updateState();
            }
          );
        } else {
          int currentRel = _getCurrentRelationshipValue();
          bool accepted = currentRel >= 70 ? (random.nextInt(100) < 90) : (random.nextInt(100) < 50);

          if (accepted) {
            String spouseRelation = partnerGender == 'Laki-laki' ? 'Suami' : 'Istri';
            showDialog(
              'Pernikahan Sukses! 🎉💒',
              'Selamat! Pernikahan kalian berjalan sangat lancar dan meriah. Sekarang kalian resmi menjadi sepasang Suami-Istri!',
              Icons.wc, Colors.green, () {
                character.money -= 100;
                if (character.partner != null) {
                  character.partner!['relation'] = spouseRelation;
                }
                character.happiness = (character.happiness + 40).clamp(0, 100);
                updateState();
              }
            );
          } else {
            int relPenalty = random.nextInt(6) + 5;
            showDialog(
              'Pernikahan Ditunda',
              'Rencana pernikahan ditunda karena terjadi perselisihan pendapat saat merencanakan detail pesta (-$relPenalty%).',
              Icons.error_outline, Colors.orange, () {
                updateRelationship(-relPenalty);
                updateState();
              }
            );
          }
        }
      },
    ));
  }

  // 5. Minta Uang
  actions.add(ActionItem(
    label: 'Minta Uang',
    icon: Icons.monetization_on,
    color: Colors.amber,
    onTap: () {
      if (random.nextBool()) {
        int gotMoney = random.nextInt(20) + 20;
        int relBonus = random.nextInt(6) + 5;
        showDialog(
          'Minta Uang Sukses!',
          '$relation memberimu uang tunai sebesar \$$gotMoney! Uang dimasukkan ke saldo tunai (+$relBonus% hubungan).',
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
          'Minta Uang Gagal',
          '$relation menggelengkan kepala. Hubunganmu merenggang (-$relPenalty%).',
          Icons.money_off, Colors.red, () {
            character.happiness = (character.happiness - 5).clamp(0, 100);
            updateRelationship(-relPenalty);
            updateState();
          }
        );
      }
    },
  ));

  return actions;
}