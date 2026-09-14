// lib/store_page/fitur_premium/skip_usia/skip_usia_logic.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

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

    // 1. Update usia karakter utama
    character.age = targetAge;

    // 2. Akumulasi gaji pekerjaan utama, part-time, dan bisnis selama tahun yang dilompati
    int totalIncomeEarned = 0;
    int currentJobSalary = character.jobSalary ?? 0;

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
    }

    if (currentJobSalary > 0) {
      character.jobSalary = currentJobSalary;
    }

    if (totalIncomeEarned > 0) {
      character.money += totalIncomeEarned;
    }

    // 3. Update usia seluruh NPC (Orang Tua, Mertua, Pasangan, Anak, Saudara, Teman, Dll.)
    _updateAllNpcAges(character, yearsSkipped);

    // 4. Sync riwayat pendidikan secara otomatis berdasarkan usia baru
    final history = character.educationHistory;
    if (targetAge >= 6) {
      history['SD'] ??= (targetAge >= 12 ? 'Lulus' : 'Belum Lulus');
    }
    if (targetAge >= 12) {
      history['SD'] = 'Lulus';
      history['SMP'] ??= (targetAge >= 15 ? 'Lulus' : 'Belum Lulus');
    }
    if (targetAge >= 15) {
      history['SMP'] = 'Lulus';
      history['SMA'] ??= (targetAge >= 18 ? 'Lulus' : 'Belum Lulus');
    }
    if (targetAge >= 18) {
      history['SMA'] = 'Lulus';
    }

    // Catat log inbox
    String incomeLog = totalIncomeEarned > 0 
        ? ' 💰 Total akumulasi gaji & pendapatan usaha selama $yearsSkipped tahun sebesar ${CurrencySettings.format(totalIncomeEarned)} telah ditambahkan ke saldo keuanganmu!'
        : '';

    character.inbox.insert(
      0,
      '⏩ Fast Forward Usia: Karakter kamu telah berhasil melompat dari usia $oldAge tahun ke $targetAge tahun (+$yearsSkipped tahun)!$incomeLog Seluruh anggota keluarga & kerabat ikut bertambah usia.',
    );

    final String resultMsg = totalIncomeEarned > 0
        ? 'Berhasil melompat ke usia $targetAge tahun (+$yearsSkipped tahun)! Gaji & pendapatan sebesar ${CurrencySettings.format(totalIncomeEarned)} berhasil ditambahkan ke saldo.'
        : 'Berhasil melompat ke usia $targetAge tahun (+$yearsSkipped tahun)!';

    return {
      'success': true,
      'message': resultMsg,
      'oldAge': oldAge,
      'newAge': targetAge,
      'yearsSkipped': yearsSkipped,
      'totalIncomeEarned': totalIncomeEarned,
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
