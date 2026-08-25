import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

// Imports for gay dating
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_incest/family_incest_handler.dart';
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

// Idol sub-handlers
import 'ajakan_pacaran/gay/idol_gf_bf/ajakan_pacaran_gay_staf_idol.dart';
import 'ajakan_pacaran/gay/idol_gf_bf/ajakan_pacaran_gay_rekan_idol.dart';
import 'ajakan_pacaran/lesbian/idol_gf_bf/ajakan_pacaran_lesbian_staf_idol.dart';
import 'ajakan_pacaran/lesbian/idol_gf_bf/ajakan_pacaran_lesbian_rekan_idol.dart';
import 'ajakan_pacaran/hetero/idol_gf_bf/ajakan_pacaran_hetero_staf_idol.dart';
import 'ajakan_pacaran/hetero/idol_gf_bf/ajakan_pacaran_hetero_rekan_idol.dart';

import 'ajakan_makelove/gay/idol_makelove/ajakan_ml_gay_staf_idol.dart';
import 'ajakan_makelove/gay/idol_makelove/ajakan_ml_gay_rekan_idol.dart';
import 'ajakan_makelove/lesbian/idol_makelove/ajakan_ml_lesbian_staf_idol.dart';
import 'ajakan_makelove/lesbian/idol_makelove/ajakan_ml_lesbian_rekan_idol.dart';
import 'ajakan_makelove/hetero/idol_makelove/ajakan_ml_hetero_staf_idol.dart';
import 'ajakan_makelove/hetero/idol_makelove/ajakan_ml_hetero_rekan_idol.dart';

class AjakanHandler {
  static void checkAndGenerateProposal(Character character, Random random) {
    final age = character.age;
    if (age < 6 || character.activeProposal != null) return;

    final String myGenderLower = character.gender.trim().toLowerCase();
    
    // 1. Collect School / College / Job candidates
    List<Map<String, dynamic>> schoolCandidates = [];

    if (age < 18) {
      List<Map<String, String>> activeTeachers = [];
      if (age >= 6 && age <= 12) {
        activeTeachers = character.sdTeachers;
      } else if (age >= 13 && age <= 15) {
        activeTeachers = character.smpTeachers;
      } else {
        activeTeachers = character.smaTeachers;
      }

      for (var t in activeTeachers) {
        final String sexuality = t['sexuality'] ?? 'Heteroseksual';
        final String tGender = (t['gender'] ?? 'Laki-laki').trim().toLowerCase();
        final String name = t['name'] ?? '';
        if (character.isAnyPartnerNameMatching(name)) continue;

        bool match = false;
        if (sexuality == 'Heteroseksual') {
          match = (myGenderLower != tGender);
        } else if (sexuality == 'Biseksual') {
          match = true;
        } else {
          match = (myGenderLower == tGender);
        }

        if (match) {
          schoolCandidates.add({
            'name': t['name'],
            'relation': 'Guru',
            'gender': t['gender'] ?? 'Laki-laki',
            'age': t['age'] ?? '35',
            'role': 'Guru',
          });
        }
      }

      for (var cm in character.classmates) {
        final String sexuality = cm['sexuality'] ?? 'Heteroseksual';
        final String cmGender = (cm['gender'] ?? 'Laki-laki').trim().toLowerCase();
        final String name = cm['name'] ?? '';
        if (character.isAnyPartnerNameMatching(name)) continue;

        bool match = false;
        if (sexuality == 'Heteroseksual') {
          match = (myGenderLower != cmGender);
        } else if (sexuality == 'Biseksual') {
          match = true;
        } else {
          match = (myGenderLower == cmGender);
        }

        if (match) {
          schoolCandidates.add({
            'name': cm['name'],
            'relation': 'Teman Sekelas',
            'gender': cm['gender'] ?? 'Laki-laki',
            'age': cm['age'] ?? age.toString(),
            'role': 'Teman Sekelas',
          });
        }
      }
    } else {
      // Age >= 18: College / Coworkers
      if (character.univMajor != null) {
        for (var cm in character.univClassmates) {
          final String sexuality = cm['sexuality'] ?? 'Heteroseksual';
          final String cmGender = (cm['gender'] ?? 'Laki-laki').trim().toLowerCase();
          final String name = cm['name'] ?? '';
          if (character.isAnyPartnerNameMatching(name)) continue;

          bool match = false;
          if (sexuality == 'Heteroseksual') {
            match = (myGenderLower != cmGender);
          } else if (sexuality == 'Biseksual') {
            match = true;
          } else {
            match = (myGenderLower == cmGender);
          }

          if (match) {
            schoolCandidates.add({
              'name': cm['name'],
              'relation': 'Teman Kuliah',
              'gender': cm['gender'] ?? 'Laki-laki',
              'age': cm['age'] ?? age.toString(),
              'role': 'Teman Kuliah',
            });
          }
        }

        for (var t in character.univLecturers) {
          final String sexuality = t['sexuality'] ?? 'Heteroseksual';
          final String tGender = (t['gender'] ?? 'Laki-laki').trim().toLowerCase();
          final String name = t['name'] ?? '';
          if (character.isAnyPartnerNameMatching(name)) continue;

          bool match = false;
          if (sexuality == 'Heteroseksual') {
            match = (myGenderLower != tGender);
          } else if (sexuality == 'Biseksual') {
            match = true;
          } else {
            match = (myGenderLower == tGender);
          }

          if (match) {
            schoolCandidates.add({
              'name': t['name'],
              'relation': 'Dosen',
              'gender': t['gender'] ?? 'Laki-laki',
              'age': t['age'] ?? '40',
              'role': 'Dosen',
            });
          }
        }
      }

      if (character.jobName != null) {
        for (var cm in character.coworkers) {
          final String sexuality = cm['sexuality'] ?? 'Heteroseksual';
          final String cmGender = (cm['gender'] ?? 'Laki-laki').trim().toLowerCase();
          final String name = cm['name'] ?? '';
          if (character.isAnyPartnerNameMatching(name)) continue;

          bool match = false;
          if (sexuality == 'Heteroseksual') {
            match = (myGenderLower != cmGender);
          } else if (sexuality == 'Biseksual') {
            match = true;
          } else {
            match = (myGenderLower == cmGender);
          }

          if (match) {
            schoolCandidates.add({
              'name': cm['name'],
              'relation': 'Rekan Kerja',
              'gender': cm['gender'] ?? 'Laki-laki',
              'age': cm['age'] ?? age.toString(),
              'role': 'Rekan Kerja',
            });
          }
        }
      }

      if (character.isIdolRelated) {
        // Collect Staf candidates
        for (var staff in character.idolStaff) {
          final String name = staff['name'] ?? '';
          if (character.isAnyPartnerNameMatching(name)) continue;
          
          final String sexuality = staff['sexuality'] ?? 'Heteroseksual';
          final String stGender = (staff['gender'] ?? 'Laki-laki').trim().toLowerCase();
          
          bool match = false;
          if (sexuality == 'Heteroseksual') {
            match = (myGenderLower != stGender);
          } else if (sexuality == 'Biseksual') {
            match = true;
          } else {
            match = (myGenderLower == stGender);
          }
          
          if (match) {
            schoolCandidates.add({
              'name': staff['name'],
              'relation': 'Staf Idol (${staff['role']})',
              'gender': staff['gender'] ?? 'Laki-laki',
              'age': staff['age'] ?? '30',
              'role': 'Staf Idol',
            });
          }
        }
        
        // Collect Rekan candidates (Trainee or Main Members)
        final List<Map<String, String>> membersList = [];
        membersList.addAll(character.idolMainMembers);
        membersList.addAll(character.idolTrainees);
        
        for (var member in membersList) {
          final String name = member['name'] ?? '';
          if (character.isAnyPartnerNameMatching(name)) continue;
          
          final String sexuality = member['sexuality'] ?? 'Heteroseksual';
          final String mbGender = (member['gender'] ?? 'Perempuan').trim().toLowerCase();
          
          bool match = false;
          if (sexuality == 'Heteroseksual') {
            match = (myGenderLower != mbGender);
          } else if (sexuality == 'Biseksual') {
            match = true;
          } else {
            match = (myGenderLower == mbGender);
          }
          
          if (match) {
            schoolCandidates.add({
              'name': member['name'],
              'relation': 'Rekan Idol',
              'gender': member['gender'] ?? 'Perempuan',
              'age': member['age'] ?? '16',
              'role': 'Rekan Idol',
            });
          }
        }
      }
    }

    // Try processing school/work proposal
    if (schoolCandidates.isNotEmpty) {
      final candidate = schoolCandidates[random.nextInt(schoolCandidates.length)];
      final String candRole = candidate['role'];
      final String candGender = (candidate['gender'] ?? 'Laki-laki').trim().toLowerCase();

      final bool isGay = (myGenderLower == 'laki-laki' && candGender == 'laki-laki');
      final bool isLesbian = (myGenderLower == 'perempuan' && candGender == 'perempuan');

      if (candRole == 'Rekan Kerja') {
        if (isGay) {
          final int roll = random.nextInt(100);
          if (roll < 20) {
            character.activeProposal = AjakanPacaranGayCoworker.check(character, candidate, random);
          } else if (roll < 30) {
            character.activeProposal = AjakanMlGayCoworker.check(character, candidate, random);
          }
        } else if (isLesbian) {
          final int roll = random.nextInt(100);
          if (roll < 20) {
            character.activeProposal = AjakanPacaranLesbianCoworker.check(character, candidate, random);
          } else if (roll < 30) {
            character.activeProposal = AjakanMlLesbianCoworker.check(character, candidate, random);
          }
        } else {
          // Hetero
          final int roll = random.nextInt(100);
          if (roll < 30) {
            character.activeProposal = AjakanPacaranHeteroCoworker.check(character, candidate, random);
          } else if (roll < 60) {
            character.activeProposal = AjakanMlHeteroCoworker.check(character, candidate, random);
          }
        }
      } else {
        // Classmates, Teachers, Lecturers, Idols
        final String proposalType = random.nextInt(100) < 70 ? 'Ajak Pacaran' : 'Bercinta';
        if (proposalType == 'Ajak Pacaran') {
          if (isGay) {
            if (candRole == 'Guru') {
              character.activeProposal = AjakanPacaranGayGuruSekolah.check(character, candidate, random);
            } else if (candRole == 'Dosen') {
              character.activeProposal = AjakanPacaranGayDosen.check(character, candidate, random);
            } else if (candRole == 'Staf Idol') {
              character.activeProposal = AjakanPacaranGayStafIdol.check(character, candidate, random);
            } else if (candRole == 'Rekan Idol') {
              character.activeProposal = AjakanPacaranGayRekanIdol.check(character, candidate, random);
            } else {
              character.activeProposal = AjakanPacaranGayTemanSekolah.check(character, candidate, random);
            }
          } else if (isLesbian) {
            if (candRole == 'Guru') {
              character.activeProposal = AjakanPacaranLesbianGuruSekolah.check(character, candidate, random);
            } else if (candRole == 'Dosen') {
              character.activeProposal = AjakanPacaranLesbianDosen.check(character, candidate, random);
            } else if (candRole == 'Staf Idol') {
              character.activeProposal = AjakanPacaranLesbianStafIdol.check(character, candidate, random);
            } else if (candRole == 'Rekan Idol') {
              character.activeProposal = AjakanPacaranLesbianRekanIdol.check(character, candidate, random);
            } else {
              character.activeProposal = AjakanPacaranLesbianTemanSekolah.check(character, candidate, random);
            }
          } else {
            // Hetero
            if (candRole == 'Guru') {
              character.activeProposal = AjakanPacaranHeteroGuruSekolah.check(character, candidate, random);
            } else if (candRole == 'Dosen') {
              character.activeProposal = AjakanPacaranHeteroDosen.check(character, candidate, random);
            } else if (candRole == 'Staf Idol') {
              character.activeProposal = AjakanPacaranHeteroStafIdol.check(character, candidate, random);
            } else if (candRole == 'Rekan Idol') {
              character.activeProposal = AjakanPacaranHeteroRekanIdol.check(character, candidate, random);
            } else {
              character.activeProposal = AjakanPacaranHeteroTemanSekolah.check(character, candidate, random);
            }
          }
        } else {
          // Bercinta (Make Love)
          if (isGay) {
            if (candRole == 'Guru') {
              character.activeProposal = AjakanMlGayGuruSekolah.check(character, candidate, random);
            } else if (candRole == 'Dosen') {
              character.activeProposal = AjakanMlGayDosen.check(character, candidate, random);
            } else if (candRole == 'Staf Idol') {
              character.activeProposal = AjakanMlGayStafIdol.check(character, candidate, random);
            } else if (candRole == 'Rekan Idol') {
              character.activeProposal = AjakanMlGayRekanIdol.check(character, candidate, random);
            } else {
              character.activeProposal = AjakanMlGayTemanSekolah.check(character, candidate, random);
            }
          } else if (isLesbian) {
            if (candRole == 'Guru') {
              character.activeProposal = AjakanMlLesbianGuruSekolah.check(character, candidate, random);
            } else if (candRole == 'Dosen') {
              character.activeProposal = AjakanMlLesbianDosen.check(character, candidate, random);
            } else if (candRole == 'Staf Idol') {
              character.activeProposal = AjakanMlLesbianStafIdol.check(character, candidate, random);
            } else if (candRole == 'Rekan Idol') {
              character.activeProposal = AjakanMlLesbianRekanIdol.check(character, candidate, random);
            } else {
              character.activeProposal = AjakanMlLesbianTemanSekolah.check(character, candidate, random);
            }
          } else {
            // Hetero
            if (candRole == 'Guru') {
              character.activeProposal = AjakanMlHeteroGuruSekolah.check(character, candidate, random);
            } else if (candRole == 'Dosen') {
              character.activeProposal = AjakanMlHeteroDosen.check(character, candidate, random);
            } else if (candRole == 'Staf Idol') {
              character.activeProposal = AjakanMlHeteroStafIdol.check(character, candidate, random);
            } else if (candRole == 'Rekan Idol') {
              character.activeProposal = AjakanMlHeteroRekanIdol.check(character, candidate, random);
            } else {
              character.activeProposal = AjakanMlHeteroTemanSekolah.check(character, candidate, random);
            }
          }
        }
      }
    }

    // 2. If no school/work proposal occurred, check family
    if (character.activeProposal == null) {
      // First, check parent/step-parent incest logic using the new handler
      FamilyIncestHandler.checkAndGenerateProposal(character, random);
      if (character.activeProposal != null) return;

      List<Map<String, dynamic>> familyCandidates = [];

      bool isAlreadyPartner(String name) {
        return character.isAnyPartnerNameMatching(name);
      }

      if (age >= 12) {
        for (var sib in character.siblings) {
          final int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
          final bool isDeceased = sib['isDeceased'] == 'true';
          final String sName = sib['name'] ?? '';
          if (!isDeceased && sibAge >= 12 && !isAlreadyPartner(sName)) {
            familyCandidates.add({
              'name': '${sib['name']} (${sib['relation']})',
              'relation': sib['relation'] ?? 'Saudara',
              'gender': sib['gender'] ?? 'Laki-laki',
              'age': sibAge.toString(),
              'role': 'Kandung',
            });
          }
          if (sib['childNames'] != null && sib['childNames']!.isNotEmpty) {
            final List<String> cNames = sib['childNames']!.split(',');
            final List<String> cAges = sib['childAges']!.split(',');
            final List<String> cGenders = sib['childGenders']!.split(',');
            for (int i = 0; i < cNames.length; i++) {
              int cAge = int.tryParse(cAges[i]) ?? 0;
              if (cAge >= 12 && !isAlreadyPartner(cNames[i])) {
                familyCandidates.add({
                  'name': cNames[i],
                  'relation': 'Keponakan',
                  'gender': cGenders[i],
                  'age': cAge.toString(),
                  'role': 'Keponakan',
                });
              }
            }
          }
        }

        for (var child in character.children) {
          final int childAge = int.tryParse(child['age'] ?? '0') ?? 0;
          final bool isDeceased = child['isDeceased'] == 'true';
          final String childName = child['name'] ?? '';
          if (!isDeceased && childAge >= 12 && !isAlreadyPartner(childName)) {
            familyCandidates.add({
              'name': childName,
              'relation': 'Anak',
              'gender': child['gender'] ?? 'Laki-laki',
              'age': childAge.toString(),
              'role': 'Anak',
            });
          }
        }

        if (character.fatherInLawName != null && character.fatherInLawAge != null && !isAlreadyPartner(character.fatherInLawName!)) {
          familyCandidates.add({
            'name': character.fatherInLawName!,
            'relation': 'Ayah Mertua',
            'gender': 'Laki-laki',
            'age': character.fatherInLawAge!.toString(),
            'role': 'Mertua',
          });
        }
        if (character.motherInLawName != null && character.motherInLawAge != null && !isAlreadyPartner(character.motherInLawName!)) {
          familyCandidates.add({
            'name': character.motherInLawName!,
            'relation': 'Ibu Mertua',
            'gender': 'Perempuan',
            'age': character.motherInLawAge!.toString(),
            'role': 'Mertua',
          });
        }
      }

      for (var ext in character.extendedFamily) {
        final int extAge = int.tryParse(ext['age'] ?? '0') ?? 0;
        final bool isDeceased = ext['isDeceased'] == 'true';
        final String extName = ext['name'] ?? '';
        final String extRel = (ext['relation'] ?? '').toLowerCase();
        
        bool ageValid = extRel.contains('kakek') ? (age >= 10) : (age >= 12);
        if (ageValid && !isDeceased && extAge >= 12 && !isAlreadyPartner(extName)) {
          familyCandidates.add({
            'name': extName,
            'relation': ext['relation'] ?? 'Keluarga',
            'gender': ext['gender'] ?? 'Laki-laki',
            'age': extAge.toString(),
            'role': 'Keluarga',
          });
        }
      }

      if (familyCandidates.isNotEmpty) {
        final candidate = familyCandidates[random.nextInt(familyCandidates.length)];
        final String candGender = (candidate['gender'] ?? 'Laki-laki').trim().toLowerCase();

        final bool isGay = (myGenderLower == 'laki-laki' && candGender == 'laki-laki');
        final bool isLesbian = (myGenderLower == 'perempuan' && candGender == 'perempuan');

        // Roll proposal type
        final String proposalType = random.nextInt(100) < 80 ? 'Ajak Pacaran' : 'Bercinta';

        if (proposalType == 'Ajak Pacaran') {
          if (isGay) {
            character.activeProposal = AjakanPacaranGayKeluarga.check(character, candidate, random);
          } else if (isLesbian) {
            character.activeProposal = AjakanPacaranLesbianKeluarga.check(character, candidate, random);
          } else {
            character.activeProposal = AjakanPacaranHeteroKeluarga.check(character, candidate, random);
          }
        } else {
          // Bercinta
          if (isGay) {
            character.activeProposal = AjakanMlGayKeluarga.check(character, candidate, random);
          } else if (isLesbian) {
            character.activeProposal = AjakanMlLesbianKeluarga.check(character, candidate, random);
          } else {
            character.activeProposal = AjakanMlHeteroKeluarga.check(character, candidate, random);
          }
        }
      }
    }

    // 3. Intimacy/Romance proposals from existing partner
    if (age >= 12 && character.partner != null && character.partner!['isDeceased'] != 'true' && character.activeProposal == null) {
      final int pCount = character.activePartnersCount;
      if (pCount >= 2) {
        if (random.nextInt(100) < 60) {
          final List<Map<String, String>> existing = [];
          if (character.partner != null && character.partner!['isDeceased'] != 'true') existing.add(character.partner!);
          if (character.secondPartner != null && character.secondPartner!['isDeceased'] != 'true') existing.add(character.secondPartner!);
          if (character.thirdPartner != null && character.thirdPartner!['isDeceased'] != 'true') existing.add(character.thirdPartner!);
          if (character.fourthPartner != null && character.fourthPartner!['isDeceased'] != 'true') existing.add(character.fourthPartner!);
          if (character.fifthPartner != null && character.fifthPartner!['isDeceased'] != 'true') existing.add(character.fifthPartner!);

          if (existing.isNotEmpty) {
            final proposer = existing[random.nextInt(existing.length)];
            character.activeProposal = {
              'name': proposer['name'],
              'relation': proposer['relation'] ?? 'Pacar',
              'type': 'Ajak 3some',
              'gender': proposer['gender'] ?? 'Perempuan',
              'age': proposer['age'] ?? '20',
              'role': 'Partner',
            };
          }
        }
      } else {
        final bool isBiologicalFatherPartner = (character.partner != null && (character.partner!['name'] == character.fatherName || character.partner!['name']!.contains(character.fatherName ?? '___'))) ||
                                               character.isAnyPartnerNameMatching(character.fatherName ?? '___');
        final bool isStepFatherPartner = (character.partner != null && (character.partner!['name'] == character.stepFatherName || character.partner!['name']!.contains(character.stepFatherName ?? '___'))) ||
                                         character.isAnyPartnerNameMatching(character.stepFatherName ?? '___');

        final bool isDaughter = myGenderLower == 'perempuan';
        final bool hasNoStepMother = character.stepMotherName == null || character.isStepMotherDeceased;
        final bool fatherIsSingle = hasNoStepMother || character.isFatherDivorced;
        final bool hasDeadMother = character.isMotherDeceased;

        if (isDaughter && isBiologicalFatherPartner && fatherIsSingle) {
          final bool isLivingWithFather = character.custodyParent == 'Ayah';
          final String proposalType = (age >= 18 && random.nextInt(100) < (isLivingWithFather ? 70 : 50)) ? 'Lamar Nikah' : 'Bercinta';
          final int chance = isLivingWithFather ? 70 : (proposalType == 'Bercinta' ? 70 : 60);
          if (random.nextInt(100) < chance) {
            String fAgeStr = character.fatherAge != null ? character.fatherAge.toString() : '40';
            character.activeProposal = {
              'name': character.fatherName ?? 'Ayah',
              'relation': 'Pacar (Ayah)',
              'type': proposalType,
              'gender': 'Laki-laki',
              'age': fAgeStr,
              'role': 'Keluarga',
            };
          }
        } else if (isDaughter && isStepFatherPartner && hasDeadMother) {
          final String proposalType = (age >= 18 && random.nextInt(100) < 50) ? 'Lamar Nikah' : 'Bercinta';
          final int chance = proposalType == 'Bercinta' ? 70 : 60;
          if (random.nextInt(100) < chance) {
            String sfAgeStr = character.stepFatherAge != null ? character.stepFatherAge.toString() : '40';
            character.activeProposal = {
              'name': character.stepFatherName ?? 'Ayah Tiri',
              'relation': 'Pacar (Ayah Tiri)',
              'type': proposalType,
              'gender': 'Laki-laki',
              'age': sfAgeStr,
              'role': 'Tiri',
            };
          }
        } else {
          if (random.nextInt(100) < 60) {
            character.activeProposal = {
              'name': character.partner!['name'],
              'relation': character.partner!['relation'] ?? 'Pacar',
              'type': 'Bercinta',
              'gender': character.partner!['gender'] ?? 'Perempuan',
              'age': character.partner!['age'] ?? '18',
              'role': 'Partner',
            };
          }
        }
      }
    }
  }
}
