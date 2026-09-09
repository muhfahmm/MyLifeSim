// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/sepakbola_logic/perpanjangan_kontrak_logic.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class PerpanjanganKontrakLogic {
  /// Memeriksa dan menguji evaluasi perpanjangan kontrak saat durasi kontrak habis.
  /// Menghitung peluang berdasarkan rating karir (Rating 8.0 = 80%, 7.0 = 70%, dst).
  static void evaluasiPerpanjanganKontrak({
    required Character character,
    required String teamName,
    required String jobTitle,
    required double currentSeasonRating,
    required Random rand,
  }) {
    // Hitung rata-rata rating karir dari akumulasi riwayat musim
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

    final double careerAvgRating = ratingCount > 0 ? (totalRatingSum / ratingCount) : currentSeasonRating;
    // Peluang diperpanjang kontrak dihitung langsung dari rating karir (Rating 8.0 = 80%, 7.0 = 70%, dst)
    final int extensionChance = (careerAvgRating * 10).round().clamp(5, 95);
    final bool getContractExtension = rand.nextInt(100) < extensionChance;

    if (getContractExtension) {
      final int extensionYears = 2 + rand.nextInt(3); // 2 s/d 4 Tahun Kontrak Baru
      final int raisePercent = 5 + rand.nextInt(16); // 5% s/d 20% kenaikan gaji
      final int offeredSalary = ((character.jobSalary ?? 8000) * (1 + (raisePercent / 100))).round();

      character.pendingContractOffer = {
        'teamName': teamName,
        'offeredYears': extensionYears,
        'offeredSalary': offeredSalary,
        'currentSalary': character.jobSalary ?? 8000,
        'jobTitle': jobTitle,
      };
    } else {
      // Kontrak habis & tidak diperpanjang -> Karakter Menjadi Pengangguran
      final String contractNotice = '⚠️ Kontrak Berakhir & Bebas Transfer!\n'
          'Kontrakmu bersama $teamName telah habis dan manajemen tidak memberikan tawaran perpanjangan kontrak. Kamu kini berstatus Pengangguran (Free Agent) dan dapat melamar ke klub lain.';
      character.pendingAthleteContractNotice = contractNotice;
      character.inbox.add(contractNotice);
      character.resignJob();
    }
  }
}
