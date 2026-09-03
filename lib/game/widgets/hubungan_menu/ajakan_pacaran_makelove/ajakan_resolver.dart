// lib/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_resolver.dart

import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/pilih_karakter/settings/proposal_percentage_settings.dart';

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

// Imports for hetero perempuan dating
import 'ajakan_pacaran/hetero/hetero_perempuan/ajakan_pacaran_hetero_perempuan_teman_sekolah.dart';
import 'ajakan_pacaran/hetero/hetero_perempuan/ajakan_pacaran_hetero_perempuan_guru_sekolah.dart';
import 'ajakan_pacaran/hetero/hetero_perempuan/ajakan_pacaran_hetero_perempuan_dosen.dart';
import 'ajakan_pacaran/hetero/hetero_perempuan/ajakan_pacaran_hetero_perempuan_coworker.dart';
import 'ajakan_pacaran/hetero/hetero_perempuan/ajakan_pacaran_hetero_perempuan_keluarga.dart';

// Imports for hetero laki dating
import 'ajakan_pacaran/hetero/hetero_laki/ajakan_pacaran_hetero_laki_teman_sekolah.dart';
import 'ajakan_pacaran/hetero/hetero_laki/ajakan_pacaran_hetero_laki_guru_sekolah.dart';
import 'ajakan_pacaran/hetero/hetero_laki/ajakan_pacaran_hetero_laki_dosen.dart';
import 'ajakan_pacaran/hetero/hetero_laki/ajakan_pacaran_hetero_laki_coworker.dart';
import 'ajakan_pacaran/hetero/hetero_laki/ajakan_pacaran_hetero_laki_keluarga.dart';

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

// Imports for hetero perempuan ml
import 'ajakan_makelove/hetero/hetero_perempuan/ajakan_ml_hetero_perempuan_teman_sekolah.dart';
import 'ajakan_makelove/hetero/hetero_perempuan/ajakan_ml_hetero_perempuan_guru_sekolah.dart';
import 'ajakan_makelove/hetero/hetero_perempuan/ajakan_ml_hetero_perempuan_dosen.dart';
import 'ajakan_makelove/hetero/hetero_perempuan/ajakan_ml_hetero_perempuan_coworker.dart';
import 'ajakan_makelove/hetero/hetero_perempuan/ajakan_ml_hetero_perempuan_keluarga.dart';

// Imports for hetero laki ml
import 'ajakan_makelove/hetero/hetero_laki/ajakan_ml_hetero_laki_teman_sekolah.dart';
import 'ajakan_makelove/hetero/hetero_laki/ajakan_ml_hetero_laki_guru_sekolah.dart';
import 'ajakan_makelove/hetero/hetero_laki/ajakan_ml_hetero_laki_dosen.dart';
import 'ajakan_makelove/hetero/hetero_laki/ajakan_ml_hetero_laki_coworker.dart';
import 'ajakan_makelove/hetero/hetero_laki/ajakan_ml_hetero_laki_keluarga.dart';

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
import 'ajakan_pacaran/hetero/hetero_perempuan/idol_gf_bf/ajakan_pacaran_hetero_perempuan_staf_idol.dart';
import 'ajakan_pacaran/hetero/hetero_perempuan/idol_gf_bf/ajakan_pacaran_hetero_perempuan_rekan_idol.dart';
import 'ajakan_pacaran/hetero/hetero_laki/idol_gf_bf/ajakan_pacaran_hetero_laki_staf_idol.dart';
import 'ajakan_pacaran/hetero/hetero_laki/idol_gf_bf/ajakan_pacaran_hetero_laki_rekan_idol.dart';
import 'ajakan_pacaran/biseksual/idol_gf_bf/ajakan_pacaran_biseksual_staf_idol.dart';
import 'ajakan_pacaran/biseksual/idol_gf_bf/ajakan_pacaran_biseksual_rekan_idol.dart';

import 'ajakan_makelove/gay/idol_makelove/ajakan_ml_gay_staf_idol.dart';
import 'ajakan_makelove/gay/idol_makelove/ajakan_ml_gay_rekan_idol.dart';
import 'ajakan_makelove/lesbian/idol_makelove/ajakan_ml_lesbian_staf_idol.dart';
import 'ajakan_makelove/lesbian/idol_makelove/ajakan_ml_lesbian_rekan_idol.dart';
import 'ajakan_makelove/hetero/hetero_perempuan/idol_makelove/ajakan_ml_hetero_perempuan_staf_idol.dart';
import 'ajakan_makelove/hetero/hetero_perempuan/idol_makelove/ajakan_ml_hetero_perempuan_rekan_idol.dart';
import 'ajakan_makelove/hetero/hetero_laki/idol_makelove/ajakan_ml_hetero_laki_staf_idol.dart';
import 'ajakan_makelove/hetero/hetero_laki/idol_makelove/ajakan_ml_hetero_laki_rekan_idol.dart';
import 'ajakan_makelove/biseksual/idol_makelove/ajakan_ml_biseksual_staf_idol.dart';
import 'ajakan_makelove/biseksual/idol_makelove/ajakan_ml_biseksual_rekan_idol.dart';

// BA_talent sub-handlers
import 'ajakan_makelove/gay/BA_talent/ajakan_ml_gay_ba_talent.dart';
import 'ajakan_makelove/hetero/hetero_perempuan/BA_talent/ajakan_ml_hetero_perempuan_ba_talent.dart';
import 'ajakan_makelove/hetero/hetero_laki/BA_talent/ajakan_ml_hetero_laki_ba_talent.dart';
import 'ajakan_makelove/lesbian/BA_talent/ajakan_ml_lesbian_ba_talent.dart';
import 'ajakan_makelove/biseksual/BA_talent/ajakan_ml_biseksual_ba_talent.dart';
import 'ajakan_pacaran/gay/BA_talent/ajakan_pacaran_gay_ba_talent.dart';
import 'ajakan_pacaran/hetero/hetero_perempuan/BA_talent/ajakan_pacaran_hetero_perempuan_ba_talent.dart';
import 'ajakan_pacaran/hetero/hetero_laki/BA_talent/ajakan_pacaran_hetero_laki_ba_talent.dart';
import 'ajakan_pacaran/lesbian/BA_talent/ajakan_pacaran_lesbian_ba_talent.dart';
import 'ajakan_pacaran/biseksual/BA_talent/ajakan_pacaran_biseksual_ba_talent.dart';

class AjakanResolver {
  static String getPartnerGender(String targetName) {
    final String nameLower = targetName.toLowerCase();

    if (nameLower.contains('ibu') ||
        nameLower.contains('bibi') ||
        nameLower.contains('nenek') ||
        nameLower.contains('perempuan') ||
        nameLower.contains('wanita')) {
      return 'Perempuan';
    }

    if (nameLower.contains('ayah') ||
        nameLower.contains('paman') ||
        nameLower.contains('kakek') ||
        nameLower.contains('laki') ||
        nameLower.contains('pria')) {
      return 'Laki-laki';
    }

    return (Random().nextBool()) ? 'Laki-laki' : 'Perempuan';
  }

  static Map<String, dynamic>? tryResolveGeneralProposal(
      Character character, Random random, List<Map<String, dynamic>> targetCandidates) {
    if (targetCandidates.isEmpty) return null;

    final String sexuality = character.sexuality.trim().toLowerCase();
    final bool isBiseksual = sexuality == 'biseksual';
    final bool isGay = sexuality == 'gay';
    final bool isLesbian = sexuality == 'lesbian';

    final String myGenderLower = character.gender.trim().toLowerCase();
    final bool isFemaleUser = myGenderLower == 'perempuan' || myGenderLower == 'female';

    List<Map<String, dynamic>> validCandidates = [];
    for (var candidate in targetCandidates) {
      final String targetGenderLower = (candidate['gender'] ?? '').toString().toLowerCase();

      if (isBiseksual) {
        validCandidates.add(candidate);
      } else if (isGay) {
        if (myGenderLower == 'laki-laki' && targetGenderLower == 'laki-laki') {
          validCandidates.add(candidate);
        }
      } else if (isLesbian) {
        if (myGenderLower == 'perempuan' && targetGenderLower == 'perempuan') {
          validCandidates.add(candidate);
        }
      } else {
        if (myGenderLower == 'perempuan' && targetGenderLower == 'laki-laki') {
          validCandidates.add(candidate);
        } else if (myGenderLower == 'laki-laki' && targetGenderLower == 'perempuan') {
          validCandidates.add(candidate);
        }
      }
    }

    if (validCandidates.isEmpty) return null;

    validCandidates.shuffle(random);
    final chosenCandidate = validCandidates.first;

    final String targetName = chosenCandidate['name'] ?? 'Seseorang';
    final String targetRole = chosenCandidate['role'] ?? chosenCandidate['relation'] ?? 'Kenalan';
    final String targetGender = chosenCandidate['gender'] ?? getPartnerGender(targetName);
    final int targetAge = int.tryParse(chosenCandidate['age']?.toString() ?? '18') ?? 18;

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
        result = isFemaleUser
            ? AjakanPacaranHeteroPerempuanBaTalent.check(character, candidate, random)
            : AjakanPacaranHeteroLakiBaTalent.check(character, candidate, random);
      }
    } else if (isFamily(targetName, targetRole)) {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualKeluarga.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayKeluarga.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianKeluarga.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanPacaranHeteroPerempuanKeluarga.check(character, candidate, random)
            : AjakanPacaranHeteroLakiKeluarga.check(character, candidate, random);
      }
    } else if (targetRole == 'Guru') {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualGuruSekolah.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayGuruSekolah.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianGuruSekolah.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanPacaranHeteroPerempuanGuruSekolah.check(character, candidate, random)
            : AjakanPacaranHeteroLakiGuruSekolah.check(character, candidate, random);
      }
    } else if (targetRole == 'Dosen') {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualDosen.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayDosen.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianDosen.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanPacaranHeteroPerempuanDosen.check(character, candidate, random)
            : AjakanPacaranHeteroLakiDosen.check(character, candidate, random);
      }
    } else if (targetRole == 'Rekan Kerja') {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualCoworker.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayCoworker.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianCoworker.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanPacaranHeteroPerempuanCoworker.check(character, candidate, random)
            : AjakanPacaranHeteroLakiCoworker.check(character, candidate, random);
      }
    } else if (targetRole == 'Staf Idol') {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualStafIdol.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayStafIdol.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianStafIdol.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanPacaranHeteroPerempuanStafIdol.check(character, candidate, random)
            : AjakanPacaranHeteroLakiStafIdol.check(character, candidate, random);
      }
    } else if (targetRole == 'Rekan Idol') {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualRekanIdol.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayRekanIdol.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianRekanIdol.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanPacaranHeteroPerempuanRekanIdol.check(character, candidate, random)
            : AjakanPacaranHeteroLakiRekanIdol.check(character, candidate, random);
      }
    } else {
      if (isBiseksual) {
        result = AjakanPacaranBiseksualTemanSekolah.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanPacaranGayTemanSekolah.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanPacaranLesbianTemanSekolah.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanPacaranHeteroPerempuanTemanSekolah.check(character, candidate, random)
            : AjakanPacaranHeteroLakiTemanSekolah.check(character, candidate, random);
      }
    }

    if (result != null) {
      final double chanceValue = ProposalPercentageSettings.getChance(
        targetRole,
        result['type'] ?? 'Ajak Pacaran',
        gender: character.gender,
        sexuality: character.sexuality,
      );

      if (chanceValue <= 0.0) return null;

      result['chance'] = chanceValue;
      return result;
    }

    return null;
  }

  static bool isFamily(String name, String role) {
    final String nameLower = name.toLowerCase();
    final String roleLower = role.toLowerCase();

    if (roleLower.contains('keluarga') || roleLower.contains('tiri')) return true;

    return nameLower.contains('ayah') ||
        nameLower.contains('ibu') ||
        nameLower.contains('kakak') ||
        nameLower.contains('adik') ||
        nameLower.contains('paman') ||
        nameLower.contains('bibi') ||
        nameLower.contains('kakek') ||
        nameLower.contains('nenek') ||
        nameLower.contains('sepupu') ||
        nameLower.contains('anak') ||
        nameLower.contains('keponakan');
  }

  static bool checkPacaran(Character character, String targetName, String targetRole, Random random) {
    final candidateList = [
      {
        'name': targetName,
        'relation': targetRole,
        'gender': getPartnerGender(targetName),
        'age': '18',
        'role': targetRole,
      }
    ];
    final res = tryResolveGeneralProposal(character, random, candidateList);
    return res != null;
  }

  static bool checkMakeLove(Character character, String targetName, String targetRole, Random random) {
    final candidate = {
      'name': targetName,
      'relation': targetRole,
      'gender': getPartnerGender(targetName),
      'age': '18',
      'role': targetRole,
    };

    final String sexuality = character.sexuality.trim().toLowerCase();
    final bool isBiseksual = sexuality == 'biseksual';
    final bool isGay = sexuality == 'gay';
    final bool isLesbian = sexuality == 'lesbian';

    final String myGenderLower = character.gender.trim().toLowerCase();
    final bool isFemaleUser = myGenderLower == 'perempuan' || myGenderLower == 'female';

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
        result = isFemaleUser
            ? AjakanMlHeteroPerempuanBaTalent.check(character, candidate, random)
            : AjakanMlHeteroLakiBaTalent.check(character, candidate, random);
      }
    } else if (isFamily(targetName, targetRole)) {
      if (isBiseksual) {
        result = AjakanMlBiseksualKeluarga.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayKeluarga.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianKeluarga.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanMlHeteroPerempuanKeluarga.check(character, candidate, random)
            : AjakanMlHeteroLakiKeluarga.check(character, candidate, random);
      }
    } else if (targetRole == 'Guru') {
      if (isBiseksual) {
        result = AjakanMlBiseksualGuruSekolah.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayGuruSekolah.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianGuruSekolah.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanMlHeteroPerempuanGuruSekolah.check(character, candidate, random)
            : AjakanMlHeteroLakiGuruSekolah.check(character, candidate, random);
      }
    } else if (targetRole == 'Dosen') {
      if (isBiseksual) {
        result = AjakanMlBiseksualDosen.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayDosen.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianDosen.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanMlHeteroPerempuanDosen.check(character, candidate, random)
            : AjakanMlHeteroLakiDosen.check(character, candidate, random);
      }
    } else if (targetRole == 'Rekan Kerja') {
      if (isBiseksual) {
        result = AjakanMlBiseksualCoworker.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayCoworker.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianCoworker.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanMlHeteroPerempuanCoworker.check(character, candidate, random)
            : AjakanMlHeteroLakiCoworker.check(character, candidate, random);
      }
    } else if (targetRole == 'Staf Idol') {
      if (isBiseksual) {
        result = AjakanMlBiseksualStafIdol.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayStafIdol.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianStafIdol.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanMlHeteroPerempuanStafIdol.check(character, candidate, random)
            : AjakanMlHeteroLakiStafIdol.check(character, candidate, random);
      }
    } else if (targetRole == 'Rekan Idol') {
      if (isBiseksual) {
        result = AjakanMlBiseksualRekanIdol.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayRekanIdol.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianRekanIdol.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanMlHeteroPerempuanRekanIdol.check(character, candidate, random)
            : AjakanMlHeteroLakiRekanIdol.check(character, candidate, random);
      }
    } else {
      if (isBiseksual) {
        result = AjakanMlBiseksualTemanSekolah.check(character, candidate, random);
      } else if (isGay) {
        result = AjakanMlGayTemanSekolah.check(character, candidate, random);
      } else if (isLesbian) {
        result = AjakanMlLesbianTemanSekolah.check(character, candidate, random);
      } else {
        result = isFemaleUser
            ? AjakanMlHeteroPerempuanTemanSekolah.check(character, candidate, random)
            : AjakanMlHeteroLakiTemanSekolah.check(character, candidate, random);
      }
    }

    return result != null;
  }
}
