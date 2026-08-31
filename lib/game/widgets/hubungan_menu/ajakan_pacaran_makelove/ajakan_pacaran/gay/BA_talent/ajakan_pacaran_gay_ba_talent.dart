import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanPacaranGayBaTalent {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
    final int userAge = character.age;

    String userRole = 'Lain';
    final String userJob = character.jobName ?? '';
    if (userJob.startsWith('Talent Esports')) {
      userRole = 'Talent';
    } else if (userJob.startsWith('Brand Ambassador Esport')) {
      userRole = 'BA';
    } else if (userJob.startsWith('Pro Player Esport')) {
      userRole = 'Pro Player';
    } else if (userJob.startsWith('CEO') || userJob.toLowerCase().contains('ceo') || userJob.toLowerCase().contains('operasional') || userJob.toLowerCase().contains('manager')) {
      userRole = 'CEO';
    }

    String targetRole = 'Lain';
    final String candRole = (candidate['role'] ?? '').toString().toLowerCase();
    if (candRole == 'talent' || candRole == 'talent esports' || candRole.contains('talent')) {
      targetRole = 'Talent';
    } else if (candRole == 'ba' || candRole == 'brand ambassador' || candRole.contains('ambassador')) {
      targetRole = 'BA';
    } else if (candRole == 'pro player' || candRole.contains('pro')) {
      targetRole = 'Pro Player';
    } else if (candRole == 'ceo' || candRole == 'atasan' || candRole == 'supervisor' || candRole.contains('ceo')) {
      targetRole = 'CEO';
    } else if (candRole == 'rekan kerja') {
      targetRole = 'Rekan';
    }

    int chance = 35;

    if (targetRole == 'CEO') {
      // Peluang pacaran dengan CEO naik sesuai usia (Gay) - sedikit lebih rendah dari hetero
      if (userAge <= 13) chance = 20;
      else if (userAge == 14) chance = 25;
      else if (userAge == 15) chance = 30;
      else if (userAge == 16) chance = 35;
      else if (userAge == 17) chance = 40;
      else chance = 45; // 18+
    } else if (userRole == 'Talent') {
      if (targetRole == 'Talent') chance = 45;
      else if (targetRole == 'BA') chance = 40;
      else if (targetRole == 'Pro Player') chance = 35;
      else chance = 35; // Rekan
    } else if (userRole == 'BA') {
      if (targetRole == 'Talent') chance = 40;
      else if (targetRole == 'BA') chance = 45;
      else if (targetRole == 'Pro Player') chance = 35;
      else chance = 35; // Rekan
    } else if (userRole == 'Pro Player') {
      if (targetRole == 'Talent') chance = 35;
      else if (targetRole == 'BA') chance = 35;
      else if (targetRole == 'Pro Player') chance = 45;
      else chance = 35; // Rekan
    } else if (userRole == 'CEO') {
      if (targetRole == 'Talent') chance = 30;
      else if (targetRole == 'BA') chance = 30;
      else if (targetRole == 'Pro Player') chance = 30;
    }

    final String rel = candidate['relation'].toString().toLowerCase();
    if (rel.contains('bos') || rel.contains('atasan') || rel.contains('supervisor') || rel.contains('ceo')) {
      // Atasan / Supervisor / Bos / CEO: +5%
      if (targetRole != 'CEO') chance += 5;
    } else if (rel.contains('rekan kerja') || rel.contains('coworker')) {
      // Rekan Kerja Biasa: normal
    } else if (rel.contains('anak magang') || rel.contains('intern')) {
      // Anak Magang / Intern: -5%
      chance = (chance - 5).clamp(0, 100);
    }

    if (rand.nextInt(100) < chance) {
      return {
        'name': candidate['name'],
        'relation': candidate['role'] ?? 'Rekan Esports',
        'type': 'Ajak Pacaran',
        'gender': candidate['gender'] ?? 'Laki-laki',
        'age': candidate['age'] ?? '18',
        'role': candidate['role'] ?? 'BA_talent',
      };
    }
    return null;
  }
}
