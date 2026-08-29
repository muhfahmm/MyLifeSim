import 'dart:math';
import '../character.dart';

extension DisiplinExtension on Character {
  void changeDiscipline(int delta) {
    discipline = (discipline + delta).clamp(0, 100);
  }

  void updateDisciplineDynamic() {
    final random = Random();

    // 1. Decay dasar acak halus (peluang 30% turun 1, 10% turun 2, sisanya 0)
    int decay = 0;
    final int rollDecay = random.nextInt(100);
    if (rollDecay < 30) {
      decay = 1;
    } else if (rollDecay < 40) {
      decay = 2;
    }

    // 2. Fluktuasi naik/turun acak (50% peluang naik 1-2, 50% peluang turun 1-2)
    int fluctuation = 0;
    if (random.nextBool()) {
      fluctuation = 1 + random.nextInt(2); // naik 1 s/d 2
    } else {
      fluctuation = -(1 + random.nextInt(2)); // turun 1 s/d 2
    }

    // 3. Pengaruh Kecerdasan: Jika Kecerdasan > 70%, Disiplin naik ekstra +1 s/d +2
    int intelligenceBonus = 0;
    if (intelligence > 70) {
      intelligenceBonus = 1 + random.nextInt(2);
    }

    // 4. Kebahagiaan Rendah (Happiness < 30%): Disiplin turun -1 s/d -2 (halus, tidak langsung banyak)
    int lowHappinessPenalty = 0;
    if (happiness < 30) {
      lowHappinessPenalty = 1 + random.nextInt(2);
    }

    // 5. Kesehatan Buruk (di bawah 30%): -1
    int lowHealthPenalty = 0;
    if (health < 30) {
      lowHealthPenalty = 1;
    }

    int totalChange = -decay + fluctuation + intelligenceBonus - lowHappinessPenalty - lowHealthPenalty;
    changeDiscipline(totalChange);
  }
}
