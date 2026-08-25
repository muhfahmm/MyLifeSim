import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlHeteroRekanIdol {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final String rel = candidate['relation'].toString().toLowerCase();
    int chance = 15;

    if (rel.contains('main member') || rel.contains('utama') || rel.contains('center')) {
      // Main Member / Center: +10%
      chance += 10;
    } else if (rel.contains('trainee')) {
      // Trainee Baru: -5%
      chance = (chance - 5).clamp(0, 100);
    } else if (rel.contains('leader') || rel.contains('pemimpin')) {
      // Group Leader: +12%
      chance += 12;
    }

    if (rand.nextDouble() < (chance / 100.0)) {
      return {
        'name': '${candidate['name']} (Rekan Idol)',
        'relation': 'Rekan Idol',
        'type': 'Bercinta',
        'gender': candidate['gender'] ?? 'Laki-laki',
        'age': candidate['age'] ?? '16',
        'role': 'Rekan Idol',
      };
    }
    return null;
  }
}
