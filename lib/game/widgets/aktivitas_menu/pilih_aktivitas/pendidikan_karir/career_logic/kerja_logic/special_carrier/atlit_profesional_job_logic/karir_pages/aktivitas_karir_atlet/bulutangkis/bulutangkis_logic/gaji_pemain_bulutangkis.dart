import 'dart:math';

class GajiPemainBulutangkisLogic {
  static int hitungGajiBerdasarkanUsia({
    required int usia,
    required Random rand,
  }) {
    if (usia <= 10) {
      return 1000 + rand.nextInt(500);
    } else if (usia <= 15) {
      return 2500 + rand.nextInt(1500);
    } else if (usia <= 20) {
      return 6000 + rand.nextInt(3000);
    } else if (usia <= 30) {
      return 12000 + rand.nextInt(8000);
    } else {
      return 8000 + rand.nextInt(4000);
    }
  }

  static int hitungTawaranGajiBaru({
    required int currentSalary,
    required int usia,
    required double rating,
    required Random rand,
  }) {
    double multiplier = 1.0;
    if (rating >= 8.5) {
      multiplier = 1.3 + (rand.nextDouble() * 0.2);
    } else if (rating >= 7.0) {
      multiplier = 1.1 + (rand.nextDouble() * 0.15);
    } else {
      multiplier = 0.9 + (rand.nextDouble() * 0.1);
    }

    return (currentSalary * multiplier).round();
  }
}
