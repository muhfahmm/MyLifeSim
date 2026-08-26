// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_12_plus.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/bercinta.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_lamar.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_pacar.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/threesome.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/interograsi/interograsi_pacar.dart';
import 'age_base.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_resolver.dart';

/// Fungsi helper untuk menentukan gender target berdasarkan nama target.
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

/// Menghasilkan daftar ActionItem untuk karakter berusia 12 tahun ke atas.
List<ActionItem> getAge12PlusActions(
  BuildContext context,
  Character character,
  String targetName,
  String targetRole,
  int age,
  Random random,
  Function(String title, String message, IconData icon, Color color, VoidCallback onConfirm) showDialogCallback,
  Function(int change) updateRelationship,
  VoidCallback updateState,
) {
  final String relation = targetName.split(' ')[0];
  final String myGender = character.gender.trim().toLowerCase();
  final String partnerGender = _getPartnerGender(targetName).toLowerCase();
  final bool isPartnerRole = targetRole == 'Pacar' || targetRole == 'Tunangan' || targetRole == 'Suami' || targetRole == 'Istri';
  final bool isAlreadyPartner = character.partner != null && character.partner!['name'] == targetName;
  final bool isAlreadySecondPartner = character.secondPartner != null && character.secondPartner!['name'] == targetName;
  bool isActivePartner = character.isAnyPartnerNameMatching(targetName);
  if (!isActivePartner) {
    if (character.partner != null &&
        (character.partner!['name'] == targetName ||
            targetName.contains(character.partner!['name'] ?? '___'))) {
      isActivePartner = true;
    }
    if (character.secondPartner != null &&
        (character.secondPartner!['name'] == targetName ||
            targetName.contains(character.secondPartner!['name'] ?? '___'))) {
      isActivePartner = true;
    }
  }
  final bool hasExistingPartner = character.partner != null;
  final bool isChild = targetRole == 'Laki-laki' || targetRole == 'Perempuan';

  // Helper untuk mendapatkan nilai hubungan saat ini
  int _getCurrentRelationshipValue() {
    return int.tryParse(character.partner?['relationship'] ?? '50') ?? 50;
  }

  // --- Helper untuk meminta barang (sama seperti di age_6_11) ---
  void _requestItem(String itemName, int successRate, int happinessGain, int relationshipGain) {
    final bool isDatingFather = character.gender.toLowerCase() == 'perempuan' &&
        character.fatherName != null &&
        targetName.toLowerCase().contains(character.fatherName!.toLowerCase()) &&
        character.isAnyPartnerNameMatching(targetName);

    final int actualRate = isDatingFather ? 90 : successRate;

    if (random.nextInt(100) < actualRate) {
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

  List<ActionItem> actions = [];

  // Jika target adalah anak (dengan status Laki-laki atau Perempuan)
  if (isChild) {
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
        showDialogCallback(
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
          showDialogCallback(
            'Uang Tidak Cukup',
            'Kamu tidak memiliki cukup uang untuk memberikan uang jajan (\$20).',
            Icons.money_off,
            Colors.red,
            () {},
          );
        } else {
          int relBonus = random.nextInt(6) + 8;
          showDialogCallback(
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
          showDialogCallback(
            'Uang Tidak Cukup',
            'Kamu tidak memiliki cukup uang untuk membelikan hadiah (\$100).',
            Icons.money_off,
            Colors.red,
            () {},
          );
        } else {
          int relBonus = random.nextInt(11) + 12;
          showDialogCallback(
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
          showDialogCallback(
            'Uang Tidak Cukup',
            'Kamu tidak memiliki cukup uang untuk mengajak liburan (\$250).',
            Icons.money_off,
            Colors.red,
            () {},
          );
        } else {
          int relBonus = random.nextInt(16) + 15;
          showDialogCallback(
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
        showDialogCallback(
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

    return actions; // Kembali lebih awal karena target adalah anak.
  }

  // Menu untuk target umum (bukan anak)
  // 1. Bercinta / Make Love (logika kondom sudah ada di dalam BercintaScreen)
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

  // --- AJAK 3SOME (jika memiliki dua pasangan) ---
  final bool targetIsEitherPartner = (character.partner != null && character.partner!['name'] == targetName) ||
                                     (character.secondPartner != null && character.secondPartner!['name'] == targetName);
  final bool hasTwoPartners = character.partner != null && character.secondPartner != null;

  if (targetIsEitherPartner && hasTwoPartners) {
    actions.add(ActionItem(
      label: 'Ajak 3some? 🔥',
      icon: Icons.people,
      color: Colors.purple,
      onTap: () {
        ThreesomeHelper.processThreesome(
          context: context,
          character: character,
          updateState: updateState,
        );
      },
    ));
  }

  // 2. Ajak Pacaran / Ajak Balikan (dengan logika khusus mantan pacar)
  if (!isActivePartner && !isAlreadyPartner && !isAlreadySecondPartner && !isPartnerRole) {
    final bool isExPartner = character.exPartners.any((ex) => ex['name'] == targetName);
    final String actionLabel = isExPartner 
        ? 'Ajak Balikan' 
        : (hasExistingPartner ? 'Ajak Pacaran (Selingkuh?)' : 'Ajak Pacaran');

    actions.add(ActionItem(
      label: actionLabel,
      icon: hasExistingPartner ? Icons.heart_broken : Icons.favorite_border,
      color: hasExistingPartner ? Colors.deepOrange : Colors.redAccent,
      onTap: () {
        int currentRel = _getCurrentRelationshipValue();
        bool accepted = false;
        String targetNameLower = targetName.toLowerCase();

        // --- LOGIKA PERSENTASE AJAK BALIKAN (jika mantan) ---
        if (isExPartner) {
          Map<String, String>? exData;
          for (var ex in character.exPartners) {
            if (ex['name'] == targetName) {
              exData = ex;
              break;
            }
          }

          String? breakInitiator = exData?['breakInitiator'];
          String? breakReason = exData?['breakReason'];

          if (breakReason == 'selingkuh' || breakReason == 'threesome') {
            accepted = random.nextInt(100) < 10; // 10%
          } else {
            if (breakInitiator == 'Laki-laki') {
              accepted = random.nextInt(100) < 30;
            } else if (breakInitiator == 'Perempuan') {
              accepted = random.nextInt(100) < 25;
            } else {
              accepted = random.nextInt(100) < 50;
            }
          }
        } else {
          // Gunakan logika kelas penentu dari folder ajakan_pacaran
          accepted = AjakanResolver.checkPacaran(character, targetName, targetRole, random);
        }

        if (accepted) {
          // --- HAPUS DARI EX-PARTNERS JIKA BERHASIL BALIKAN ---
          if (isExPartner) {
            character.exPartners.removeWhere((ex) => ex['name'] == targetName);
          }

          int actualTargetAge = 18;
          if (targetName.startsWith('Ayah')) {
            actualTargetAge = character.fatherAge ?? 40;
          } else if (targetName.startsWith('Ibu')) {
            actualTargetAge = character.motherAge ?? 38;
          } else {
            for (var sib in character.siblings) {
              final String expectedLabel = '${sib['name']} (${sib['relation']})';
              if (expectedLabel == targetName) {
                actualTargetAge = int.tryParse(sib['age'] ?? '18') ?? 18;
                break;
              }
            }
            for (var ext in character.extendedFamily) {
              if (ext['name'] == targetName) {
                actualTargetAge = int.tryParse(ext['age'] ?? '18') ?? 18;
                break;
              }
            }
          }

          // Tentukan nilai hubungan awal yang tepat:
          // Jika target adalah orang tua, gunakan field hubungan mereka
          // agar kartu keluarga dan kartu pacar menampilkan angka yang sama.
          int initialRelForPartner = currentRel;
          final String lowerTarget = targetName.toLowerCase();
          if (lowerTarget.startsWith('ibu') && !lowerTarget.contains('tiri')) {
            initialRelForPartner = character.motherRelationship ?? 50;
          } else if (lowerTarget.startsWith('ayah') && !lowerTarget.contains('tiri')) {
            initialRelForPartner = character.fatherRelationship ?? 50;
          } else if (lowerTarget.startsWith('ibu') && lowerTarget.contains('tiri')) {
            initialRelForPartner = character.stepMotherRelationship ?? 50;
          } else if (lowerTarget.startsWith('ayah') && lowerTarget.contains('tiri')) {
            initialRelForPartner = character.stepFatherRelationship ?? 50;
          }

          final String? familySkinColor = character.getFamilyMemberSkinColor(targetName);
          final newPartnerData = {
            'name': targetName,
            'gender': partnerGender,
            'age': '$actualTargetAge',
            'relationship': initialRelForPartner.toString(),
            'relation': 'Pacar',
            if (familySkinColor != null) 'skinColor': familySkinColor,
          };

          if (hasExistingPartner) {
            bool affairSuccess = random.nextInt(100) < 50;
            if (affairSuccess) {
              showDialogCallback(
                'Selingkuh Berhasil! 💘',
                '$targetName menerima ajakanmu meskipun kamu sudah punya pacar. Kamu kini memiliki 2 pacar!',
                Icons.favorite, Colors.deepOrange, () {
                  character.secondPartner = newPartnerData;
                  character.isHavingAffair = true;
                  character.happiness = (character.happiness + 10).clamp(0, 100);
                  updateState();
                  BeritahuPacarHelper.showTellFirstPartnerDialog(
                    context: context,
                    character: character,
                    secondPartnerName: targetName,
                    onComplete: () {
                      updateState();
                    },
                  );
                }
              );
            } else {
              int relPenalty = random.nextInt(15) + 10;
              final String firstPartnerName = character.partner!['name']!;
              showDialogCallback(
                'Ketahuan! 😡',
                '$targetName menolak ajakanmu dan langsung memberitahu pacarmu!',
                Icons.heart_broken, Colors.red, () {
                  if (character.partner != null) {
                    int rel = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
                    character.partner!['relationship'] = (rel - relPenalty).clamp(0, 100).toString();
                  }
                  character.happiness = (character.happiness - 15).clamp(0, 100);
                  character.inbox.add('😡 Ketahuan: $firstPartnerName mengetahui kamu mencoba merayu $targetName sebagai selingkuhan!');
                  updateState();
                  InterograsiPacarHelper.showInterograsiDialog(
                    context: context,
                    character: character,
                    partnerName: firstPartnerName,
                    informantName: targetName,
                    onComplete: () {
                      updateState();
                    },
                  );
                }
              );
            }
          } else {
            showDialogCallback(
              'Cinta Diterima! 💖',
              '$targetName menerima ajakanmu untuk berpacaran! Sekarang kalian resmi berpacaran.',
              Icons.favorite, Colors.pink, () {
                character.partner = newPartnerData;
                character.happiness = (character.happiness + 25).clamp(0, 100);
                updateState();
              }
            );
          }
        } else {
          int relPenalty = random.nextInt(5) + 1;
          showDialogCallback(
            'Ajakan Ditolak 💔',
            '$targetName menolak ajakanmu untuk berpacaran. Hubungan kalian menjadi canggung (-$relPenalty%).',
            Icons.heart_broken, Colors.red, () {
              character.happiness = (character.happiness - 5).clamp(0, 100);
              updateRelationship(-relPenalty);
              updateState();
            }
          );
        }
      },
    ));
  }

  // 3. Lamar (hanya jika sudah pacar)
  Map<String, dynamic>? matchingPartner;
  if (character.partner != null && character.partner!['name'] == targetName) {
    matchingPartner = character.partner;
  } else if (character.secondPartner != null && character.secondPartner!['name'] == targetName) {
    matchingPartner = character.secondPartner;
  } else if (character.thirdPartner != null && character.thirdPartner!['name'] == targetName) {
    matchingPartner = character.thirdPartner;
  } else if (character.fourthPartner != null && character.fourthPartner!['name'] == targetName) {
    matchingPartner = character.fourthPartner;
  } else if (character.fifthPartner != null && character.fifthPartner!['name'] == targetName) {
    matchingPartner = character.fifthPartner;
  }

  final bool isDatingPartner = matchingPartner != null && 
      (matchingPartner['relation']?.toString().contains('Pacar') ?? false);

  if (isDatingPartner && age >= 18) {
    actions.add(ActionItem(
      label: 'Lamar',
      icon: Icons.diamond,
      color: Colors.amber,
      onTap: () {
        int currentRel = _getCurrentRelationshipValue();
        bool accepted = currentRel >= 60 ? (random.nextInt(100) < 80) : (random.nextInt(100) < 30);

        if (accepted) {
          showDialogCallback(
            'Lamaran Diterima! 💍',
            '$targetName menerima lamaran pernikahanmu dengan air mata bahagia! Status hubungan kalian kini adalah Tunangan.',
            Icons.diamond, Colors.pink, () {
              if (character.partner != null && character.partner!['name'] == targetName) {
                character.partner!['relation'] = 'Tunangan';
              } else if (character.secondPartner != null && character.secondPartner!['name'] == targetName) {
                character.secondPartner!['relation'] = 'Tunangan';
              } else if (character.thirdPartner != null && character.thirdPartner!['name'] == targetName) {
                character.thirdPartner!['relation'] = 'Tunangan';
              } else if (character.fourthPartner != null && character.fourthPartner!['name'] == targetName) {
                character.fourthPartner!['relation'] = 'Tunangan';
              } else if (character.fifthPartner != null && character.fifthPartner!['name'] == targetName) {
                character.fifthPartner!['relation'] = 'Tunangan';
              }
              character.happiness = (character.happiness + 30).clamp(0, 100);
              updateState();
              BeritahuLamaranHelper.showTellOrNotDialog(
                context: context,
                character: character,
                partnerName: targetName,
                partnerRole: targetRole,
                onComplete: () {
                  updateState();
                },
              );
            }
          );
        } else {
          int relPenalty = random.nextInt(5) + 1;
          showDialogCallback(
            'Lamaran Ditolak 💔',
            '$targetName menolak lamaranmu karena merasa hubungan kalian belum cukup matang (-$relPenalty%).',
            Icons.heart_broken, Colors.red, () {
              character.happiness = (character.happiness - 5).clamp(0, 100);
              updateRelationship(-relPenalty);
              updateState();
            }
          );
        }
      },
    ));
  }

  // 4. Rencanakan Pernikahan (hanya jika sudah tunangan)
  if (isPartnerRole && character.partner != null && character.partner!['relation'] == 'Tunangan' && age >= 18) {
    actions.add(ActionItem(
      label: 'Rencanakan Pernikahan',
      icon: Icons.wc,
      color: Colors.indigo,
      onTap: () {
        if (character.money < 100) {
          showDialogCallback(
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
            showDialogCallback(
              'Pernikahan Sukses! 🎉💒',
              'Selamat! Pernikahan kalian berjalan sangat lancar dan meriah. Sekarang kalian resmi menjadi sepasang Suami-Istri! (Sekarang kamu juga memiliki keluarga mertua baru!)',
              Icons.wc, Colors.green, () {
                character.money -= 100;
                if (character.partner != null) {
                  character.partner!['relation'] = spouseRelation;
                }
                character.happiness = (character.happiness + 40).clamp(0, 100);
                // Generate mertua (sudah ada di logika sebelumnya)
                updateState();
              }
            );
          } else {
            int relPenalty = random.nextInt(6) + 5;
            showDialogCallback(
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
      final String cleanName = targetName.toLowerCase();
      final String cleanRole = targetRole.toLowerCase();
      final bool isParent = cleanName.startsWith('ayah') ||
                            cleanName.startsWith('ibu') ||
                            cleanRole.contains('kandung') ||
                            cleanRole.contains('tiri') ||
                            cleanRole.contains('cerai') ||
                            (character.fatherName != null && cleanName.contains(character.fatherName!.toLowerCase())) ||
                            (character.motherName != null && cleanName.contains(character.motherName!.toLowerCase())) ||
                            (character.stepFatherName != null && cleanName.contains(character.stepFatherName!.toLowerCase())) ||
                            (character.stepMotherName != null && cleanName.contains(character.stepMotherName!.toLowerCase()));

      final bool isDatingFather = character.gender.toLowerCase() == 'perempuan' &&
          character.fatherName != null &&
          targetName.toLowerCase().contains(character.fatherName!.toLowerCase()) &&
          character.isAnyPartnerNameMatching(targetName);

      int gotMoney = 0;
      if (isParent) {
        if (character.age >= 6 && character.age <= 11) {
          gotMoney = random.nextInt(10) + 1; // 1-10 $
        } else if (character.age >= 12 && character.age <= 14) {
          gotMoney = random.nextInt(31) + 20; // 20-50 $
        } else if (character.age >= 15 && character.age <= 18) {
          gotMoney = random.nextInt(101) + 100; // 100-200 $
        } else {
          gotMoney = random.nextInt(20) + 20; // fallback
        }
      } else {
        // Cek jika target adalah kakak (saudara kandung/tiri/dll) yang sudah dewasa/kerja (>18)
        bool isKakakAdult = false;
        int targetAgeVal = 0;
        for (var sib in character.siblings) {
          final String expectedLabel = '${sib['name']} (${sib['relation']})';
          if (expectedLabel == targetName || sib['name'] == targetName) {
            targetAgeVal = int.tryParse(sib['age'] ?? '0') ?? 0;
            if (targetAgeVal > 18 && (sib['relation'] ?? '').toLowerCase().contains('kakak')) {
              isKakakAdult = true;
            }
            break;
          }
        }
        
        if (isKakakAdult) {
          int kakakWealth = character.getTargetWealth(targetName, targetRole);
          gotMoney = (kakakWealth * 0.05).clamp(10, 100).toInt() + random.nextInt(21);
        } else {
          gotMoney = random.nextInt(20) + 20; // fallback umum
        }
      }

      if (isDatingFather) {
        gotMoney = (gotMoney * 1.5).round(); // uang naik 50%
      }

      final bool accepted = isDatingFather ? (random.nextInt(100) < 90) : random.nextBool();

      if (accepted) {
        int relBonus = random.nextInt(6) + 5;
        showDialogCallback(
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
        int relPenalty = random.nextInt(5) + 1;
        showDialogCallback(
          'Minta Uang Gagal',
          '$relation menggelengkan kepala. Hubunganmu merenggang (-$relPenalty%).',
          Icons.money_off, Colors.red, () {
            character.happiness = (character.happiness - 2).clamp(0, 100);
            updateRelationship(-relPenalty);
            updateState();
          }
        );
      }
    },
  ));

  // 6. Pujian
  actions.add(ActionItem(
    label: 'Pujian',
    icon: Icons.thumb_up,
    color: Colors.blueAccent,
    onTap: () {
      int relBonus = random.nextInt(5) + 8;
      showDialogCallback(
        'Berikan Pujian',
        'Kamu memberikan pujian yang tulus kepada $relation. Dia terlihat sangat senang! (+$relBonus% hubungan)',
        Icons.thumb_up, Colors.blueAccent, () {
          updateRelationship(relBonus);
          updateState();
        }
      );
    },
  ));

  // 7. Percakapan
  actions.add(ActionItem(
    label: 'Percakapan',
    icon: Icons.chat,
    color: Colors.teal,
    onTap: () {
      int relBonus = random.nextInt(4) + 2;
      showDialogCallback(
        'Bercakap-cakap',
        'Kamu mengobrol santai dengan $relation tentang hobi dan kesehariannya. (+$relBonus% hubungan)',
        Icons.chat, Colors.teal, () {
          character.happiness = (character.happiness + 5).clamp(0, 100);
          updateRelationship(relBonus);
          updateState();
        }
      );
    },
  ));

  // 8. Menyinggung
  actions.add(ActionItem(
    label: 'Menyinggung',
    icon: Icons.sentiment_very_dissatisfied,
    color: Colors.red,
    onTap: () {
      int relPenalty = random.nextInt(11) + 5;
      showDialogCallback(
        'Menyinggung Perasaan',
        'Kamu melontarkan lelucon kasar yang menyinggung perasaan $relation. Hubungan menjadi canggung (-$relPenalty% hubungan).',
        Icons.sentiment_very_dissatisfied, Colors.red, () {
          character.happiness = (character.happiness - 15).clamp(0, 100);
          updateRelationship(-relPenalty);
          updateState();
        }
      );
    },
  ));

  // 9. Pergi ke Bioskop Bersama
  actions.add(ActionItem(
    label: 'Pergi ke Bioskop Bersama',
    icon: Icons.movie,
    color: Colors.deepPurple,
    onTap: () {
      final bool isDatingFather = character.gender.toLowerCase() == 'perempuan' &&
          character.fatherName != null &&
          targetName.toLowerCase().contains(character.fatherName!.toLowerCase()) &&
          character.isAnyPartnerNameMatching(targetName);

      final double rate = isDatingFather ? 0.80 : 0.75;
      if (random.nextDouble() < rate) {
        int relBonus = random.nextInt(6) + 10;
        showDialogCallback(
          'Menonton Bioskop',
          'Kamu mengajak $relation pergi menonton film di bioskop terdekat. (+$relBonus% hubungan)',
          Icons.movie, Colors.deepPurple, () {
            character.happiness = (character.happiness + 15).clamp(0, 100);
            updateRelationship(relBonus);
            updateState();
          }
        );
      } else {
        int relPenalty = random.nextInt(6) + 5;
        showDialogCallback(
          'Ajakan Ditolak',
          '$relation menolak ajakan menonton bioskop kali ini (-$relPenalty% hubungan).',
          Icons.block, Colors.red, () {
            updateRelationship(-relPenalty);
            updateState();
          }
        );
      }
    },
  ));

  // 10. Habiskan Waktu Bersama
  actions.add(ActionItem(
    label: 'Habiskan Waktu Bersama',
    icon: Icons.people,
    color: Colors.indigo,
    onTap: () {
      final bool isDatingFather = character.gender.toLowerCase() == 'perempuan' &&
          character.fatherName != null &&
          targetName.toLowerCase().contains(character.fatherName!.toLowerCase()) &&
          character.isAnyPartnerNameMatching(targetName);

      final double rate = isDatingFather ? 0.80 : 0.80; // set 80%
      if (random.nextDouble() < rate) {
        int relBonus = random.nextInt(5) + 8;
        showDialogCallback(
          'Habiskan Waktu',
          'Kamu menghabiskan sore yang santai bersama $relation untuk mengobrol dan berjalan-jalan. (+$relBonus% hubungan)',
          Icons.people, Colors.indigo, () {
            character.happiness = (character.happiness + 10).clamp(0, 100);
            updateRelationship(relBonus);
            updateState();
          }
        );
      } else {
        int relPenalty = random.nextInt(6) + 5;
        showDialogCallback(
          'Ajakan Ditolak',
          '$relation menolak diajak menghabiskan waktu bersama (-$relPenalty% hubungan).',
          Icons.block, Colors.red, () {
            updateRelationship(-relPenalty);
            updateState();
          }
        );
      }
    },
  ));

  // ★ MENU BARU: Minta Barang
  actions.add(ActionItem(
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
  ));

  return actions;
}