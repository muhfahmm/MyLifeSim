// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_12_plus.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/store_page/fitur_premium/adult_features/adult_features.dart';
import 'package:mylifesim/game/widgets/assets_menu/aset_premium/garasi_mobil/database_mobil.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/bercinta.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_masturbate/masturbate.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_lamar.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_pacar.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/threesome.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/interograsi/interograsi_pacar.dart';
import 'age_base.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_resolver.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/ajakan_masturbasi_dialog.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/persentase_ajakan.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/percakapan_dispatcher.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_progress_modal.dart';

// ──────────────────────────────────────────────
// HELPER: Tampilkan pilihan sebelum VN dialogue
// ──────────────────────────────────────────────

void _showPickerBottomSheet({
  required BuildContext context,
  required String title,
  required IconData titleIcon,
  required Color titleColor,
  required List<Map<String, dynamic>> options, // {label, icon, color, value}
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
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(titleIcon, color: titleColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
                  return InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      onPicked(opt['value'] as String);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? titleColor.withValues(alpha: 0.15) : cardBgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: isDark ? titleColor.withValues(alpha: 0.4) : titleColor.withValues(alpha: 0.6)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Icon(opt['icon'] as IconData? ?? Icons.circle, color: titleColor, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              opt['label'] as String,
                              style: TextStyle(
                                color: isDark
                                    ? titleColor
                                    : (titleColor == Colors.amber
                                        ? Colors.amber.shade900
                                        : titleColor),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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

String _getNPCGender(Character character, String name, String role) {
  final String nameLower = name.toLowerCase().trim();
  final String roleLower = role.toLowerCase().trim();

  if (character.partner != null && character.partner!['name']?.toLowerCase().trim() == nameLower) {
    return character.partner!['gender'] ?? 'Laki-laki';
  }
  if (character.secondPartner != null && character.secondPartner!['name']?.toLowerCase().trim() == nameLower) {
    return character.secondPartner!['gender'] ?? 'Laki-laki';
  }

  if (character.fatherName?.toLowerCase().trim() == nameLower) return 'Laki-laki';
  if (character.stepFatherName?.toLowerCase().trim() == nameLower) return 'Laki-laki';
  if (character.motherName?.toLowerCase().trim() == nameLower) return 'Perempuan';
  if (character.stepMotherName?.toLowerCase().trim() == nameLower) return 'Perempuan';

  if (roleLower.contains('ayah') || roleLower.contains('paman') || roleLower.contains('kakek') || roleLower.contains('suami')) {
    return 'Laki-laki';
  }
  if (roleLower.contains('ibu') || roleLower.contains('bibi') || roleLower.contains('nenek') || roleLower.contains('istri')) {
    return 'Perempuan';
  }

  for (var list in [
    character.siblings,
    character.extendedFamily,
    character.classmates,
    character.univClassmates,
    character.coworkers,
    character.sdTeachers,
    character.smpTeachers,
    character.smaTeachers,
    character.univLecturers,
    character.children,
  ]) {
    for (var npc in list) {
      if (npc['name']?.toLowerCase().trim() == nameLower) {
        return npc['gender'] ?? 'Laki-laki';
      }
    }
  }

  if (roleLower.contains('perempuan') || roleLower.contains('binti') || roleLower.contains('bibi') || roleLower.contains('nenek')) {
    return 'Perempuan';
  }
  if (roleLower.contains('laki') || roleLower.contains('bin') || roleLower.contains('paman') || roleLower.contains('kakek')) {
    return 'Laki-laki';
  }

  return _getPartnerGender(name);
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
  VoidCallback updateState, {
  String? targetAvatarUrl,
  String? playerAvatarUrl,
  int? targetAge,
  String? targetGender,
}) {
  final String relation = targetName.split(' ')[0];
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

  List<ActionItem> actions = [];

  // Jika target adalah anak (dengan status Laki-laki atau Perempuan)
  if (isChild) {

    // 4. Beri Uang Jajan
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
              final int childW = character.getTargetWealth(targetName, targetRole);
              character.setTargetWealth(targetName, targetRole, childW + 20);
              updateRelationship(relBonus);
              updateState();
            },
          );
        }
      },
    ));

    // 5. Beri Hadiah Spesial
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
              final int childW = character.getTargetWealth(targetName, targetRole);
              character.setTargetWealth(targetName, targetRole, childW + 100);
              updateRelationship(relBonus);
              updateState();
            },
          );
        }
      },
    ));

    // 6. Ajak Liburan Bersama
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

    // 7. Pergi ke Bioskop Bersama
    actions.add(ActionItem(
      label: 'Pergi ke Bioskop Bersama',
      icon: Icons.movie,
      color: Colors.deepPurple,
      onTap: () {
        if (character.money < 30) {
          showDialogCallback(
            'Uang Tidak Cukup',
            'Kamu tidak memiliki cukup uang untuk pergi ke bioskop (\$30).',
            Icons.money_off,
            Colors.red,
            () {},
          );
        } else {
          int relBonus = random.nextInt(10) + 10;
          showDialogCallback(
            'Nonton Bioskop Bersama',
            'Kamu mengajak $targetName pergi menonton film seru di bioskop bersama. Kalian bersenang-senang menikmati popcorn dan film! (+$relBonus% hubungan)',
            Icons.movie,
            Colors.deepPurple,
            () {
              character.money -= 30;
              character.happiness = (character.happiness + 15).clamp(0, 100);
              updateRelationship(relBonus);
              updateState();
            },
          );
        }
      },
    ));

    // 8. Habiskan Waktu Bersama
    actions.add(ActionItem(
      label: 'Habiskan Waktu Bersama',
      icon: Icons.sunny,
      color: Colors.orange,
      onTap: () {
        int relBonus = random.nextInt(8) + 6;
        showDialogCallback(
          'Habiskan Waktu Bersama',
          'Kamu menghabiskan waktu luang berkualitas bersama $targetName dengan santai. (+$relBonus% hubungan)',
          Icons.sunny,
          Colors.orange,
          () {
            updateRelationship(relBonus);
            updateState();
          },
        );
      },
    ));

    // 9. Puji Anak
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
  if (AdultFeatures.canMakeLove(userAge: character.age, role: targetRole, relation: targetRole)) {
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
  }

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
  if (!isActivePartner && !isAlreadyPartner && !isAlreadySecondPartner && !isPartnerRole && AdultFeatures.canProposeDating(targetRole, targetName, userAge: character.age)) {
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
    label: 'Minta Uang Saku',
    icon: Icons.monetization_on,
    color: Colors.amber,
    onTap: () {
      PercakapanDispatcher.dispatchAction(
        context: context,
        character: character,
        targetName: targetName,
        targetRole: targetRole,
        targetAge: targetAge != null ? '$targetAge' : '$age',
        relationshipValue: _getCurrentRelationshipValue(),
        actionType: 'Minta Uang Saku',
        onActionComplete: updateState,
        targetAvatarUrl: targetAvatarUrl,
        playerAvatarUrl: playerAvatarUrl,
        targetGender: targetGender,
      );
    },
  ));

  // Minta Kendaraan
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

  if (isParent) {
    actions.add(ActionItem(
      label: 'Minta Kendaraan',
      icon: Icons.directions_car,
      color: Colors.redAccent,
      onTap: () {
        // 1. Cek apakah user punya setidaknya 1 lisensi
        if (character.ownedLicenses.isEmpty) {
          showDialogCallback(
            'Urus Lisensi Dulu',
            'Kamu belum memiliki lisensi mengemudi apapun! Urus lisensi mengemudi (SIM A/B/C) terlebih dahulu di menu Aktivitas.',
            Icons.lock_outline, Colors.grey, () {}
          );
          return;
        }

        // 2. Cek uang orang tua
        final int parentWealth = character.getTargetWealth(targetName, targetRole);
        
        List<Map<String, dynamic>> affordableCars = [];
        for (var car in mobilTersediaList) {
          final int price = (car['harga'] as num).toInt();
          if (price <= parentWealth) {
            final String typeLower = car['tipe'].toString().toLowerCase();
            bool licenseMatch = false;
            for (var license in character.ownedLicenses) {
              if (license.contains('SIM C') && (typeLower.contains('motor') || typeLower.contains('dua roda') || typeLower.contains('sport'))) {
                licenseMatch = true;
              } else if (license.contains('SIM B') && (typeLower.contains('truk') || typeLower.contains('heavy') || typeLower.contains('pickup'))) {
                licenseMatch = true;
              } else if (license.contains('SIM A') && !typeLower.contains('truk') && !typeLower.contains('motor')) {
                licenseMatch = true;
              }
            }
            if (licenseMatch) {
              affordableCars.add(car);
            }
          }
        }

        if (affordableCars.isEmpty) {
          showDialogCallback(
            'Permintaan Ditolak',
            'Uang $relation tidak cukup untuk membeli kendaraan saat ini! (Saldo Kekayaan mereka: \$${parentWealth.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")})',
            Icons.block, Colors.red, () {
              character.happiness = (character.happiness - 5).clamp(0, 100);
              updateRelationship(-random.nextInt(6) - 5);
              updateState();
            }
          );
          return;
        }

        // Pilih kendaraan acak
        final chosenCar = affordableCars[random.nextInt(affordableCars.length)];
        final int carPrice = (chosenCar['harga'] as num).toInt();

        // Tentukan kelulusan berdasarkan relasi
        final int relVal = character.fatherName != null && cleanName.contains(character.fatherName!.toLowerCase())
            ? (character.fatherRelationship ?? 50)
            : (character.motherName != null && cleanName.contains(character.motherName!.toLowerCase())
                ? (character.motherRelationship ?? 50)
                : 50);

        final bool accepted = random.nextInt(100) < (relVal * 0.8 + 10).toInt();

        if (accepted) {
          showDialogCallback(
            'Minta Kendaraan Sukses! 🚗',
            'Hebat! $relation mengabulkan permintaanmu dan membelikanmu kendaraan ${chosenCar['nama']} seharga \$${chosenCar['harga'].toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}!',
            Icons.check_circle, Colors.green, () {
              character.addCarToGarage(chosenCar, character.age);
              character.setTargetWealth(targetName, targetRole, parentWealth - carPrice);
              character.happiness = (character.happiness + 20).clamp(0, 100);
              character.inbox.add('🚗 Minta Kendaraan Sukses: Dibelikan ${chosenCar['nama']} oleh $relation (Kekayaan mereka berkurang). (+20% Kebahagiaan)');
              updateRelationship(random.nextInt(6) + 10);
              updateState();
            }
          );
        } else {
          showDialogCallback(
            'Permintaan Ditolak',
            '$relation menolak membelikan kendaraan untukmu. Mereka bilang kamu harus menabung sendiri.',
            Icons.block, Colors.red, () {
              character.happiness = (character.happiness - 10).clamp(0, 100);
              updateRelationship(-random.nextInt(6) - 5);
              updateState();
            }
          );
        }
      },
    ));
  }

  // 6. Pujian
  actions.add(ActionItem(
    label: 'Pujian',
    icon: Icons.thumb_up,
    color: Colors.blueAccent,
    onTap: () {
      _showPickerBottomSheet(
        context: context,
        title: 'Pilih Topik Pujian',
        titleIcon: Icons.thumb_up,
        titleColor: Colors.blueAccent,
        options: [
          {'label': 'Penampilan', 'icon': Icons.face_retouching_natural, 'color': Colors.pink, 'value': 'Penampilan'},
          {'label': 'Kepribadian', 'icon': Icons.psychology, 'color': Colors.purple, 'value': 'Kepribadian'},
          {'label': 'Prestasi', 'icon': Icons.emoji_events, 'color': Colors.amber, 'value': 'Prestasi'},
          {'label': 'Kerja Keras', 'icon': Icons.fitness_center, 'color': Colors.orange, 'value': 'Kerja Keras'},
          {'label': 'Kecerdasan', 'icon': Icons.lightbulb, 'color': Colors.yellow, 'value': 'Kecerdasan'},
          {'label': 'Humor', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.green, 'value': 'Humor'},
          {'label': 'Kebaikan', 'icon': Icons.favorite, 'color': Colors.red, 'value': 'Kebaikan'},
          {'label': 'Gaya Hidup', 'icon': Icons.stars, 'color': Colors.cyan, 'value': 'Gaya Hidup'},
        ],
        onPicked: (topik) {
          PercakapanDispatcher.dispatchAction(
            context: context,
            character: character,
            targetName: targetName,
            targetRole: targetRole,
            targetAge: targetAge != null ? '$targetAge' : '$age',
            relationshipValue: _getCurrentRelationshipValue(),
            actionType: 'Pujian - $topik',
            onActionComplete: updateState,
            targetAvatarUrl: targetAvatarUrl,
            playerAvatarUrl: playerAvatarUrl,
            targetGender: targetGender,
          );
        },
      );
    },
  ));

  // 8. Menyinggung
  actions.add(ActionItem(
    label: 'Menyinggung',
    icon: Icons.sentiment_very_dissatisfied,
    color: Colors.red,
    onTap: () {
      _showPickerBottomSheet(
        context: context,
        title: 'Pilih Cara Menyinggung',
        titleIcon: Icons.sentiment_very_dissatisfied,
        titleColor: Colors.red,
        options: [
          {'label': 'Penampilan', 'icon': Icons.face, 'color': Colors.pink, 'value': 'Penampilan'},
          {'label': 'Kepribadian', 'icon': Icons.psychology, 'color': Colors.purple, 'value': 'Kepribadian'},
          {'label': 'Pekerjaan', 'icon': Icons.work_off, 'color': Colors.orange, 'value': 'Pekerjaan'},
          {'label': 'Kecerdasan', 'icon': Icons.lightbulb_outline, 'color': Colors.amber, 'value': 'Kecerdasan'},
          {'label': 'Kebiasaan', 'icon': Icons.loop, 'color': Colors.brown, 'value': 'Kebiasaan'},
          {'label': 'Keluarga', 'icon': Icons.family_restroom, 'color': Colors.indigo, 'value': 'Keluarga'},
          {'label': 'Masa Lalu', 'icon': Icons.history, 'color': Colors.grey, 'value': 'Masa Lalu'},
          {'label': 'Fisik', 'icon': Icons.fitness_center, 'color': Colors.red, 'value': 'Fisik'},
        ],
        onPicked: (topik) {
          PercakapanDispatcher.dispatchAction(
            context: context,
            character: character,
            targetName: targetName,
            targetRole: targetRole,
            targetAge: targetAge != null ? '$targetAge' : '$age',
            relationshipValue: _getCurrentRelationshipValue(),
            actionType: 'Menyinggung - $topik',
            onActionComplete: updateState,
            targetAvatarUrl: targetAvatarUrl,
            playerAvatarUrl: playerAvatarUrl,
            targetGender: targetGender,
          );
        },
      );
    },
  ));

  // 9. Pergi ke Bioskop Bersama
  actions.add(ActionItem(
    label: 'Pergi ke Bioskop Bersama',
    icon: Icons.movie,
    color: Colors.deepPurple,
    onTap: () {
      PercakapanDispatcher.dispatchAction(
        context: context,
        character: character,
        targetName: targetName,
        targetRole: targetRole,
        targetAge: targetAge != null ? '$targetAge' : '$age',
        relationshipValue: _getCurrentRelationshipValue(),
        actionType: 'Pergi ke Bioskop Bersama',
        onActionComplete: updateState,
        targetAvatarUrl: targetAvatarUrl,
        playerAvatarUrl: playerAvatarUrl,
        targetGender: targetGender,
      );
    },
  ));

  // 10. Habiskan Waktu Bersama
  actions.add(ActionItem(
    label: 'Habiskan Waktu Bersama',
    icon: Icons.people,
    color: Colors.indigo,
    onTap: () {
      _showPickerBottomSheet(
        context: context,
        title: 'Pilih Aktivitas',
        titleIcon: Icons.people,
        titleColor: Colors.indigo,
        options: [
          {'label': 'Masak Bersama', 'icon': Icons.lunch_dining, 'color': Colors.orange, 'value': 'Masak Bersama'},
          {'label': 'Main Game', 'icon': Icons.videogame_asset, 'color': Colors.blue, 'value': 'Main Game'},
          {'label': 'Jalan-Jalan', 'icon': Icons.directions_walk, 'color': Colors.green, 'value': 'Jalan-Jalan'},
          {'label': 'Nonton TV', 'icon': Icons.tv, 'color': Colors.purple, 'value': 'Nonton TV'},
          {'label': 'Olahraga', 'icon': Icons.sports_soccer, 'color': Colors.red, 'value': 'Olahraga'},
          {'label': 'Berkebun', 'icon': Icons.local_florist, 'color': Colors.teal, 'value': 'Berkebun'},
          {'label': 'Baca Buku', 'icon': Icons.menu_book, 'color': Colors.amber, 'value': 'Baca Buku'},
          {'label': 'Santai', 'icon': Icons.spa, 'color': Colors.cyan, 'value': 'Santai'},
        ],
        onPicked: (aktivitas) {
          PercakapanDispatcher.dispatchAction(
            context: context,
            character: character,
            targetName: targetName,
            targetRole: targetRole,
            targetAge: targetAge != null ? '$targetAge' : '$age',
            relationshipValue: _getCurrentRelationshipValue(),
            actionType: 'Habiskan Waktu Bersama - $aktivitas',
            onActionComplete: updateState,
            targetAvatarUrl: targetAvatarUrl,
            playerAvatarUrl: playerAvatarUrl,
            targetGender: targetGender,
          );
        },
      );
    },
  ));

  // ★ MENU BARU: Minta Barang
  actions.add(ActionItem(
    label: 'Minta Barang',
    icon: Icons.shopping_bag,
    color: Colors.purple,
    onTap: () {
      _showPickerBottomSheet(
        context: context,
        title: 'Pilih Barang yang Diminta',
        titleIcon: Icons.shopping_bag,
        titleColor: Colors.purple,
        options: [
          {'label': 'Smartphone', 'icon': Icons.smartphone, 'color': Colors.blue, 'value': 'Smartphone'},
          {'label': 'Laptop', 'icon': Icons.laptop, 'color': Colors.indigo, 'value': 'Laptop'},
          {'label': 'Pakaian Baru', 'icon': Icons.checkroom, 'color': Colors.pink, 'value': 'Pakaian Baru'},
          {'label': 'Sepatu', 'icon': Icons.backpack, 'color': Colors.brown, 'value': 'Sepatu'},
          {'label': 'Game Console', 'icon': Icons.videogame_asset, 'color': Colors.purple, 'value': 'Game Console'},
          {'label': 'Headphone', 'icon': Icons.headphones, 'color': Colors.teal, 'value': 'Headphone'},
          {'label': 'Jam Tangan', 'icon': Icons.watch, 'color': Colors.amber, 'value': 'Jam Tangan'},
          {'label': 'Tas Baru', 'icon': Icons.shopping_bag, 'color': Colors.orange, 'value': 'Tas Baru'},
          {'label': 'Uang Lebih', 'icon': Icons.attach_money, 'color': Colors.green, 'value': 'Uang Lebih'},
          {'label': 'Kamera', 'icon': Icons.camera_alt, 'color': Colors.red, 'value': 'Kamera'},
        ],
        onPicked: (barang) {
          PercakapanDispatcher.dispatchAction(
            context: context,
            character: character,
            targetName: targetName,
            targetRole: targetRole,
            targetAge: targetAge != null ? '$targetAge' : '$age',
            relationshipValue: _getCurrentRelationshipValue(),
            actionType: 'Minta Barang - $barang',
            onActionComplete: updateState,
            targetAvatarUrl: targetAvatarUrl,
            playerAvatarUrl: playerAvatarUrl,
            targetGender: targetGender,
          );
        },
      );
    },
  ));

  if (!isChild && AdultFeatures.canMasturbateTogether()) {
    final ActionItem ajakMasturbasiAction = ActionItem(
      label: 'Ajak Masturbasi Bersama',
      icon: Icons.flash_on,
      color: Colors.purple,
      onTap: () {
        final String myGender = character.gender.trim().toLowerCase();
        final String targetGender = _getNPCGender(character, targetName, targetRole).trim().toLowerCase();
        
        final bool isGay = (myGender == 'laki-laki' && targetGender == 'laki-laki');
        final bool isLesbian = (myGender == 'perempuan' && targetGender == 'perempuan');

        if (character.disableSameSexProposals && (isGay || isLesbian)) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Aksi Diblokir 🚫'),
              content: Text(isGay 
                ? 'Kamu telah menonaktifkan ajakan gay di pengaturan karakter.' 
                : 'Kamu telah menonaktifkan ajakan lesbian di pengaturan karakter.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        final int currentRel = NpcRelationshipHelper.getCurrentRelationship(
          character: character,
          targetName: targetName,
          targetRole: targetRole,
        );

        int successChance = PersentaseAjakan.getSuccessChance(
          character: character,
          relationType: targetRole,
          viewerName: targetName,
        );

        // Jika tingkat hubungan 60% atau lebih, NPC otomatis menyetujui (100% mau)
        if (currentRel >= 60) {
          successChance = 100;
        }

        // Aturan khusus untuk user perempuan: auto-accept berdasarkan happiness
        final String myGenderLow = character.gender.trim().toLowerCase();
        final String relLow2 = targetRole.toLowerCase();
        if (myGenderLow == 'perempuan') {
          if (relLow2.contains('ayah') && character.happiness > 70) {
            successChance = 100; // Ayah selalu menerima jika happiness > 70
          } else if (!relLow2.contains('ayah') && character.happiness > 60) {
            successChance = 100; // Selain ayah selalu menerima jika happiness > 60
          }
        }

        final bool success = random.nextInt(100) < successChance;
        final String relLower = targetRole.toLowerCase();
        final bool isParent = relLower == 'ayah' || relLower == 'ibu' || relLower == 'ayah tiri' || relLower == 'ibu tiri';

        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MasturbateScreen(
                character: character,
                targetName: targetName,
                targetRole: targetRole,
                onActionComplete: () {
                  updateState();
                },
              ),
            ),
          );
        } else {
          if (isParent) {
            character.happiness = (character.happiness - 50).clamp(0, 100);
            character.money = (character.money * 0.5).round();
            updateRelationship(-100);
            character.inbox.add('🚨 DIUSIR & DIPENJARA: Kamu diusir dari rumah dan polisi memenjarakanmu selama 3 tahun atas tindakan asusila!');
            
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Rayuan Ditolak (Tragedi) 🚨'),
                content: Text('$targetRole marah besar dan merasa sangat jijik! Kamu langsung diusir dari rumah, dan polisi dipanggil untuk menangkapmu. Kamu dipenjara selama 3 tahun (-50% Kebahagiaan, uangmu terpotong 50%, -100% Hubungan).'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      updateState();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            final int relDrop = random.nextInt(15) + 1; // 1-15%
            final int hapDrop = random.nextInt(5) + 1;  // 1-5%
            updateRelationship(-relDrop);
            character.happiness = (character.happiness - hapDrop).clamp(0, 100);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Ajakan Ditolak ❌'),
                content: Text('$targetName menolak ajakanmu secara mentah-mentah karena merasa aneh dan canggung! (-$relDrop% Hubungan, -$hapDrop% Kebahagiaan).'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      updateState();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      },
    );

    final int bercintaIndex = actions.indexWhere((act) => act.label == 'Bercinta / Make Love');
    if (bercintaIndex != -1) {
      actions.insert(bercintaIndex + 1, ajakMasturbasiAction);
    } else {
      actions.add(ajakMasturbasiAction);
    }
  }

  return actions;
}