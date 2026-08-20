// lib/game/widgets/hubungan_menu/school_sexuality/guru_siswi/teacher_student_romance_logic.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class TeacherStudentRomanceLogic {
  static final Random _random = Random();

  /// Menentukan apakah button "Ajak Pacaran" dan "Bercinta / Make Love" harus ditampilkan untuk Guru.
  /// Muncul ketika user berusia minimal 10 tahun.
  static bool shouldShowTeacherRomance(int userAge) {
    return userAge >= 10;
  }

  /// Menjalankan aksi "Ajak Pacaran" antara siswa dengan guru.
  static void ajakPacaran({
    required BuildContext context,
    required Character character,
    required Map<String, String> teacher,
    required VoidCallback onRefresh,
    required Function(String, String) showOutcome,
  }) {
    final String name = teacher['name']!;
    final String gender = teacher['gender']!;
    final String sexuality = teacher['sexuality'] ?? 'Heteroseksual';
    final int rel = int.tryParse(teacher['relationship'] ?? '50') ?? 50;

    // Cek apakah orientasi seksual guru cocok dengan gender user
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

    // Peluang guru mau pacaran dengan siswa sangat kecil (rel - 40)
    int successChance = rel - 40;
    if (successChance < 5) successChance = 5; // minimal 5%

    final bool accepted = _random.nextInt(100) < successChance;

    if (accepted) {
      // Set partner
      character.partner = {
        'name': name,
        'relation': 'Pacar (Guru)',
        'gender': gender,
        'age': teacher['age'] ?? '30',
        'relationship': '80',
        'isDeceased': 'false',
      };
      teacher['relationship'] = '85';
      onRefresh();

      DialogHelper.show(
        context: context,
        title: 'Pacaran Baru! ❤️',
        content: Text('Sangat mengejutkan! Guru $name menerima ajakan pacaranmu secara rahasia!'),
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
      final change = 15 + _random.nextInt(11);
      teacher['relationship'] = (rel - change).clamp(0, 100).toString();
      onRefresh();
      showOutcome(
        'Ajakan Ditolak 🚫',
        '$name menolak keras ajakanmu dan mengingatkan bahwa pacaran antara guru dan siswa adalah tindakan yang melanggar kode etik!',
      );
    }
  }

  /// Menjalankan aksi "Bercinta / Make Love" antara siswa dengan guru.
  static void bercinta({
    required BuildContext context,
    required Character character,
    required Map<String, String> teacher,
    required VoidCallback onRefresh,
    required Function(String, String) showOutcome,
  }) {
    final String name = teacher['name']!;
    final String gender = teacher['gender']!;
    final int rel = int.tryParse(teacher['relationship'] ?? '50') ?? 50;

    // Cek apakah pacar atau bukan
    final bool isPartner = character.partner != null && character.partner!['name'] == name;

    // Peluang mau diajak bercinta sangat sulit
    int chance = isPartner ? (rel - 30) : (rel - 60);
    if (chance < 0) chance = 0;

    final bool accepted = _random.nextInt(100) < chance;

    if (accepted) {
      character.happiness = (character.happiness + 20).clamp(0, 100);
      teacher['relationship'] = (rel + 10).clamp(0, 100).toString();
      onRefresh();

      // Cek kemungkinan kehamilan jika lawan jenis
      if (character.gender != gender) {
        final String femaleName = (character.gender == 'Perempuan') ? character.name : name;
        // Peluang hamil 20%
        if (_random.nextInt(100) < 20) {
          if (character.gender == 'Perempuan') {
            character.isPregnant = true;
            character.pregnantByPartnerName = name;
            character.pregnantByPartnerRole = 'Guru';
          } else {
            character.partnerIsPregnant = true;
            character.pregnantByPartnerName = name;
            character.pregnantByPartnerRole = 'Guru';
          }
        }
      }

      showOutcome('Bercinta Sukses 💖', 'Secara rahasia, kamu dan guru $name menghabiskan waktu intim bersama.');
    } else {
      final change = 15 + _random.nextInt(11);
      teacher['relationship'] = (rel - change).clamp(0, 100).toString();
      onRefresh();
      showOutcome(
        'Bercinta Ditolak 🚫',
        '$name menolak ajakanmu secara tegas dan memperingatkanmu agar menjaga batasan profesional!',
      );
    }
  }
}
