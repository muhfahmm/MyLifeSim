import 'dart:math';
import '../character.dart';

extension KecerdasanExtension on Character {
  void changeIntelligence(int delta) {
    intelligence = (intelligence + delta).clamp(0, 100);
  }

  void updateIntelligenceDynamic() {
    final random = Random();

    // 1. Decay dasar acak halus (peluang 40% turun 1, 10% turun 2, sisanya 0)
    int decay = 0;
    final int rollDecay = random.nextInt(100);
    if (rollDecay < 40) {
      decay = 1;
    } else if (rollDecay < 50) {
      decay = 2;
    }

    // 2. Fluktuasi naik/turun acak (50% peluang naik 1-2, 50% peluang turun 1-2)
    int fluctuation = 0;
    if (random.nextBool()) {
      fluctuation = 1 + random.nextInt(2); // naik 1 s/d 2
    } else {
      fluctuation = -(1 + random.nextInt(2)); // turun 1 s/d 2
    }

    // 3. Stres / Kebahagiaan Rendah: Jika Happiness < 30%, turun ekstra -1 s/d -2 per tahun (halus)
    int stressPenalty = 0;
    if (happiness < 30) {
      stressPenalty = 1 + random.nextInt(2);
    }

    // 4. Usia Tua (di atas 50 tahun): -1 per tahun (penuaan otak).
    int ageDecay = 0;
    if (age > 50) {
      ageDecay = 1;
    }

    int totalChange = -decay + fluctuation - stressPenalty - ageDecay;
    changeIntelligence(totalChange);
  }
}
