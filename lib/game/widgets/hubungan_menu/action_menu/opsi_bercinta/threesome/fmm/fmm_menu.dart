// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/fmm/fmm_menu.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_tempat/pilih_tempat.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_waktu/pilih_waktu.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/fmm/posisi_fmm.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_overlay.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_npc_perempuan/desahan_npc_perempuan_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_npc_laki/desahan_npc_laki_makelove.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_pacar.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_user_laki/desahan_user_laki_makelove.dart';





class FmmThreesomeHelper {
  /// Mengambil seluruh anggota keluarga yang hidup dan dewasa
  static List<Map<String, dynamic>> _getLivingFamilyMembers(Character character) {
    final List<Map<String, dynamic>> family = [];

    if (character.fatherName != null && !character.isFatherDeceased) {
      family.add({
        'name': character.fatherName!,
        'gender': 'Laki-laki',
        'relation': 'Ayah',
        'relationship': character.fatherRelationship.toString(),
      });
    }
    if (character.motherName != null && !character.isMotherDeceased) {
      family.add({
        'name': character.motherName!,
        'gender': 'Perempuan',
        'relation': 'Ibu',
        'relationship': character.motherRelationship.toString(),
      });
    }
    if (character.stepFatherName != null && !character.isStepFatherDeceased) {
      family.add({
        'name': character.stepFatherName!,
        'gender': 'Laki-laki',
        'relation': 'Ayah Tiri',
        'relationship': character.stepFatherRelationship.toString(),
      });
    }
    if (character.stepMotherName != null && !character.isStepMotherDeceased) {
      family.add({
        'name': character.stepMotherName!,
        'gender': 'Perempuan',
        'relation': 'Ibu Tiri',
        'relationship': character.stepMotherRelationship.toString(),
      });
    }

    for (var sib in character.siblings) {
      if (sib['isDeceased'] != 'true' && sib['name'] != null) {
        final int age = int.tryParse(sib['age']?.toString() ?? '18') ?? 18;
        if (age >= 10) {
          family.add({
            'name': sib['name']!,
            'gender': sib['gender'] ?? 'Perempuan',
            'relation': sib['relation'] ?? (age < character.age ? 'Adik' : 'Kakak'),
            'relationship': sib['relationship'] ?? '50',
            'age': age,
          });
        }
      }
    }


    for (var child in character.children) {
      if (child['isDeceased'] != 'true' && child['name'] != null) {
        final int age = int.tryParse(child['age']?.toString() ?? '0') ?? 0;
        if (age >= 10) {
          family.add({
            'name': child['name']!,
            'gender': child['gender'] ?? 'Perempuan',
            'relation': child['relation'] ?? 'Anak',
            'relationship': child['relationship'] ?? '50',
            'age': age,
          });
        }
      }
    }


    return family;
  }

  /// Helper untuk mendapatkan Avatar URL konsisten
  static String _getAvatarUrl(Map<String, dynamic> cand) {
    if (cand['avatarUrl'] != null && cand['avatarUrl'].toString().isNotEmpty) {
      return cand['avatarUrl'].toString();
    }
    final String name = cand['name']?.toString() ?? '';
    final String gender = cand['gender']?.toString() ?? 'Perempuan';
    final int age = int.tryParse(cand['age']?.toString() ?? '20') ?? 20;
    final int happiness = int.tryParse(cand['relationship']?.toString() ?? '50') ?? 50;
    final String? skinColor = cand['skinColor']?.toString();

    return AvatarAgeRules.getAgeBasedAvatarUrlForNPC(
      name: name,
      gender: gender,
      age: age,
      happiness: happiness,
      forcedSkinColor: skinColor,
    );
  }

  /// Proses Threesome FMM (1 Wanita & 2 Pria)
  static void processFmm({
    required BuildContext context,
    required Character character,
    required VoidCallback updateState,
    String? preselectedTargetName,
  }) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String playerGender = character.gender.toLowerCase();
    final bool isPlayerMale = playerGender == 'laki-laki' || playerGender == 'male' || playerGender == 'pria';
    final bool isPlayerFemale = !isPlayerMale;


    // Kumpulkan Pasangan Aktif
    final List<Map<String, dynamic>> partnerList = [];
    for (var p in [character.partner, character.secondPartner, character.thirdPartner, character.fourthPartner, character.fifthPartner]) {
      if (p != null && p['isDeceased'] != 'true') {
        partnerList.add(p);
      }
    }

    // Kumpulkan Anggota Keluarga
    final List<Map<String, dynamic>> familyList = _getLivingFamilyMembers(character);

    // Kategori Pria (Pacar Pria & Keluarga Pria)
    final List<Map<String, dynamic>> malePartnerCandidates = [];
    final List<Map<String, dynamic>> maleFamilyCandidates = [];

    for (var p in partnerList) {
      final g = (p['gender'] ?? '').toString().toLowerCase();
      if (g == 'laki-laki' || g == 'male' || g == 'pria') {
        malePartnerCandidates.add({...p, 'source': 'Pacar'});
      }
    }

    for (var f in familyList) {
      final g = (f['gender'] ?? '').toString().toLowerCase();
      if (g == 'laki-laki' || g == 'male' || g == 'pria') {
        maleFamilyCandidates.add({...f, 'source': 'Keluarga (${f['relation']})'});
      }
    }

    final List<Map<String, dynamic>> availableMales = [...malePartnerCandidates, ...maleFamilyCandidates];

    // Kategori Wanita (Pacar Wanita & Keluarga Wanita)
    final List<Map<String, dynamic>> femaleCandidates = [];
    for (var p in partnerList) {
      final g = (p['gender'] ?? '').toString().toLowerCase();
      if (g == 'perempuan' || g == 'female' || g == 'wanita') {
        femaleCandidates.add({...p, 'source': 'Pacar'});
      }
    }
    for (var f in familyList) {
      final g = (f['gender'] ?? '').toString().toLowerCase();
      if (g == 'perempuan' || g == 'female' || g == 'wanita') {
        if (!femaleCandidates.any((c) => c['name'] == f['name'])) {
          femaleCandidates.add({...f, 'source': 'Keluarga (${f['relation']})'});
        }
      }
    }

    final int neededMales = isPlayerMale ? 1 : 2;

    if (availableMales.length < neededMales || femaleCandidates.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.deepPurpleAccent, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Syarat FMM Belum Terpenuhi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
              ),
            ],
          ),
          content: Text(
            isPlayerMale
                ? 'Untuk Threesome FMM (1 Wanita & 2 Pria), kamu (Pria) harus memilih 1 Pria Tambahan (Pacar/Keluarga) dan 1 Wanita (Pacar/Keluarga).'
                : 'Untuk Threesome FMM (1 Wanita & 2 Pria), kamu (Wanita) membutuhkan minimal 2 Pria (Pacar/Keluarga).',
            style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return;
    }

    List<Map<String, dynamic>> selectedMales = [];
    Map<String, dynamic>? selectedFemale;

    if (isPlayerMale) {
      // --- SKENARIO USER LAKI-LAKI ---
      // Cek apakah preselectedTargetName sudah menentukan siapa yang diajak (Wanita atau Pria)
      final String cleanTarget = AvatarAgeRules.getCleanNPCName(preselectedTargetName ?? '');
      
      Map<String, dynamic>? preselectedFemale;
      Map<String, dynamic>? preselectedMale;

      if (cleanTarget.isNotEmpty) {
        for (var f in femaleCandidates) {
          final String cleanF = AvatarAgeRules.getCleanNPCName(f['name']?.toString() ?? '');
          if (cleanF == cleanTarget || preselectedTargetName!.contains(cleanF)) {
            preselectedFemale = f;
            break;
          }
        }
        for (var m in availableMales) {
          final String cleanM = AvatarAgeRules.getCleanNPCName(m['name']?.toString() ?? '');
          if (cleanM == cleanTarget || preselectedTargetName!.contains(cleanM)) {
            preselectedMale = m;
            break;
          }
        }
      }

      // 1. Tentukan Pria Tambahan dengan Modal Pemilihan Checkbox (seperti FFM)
      final List<Map<String, dynamic>>? pickedMales = await showDialog<List<Map<String, dynamic>>>(
        context: context,
        builder: (context) {
          final String cleanTarget = AvatarAgeRules.getCleanNPCName(preselectedTargetName ?? '');
          List<Map<String, dynamic>> selection = availableMales.where((cand) {
            final String cleanCand = AvatarAgeRules.getCleanNPCName(cand['name']?.toString() ?? '');
            return cleanTarget.isNotEmpty && (cleanCand == cleanTarget || preselectedTargetName!.contains(cleanCand));
          }).toList();

          return StatefulBuilder(
            builder: (context, setModalState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
                insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.deepPurpleAccent, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pilih 1 Pria Tambahan untuk FMM ⚡',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                  ],
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: availableMales.map((m) {
                        final bool isSelected = selection.any((c) => c['name'] == m['name']);
                        final String avatarUrl = _getAvatarUrl(m);
                        final String source = m['source'].toString();

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? Colors.deepPurple.shade900.withValues(alpha: 0.4) : Colors.deepPurple.shade50)
                                : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.deepPurpleAccent
                                  : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                              width: isSelected ? 1.8 : 1.0,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            onTap: () {
                              setModalState(() {
                                if (isSelected) {
                                  selection.removeWhere((c) => c['name'] == m['name']);
                                } else {
                                  selection = [m];
                                }
                              });
                            },
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: isDark ? Colors.grey.shade700 : Colors.blue.shade100,
                              child: ClipOval(
                                child: Image(
                                  image: AvatarImageCache.getImageProvider(avatarUrl),
                                  width: 38,
                                  height: 38,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.face, color: Colors.blue, size: 22),
                                ),
                              ),
                            ),
                            title: Text(
                              m['name'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: isDark ? Colors.white : Colors.black87),
                            ),
                            subtitle: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(top: 3),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: source.contains('Keluarga')
                                      ? Colors.orange.withValues(alpha: 0.15)
                                      : Colors.blue.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  source,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: source.contains('Keluarga') ? Colors.orange : Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                            trailing: Checkbox(
                              value: isSelected,
                              activeColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) {
                                setModalState(() {
                                  if (val == true) {
                                    selection = [m];
                                  } else {
                                    selection.removeWhere((c) => c['name'] == m['name']);
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: selection.length == 1 ? () => Navigator.pop(context, selection) : null,
                    child: Text(
                      'Konfirmasi (${selection.length}/1)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: selection.length == 1 ? Colors.deepPurpleAccent : Colors.grey,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: const Text('Batal', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                ],
              );
            },
          );
        },
      );
      if (pickedMales == null || pickedMales.isEmpty || !context.mounted) return;
      selectedMales = pickedMales;


      // 2. Tentukan Wanita (jika preselectedTargetName adalah wanita, gunakan wanita tersebut tanpa perlu bertanya lagi!)
      if (preselectedFemale != null) {
        selectedFemale = preselectedFemale;
      } else if (femaleCandidates.length == 1) {
        selectedFemale = femaleCandidates.first;
      } else {
        selectedFemale = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Row(
              children: [
                const Icon(Icons.bolt, color: Colors.deepPurpleAccent, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Langkah 2: Pilih 1 Wanita untuk FMM ⚡',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: femaleCandidates.map((f) {
                    final String avatarUrl = _getAvatarUrl(f);
                    final String source = f['source'].toString();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        onTap: () => Navigator.pop(context, f),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: isDark ? Colors.grey.shade700 : Colors.pink.shade100,
                          child: ClipOval(
                            child: Image(
                              image: AvatarImageCache.getImageProvider(avatarUrl),
                              width: 38,
                              height: 38,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.face_3, color: Colors.pinkAccent, size: 22),
                            ),
                          ),
                        ),
                        title: Text(
                          f['name'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: isDark ? Colors.white : Colors.black87),
                        ),
                        subtitle: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(top: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: source.contains('Keluarga')
                                  ? Colors.orange.withValues(alpha: 0.15)
                                  : Colors.pink.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              source,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: source.contains('Keluarga') ? Colors.orange : Colors.pinkAccent,
                              ),
                            ),
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null),
                child: const Text('Batal', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
            ],
          ),
        );
        if (selectedFemale == null || !context.mounted) return;
      }
    } else {
      // --- SKENARIO USER PEREMPUAN ---
      // User adalah Wanita. Pilih 2 Pria (Pacar Pria / Keluarga Pria)
      if (availableMales.length == 2) {
        selectedMales = availableMales;
      } else {
        final List<Map<String, dynamic>>? picked = await showDialog<List<Map<String, dynamic>>>(
          context: context,
          builder: (context) {
            final String cleanTarget = AvatarAgeRules.getCleanNPCName(preselectedTargetName ?? '');
            List<Map<String, dynamic>> selection = availableMales.where((cand) {
              final String cleanCand = AvatarAgeRules.getCleanNPCName(cand['name']?.toString() ?? '');
              return cleanTarget.isNotEmpty && (cleanCand == cleanTarget || preselectedTargetName!.contains(cleanCand));
            }).toList();

            return StatefulBuilder(
              builder: (context, setModalState) {

                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  title: Row(
                    children: [
                      const Icon(Icons.bolt, color: Colors.deepPurpleAccent, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pilih 2 Pria untuk FMM ⚡',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: availableMales.map((cand) {
                          final bool isSelected = selection.any((c) => c['name'] == cand['name']);
                          final String avatarUrl = _getAvatarUrl(cand);
                          final String source = cand['source'].toString();

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? Colors.deepPurple.shade900.withValues(alpha: 0.4) : Colors.deepPurple.shade50)
                                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.deepPurpleAccent
                                    : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                                width: isSelected ? 1.8 : 1.0,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    selection.removeWhere((c) => c['name'] == cand['name']);
                                  } else {
                                    if (selection.length < 2) selection.add(cand);
                                  }
                                });
                              },
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: isDark ? Colors.grey.shade700 : Colors.blue.shade100,
                                child: ClipOval(
                                  child: Image(
                                    image: AvatarImageCache.getImageProvider(avatarUrl),
                                    width: 38,
                                    height: 38,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.face, color: Colors.blue, size: 22),
                                  ),
                                ),
                              ),
                              title: Text(
                                cand['name'].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: isDark ? Colors.white : Colors.black87),
                              ),
                              subtitle: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: source.contains('Keluarga')
                                        ? Colors.orange.withValues(alpha: 0.15)
                                        : Colors.blue.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    source,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: source.contains('Keluarga') ? Colors.orange : Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              trailing: Checkbox(
                                value: isSelected,
                                activeColor: Colors.deepPurpleAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) {
                                  setModalState(() {
                                    if (val == true) {
                                      if (selection.length < 2) selection.add(cand);
                                    } else {
                                      selection.removeWhere((c) => c['name'] == cand['name']);
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: selection.length == 2 ? () => Navigator.pop(context, selection) : null,
                      child: Text(
                        'Konfirmasi (${selection.length}/2)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: selection.length == 2 ? Colors.deepPurpleAccent : Colors.grey,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: const Text('Batal', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                  ],
                );
              },
            );
          },
        );
        if (picked == null || picked.isEmpty || !context.mounted) return;
        selectedMales = picked;
      }

      // User Wanita otomatis menjadi Wanita tunggal dalam FMM
      selectedFemale = {'name': character.name, 'source': 'Pemain (Wanita)'};
    }

    final List<String> targetNamesList = [];
    if (selectedFemale.isNotEmpty && selectedFemale['name'] != character.name) {
      targetNamesList.add(selectedFemale['name'].toString());
    }
    for (var m in selectedMales) {
      if (m['name'] != character.name) {
        targetNamesList.add(m['name'].toString());
      }
    }
    final String targetNamesText = targetNamesList.join(' dan ');

    final List<String> participantNames = [
      if (selectedFemale.isNotEmpty) '${selectedFemale['name']}',
      ...selectedMales.map((m) => '${m['name']}'),
    ];
    final String namesText = participantNames.join(' dan ');

    // Pilih Tempat & Waktu
    final String? loc = await TempatBercintaHelper.showLocationChooser(
      context: context,
      character: character,
      partnerName: namesText,
      userAge: character.age,
      targetAge: 20,
    );
    if (loc == null || !context.mounted) return;

    final String? time = await PilihWaktuHelper.showTimeChooser(context, loc);
    if (time == null || !context.mounted) return;

    // Opsi Kondom
    bool useCondom = false;
    final bool? chooseCondom = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        title: Row(
          children: [
            const Icon(Icons.security, color: Colors.blue, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Gunakan Pengaman (Kondom)?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
        content: const Text('Apakah para pria ingin menggunakan kondom saat Threesome FMM untuk mencegah kehamilan?', style: TextStyle(fontSize: 12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Pakai Kondom', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tanpa Kondom', style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (chooseCondom == null) return;
    useCondom = chooseCondom;

    if (!context.mounted) return;
    _executeFmm(context, character, namesText, targetNamesText, loc, time, useCondom, selectedFemale, selectedMales, isPlayerFemale, updateState);
  }

  static void _executeFmm(
    BuildContext context,
    Character character,
    String namesText,
    String targetNamesText,
    String loc,
    String time,
    bool useCondom,
    Map<String, dynamic>? selectedFemale,
    List<Map<String, dynamic>> selectedMales,
    bool isPlayerFemale,
    VoidCallback updateState,
  ) {
    character.currentPosisiSeks = null;
    final Random random = Random();

    // Ambil daftar posisi FMM berdasarkan lokasi yang dipilih
    final List<Map<String, dynamic>> posisiOptions = PosisiFmmHelper.getPosisiOptions(location: loc);

    character.happiness = (character.happiness + 35).clamp(0, 100);
    if (selectedFemale != null && selectedFemale['name'] != character.name) {
      int rel = int.tryParse(selectedFemale['relationship'] ?? '50') ?? 50;
      selectedFemale['relationship'] = (rel + 25).clamp(0, 100).toString();
    }

    String pregText = '';
    if (!useCondom) {
      bool isPregnant = random.nextInt(100) < 60;
      if (isPregnant) {
        if (isPlayerFemale) {
          character.isPregnant = true;
          pregText = '\n\n🤰 Kehamilan: Kamu telah hamil dari sesi Threesome FMM ini!';
        } else if (selectedFemale != null && selectedFemale['name'] != character.name) {
          character.partnerIsPregnant = true;
          final String fName = selectedFemale['name'] ?? 'Partisipan Wanita';
          final String existing = character.pregnantByPartnerName ?? '';
          final List<String> currentList = existing.isEmpty ? [] : existing.split(', ');
          if (!currentList.contains(fName)) currentList.add(fName);
          character.pregnantByPartnerName = currentList.join(', ');
          pregText = '\n\n🤰 Kehamilan: $fName telah hamil dari hasil Threesome FMM ini!';
        }
      }
    }


      // Buat pilihan posisi FMM untuk opsi 4 (Pilih Posisi Seks)
      final List<VNChoiceOption> subPosisiChoices = posisiOptions.map((pos) {
        final String posLabel = pos['label'] ?? 'Posisi FMM';
        final String posDesc = pos['description'] ?? '';
        return VNChoiceOption(
          text: '${pos['icon'] ?? "⚡"} Posisi: $posLabel',
          nextNodeIndex: 86, // Kembali ke menu aksi utama (Node 86)
          onSelect: (player, npc) {
            player.currentPosisiSeks = posLabel;
            character.inbox.add('⚡ Sukses Threesome FMM ($posLabel): Sesi luar biasa bersama $namesText $loc ($time)! $posDesc$pregText');
          },
        );
      }).toList();

      final List<VNDialogueNode> nodes = [];

      final String currentPosBadge = (character.currentPosisiSeks != null && character.currentPosisiSeks!.isNotEmpty)
          ? ' [${character.currentPosisiSeks}] 🔄 Ganti'
          : '';
      final String posisiBtnText = '4. Pilih Posisi Seks$currentPosBadge';

      // Button Utama Awal (Node 0)
      final List<VNChoiceOption> initialMainActionButtons = [
        VNChoiceOption(text: '💋 1. Ciuman', nextNodeIndex: 1),
        VNChoiceOption(text: '👅 2. Oral Seks', nextNodeIndex: 2),
        VNChoiceOption(text: '🌸 3. Lakukan Penetrasi', nextNodeIndex: 3),
        VNChoiceOption(text: posisiBtnText, nextNodeIndex: 4),
        VNChoiceOption(text: '🖐️ 5. Minta Pasangan Melakukan Onani', nextNodeIndex: 5),
        VNChoiceOption(text: '👆 6. Lakukan Onani Kepada Pasangan', nextNodeIndex: 6),
      ];


      // Button Utama Unlocked (Node 86)
      final List<VNChoiceOption> unlockedMainActionButtons = [
        ...initialMainActionButtons,
        VNChoiceOption(text: '💦 7. Ejakulasi / Klimaks', nextNodeIndex: 7),
        VNChoiceOption(text: '🏁 Selesai Bercinta', nextNodeIndex: null),
      ];

      // NODE 0: Opening Narasi & Menu Utama
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Suasana di $loc pada $time ini terasa begitu hangat dan dahsyat. Kehangatan membara menyelimuti ${character.name} dan $namesText. Pilih aksi intim yang ingin kamu lakukan...) ✨',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        background: VNBackgroundType.bedroom,
        choices: initialMainActionButtons,
      ));

      final List<String> partners = targetNamesText.contains(' dan ')
          ? targetNamesText.split(' dan ')
          : [targetNamesText, 'Pasangan'];
      final String p1 = partners.isNotEmpty ? partners[0].trim() : 'Pasangan 1';
      final String p2 = partners.length > 1 ? partners[1].trim() : 'Pasangan 2';

      // NODE 1: Sub-Menu Ciuman
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih siapa pasangan yang ingin kamu cium...) 💋',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '💋 Ciuman dengan $p1', nextNodeIndex: 11),
          VNChoiceOption(text: '💋 Ciuman dengan $p2', nextNodeIndex: 12),
          VNChoiceOption(text: '💋 Ciuman Bertiga dengan Keduanya ($p1 & $p2)', nextNodeIndex: 13),
        ],
      ));

      // NODE 2: Sub-Menu Oral Seks
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih siapa pasangan yang ingin kamu berikan oral seks...) 👅',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '👅 Oral seks dengan $p1', nextNodeIndex: 21),
          VNChoiceOption(text: '👅 Oral seks dengan $p2', nextNodeIndex: 22),
          VNChoiceOption(text: '👅 Oral seks dengan Keduanya ($p1 & $p2)', nextNodeIndex: 23),
        ],
      ));

      // NODE 3: Sub-Menu Penetrasi
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih siapa pasangan yang ingin kamu penetrasi...) 🌸',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🌸 Penetrasi kepada $p1', nextNodeIndex: 31),
          VNChoiceOption(text: '🌸 Penetrasi kepada $p2', nextNodeIndex: 32),
          VNChoiceOption(text: '🌸 Penetrasi kepada Keduanya ($p1 & $p2)', nextNodeIndex: 33),
        ],
      ));

      // NODE 4: Sub-Menu Posisi Seks (Posisi FMM berdasarkan lokasi)
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih posisi Threesome FMM yang kamu inginkan di $loc...) ⚡',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          ...subPosisiChoices,
        ],
      ));

      // NODE 5: Sub-Menu Minta Pasangan Melakukan Onani
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih siapa yang kamu minta untuk melakukan onani...) 🖐️',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🖐️ Minta $p1 melakukan onani', nextNodeIndex: 51),
          VNChoiceOption(text: '🖐️ Minta $p2 melakukan onani', nextNodeIndex: 52),
          VNChoiceOption(text: '🖐️ Minta Keduanya ($p1 & $p2) melakukan onani', nextNodeIndex: 53),
        ],
      ));

      // NODE 6: Sub-Menu Lakukan Onani Kepada Pasangan
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih siapa yang ingin kamu berikan onani/stimulasi...) 👆',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '👆 Lakukan onani kepada $p1', nextNodeIndex: 61),
          VNChoiceOption(text: '👆 Lakukan onani kepada $p2', nextNodeIndex: 62),
          VNChoiceOption(text: '👆 Lakukan onani kepada Keduanya ($p1 & $p2)', nextNodeIndex: 63),
        ],
      ));

      // NODE 7: Sub-Menu Ejakulasi
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih lokasi pengeluaran cairan klimaks untuk FMM...) 💦',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '💦 Keluar di Dalam Vagina / Anus', nextNodeIndex: null),
          VNChoiceOption(text: '🧴 Keluar di Perut / Luar', nextNodeIndex: null),
          VNChoiceOption(text: '👑 Keluar di Wajah', nextNodeIndex: null),
          VNChoiceOption(text: '👄 Keluar di Mulut', nextNodeIndex: null),
          VNChoiceOption(text: '🏁 Selesai Bercinta', nextNodeIndex: null),
        ],
      ));

      // Node Outcome Ciuman (11, 12, 13)
      while (nodes.length < 11) {
        nodes.add(VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Aksi berjalan memuaskan...) ✨',
          emotion: VNEmotionType.blush,
          background: VNBackgroundType.bedroom,
          nextIndex: 86,
        ));
      }

      // NODE 11: Outcome Ciuman P1
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Kamu berciuman mesra dan hangat bersama $p1...) 💋',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 12: Outcome Ciuman P2
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Kamu berciuman mesra dan hangat bersama $p2...) 💋',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 13: Outcome Ciuman Keduanya
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Kamu berciuman mesra dan bergairah dengan $p1 dan $p2 sekaligus...) 💋',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // Node Outcome Oral Seks (21, 22, 23)
      while (nodes.length < 21) {
        nodes.add(VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Aksi berjalan memuaskan...) ✨',
          emotion: VNEmotionType.blush,
          background: VNBackgroundType.bedroom,
          nextIndex: 86,
        ));
      }

      // NODE 21: Outcome Oral P1
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Sesi oral seks yang nikmat dan membara bersama $p1...) 👅',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 22: Outcome Oral P2
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Sesi oral seks yang nikmat dan membara bersama $p2...) 👅',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 23: Outcome Oral Keduanya
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Sesi oral seks bergantian dan nikmat bersama $p1 dan $p2...) 👅',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // Node Outcome Penetrasi (31, 32, 33)
      while (nodes.length < 31) {
        nodes.add(VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Aksi berjalan memuaskan...) ✨',
          emotion: VNEmotionType.blush,
          background: VNBackgroundType.bedroom,
          nextIndex: 86,
        ));
      }

      final bool p1IsFemale = !isPlayerFemale;
      final bool p2IsFemale = false; // Di FMM, P2 selalu Laki-laki

      // NODE 31: Sub-Menu Penetrasi P1
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih lokasi penetrasi untuk $p1...) 🌸',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          if (p1IsFemale) VNChoiceOption(text: '🌸 Penetrasi Vagina $p1', nextNodeIndex: 34),
          VNChoiceOption(text: '🍑 Penetrasi Anal $p1', nextNodeIndex: 35),
        ],
      ));

      // NODE 32: Sub-Menu Penetrasi P2
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih lokasi penetrasi untuk $p2...) 🌸',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          if (p2IsFemale) VNChoiceOption(text: '🌸 Penetrasi Vagina $p2', nextNodeIndex: 36),
          VNChoiceOption(text: '🍑 Penetrasi Anal $p2', nextNodeIndex: 37),
        ],
      ));

      // NODE 33: Sub-Menu Penetrasi Keduanya
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih posisi penetrasi untuk $p1 dan $p2...) 🌸',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          if (p1IsFemale) VNChoiceOption(text: '🌸 Penetrasi Vagina $p1 & Anal $p2', nextNodeIndex: 38),
          VNChoiceOption(text: '🍑 Penetrasi Anal Bergantian', nextNodeIndex: 39),
          if (p1IsFemale) VNChoiceOption(text: '🔥 Double Penetration Simultan ($p1)', nextNodeIndex: 40),
        ],
      ));

      final String femaleName = isPlayerFemale ? character.name : (selectedFemale != null ? (selectedFemale['name'] ?? p1) : p1);
      final Map<String, dynamic> femaleMap = isPlayerFemale ? {'name': character.name} : (selectedFemale ?? {'name': p1});

      String getCallNameForTarget(String targetName) {
        if (targetName == character.name) {
          // NPC memanggil User
          final Map<String, dynamic>? npcMapObj = (selectedFemale != null && selectedFemale['name'] != character.name)
              ? selectedFemale
              : (selectedMales.isNotEmpty ? selectedMales[0] : null);
          final String role = npcMapObj?['role'] ?? npcMapObj?['relation'] ?? 'Pasangan';

          return PanggilanManager.getPanggilan(
            targetName: character.name,
            targetRole: role,
            targetGender: character.gender,
            isSpeakerPlayer: false,
            userName: character.name,
            userGender: character.gender,
            isIntimate: true,
            character: character,
          );
        } else {
          // User memanggil NPC / NPC memanggil sesama NPC
          final Map<String, dynamic>? npcMapObj = (selectedFemale != null && selectedFemale['name'] == targetName)
              ? selectedFemale
              : (selectedMales.where((m) => m['name'] == targetName).isNotEmpty ? selectedMales.firstWhere((m) => m['name'] == targetName) : null);
          final String role = npcMapObj?['role'] ?? npcMapObj?['relation'] ?? 'Pasangan';
          final String gndr = npcMapObj?['gender'] ?? 'Perempuan';

          return PanggilanManager.getPanggilan(
            targetName: targetName,
            targetRole: role,
            targetGender: gndr,
            isSpeakerPlayer: true,
            userName: character.name,
            userGender: character.gender,
            isIntimate: true,
            character: character,
          );
        }
      }

      // NODE 34: Outcome Vagina P1
      nodes.add(VNDialogueNode(
        speakerName: femaleName,
        dynamicDialogueText: () => '"${DesahanNpcPerempuanMakeLove.getRandomMoan(femaleMap)} ${getCallNameForTarget(isPlayerFemale ? p1 : character.name)}..."',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 35: Outcome Anal P1
      nodes.add(VNDialogueNode(
        speakerName: p1IsFemale ? femaleName : p1,
        dynamicDialogueText: () => p1IsFemale
            ? '"${DesahanNpcPerempuanMakeLove.getRandomMoan(femaleMap)} ${getCallNameForTarget(isPlayerFemale ? p1 : character.name)}..."'
            : '"${DesahanNpcLakiMakeLove.getRandomMoan({'name': p1})} ${getCallNameForTarget(character.name)}..."',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 36: Outcome Vagina P2
      nodes.add(VNDialogueNode(
        speakerName: femaleName,
        dynamicDialogueText: () => '"${DesahanNpcPerempuanMakeLove.getRandomMoan(femaleMap)}..."',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 37: Outcome Anal P2 (P2 selalu Laki-laki di FMM)
      nodes.add(VNDialogueNode(
        speakerName: p2,
        dynamicDialogueText: () => '"${DesahanNpcLakiMakeLove.getRandomMoan({'name': p2})} ${getCallNameForTarget(character.name)}..."',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));


      // NODE 38: Outcome Vagina Keduanya
      nodes.add(VNDialogueNode(
        speakerName: femaleName,
        dynamicDialogueText: () => '"${DesahanNpcPerempuanMakeLove.getRandomMoan(femaleMap)}... Ahh...!"',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 39: Outcome Anal Keduanya
      nodes.add(VNDialogueNode(
        speakerName: femaleName,
        dynamicDialogueText: () => '"${DesahanNpcPerempuanMakeLove.getRandomMoan(femaleMap)}... Ahh...!"',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 40: Outcome Double Penetration
      nodes.add(VNDialogueNode(
        speakerName: femaleName,
        dynamicDialogueText: () => '"${DesahanNpcPerempuanMakeLove.getRandomMoan(femaleMap)}... Ahhh... Nikmat sekali...!"',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));


      final Map<String, dynamic> p1Map = {'name': p1, 'gender': p1IsFemale ? 'Perempuan' : 'Laki-laki'};
      final Map<String, dynamic> p2Map = {'name': p2, 'gender': p2IsFemale ? 'Perempuan' : 'Laki-laki'};
      final bool isP1Male = !p1IsFemale;
      final bool isP2Male = !p2IsFemale;

      // NODE 51: Outcome Minta P1
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '($p1 memberikan manipulasi dan stimulasi intim kepada ${character.name} dengan begitu penuh gairah...) 🖐️',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
      ));
      nodes.add(VNDialogueNode(
        speakerName: isPlayerFemale ? p1 : character.name,
        dynamicDialogueText: () => isPlayerFemale
            ? '"${isP1Male ? DesahanNpcLakiMakeLove.getRandomMoan(p1Map) : DesahanNpcPerempuanMakeLove.getRandomMoan(p1Map)}... Mmh..."'
            : '"${DesahanUserLakiMakeLove.getRandomMoan(character)}... $p1... Ahh!"',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: !isPlayerFemale,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 52: Outcome Minta P2
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '($p2 memberikan stimulasi intim kepada ${character.name} dengan nikmat...) 🖐️',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
      ));
      nodes.add(VNDialogueNode(
        speakerName: isPlayerFemale ? p2 : character.name,
        dynamicDialogueText: () => isPlayerFemale
            ? '"${isP2Male ? DesahanNpcLakiMakeLove.getRandomMoan(p2Map) : DesahanNpcPerempuanMakeLove.getRandomMoan(p2Map)}... Aah..."'
            : '"${DesahanUserLakiMakeLove.getRandomMoan(character)}... $p2... Ngh!"',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: !isPlayerFemale,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 53: Outcome Minta Keduanya
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '($p1 dan $p2 memberikan stimulasi intim bersama-sama kepada ${character.name}...) 🖐️',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
      ));
      nodes.add(VNDialogueNode(
        speakerName: isPlayerFemale ? p1 : character.name,
        dynamicDialogueText: () => isPlayerFemale
            ? '"${isP1Male ? DesahanNpcLakiMakeLove.getRandomMoan(p1Map) : DesahanNpcPerempuanMakeLove.getRandomMoan(p1Map)}..."'
            : '"${DesahanUserLakiMakeLove.getRandomMoan(character)}... Ahh!"',
        emotion: VNEmotionType.blush,
        isPlayerSpeaking: !isPlayerFemale,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      while (nodes.length < 61) {
        nodes.add(VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Aksi berjalan memuaskan...) ✨',
          emotion: VNEmotionType.blush,
          background: VNBackgroundType.bedroom,
          nextIndex: 86,
        ));
      }

      // NODE 61: Outcome Lakukan P1
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Kamu memberikan rabaan dan stimulasi mendalam kepada $p1...) 👆',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
      ));
      nodes.add(VNDialogueNode(
        speakerName: p1,
        dynamicDialogueText: () => '"${isP1Male ? DesahanNpcLakiMakeLove.getRandomMoan(p1Map) : DesahanNpcPerempuanMakeLove.getRandomMoan(p1Map)}... Ahh!"',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 62: Outcome Lakukan P2
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Kamu memberikan stimulasi intens yang membuat $p2 mendesah nikmat...) 👆',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
      ));
      nodes.add(VNDialogueNode(
        speakerName: p2,
        dynamicDialogueText: () => '"${isP2Male ? DesahanNpcLakiMakeLove.getRandomMoan(p2Map) : DesahanNpcPerempuanMakeLove.getRandomMoan(p2Map)}... Ngh!"',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 63: Outcome Lakukan Keduanya
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Kamu menggunakan kedua tanganmu untuk memberikan stimulasi kepada $p1 dan $p2 sekaligus...) 👆',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
      ));
      nodes.add(VNDialogueNode(
        speakerName: 'Keduanya',
        dynamicDialogueText: () => '"${isP1Male ? DesahanNpcLakiMakeLove.getRandomMoan(p1Map) : DesahanNpcPerempuanMakeLove.getRandomMoan(p1Map)}... ${isP2Male ? DesahanNpcLakiMakeLove.getRandomMoan(p2Map) : DesahanNpcPerempuanMakeLove.getRandomMoan(p2Map)}...!"',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        nextIndex: 86,
      ));

      // NODE 86: Loop Re-choice Card Utama (Menu Utama setelah melakukan aksi)
      while (nodes.length < 86) {
        nodes.add(VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Aksi FMM berjalan sengit dan memuaskan...) ✨',
          emotion: VNEmotionType.blush,
          background: VNBackgroundType.bedroom,
          nextIndex: 86,
        ));
      }

      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Gairah Threesome FMM semakin memuncak! Pilih aksi selanjutnya yang ingin kamu lakukan...) ✨',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: unlockedMainActionButtons,
      ));

      Map<String, dynamic>? overlayP1Map;
      Map<String, dynamic>? overlayP2Map;

      if (isPlayerFemale) {
        if (selectedMales.isNotEmpty) overlayP1Map = selectedMales[0];
        if (selectedMales.length > 1) overlayP2Map = selectedMales[1];
      } else {
        if (selectedFemale != null) overlayP1Map = selectedFemale;
        if (selectedMales.isNotEmpty) overlayP2Map = selectedMales[0];
      }

      final Map<String, dynamic> npcMap1 = overlayP1Map ?? {
        'name': namesText,
        'gender': 'Laki-laki',
        'role': 'Threesome FMM',
      };

      VNDialogueOverlay.show(
        context: context,
        player: character,
        npc: npcMap1,
        npcAvatarUrl: overlayP1Map != null ? _getAvatarUrl(overlayP1Map) : null,
        secondNpc: overlayP2Map,
        secondNpcAvatarUrl: overlayP2Map != null ? _getAvatarUrl(overlayP2Map) : null,
        nodes: nodes,
        customLocation: '$loc ($time)',
        finishButtonText: 'Selesai Sesi FMM',
        onFinished: () {
          character.currentPosisiSeks = null;
          updateState();
        },
      );
  }
}



