import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/academic_logic/school_logic/actions/school_generator.dart';

class SkipUsiaLogic {
  /// Melakukan lompat usia secara instan ke [targetAge] dan memperbarui usia seluruh NPC serta akumulasi gaji
  static Map<String, dynamic> performSkipUsia(Character character, int targetAge) {
    if (targetAge <= character.age) {
      return {
        'success': false,
        'message': 'Usia tujuan harus lebih besar dari usia saat ini (${character.age} tahun).',
      };
    }

    if (targetAge > 100) {
      return {
        'success': false,
        'message': 'Batas maksimum lompat usia adalah 100 tahun.',
      };
    }

    final int oldAge = character.age;
    final int yearsSkipped = targetAge - oldAge;

    // 1. Update usia karakter utama dan sync currentDate
    character.age = targetAge;
    if (character.currentDate != null) {
      character.currentDate = DateTime(
        character.currentDate!.year + yearsSkipped,
        character.currentDate!.month,
        character.currentDate!.day,
      );
    }

    // 2. Akumulasi gaji & jalankan simulasi tahunan (ageUp) selama tahun yang dilompati
    int totalIncomeEarned = 0;
    int currentJobSalary = character.jobSalary ?? 0;
    final List<String> skippedEvents = [];

    // Kembalikan dulu umur sementara ke oldAge agar ageUp() menaikkannya bertahap per tahun
    character.age = oldAge;
    if (character.currentDate != null) {
      character.currentDate = DateTime(
        character.currentDate!.year - yearsSkipped,
        character.currentDate!.month,
        character.currentDate!.day,
      );
    }

    for (int i = 0; i < yearsSkipped; i++) {
      if (!character.isImprisoned) {
        // A. Pekerjaan Utama (Gaji + kenaikan gaji tahunan 3-6%)
        if (character.jobName != null && currentJobSalary > 0) {
          final double raisePercent = 0.03 + (0.03 * (i % 2 == 0 ? 1.0 : 0.5));
          final int raiseAmount = (currentJobSalary * raisePercent).round();
          currentJobSalary += raiseAmount;
          totalIncomeEarned += currentJobSalary;
        }

        // B. Pekerjaan Part-Time
        if (character.partTimeJobName != null && character.partTimeJobSalary != null) {
          totalIncomeEarned += character.partTimeJobSalary!;
        }

        // C. Keuntungan Bisnis
        if (character.hasBusiness && character.businessAnnualProfit > 0) {
          totalIncomeEarned += character.businessAnnualProfit;
        }
      }

      // Jalankan logika tahunan (ageUp) untuk memicu event perceraian ortu, kematian ortu/saudara, pernikahan, kelahiran adik, dll.
      final yearEvents = character.ageUp();
      if (yearEvents.isNotEmpty) {
        skippedEvents.addAll(yearEvents);
      }

      // Jika kesehatan habis (<= 0) atau karakter meninggal, batasi kesehatan ke 0 dan hentikan proses skip usia
      if (character.health <= 0 || !character.isAlive) {
        character.health = 0;
        character.isAlive = false;
        final deathNotice = '💀 Karakter Meninggal: ${character.name} telah meninggal dunia pada usia ${character.age} tahun karena masalah kesehatan/usia.';
        skippedEvents.add(deathNotice);
        character.inbox.insert(0, deathNotice);
        break;
      }
    }

    // Pastikan kesehatan tidak negatif
    if (character.health < 0) {
      character.health = 0;
    }

    final int finalAge = character.age;

    if (currentJobSalary > 0) {
      character.jobSalary = currentJobSalary;
    }

    if (totalIncomeEarned > 0) {
      character.money += totalIncomeEarned;
    }

    // 3. Sync umur NPC jika ada selisih yang belum ter-update
    _updateAllNpcAges(character, 0);

    // 4. Sync riwayat pendidikan & status pendaftaran sekolah secara otomatis (60% Swasta / 40% Negeri)
    final history = character.educationHistory;
    String schoolLog = '';
    if (finalAge >= 6) {
      final bool isSwasta = Random().nextInt(100) < 60; // 60% Swasta, 40% Negeri
      character.schoolType = isSwasta ? 'Swasta' : 'Negeri';

      if (finalAge < 12) {
        history['SD'] = 'Belum Lulus';
        schoolLog = ' 🏫 Kamu otomatis terdaftar di SD (${character.schoolType}).';
      } else if (finalAge < 15) {
        history['SD'] = 'Lulus';
        history['SMP'] = 'Belum Lulus';
        schoolLog = ' 🏫 Kamu telah lulus SD dan otomatis terdaftar di SMP (${character.schoolType}).';
      } else if (finalAge < 18) {
        history['SD'] = 'Lulus';
        history['SMP'] = 'Lulus';
        history['SMA'] = 'Belum Lulus';
        schoolLog = ' 🏫 Kamu telah lulus SD & SMP, dan otomatis terdaftar di SMA (${character.schoolType}).';
      } else {
        history['SD'] = 'Lulus';
        history['SMP'] = 'Lulus';
        history['SMA'] = 'Lulus';
        schoolLog = ' 🎓 Kamu telah menyelesaikan jenjang pendidikan sekolah dasar & menengah (SD, SMP, SMA).';
      }

      if (finalAge < 18) {
        character.classmates.clear();
        character.sdTeachers.clear();
        character.smpTeachers.clear();
        character.smaTeachers.clear();
        character.headmaster = null;
        character.bkTeacher = null;
        SchoolGenerator.generateClassmatesIfEmpty(character);
        SchoolGenerator.generateTeachersIfEmpty(character);
      }
    }

    // Catat log inbox
    String incomeLog = totalIncomeEarned > 0 
        ? ' 💰 Total akumulasi gaji & pendapatan usaha sebesar ${CurrencySettings.format(totalIncomeEarned)} telah ditambahkan ke saldo keuanganmu!'
        : '';

    character.inbox.insert(
      0,
      '⏩ Fast Forward Usia: Karakter kamu telah melompat dari usia $oldAge tahun ke $finalAge tahun!$schoolLog$incomeLog Seluruh anggota keluarga & kerabat ikut bertambah usia.',
    );

    final String resultMsg = character.isAlive
        ? (totalIncomeEarned > 0
            ? 'Berhasil melompat ke usia $finalAge tahun! Gaji & pendapatan sebesar ${CurrencySettings.format(totalIncomeEarned)} berhasil ditambahkan ke saldo.'
            : 'Berhasil melompat ke usia $finalAge tahun!')
        : '⚠️ Karakter telah meninggal dunia pada usia $finalAge tahun saat proses lompat usia!';

    return {
      'success': true,
      'message': resultMsg,
      'oldAge': oldAge,
      'newAge': finalAge,
      'yearsSkipped': finalAge - oldAge,
      'totalIncomeEarned': totalIncomeEarned,
      'skippedEvents': skippedEvents,
      'isDeceased': !character.isAlive,
    };
  }

  /// Memperbarui umur seluruh NPC keluarga dan kerabat sesuai selisih [yearsSkipped]
  static void _updateAllNpcAges(Character character, int yearsSkipped) {
    if (yearsSkipped <= 0) return;

    // A. Orang Tua Kandung & Tiri
    if (character.fatherAge != null && !character.isFatherDeceased) {
      character.fatherAge = character.fatherAge! + yearsSkipped;
    }
    if (character.motherAge != null && !character.isMotherDeceased) {
      character.motherAge = character.motherAge! + yearsSkipped;
    }
    if (character.stepFatherAge != null && !character.isStepFatherDeceased) {
      character.stepFatherAge = character.stepFatherAge! + yearsSkipped;
    }
    if (character.stepMotherAge != null && !character.isStepMotherDeceased) {
      character.stepMotherAge = character.stepMotherAge! + yearsSkipped;
    }

    // B. Mertua
    if (character.fatherInLawAge != null && !character.isFatherInLawDeceased) {
      character.fatherInLawAge = character.fatherInLawAge! + yearsSkipped;
    }
    if (character.motherInLawAge != null && !character.isMotherInLawDeceased) {
      character.motherInLawAge = character.motherInLawAge! + yearsSkipped;
    }

    // Helper untuk update umur pada Map individu (Pasangan/NPC)
    void updateSingleMapAge(Map<String, String>? npcMap) {
      if (npcMap == null) return;
      if (npcMap.containsKey('age') && npcMap['age'] != null) {
        final int currentAge = int.tryParse(npcMap['age'].toString()) ?? 0;
        npcMap['age'] = (currentAge + yearsSkipped).toString();
      }
      if (npcMap.containsKey('spouseAge') && npcMap['spouseAge'] != null) {
        final int currentSpouseAge = int.tryParse(npcMap['spouseAge'].toString()) ?? 0;
        npcMap['spouseAge'] = (currentSpouseAge + yearsSkipped).toString();
      }
    }

    // Helper untuk update list NPC
    void updateNpcList(List<Map<String, String>> list) {
      for (var item in list) {
        updateSingleMapAge(item);
      }
    }

    // C. Pasangan Utama & Selingkuhan
    updateSingleMapAge(character.partner);
    updateSingleMapAge(character.secondPartner);
    updateSingleMapAge(character.thirdPartner);

    // D. Daftar Saudara & Anak
    updateNpcList(character.siblings);
    updateNpcList(character.children);

    // Sync status sekolah seluruh anak sesuai umur terbaru saat Skip Usia
    for (var child in character.children) {
      final int childAge = int.tryParse(child['age'] ?? '0') ?? 0;
      if (childAge >= 6 && (child['schoolSD'] == null || child['schoolSD'] == 'Belum Sekolah')) {
        child['schoolSD'] = 'Sekolah Negeri';
      }
      if (childAge >= 12 && (child['schoolSMP'] == null || child['schoolSMP'] == 'Belum Sekolah')) {
        child['schoolSMP'] = 'Sekolah Negeri';
      }
      if (childAge >= 15 && (child['schoolSMA'] == null || child['schoolSMA'] == 'Belum Sekolah')) {
        child['schoolSMA'] = 'Sekolah Negeri';
      }
      if (childAge >= 18 && (child['choice18'] == null || child['choice18'] == 'Belum')) {
        child['choice18'] = 'Biarkan';
      }
    }

    // E. Kerabat & Teman & Lainnya
    updateNpcList(character.extendedFamily);
    updateNpcList(character.classmates);
    updateNpcList(character.univClassmates);
    updateNpcList(character.friends);
    updateNpcList(character.coworkers);
    updateNpcList(character.secretPartners);
    updateNpcList(character.sdTeachers);
    updateNpcList(character.smpTeachers);
    updateNpcList(character.smaTeachers);
    updateNpcList(character.univLecturers);
    updateNpcList(character.donorRecipients);
  }
}
