import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'gaji_pemain_sepakbola.dart';
import 'logika_pemain_sepakbola.dart';

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
      final validYears = LogikaPemainSepakbola.getOpsiDurasiKontrak(character.age);
      final int extensionYears = validYears[rand.nextInt(validYears.length)];
      final int currentSalary = character.jobSalary ?? GajiPemainSepakbolaLogic.hitungGajiBerdasarkanUsia(usia: character.age, rand: rand);
      
      final int offeredSalary = GajiPemainSepakbolaLogic.hitungTawaranGajiBaru(
        currentSalary: currentSalary,
        usia: character.age,
        rating: careerAvgRating,
        rand: rand,
      );

      character.pendingContractOffer = {
        'teamName': teamName,
        'offeredYears': extensionYears,
        'offeredSalary': offeredSalary,
        'currentSalary': currentSalary,
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
