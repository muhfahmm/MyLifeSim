import 'dart:math';

class LogikaUsiaRekanTimtinjumma {
  static int generateUsiaRekanTim(int usiaPemain, Random rand) {
    final int variation = rand.nextInt(7) - 3;
    return (usiaPemain + variation).clamp(16, 38);
  }
}
