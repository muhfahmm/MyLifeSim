// lib/game/widgets/hubungan_menu/school_sexuality/siswa_siswi/student_romance_logic.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class StudentRomanceLogic {
  static final Random _random = Random();

  /// Menentukan apakah button "Ajak Pacaran" dan "Bercinta / Make Love" harus ditampilkan.
  /// Muncul ketika user atau teman sudah berusia minimal 9 tahun.
  static bool shouldShowRomanceButtons({required int userAge, required int classmateAge}) {
    return userAge >= 9 || classmateAge >= 9;
  }

  /// Menjalankan aksi "Ajak Pacaran" antara siswa dengan siswa.
  static void ajakPacaran({
    required BuildContext context,
    required Character character,
    required Map<String, String> classmate,
    required VoidCallback onRefresh,
    required Function(String, String) showOutcome,
  }) {
    final String name = classmate['name']!;
    final String gender = classmate['gender']!;
    final String sexuality = classmate['sexuality'] ?? 'Heteroseksual';
    final int rel = int.tryParse(classmate['relationship'] ?? '50') ?? 50;

    // Cek apakah orientasi seksual cocok dengan gender user
    // Gender user: Laki-laki / Perempuan
    final String userGender = character.gender;
    bool isMatch = false;

    if (sexuality == 'Heteroseksual') {
      isMatch = (userGender != gender);
    } else if (sexuality == 'Biseksual') {
      isMatch = true;
    } else if (sexuality == 'Gay' || sexuality == 'Lesbian') {
      isMatch = (userGender == gender);
    }

    if (!isMatch) {
      showOutcome('Ajakan Ditolak 💔', '$name menolak ajakanmu karena dia tidak tertarik dengan jenis kelaminmu ($sexuality).');
      return;
    }

    // Peluang sukses didasarkan pada tingkat hubungan
    final int successChance = rel;
    final bool accepted = _random.nextInt(100) < successChance;

    if (accepted) {
      // Set partner
      character.partner = {
        'name': name,
        'relation': 'Pacar',
        'gender': gender,
        'age': classmate['age'] ?? character.age.toString(),
        'relationship': '80',
        'isDeceased': 'false',
      };
      classmate['relationship'] = '85';
      onRefresh();

      DialogHelper.show(
        context: context,
        title: 'Pacaran Baru! ❤️',
        content: Text('Ajakan pacaranmu diterima oleh $name! Sekarang kalian resmi berpacaran.'),
        actions: [
          Builder(
            builder: (dialogContext) => TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context); // Kembali ke list
              },
              child: const Text('OK'),
            ),
          )
        ],
      );
    } else {
      final change = 10 + _random.nextInt(11);
      classmate['relationship'] = (rel - change).clamp(0, 100).toString();
      onRefresh();
      showOutcome('Ajakan Ditolak 💔', '$name merasa hubungan kalian belum cukup dekat untuk berpacaran.');
    }
  }

  /// Menjalankan aksi "Bercinta / Make Love" antara siswa dengan siswa.
  static void bercinta({
    required BuildContext context,
    required Character character,
    required Map<String, String> classmate,
    required VoidCallback onRefresh,
    required Function(String, String) showOutcome,
  }) {
    final String name = classmate['name']!;
    final String gender = classmate['gender']!;
    final String sexuality = classmate['sexuality'] ?? 'Heteroseksual';
    final int rel = int.tryParse(classmate['relationship'] ?? '50') ?? 50;

    // Cek apakah pacar atau bukan
    final bool isPartner = character.partner != null && character.partner!['name'] == name;

    // Peluang mau diajak bercinta
    int chance = isPartner ? (rel - 20) : (rel - 45);
    if (chance < 0) chance = 0;

    final bool accepted = _random.nextInt(100) < chance;

    if (accepted) {
      // Keberhasilan bercinta
      character.happiness = (character.happiness + 15).clamp(0, 100);
      classmate['relationship'] = (rel + 10).clamp(0, 100).toString();
      onRefresh();

      // Cek kemungkinan kehamilan jika lawan jenis
      if (character.gender != gender) {
        final String femaleName = (character.gender == 'Perempuan') ? character.name : name;
        // Peluang hamil 20%
        if (_random.nextInt(100) < 20) {
          if (character.gender == 'Perempuan') {
            character.isPregnant = true;
            character.pregnantByPartnerName = name;
            character.pregnantByPartnerRole = 'Teman Sekelas';
          } else {
            character.partnerIsPregnant = true;
            character.pregnantByPartnerName = name;
            character.pregnantByPartnerRole = 'Teman Sekelas';
          }
        }
      }

      showOutcome('Bercinta Sukses 💖', 'Kamu menghabiskan waktu intim yang menyenangkan bersama $name.');
    } else {
      final change = 10 + _random.nextInt(11);
      classmate['relationship'] = (rel - change).clamp(0, 100).toString();
      onRefresh();
      showOutcome('Bercinta Ditolak 🚫', '$name menolak ajakanmu untuk bercinta. Hubungan kalian menjadi canggung.');
    }
  }
}
