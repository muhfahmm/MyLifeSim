import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

// Imports for gay dating
import 'ajakan_pacaran/gay/ajakan_pacaran_gay_teman_sekolah.dart';
import 'ajakan_pacaran/gay/ajakan_pacaran_gay_guru_sekolah.dart';
import 'ajakan_pacaran/gay/ajakan_pacaran_gay_dosen.dart';
import 'ajakan_pacaran/gay/ajakan_pacaran_gay_coworker.dart';
import 'ajakan_pacaran/gay/ajakan_pacaran_gay_keluarga.dart';

// Imports for lesbian dating
import 'ajakan_pacaran/lesbian/ajakan_pacaran_lesbian_teman_sekolah.dart';
import 'ajakan_pacaran/lesbian/ajakan_pacaran_lesbian_guru_sekolah.dart';
import 'ajakan_pacaran/lesbian/ajakan_pacaran_lesbian_dosen.dart';
import 'ajakan_pacaran/lesbian/ajakan_pacaran_lesbian_coworker.dart';
import 'ajakan_pacaran/lesbian/ajakan_pacaran_lesbian_keluarga.dart';

// Imports for hetero dating
import 'ajakan_pacaran/hetero/ajakan_pacaran_hetero_teman_sekolah.dart';
import 'ajakan_pacaran/hetero/ajakan_pacaran_hetero_guru_sekolah.dart';
import 'ajakan_pacaran/hetero/ajakan_pacaran_hetero_dosen.dart';
import 'ajakan_pacaran/hetero/ajakan_pacaran_hetero_coworker.dart';
import 'ajakan_pacaran/hetero/ajakan_pacaran_hetero_keluarga.dart';

// Imports for biseksual dating
import 'ajakan_pacaran/biseksual/ajakan_pacaran_biseksual_teman_sekolah.dart';
import 'ajakan_pacaran/biseksual/ajakan_pacaran_biseksual_guru_sekolah.dart';
import 'ajakan_pacaran/biseksual/ajakan_pacaran_biseksual_dosen.dart';
import 'ajakan_pacaran/biseksual/ajakan_pacaran_biseksual_coworker.dart';
import 'ajakan_pacaran/biseksual/ajakan_pacaran_biseksual_keluarga.dart';

// Imports for gay ml
import 'ajakan_makelove/gay/ajakan_ml_gay_teman_sekolah.dart';
import 'ajakan_makelove/gay/ajakan_ml_gay_guru_sekolah.dart';
import 'ajakan_makelove/gay/ajakan_ml_gay_dosen.dart';
import 'ajakan_makelove/gay/ajakan_ml_gay_coworker.dart';
import 'ajakan_makelove/gay/ajakan_ml_gay_keluarga.dart';

// Imports for lesbian ml
import 'ajakan_makelove/lesbian/ajakan_ml_lesbian_teman_sekolah.dart';
import 'ajakan_makelove/lesbian/ajakan_ml_lesbian_guru_sekolah.dart';
import 'ajakan_makelove/lesbian/ajakan_ml_lesbian_dosen.dart';
import 'ajakan_makelove/lesbian/ajakan_ml_lesbian_coworker.dart';
import 'ajakan_makelove/lesbian/ajakan_ml_lesbian_keluarga.dart';

// Imports for hetero ml
import 'ajakan_makelove/hetero/ajakan_ml_hetero_teman_sekolah.dart';
import 'ajakan_makelove/hetero/ajakan_ml_hetero_guru_sekolah.dart';
import 'ajakan_makelove/hetero/ajakan_ml_hetero_dosen.dart';
import 'ajakan_makelove/hetero/ajakan_ml_hetero_coworker.dart';
import 'ajakan_makelove/hetero/ajakan_ml_hetero_keluarga.dart';

// Imports for biseksual ml
import 'ajakan_makelove/biseksual/ajakan_ml_biseksual_teman_sekolah.dart';
import 'ajakan_makelove/biseksual/ajakan_ml_biseksual_guru_sekolah.dart';
import 'ajakan_makelove/biseksual/ajakan_ml_biseksual_dosen.dart';
import 'ajakan_makelove/biseksual/ajakan_ml_biseksual_coworker.dart';
import 'ajakan_makelove/biseksual/ajakan_ml_biseksual_keluarga.dart';

// Idol sub-handlers
import 'ajakan_pacaran/gay/idol_gf_bf/ajakan_pacaran_gay_staf_idol.dart';
import 'ajakan_pacaran/gay/idol_gf_bf/ajakan_pacaran_gay_rekan_idol.dart';
import 'ajakan_pacaran/lesbian/idol_gf_bf/ajakan_pacaran_lesbian_staf_idol.dart';
import 'ajakan_pacaran/lesbian/idol_gf_bf/ajakan_pacaran_lesbian_rekan_idol.dart';
import 'ajakan_pacaran/hetero/idol_gf_bf/ajakan_pacaran_hetero_staf_idol.dart';
import 'ajakan_pacaran/hetero/idol_gf_bf/ajakan_pacaran_hetero_rekan_idol.dart';
import 'ajakan_pacaran/biseksual/idol_gf_bf/ajakan_pacaran_biseksual_staf_idol.dart';
import 'ajakan_pacaran/biseksual/idol_gf_bf/ajakan_pacaran_biseksual_rekan_idol.dart';

import 'ajakan_makelove/gay/idol_makelove/ajakan_ml_gay_staf_idol.dart';
import 'ajakan_makelove/gay/idol_makelove/ajakan_ml_gay_rekan_idol.dart';
import 'ajakan_makelove/lesbian/idol_makelove/ajakan_ml_lesbian_staf_idol.dart';
import 'ajakan_makelove/lesbian/idol_makelove/ajakan_ml_lesbian_rekan_idol.dart';
import 'ajakan_makelove/hetero/idol_makelove/ajakan_ml_hetero_staf_idol.dart';
import 'ajakan_makelove/hetero/idol_makelove/ajakan_ml_hetero_rekan_idol.dart';
import 'ajakan_makelove/biseksual/idol_makelove/ajakan_ml_biseksual_staf_idol.dart';
import 'ajakan_makelove/biseksual/idol_makelove/ajakan_ml_biseksual_rekan_idol.dart';

// BA_talent sub-handlers
import 'ajakan_makelove/gay/BA_talent/ajakan_ml_gay_ba_talent.dart';
import 'ajakan_makelove/hetero/BA_talent/ajakan_ml_hetero_ba_talent.dart';
import 'ajakan_makelove/lesbian/BA_talent/ajakan_ml_lesbian_ba_talent.dart';
import 'ajakan_makelove/biseksual/BA_talent/ajakan_ml_biseksual_ba_talent.dart';
import 'ajakan_pacaran/gay/BA_talent/ajakan_pacaran_gay_ba_talent.dart';
import 'ajakan_pacaran/hetero/BA_talent/ajakan_pacaran_hetero_ba_talent.dart';
import 'ajakan_pacaran/lesbian/BA_talent/ajakan_pacaran_lesbian_ba_talent.dart';
import 'ajakan_pacaran/biseksual/BA_talent/ajakan_pacaran_biseksual_ba_talent.dart';

class AjakanResolver {
  static String getPartnerGender(String targetName) {
    if (targetName.startsWith('Ayah')) return 'Laki-laki';
    if (targetName.startsWith('Ibu')) return 'Perempuan';
    final int startIndex = targetName.indexOf('(');
    final int endIndex = targetName.indexOf(')');
    if (startIndex != -1 && endIndex != -1) {
      final String relationText = targetName.substring(startIndex + 1, endIndex).toLowerCase();
      if (relationText.contains('perempuan')) return 'Perempuan';
      if (relationText.contains('laki-laki')) return 'Laki-laki';
    }
    return 'Laki-laki';
  }

  static int getTargetAge(Character character, String targetName, String targetRole) {
    final String cleanName = targetName.toLowerCase();
    if (character.fatherName != null && (cleanName == character.fatherName!.toLowerCase() || cleanName.contains(character.fatherName!.toLowerCase()))) {
      return character.fatherAge ?? 40;
    }
    if (character.motherName != null && (cleanName == character.motherName!.toLowerCase() || cleanName.contains(character.motherName!.toLowerCase()))) {
      return character.motherAge ?? 38;
    }
    if (character.stepFatherName != null && (cleanName == character.stepFatherName!.toLowerCase() || cleanName.contains(character.stepFatherName!.toLowerCase()))) {
      return character.stepFatherAge ?? 40;
    }
    if (character.stepMotherName != null && (cleanName == character.stepMotherName!.toLowerCase() || cleanName.contains(character.stepMotherName!.toLowerCase()))) {
      return character.stepMotherAge ?? 38;
    }
    for (var ex in character.exPartners) {
      if (ex['name'] == targetName) {
        return int.tryParse(ex['age'] ?? '18') ?? 18;
      }
    }
    for (var child in character.children) {
      if (child['name'] == targetName) {
        return int.tryParse(child['age'] ?? '12') ?? 12;
      }
    }
    final List<Map<String, String>> active = [];
    if (character.partner != null) active.add(character.partner!);
    if (character.secondPartner != null) active.add(character.secondPartner!);
    if (character.thirdPartner != null) active.add(character.thirdPartner!);
    if (character.fourthPartner != null) active.add(character.fourthPartner!);
    if (character.fifthPartner != null) active.add(character.fifthPartner!);
    for (var p in active) {
      if (p['name'] == targetName) {
        return int.tryParse(p['age'] ?? '18') ?? 18;
      }
    }
    for (var sib in character.siblings) {
      final String expectedLabel = '${sib['name']} (${sib['relation']})';
      if (expectedLabel == targetName || sib['name'] == targetName) {
        return int.tryParse(sib['age'] ?? '18') ?? 18;
      }
    }
    for (var ext in character.extendedFamily) {
      if (ext['name'] == targetName) {
        return int.tryParse(ext['age'] ?? '18') ?? 18;
      }
    }
    for (var cm in character.classmates) {
      if (cm['name'] == targetName) return int.tryParse(cm['age'] ?? '18') ?? 18;
    }
    for (var cm in character.univClassmates) {
      if (cm['name'] == targetName) return int.tryParse(cm['age'] ?? '18') ?? 18;
    }
    for (var cw in character.coworkers) {
      if (cw['name'] == targetName) return int.tryParse(cw['age'] ?? '18') ?? 18;
    }
    return 18;
  }

  static bool isFamily(String targetName, String targetRole) {
    final String cleanRole = targetRole.toLowerCase();
    final String cleanName = targetName.toLowerCase();
    if (cleanRole.contains('tiri') ||
        cleanRole.contains('mertua') ||
        cleanRole.contains('saudara') ||
        cleanRole.contains('kandung') ||
        cleanRole.contains('kakak') ||
        cleanRole.contains('adik') ||
        cleanRole.contains('anak') ||
        cleanRole.contains('kakek') ||
        cleanRole.contains('nenek') ||
        cleanRole.contains('paman') ||
        cleanRole.contains('bibi') ||
        cleanRole.contains('sepupu') ||
        cleanRole.contains('keponakan') ||
        cleanName.startsWith('ayah') ||
        cleanName.startsWith('ibu') ||
        cleanRole.contains('ayah') ||
        cleanRole.contains('ibu') ||
        cleanRole == 'laki-laki' ||
        cleanRole == 'perempuan') {
      return true;
    }
    return false;
  }

  static bool checkPacaran(Character character, String targetName, String targetRole, Random random) {
    final String myGenderLower = character.gender.trim().toLowerCase();
    final String targetGender = getPartnerGender(targetName);
    final String targetGenderLower = targetGender.trim().toLowerCase();
    final int targetAge = getTargetAge(character, targetName, targetRole);

    final String mySexuality = character.sexuality.trim().toLowerCase();
    final bool isBiseksual = (mySexuality == 'biseksual');

    final bool isGay = (myGenderLower == 'laki-laki' && targetGenderLower == 'laki-laki');
    final bool isLesbian = (myGenderLower == 'perempuan' && targetGenderLower == 'perempuan');

    final Map<String, dynamic> candidate = {
      'name': targetName,
      'relation': targetRole,
      'gender': targetGender,
      'age': targetAge.toString(),
      'role': targetRole,
    };

    Map<String, dynamic>? result;

    final String userJob = character.jobName ?? '';
    final bool isEsport = userJob.startsWith('Pro Player Esport') || userJob.startsWith('Brand Ambassador Esport') || userJob.startsWith('Talent Esports');
    final bool isTargetEsport = targetRole == 'Brand Ambassador' || targetRole == 'CEO' || targetRole == 'Atasan' || targetRole == 'Supervisor' || (targetRole == 'Rekan Kerja' && isEsport);

    if (isTargetEsport) {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualBaTalent.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayBaTalent.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianBaTalent.check(character, candidate, random);
      } else {
        result = AjakanPacaranHeteroBaTalent.check(character, candidate, random);
      }
    } else if (isFamily(targetName, targetRole)) {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualKeluarga.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayKeluarga.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianKeluarga.check(character, candidate, random);
      } else {
        result = AjakanPacaranHeteroKeluarga.check(character, candidate, random);
      }
    } else if (targetRole == 'Guru') {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualGuruSekolah.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayGuruSekolah.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianGuruSekolah.check(character, candidate, random);
      } else {
        result = AjakanPacaranHeteroGuruSekolah.check(character, candidate, random);
      }
    } else if (targetRole == 'Dosen') {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualDosen.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayDosen.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianDosen.check(character, candidate, random);
      } else {
        result = AjakanPacaranHeteroDosen.check(character, candidate, random);
      }
    } else if (targetRole == 'Rekan Kerja') {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualCoworker.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayCoworker.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianCoworker.check(character, candidate, random);
      } else {
        result = AjakanPacaranHeteroCoworker.check(character, candidate, random);
      }
    } else if (targetRole == 'Staf Idol') {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualStafIdol.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayStafIdol.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianStafIdol.check(character, candidate, random);
      } else {
        result = AjakanPacaranHeteroStafIdol.check(character, candidate, random);
      }
    } else if (targetRole == 'Rekan Idol') {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualRekanIdol.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayRekanIdol.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianRekanIdol.check(character, candidate, random);
      } else {
        result = AjakanPacaranHeteroRekanIdol.check(character, candidate, random);
      }
    } else {
      // Default to classmate / school friend
      if (isBiseksual) {
        result = AjakanPacaranBiseksualTemanSekolah.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayTemanSekolah.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianTemanSekolah.check(character, candidate, random);
      } else {
        result = AjakanPacaranHeteroTemanSekolah.check(character, candidate, random);
      }
    }

    return result != null;
  }

  static bool checkMakeLove(Character character, String targetName, String targetRole, Random random) {
    final String myGenderLower = character.gender.trim().toLowerCase();
    final String targetGender = getPartnerGender(targetName);
    final String targetGenderLower = targetGender.trim().toLowerCase();
    final int targetAge = getTargetAge(character, targetName, targetRole);

    final String mySexuality = character.sexuality.trim().toLowerCase();
    final bool isBiseksual = (mySexuality == 'biseksual');

    final bool isGay = (myGenderLower == 'laki-laki' && targetGenderLower == 'laki-laki');
    final bool isLesbian = (myGenderLower == 'perempuan' && targetGenderLower == 'perempuan');

    final Map<String, dynamic> candidate = {
      'name': targetName,
      'relation': targetRole,
      'gender': targetGender,
      'age': targetAge.toString(),
      'role': targetRole,
    };

    Map<String, dynamic>? result;

    final String userJob = character.jobName ?? '';
    final bool isEsport = userJob.startsWith('Pro Player Esport') || userJob.startsWith('Brand Ambassador Esport') || userJob.startsWith('Talent Esports');
    final bool isTargetEsport = targetRole == 'Brand Ambassador' || targetRole == 'CEO' || targetRole == 'Atasan' || targetRole == 'Supervisor' || (targetRole == 'Rekan Kerja' && isEsport);

    if (isTargetEsport) {
      if (isBiseksual) {
        result = AjakanMlBiseksualBaTalent.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayBaTalent.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianBaTalent.check(character, candidate, random);
      } else {
        result = AjakanMlHeteroBaTalent.check(character, candidate, random);
      }
    } else if (isFamily(targetName, targetRole)) {
      if (isBiseksual) {
        result = AjakanMlBiseksualKeluarga.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayKeluarga.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianKeluarga.check(character, candidate, random);
      } else {
        result = AjakanMlHeteroKeluarga.check(character, candidate, random);
      }
    } else if (targetRole == 'Guru') {
      if (isBiseksual) {
        result = AjakanMlBiseksualGuruSekolah.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayGuruSekolah.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianGuruSekolah.check(character, candidate, random);
      } else {
        result = AjakanMlHeteroGuruSekolah.check(character, candidate, random);
      }
    } else if (targetRole == 'Dosen') {
      if (isBiseksual) {
        result = AjakanMlBiseksualDosen.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayDosen.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianDosen.check(character, candidate, random);
      } else {
        result = AjakanMlHeteroDosen.check(character, candidate, random);
      }
    } else if (targetRole == 'Rekan Kerja') {
      if (isBiseksual) {
        result = AjakanMlBiseksualCoworker.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayCoworker.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianCoworker.check(character, candidate, random);
      } else {
        result = AjakanMlHeteroCoworker.check(character, candidate, random);
      }
    } else if (targetRole == 'Staf Idol') {
      if (isBiseksual) {
        result = AjakanMlBiseksualStafIdol.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayStafIdol.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianStafIdol.check(character, candidate, random);
      } else {
        result = AjakanMlHeteroStafIdol.check(character, candidate, random);
      }
    } else if (targetRole == 'Rekan Idol') {
      if (isBiseksual) {
        result = AjakanMlBiseksualRekanIdol.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayRekanIdol.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianRekanIdol.check(character, candidate, random);
      } else {
        result = AjakanMlHeteroRekanIdol.check(character, candidate, random);
      }
    } else {
      // Default to classmate / school friend
      if (isBiseksual) {
        result = AjakanMlBiseksualTemanSekolah.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayTemanSekolah.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianTemanSekolah.check(character, candidate, random);
      } else {
        result = AjakanMlHeteroTemanSekolah.check(character, candidate, random);
      }
    }

    return result != null;
  }
}
