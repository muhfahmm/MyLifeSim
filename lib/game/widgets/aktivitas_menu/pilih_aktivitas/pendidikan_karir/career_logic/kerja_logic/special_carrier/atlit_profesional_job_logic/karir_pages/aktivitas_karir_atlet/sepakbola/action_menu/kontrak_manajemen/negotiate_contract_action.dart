// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/action_menu/kontrak_manajemen/negotiate_contract_action.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../../contract_modals.dart';
import '../../sepakbola_logic/gaji_pemain_sepakbola.dart';
import '../../sepakbola_logic/logika_pemain_sepakbola.dart';

class NegotiateContractAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    final Random random = Random();

    // 1. Cek jika sisa kontrak masih panjang (misal 5 atau 4 tahun)
    final int remainingContract = character.athleteContractYears;
    if (LogikaPemainSepakbola.isKontrakMasihPanjang(remainingContract)) {
      showResult(
        'Negosiasi Ditolak 🚫',
        'Manajemen klub menolak tawaranmu! Masa kontrakmu saat ini masih cukup panjang ($remainingContract tahun tersisa). Manajemen tidak ingin memperbarui kontrak di saat kontrak lama masih berlaku lama.',
        Icons.cancel,
        Colors.red,
      );
      return;
    }

    // 2. Cek Cooldown 1 Tahun sejak meneken/memperbarui kontrak terakhir
    if (character.lastContractSignedAge != null &&
        character.age <= character.lastContractSignedAge!) {
      showResult(
        'Kontrak Baru Aktif ⏳',
        'Kamu baru saja menandatangani/memperbarui kontrak! Kamu harus menunggu minimal 1 tahun (musim berikutnya) sebelum bisa mengajukan negosiasi perpanjangan kontrak lagi.',
        Icons.timer_outlined,
        Colors.orange,
      );
      return;
    }

    // 3. Hitung rata-rata rating karir dari statistik musim
    double totalRatingSum = 0.0;
    int ratingCount = 0;
    for (var s in character.athleteSeasonStats) {
      final r = s['rating'];
      if (r is num) {
        totalRatingSum += r.toDouble();
        ratingCount++;
      } else if (r != null) {
        final parsedR = double.tryParse(r.toString());
        if (parsedR != null) {
          totalRatingSum += parsedR;
          ratingCount++;
        }
      }
    }
    final double careerAvgRating = ratingCount > 0 ? (totalRatingSum / ratingCount) : 7.0;
    final int persuadeChance = (careerAvgRating * 10).round().clamp(10, 90);

    final bool success = random.nextInt(100) < persuadeChance;

    if (success) {
      String teamName = 'Klub Usia Muda';
      final String title = character.jobName ?? 'Atlet';
      if (title.contains(' - ')) {
        teamName = title.split(' - ').last.trim();
      }

      final int currentSalary = character.jobSalary ?? GajiPemainSepakbolaLogic.hitungGajiBerdasarkanUsia(usia: character.age, rand: random);
      final int offeredYears = 2 + random.nextInt(3);
      final int offeredSalary = GajiPemainSepakbolaLogic.hitungTawaranGajiBaru(
        currentSalary: currentSalary,
        usia: character.age,
        rating: careerAvgRating,
        rand: random,
      );

      final Map<String, dynamic> offerData = {
        'teamName': teamName,
        'offeredYears': offeredYears,
        'offeredSalary': offeredSalary,
        'currentSalary': currentSalary,
        'jobTitle': title,
      };

      ContractModal.showContractOffer(
        context,
        character: character,
        offerData: offerData,
        onDone: onRefresh,
      );
    } else {
      character.happiness = (character.happiness - 5).clamp(0, 100);
      onRefresh();

      showResult(
        'Manajemen Menolak 🚫',
        'Manajemen klub menolak membicarakan perpanjangan kontrak saat ini. Mereka meminta bukti performa yang lebih konsisten di lapangan.',
        Icons.cancel,
        Colors.red,
      );
    }
  }
}
