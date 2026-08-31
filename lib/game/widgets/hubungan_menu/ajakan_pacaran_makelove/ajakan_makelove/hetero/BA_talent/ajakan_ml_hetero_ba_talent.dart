import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class AjakanMlHeteroBaTalent {
  static Map<String, dynamic>? check(Character character, Map<String, dynamic> candidate, Random rand) {
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
    } else if (candRole == 'pro player' || candRole == 'rekan kerja' || candRole.contains('pro')) {
      targetRole = 'Pro Player';
    } else if (candRole == 'ceo' || candRole == 'atasan' || candRole == 'supervisor' || candRole.contains('ceo')) {
      targetRole = 'CEO';
    }

    double chance = 0.40;
    if (userRole == 'Talent') {
      if (targetRole == 'Talent') chance = 0.50;
      else if (targetRole == 'BA') chance = 0.45;
      else if (targetRole == 'Pro Player') chance = 0.40;
      else if (targetRole == 'CEO') chance = 0.30;
    } else if (userRole == 'BA') {
      if (targetRole == 'Talent') chance = 0.45;
      else if (targetRole == 'BA') chance = 0.50;
      else if (targetRole == 'Pro Player') chance = 0.40;
      else if (targetRole == 'CEO') chance = 0.30;
    } else if (userRole == 'Pro Player') {
      if (targetRole == 'Talent') chance = 0.40;
      else if (targetRole == 'BA') chance = 0.40;
      else if (targetRole == 'Pro Player') chance = 0.50;
      else if (targetRole == 'CEO') chance = 0.30;
    } else if (userRole == 'CEO') {
      if (targetRole == 'Talent') chance = 0.35;
      else if (targetRole == 'BA') chance = 0.35;
      else if (targetRole == 'Pro Player') chance = 0.35;
      else if (targetRole == 'CEO') chance = 0.40;
    }

    if (rand.nextDouble() < chance) {
      return {
        'name': candidate['name'],
        'relation': candidate['role'] ?? 'Rekan Esports',
        'type': 'Bercinta',
        'gender': candidate['gender'] ?? 'Perempuan',
        'age': candidate['age'] ?? '18',
        'role': candidate['role'] ?? 'BA_talent',
      };
    }
    return null;
  }
}
