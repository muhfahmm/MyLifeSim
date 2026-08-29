import 'dart:math';
import '../character.dart';

extension KebahagiaanExtension on Character {
  void changeHappiness(int delta) {
    happiness = (happiness + delta).clamp(0, 100);
  }

  void updateHappinessDynamic() {
    final random = Random();

    // 1. Decay dasar acak halus (peluang 25% turun 1, 5% turun 2, sisanya 0)
    int decay = 0;
    final int rollDecay = random.nextInt(100);
    if (rollDecay < 25) {
      decay = 1;
    } else if (rollDecay < 30) {
      decay = 2;
    }

    // 2. Fluktuasi naik/turun acak (50% peluang naik 1-2, 50% peluang turun 1-2)
    int fluctuation = 0;
    if (random.nextBool()) {
      fluctuation = 1 + random.nextInt(2); // naik 1 s/d 2
    } else {
      fluctuation = -(1 + random.nextInt(2)); // turun 1 s/d 2
    }

    // 3. Pengaruh Kesehatan: Jika Kesehatan buruk (Health < 30%), Kebahagiaan turun ekstra -1 s/d -2
    int healthPenalty = 0;
    if (health < 30) {
      healthPenalty = 1 + random.nextInt(2);
    }

    // 4. Pengaruh Keuangan: Jika Uang = 0 atau negatif, turun ekstra -1
    int financePenalty = 0;
    if (money <= 0) {
      financePenalty = 1;
    }

    int totalChange = -decay + fluctuation - healthPenalty - financePenalty;
    changeHappiness(totalChange);
  }
}
