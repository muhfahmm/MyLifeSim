// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/basket/basket_logic/perpanjangan_kontrak_basket_logic.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'gaji_pemain_basket.dart';
import 'logika_pemain_basket.dart';

class PerpanjanganKontrakBasketLogic {
  static void evaluasiPerpanjanganKontrak({
    required Character character,
    required String teamName,
    required String jobTitle,
    required double currentSeasonRating,
    required Random rand,
  }) {
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
    final int extensionChance = (careerAvgRating * 10).round().clamp(5, 95);
    final bool getContractExtension = rand.nextInt(100) < extensionChance;

    if (getContractExtension) {
      final validYears = LogikaPemainBasket.getOpsiDurasiKontrak(character.age);
      final int extensionYears = validYears[rand.nextInt(validYears.length)];
      final int currentSalary = character.jobSalary ?? GajiPemainBasketLogic.hitungGajiBerdasarkanUsia(usia: character.age, rand: rand);
      
      final int offeredSalary = GajiPemainBasketLogic.hitungTawaranGajiBaru(
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
      final String contractNotice = '⚠️ Kontrak Berakhir & Bebas Transfer!\n'
          'Kontrakmu bersama $teamName telah habis dan manajemen klub basket tidak memperpanjang kontrakmu. Kamu kini berstatus Free Agent.';
      character.pendingAthleteContractNotice = contractNotice;
      character.inbox.add(contractNotice);
      character.resignJob();
    }
  }
}
