// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/ffm/ffm_menu.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_tempat/pilih_tempat.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_waktu/pilih_waktu.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/ffm/posisi_ffm.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_overlay.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';


class FfmThreesomeHelper {
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
        final int age = int.tryParse(sib['age'] ?? '18') ?? 18;
        if (age >= 18) {
          family.add({
            'name': sib['name']!,
            'gender': sib['gender'] ?? 'Perempuan',
            'relation': sib['relation'] ?? 'Saudara',
            'relationship': sib['relationship'] ?? '50',
          });
        }
      }
    }

    for (var child in character.children) {
      if (child['isDeceased'] != 'true' && child['name'] != null) {
        final int age = int.tryParse(child['age'] ?? '0') ?? 0;
        if (age >= 18) {
          family.add({
            'name': child['name']!,
            'gender': child['gender'] ?? 'Perempuan',
            'relation': child['relation'] ?? 'Anak',
            'relationship': child['relationship'] ?? '50',
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

  /// Proses Threesome FFM (2 Wanita & 1 Pria)
  static void processFfm({
    required BuildContext context,
    required Character character,
    required VoidCallback updateState,
    String? preselectedTargetName,
  }) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String playerGender = character.gender.toLowerCase();
    final bool isPlayerMale = playerGender == 'laki-laki' || playerGender == 'male' || playerGender == 'pria';

    // Kumpulkan Pasangan Aktif
    final List<Map<String, dynamic>> partnerList = [];
    for (var p in [character.partner, character.secondPartner, character.thirdPartner, character.fourthPartner, character.fifthPartner]) {
      if (p != null && p['isDeceased'] != 'true') {
        partnerList.add(p);
      }
    }

    // Kumpulkan Anggota Keluarga
    final List<Map<String, dynamic>> familyList = _getLivingFamilyMembers(character);

    // Kategori Wanita (Pacar Wanita & Keluarga Wanita)
    final List<Map<String, dynamic>> femalePartnerCandidates = [];
    final List<Map<String, dynamic>> femaleFamilyCandidates = [];

    for (var p in partnerList) {
      final g = (p['gender'] ?? '').toString().toLowerCase();
      if (g == 'perempuan' || g == 'female' || g == 'wanita') {
        femalePartnerCandidates.add({...p, 'source': 'Pacar'});
      }
    }

    for (var f in familyList) {
      final g = (f['gender'] ?? '').toString().toLowerCase();
      if (g == 'perempuan' || g == 'female' || g == 'wanita') {
        femaleFamilyCandidates.add({...f, 'source': 'Keluarga (${f['relation']})'});
      }
    }

    final List<Map<String, dynamic>> availableFemales = [...femalePartnerCandidates, ...femaleFamilyCandidates];

    // Kategori Pria (Pacar Pria & Keluarga Pria)
    final List<Map<String, dynamic>> maleCandidates = [];
    for (var p in partnerList) {
      final g = (p['gender'] ?? '').toString().toLowerCase();
      if (g == 'laki-laki' || g == 'male' || g == 'pria') {
        maleCandidates.add({...p, 'source': 'Pacar'});
      }
    }
    for (var f in familyList) {
      final g = (f['gender'] ?? '').toString().toLowerCase();
      if (g == 'laki-laki' || g == 'male' || g == 'pria') {
        if (!maleCandidates.any((c) => c['name'] == f['name'])) {
          maleCandidates.add({...f, 'source': 'Keluarga (${f['relation']})'});
        }
      }
    }

    final int neededFemales = isPlayerMale ? 2 : 1;

    if (availableFemales.length < neededFemales || (!isPlayerMale && maleCandidates.isEmpty)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Syarat FFM Belum Terpenuhi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
              ),
            ],
          ),
          content: Text(
            isPlayerMale
                ? 'Untuk Threesome FFM (2 Wanita & 1 Pria), kamu membutuhkan minimal 2 Wanita (dari Pacar atau Keluarga).'
                : 'Untuk Threesome FFM (2 Wanita & 1 Pria), kamu (Wanita) harus memilih 1 Wanita Tambahan (Pacar/Keluarga) dan 1 Pria (Pacar/Keluarga).',
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

    List<Map<String, dynamic>> selectedFemales = [];
    Map<String, dynamic>? selectedMale;

    if (isPlayerMale) {
      // --- SKENARIO USER LAKI-LAKI ---
      // Pilih 2 Wanita (Pacar / Keluarga)
      if (availableFemales.length == 2) {
        selectedFemales = availableFemales;
      } else {
        final List<Map<String, dynamic>>? picked = await showDialog<List<Map<String, dynamic>>>(
          context: context,
          builder: (context) {
            final String cleanTarget = AvatarAgeRules.getCleanNPCName(preselectedTargetName ?? '');
            List<Map<String, dynamic>> selection = availableFemales.where((cand) {
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
                      const Icon(Icons.favorite, color: Colors.pinkAccent, size: 22),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Pilih 2 Wanita untuk FFM 🔥', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black87)),
                      ),
                    ],
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: availableFemales.map((cand) {
                          final bool isSelected = selection.any((c) => c['name'] == cand['name']);
                          final String avatarUrl = _getAvatarUrl(cand);
                          final String source = cand['source'].toString();

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? Colors.pink.shade900.withValues(alpha: 0.4) : Colors.pink.shade50)
                                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.pinkAccent
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
                              title: Text(cand['name'].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: isDark ? Colors.white : Colors.black87)),
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
                              trailing: Checkbox(
                                value: isSelected,
                                activeColor: Colors.pinkAccent,
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
                          color: selection.length == 2 ? Colors.pinkAccent : Colors.grey,
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
        selectedFemales = picked;
      }
      selectedMale = {'name': character.name, 'source': 'Pemain Pria'};
    } else {

      // --- SKENARIO USER PEREMPUAN ---
      // LANGKAH 1: Pilih 1 Wanita Tambahan (Pacar Wanita / Keluarga Wanita)
      if (availableFemales.length == 1) {
        selectedFemales = [availableFemales.first];
      } else {
        final Map<String, dynamic>? pickedFemale = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.pinkAccent, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Langkah 1: Pilih 1 Wanita Tambahan 🔥',
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
                  children: availableFemales.map((f) {
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
        if (pickedFemale == null || !context.mounted) return;
        selectedFemales = [pickedFemale];
      }

      // LANGKAH 2: Pilih 1 Pria (Pacar Pria / Keluarga Pria)
      if (maleCandidates.length == 1) {
        selectedMale = maleCandidates.first;
      } else {
        selectedMale = await showDialog<Map<String, dynamic>>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Row(
              children: [
                const Icon(Icons.person, color: Colors.blue, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Langkah 2: Pilih 1 Pria untuk FFM 🔥',
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
                  children: maleCandidates.map((m) {
                    final String avatarUrl = _getAvatarUrl(m);
                    final String source = m['source'].toString();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        onTap: () => Navigator.pop(context, m),
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
        if (selectedMale == null || !context.mounted) return;
      }
    }

    final List<String> targetNamesList = selectedFemales
        .where((e) => e['name'] != character.name)
        .map((e) => e['name'].toString())
        .toList();
    if (selectedMale.isNotEmpty && selectedMale['name'] != character.name) {
      targetNamesList.add(selectedMale['name'].toString());
    }
    final String targetNamesText = targetNamesList.join(' dan ');

    final List<String> participantNames = [
      ...selectedFemales.map((e) => '${e['name']}'),
      if (selectedMale.isNotEmpty) '${selectedMale['name']}',
    ];
    final String namesText = participantNames.join(' dan ');


    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        title: Row(
          children: [
            const Icon(Icons.favorite, color: Colors.pinkAccent, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Konfirmasi Threesome FFM 🔥', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kamu akan melakukan Threesome FFM bersama: $namesText.', style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.pink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.pink.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'ℹ️ Sesi FFM pilihanmu siap dimulai.',
                style: TextStyle(fontSize: 11, color: Colors.pink, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Lanjutkan', style: TextStyle(fontSize: 12, color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

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
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.blue, size: 22),
            SizedBox(width: 8),
            Text('Gunakan Pengaman (Kondom)?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        content: const Text('Apakah ingin menggunakan kondom saat Threesome FFM untuk mencegah kehamilan?', style: TextStyle(fontSize: 12)),
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
    _executeFfm(context, character, namesText, targetNamesText, loc, time, useCondom, selectedFemales, updateState);
  }

  static void _executeFfm(
    BuildContext context,
    Character character,
    String namesText,
    String targetNamesText,
    String loc,
    String time,
    bool useCondom,
    List<Map<String, dynamic>> selectedFemales,
    VoidCallback updateState,
  ) {

    final Random random = Random();

    // Ambil daftar posisi FFM berdasarkan lokasi yang dipilih
    final List<Map<String, dynamic>> posisiOptions = PosisiFfmHelper.getPosisiOptions(location: loc);

    character.happiness = (character.happiness + 35).clamp(0, 100);

    List<String> pregnantList = [];
    if (!useCondom && selectedFemales.isNotEmpty) {
      for (var f in selectedFemales) {
        if (f['name'] != character.name && random.nextInt(100) < 50) {
          pregnantList.add(f['name'] ?? 'Partisipan');
        }
      }
    }

    String pregText = '';
    if (pregnantList.isNotEmpty) {
      character.partnerIsPregnant = true;
      final String existing = character.pregnantByPartnerName ?? '';
      final List<String> currentList = existing.isEmpty ? [] : existing.split(', ');
      for (var name in pregnantList) {
        if (!currentList.contains(name)) currentList.add(name);
      }
      character.pregnantByPartnerName = currentList.join(', ');
      pregText = '\n\n🤰 Kehamilan: ${pregnantList.join(" dan ")} telah hamil dari sesi FFM ini!';
    }


      // Buat pilihan posisi FFM untuk opsi 4 (Pilih Posisi Seks)
      final List<VNChoiceOption> subPosisiChoices = posisiOptions.map((pos) {
        final String posLabel = pos['label'] ?? 'Posisi FFM';
        final String posDesc = pos['description'] ?? '';
        return VNChoiceOption(
          text: '${pos['icon'] ?? "🔥"} Posisi: $posLabel',
          nextNodeIndex: 86, // Kembali ke menu aksi utama (Node 86)
          onSelect: (player, npc) {
            player.currentPosisiSeks = posLabel;
            character.inbox.add('🔥 Sukses Threesome FFM ($posLabel): Momen luar biasa bersama $namesText $loc ($time)! $posDesc$pregText');
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
        VNChoiceOption(text: '🖐️ 5. Minta $targetNamesText melakukan onani', nextNodeIndex: 5),
        VNChoiceOption(text: '👆 6. Lakukan onani kepada $targetNamesText', nextNodeIndex: 6),
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
        dialogueText: '(Suasana di $loc pada $time ini terasa begitu hangat dan memikat. Kehangatan mesra menyelimuti ${character.name} dan $namesText. Pilih aksi intim yang ingin kamu lakukan...) ✨',
        emotion: VNEmotionType.neutral,
        isPlayerSpeaking: false,
        background: VNBackgroundType.bedroom,
        choices: initialMainActionButtons,
      ));

      // NODE 1: Sub-Menu Ciuman
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Sesi ciuman bertiga FFM yang hangat bersama $namesText...) 💋',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '💋 Kecup Bibir Berdua', nextNodeIndex: 86),
          VNChoiceOption(text: '🔥 French Kiss Bertiga', nextNodeIndex: 86),
          VNChoiceOption(text: '↩️ Kembali ke Menu Utama', nextNodeIndex: 86),
        ],
      ));

      // NODE 2: Sub-Menu Oral Seks
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Sesi oral seks FFM yang membara bersama $namesText...) 👅',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '👅 Oral Seks Bergiliran', nextNodeIndex: 86),
          VNChoiceOption(text: '👄 Blowjob & Cunnilingus Simultan', nextNodeIndex: 86),
          VNChoiceOption(text: '↩️ Kembali ke Menu Utama', nextNodeIndex: 86),
        ],
      ));

      // NODE 3: Sub-Menu Penetrasi
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Lakukan penetrasi dalam sesi Threesome FFM...) 🌸',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '🌸 Penetrasi Vagina', nextNodeIndex: 86),
          VNChoiceOption(text: '🔥 Penetrasi Anal', nextNodeIndex: 86),
          VNChoiceOption(text: '↩️ Kembali ke Menu Utama', nextNodeIndex: 86),
        ],
      ));

      // NODE 4: Sub-Menu Posisi Seks (Posisi FFM berdasarkan lokasi)
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih posisi Threesome FFM yang kamu inginkan di $loc...) 👩‍❤️‍💋‍👩',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          ...subPosisiChoices,
          VNChoiceOption(text: '↩️ Kembali ke Menu Utama', nextNodeIndex: 86),
        ],
      ));

      // NODE 5: Onani/Fingering Minta
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '($namesText melakukan sentuhan intim dan onani yang lembut...) 🖐️',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '✨ Lanjutkan Kehangatan', nextNodeIndex: 86),
        ],
      ));

      // NODE 6: Onani/Fingering Lakukan
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Kamu memberikan rabaan dan sentuhan sensual kepada $namesText...) 👆',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '✨ Lanjutkan Kehangatan', nextNodeIndex: 86),
        ],
      ));

      // NODE 7: Sub-Menu Ejakulasi
      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Pilih lokasi pengeluaran cairan klimaks untuk FFM...) 💦',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: [
          VNChoiceOption(text: '💦 Keluar di Dalam Vagina', nextNodeIndex: 86),
          VNChoiceOption(text: '🧴 Keluar di Perut / Luar', nextNodeIndex: 86),
          VNChoiceOption(text: '👑 Keluar di Wajah', nextNodeIndex: 86),
          VNChoiceOption(text: '👄 Keluar di Mulut', nextNodeIndex: 86),
          VNChoiceOption(text: '🏁 Selesai Bercinta', nextNodeIndex: null),
        ],
      ));

      // NODE 86: Loop Re-choice Card Utama (Menu Utama setelah melakukan aksi)
      // Mengisi array nodes hingga indeks 86 tercapai
      while (nodes.length < 86) {
        nodes.add(VNDialogueNode(
          speakerName: 'Narasi',
          dialogueText: '(Aksi berjalan memuaskan...) ✨',
          emotion: VNEmotionType.blush,
          background: VNBackgroundType.bedroom,
          nextIndex: 86,
        ));
      }

      nodes.add(VNDialogueNode(
        speakerName: 'Narasi',
        dialogueText: '(Sensasi Threesome FFM semakin memanas! Pilih aksi selanjutnya yang ingin kamu lakukan...) ✨',
        emotion: VNEmotionType.blush,
        background: VNBackgroundType.bedroom,
        choices: unlockedMainActionButtons,
      ));

      final Map<String, dynamic> npcMap = {
        'name': namesText,
        'gender': 'Perempuan',
        'role': 'Threesome FFM',
        'relationship': '90',
      };

      VNDialogueOverlay.show(
        context: context,
        player: character,
        npc: npcMap,
        nodes: nodes,
        customLocation: '$loc ($time)',
        finishButtonText: 'Selesai Sesi FFM',
        onFinished: () {
          updateState();
        },
      );
  }
}


