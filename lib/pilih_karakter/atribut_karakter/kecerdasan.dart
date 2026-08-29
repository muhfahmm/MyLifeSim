import 'dart:math';
import '../character.dart';

extension KecerdasanExtension on Character {
  void changeIntelligence(int delta) {
    intelligence = (intelligence + delta).clamp(0, 100);
  }

  void updateIntelligenceDynamic() {
    final random = Random();

    // 1. Stres / Kebahagiaan Rendah: Jika Happiness < 30%, kecerdasan otomatis turun -2 s/d -4 per tahun karena sulit berkonsentrasi.
    int stressPenalty = 0;
    if (happiness < 30) {
      stressPenalty = 2 + random.nextInt(3); // 2 to 4
    }

    // 2. Usia Tua (di atas 50 tahun): -1 per tahun (penuaan otak).
    int ageDecay = 0;
    if (age > 50) {
      ageDecay = 1;
    }

    int totalChange = -stressPenalty - ageDecay;
    if (totalChange != 0) {
      changeIntelligence(totalChange);
    }
  }
}
