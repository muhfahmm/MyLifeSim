import 'dart:math';
import '../character.dart';

extension KesehatanExtension on Character {
  void changeHealth(int delta) {
    health = (health + delta).clamp(0, 100);
  }

  void updateHealthDynamic({bool isDaily = false}) {
    final random = Random();
    
    // 1. Decay dasar acak (1, 2, atau 3 untuk dewasa, 0-1 untuk anak-anak)
    int decay = 0;
    if (isDaily) {
      if (random.nextInt(100) < 10) {
        decay = 1;
      }
    } else {
      if (age < 12) {
        // Anak-anak: decay lebih kecil (peluang 20% untuk berkurang 1, sisanya 0)
        decay = random.nextInt(100) < 20 ? 1 : 0;
      } else {
        // Dewasa: Decay tahunan (Weighted: 40% dapat 1, 40% dapat 2, 20% dapat 3)
        final int roll = random.nextInt(100);
        decay = roll < 40 ? 1 : (roll < 80 ? 2 : 3);
      }
    }
    
    // 2. Bonus regenerasi atau penalti dari kebahagiaan
    int regen = 0;
    if (happiness >= 80) {
      // Sangat Bahagia: Regenerasi kuat (+2 sampai +4 pertahun, atau 20% peluang +1 perhari)
      regen = isDaily ? (random.nextInt(100) < 20 ? 1 : 0) : (2 + random.nextInt(3));
    } else if (happiness >= 65) {
      // Cukup Bahagia: Regenerasi ringan (+1 sampai +2 pertahun, atau 10% peluang +1 perhari)
      regen = isDaily ? (random.nextInt(100) < 10 ? 1 : 0) : (1 + random.nextInt(2));
    } else if (happiness >= 50) {
      // Biasa saja: 0
      regen = 0;
    } else {
      // Stres/Sedih: Penalti ekstra
      int penalty = 0;
      if (isDaily) {
        penalty = random.nextInt(100) < 10 ? 1 : 0;
      } else {
        if (age < 12) {
          // Penalti anak-anak sangat kecil (peluang 20% untuk berkurang 1, sisanya 0)
          penalty = random.nextInt(100) < 20 ? 1 : 0;
        } else {
          // Dewasa: berkurang 1 sampai 3
          penalty = 1 + random.nextInt(3);
        }
      }
      regen = -penalty;
    }
    
    // 3. Terapkan perubahan kesehatan
    health = (health - decay + regen).clamp(0, 100);
  }
}
