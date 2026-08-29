import 'dart:math';
import '../character.dart';

extension DisiplinExtension on Character {
  void changeDiscipline(int delta) {
    discipline = (discipline + delta).clamp(0, 100);
  }

  void updateDisciplineDynamic() {
    final random = Random();

    // 1. Pengaruh Kecerdasan: Jika Kecerdasan > 70%, Disiplin naik ekstra +1
    int intelligenceBonus = 0;
    if (intelligence > 70) {
      intelligenceBonus = 1;
    }

    // 2. Kebahagiaan Rendah (Happiness < 30%): Disiplin turun -3 s/d -5 drastis
    int lowHappinessPenalty = 0;
    if (happiness < 30) {
      lowHappinessPenalty = 3 + random.nextInt(3); // 3 to 5
    }

    // 3. Kesehatan Buruk (di bawah 30%): -1
    int lowHealthPenalty = 0;
    if (health < 30) {
      lowHealthPenalty = 1;
    }

    int totalChange = intelligenceBonus - lowHappinessPenalty - lowHealthPenalty;
    if (totalChange != 0) {
      changeDiscipline(totalChange);
    }
  }
}
