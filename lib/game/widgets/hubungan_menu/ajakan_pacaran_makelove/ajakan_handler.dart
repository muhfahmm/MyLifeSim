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
    
    bool hasOppositeSexPartner = false;
    bool isOppositeSex(Map<String, String>? p) {
      if (p == null || p['isDeceased'] == 'true') return false;
      final pGender = (p['gender'] ?? '').trim().toLowerCase();
      return pGender.isNotEmpty && pGender != myGenderLower;
    }
    if (isOppositeSex(character.partner) ||
        isOppositeSex(character.secondPartner) ||
        isOppositeSex(character.thirdPartner) ||
        isOppositeSex(character.fourthPartner) ||
        isOppositeSex(character.fifthPartner)) {
      hasOppositeSexPartner = true;
    }
    for (var sp in character.secretPartners) {
      if (isOppositeSex(sp)) {
        hasOppositeSexPartner = true;
        break;
      }
    }
    
    // 1. Intimacy/Romance proposals from existing partner
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
        final partnerName = character.partner!['name'] ?? '';
        final partnerGender = (character.partner!['gender'] ?? 'Perempuan').trim().toLowerCase();
        final partnerAgeStr = character.partner!['age'] ?? '18';
        final partnerAge = int.tryParse(partnerAgeStr) ?? 18;
        final partnerRelation = character.partner!['relation'] ?? 'Pacar';

        bool isFather = (character.fatherName != null && partnerName.contains(character.fatherName!));
        bool isStepFather = (character.stepFatherName != null && partnerName.contains(character.stepFatherName!));
        bool isMother = (character.motherName != null && partnerName.contains(character.motherName!));
        bool isStepMother = (character.stepMotherName != null && partnerName.contains(character.stepMotherName!));

        bool isSibling = false;
        String siblingRelation = 'Saudara';
        for (var sib in character.siblings) {
          final sName = sib['name'];
          if (sName != null && partnerName.contains(sName)) {
            isSibling = true;
            siblingRelation = sib['relation'] ?? 'Saudara';
            break;
          }
        }

        bool isExtendedFamily = false;
        String extRelation = 'Keluarga';
        for (var ext in character.extendedFamily) {
          final extName = ext['name'];
          if (extName != null && partnerName.contains(extName)) {
            isExtendedFamily = true;
            extRelation = ext['relation'] ?? 'Keluarga';
            break;
          }
        }

        bool canProposeMarriage = false;
        String relationLabel = partnerRelation;

        if (age >= 18 && partnerAge >= 18) {
          if (isFather) {
            final bool hasNoStepMother = character.stepMotherName == null || character.isStepMotherDeceased;
            final bool fatherIsSingle = hasNoStepMother || character.isFatherDivorced;
            if (fatherIsSingle) {
              canProposeMarriage = true;
              relationLabel = 'Ayah';
            }
          } else if (isStepFather) {
            if (character.isMotherDeceased) {
              canProposeMarriage = true;
              relationLabel = 'Ayah Tiri';
            }
          } else if (isMother) {
            final bool hasNoStepFather = character.stepFatherName == null || character.isStepFatherDeceased;
            final bool motherIsSingle = hasNoStepFather || character.isMotherDivorced;
            if (motherIsSingle) {
              canProposeMarriage = true;
              relationLabel = 'Ibu';
            }
          } else if (isStepMother) {
            if (character.isFatherDeceased) {
              canProposeMarriage = true;
              relationLabel = 'Ibu Tiri';
            }
          } else if (isSibling) {
            canProposeMarriage = true;
            relationLabel = siblingRelation;
          } else if (isExtendedFamily) {
            canProposeMarriage = true;
            relationLabel = extRelation;
          } else {
            // Regular partner
            canProposeMarriage = true;
            relationLabel = partnerRelation;
          }
        }

        final String partnerLoc = character.partner?['location'] ?? character.birthCountry ?? 'Indonesia';
        final bool differentCountry = character.location.toLowerCase() != partnerLoc.toLowerCase();

        final bool isSuamiIstri = partnerRelation == 'Suami' || partnerRelation == 'Istri';
        final bool isTunangan = partnerRelation == 'Tunangan';
        String? proposalType;

        if (isSuamiIstri) {
          // Jika sudah menikah: peluang murni ajak bercinta 70% (khusus perempuan-laki), default 65%
          int bercintaChance = (myGenderLower == 'perempuan' && partnerGender == 'laki-laki') ? 70 : 65;
          if (!differentCountry && random.nextInt(100) < bercintaChance) {
            proposalType = 'Bercinta';
          }
        } else if (isTunangan && age >= 18) {
          // Jika tunangan: peluang murni ajakan 60% (khusus perempuan-laki), default 65%
          int triggerChance = (myGenderLower == 'perempuan' && partnerGender == 'laki-laki') ? 60 : 65;
          if (random.nextInt(100) < triggerChance) {
            proposalType = differentCountry ? 'Rencanakan Nikah' : ((random.nextInt(100) < 50) ? 'Rencanakan Nikah' : 'Bercinta');
          }
        } else if (canProposeMarriage) {
          // Jika pacaran biasa:
          if (myGenderLower == 'perempuan' && partnerGender == 'laki-laki') {
            // Peluang Lamar Nikah murni 60%, bertambah 10% (menjadi 70%) jika ayah dan ikut ayah
            final int marrChance = (isFather && character.custodyParent == 'Ayah') ? 70 : 60;
            if (random.nextInt(100) < marrChance) {
              proposalType = 'Lamar Nikah';
            }
            // Jika tidak melamar, peluang Bercinta murni 60%
            else if (!differentCountry && random.nextInt(100) < 60) {
              proposalType = 'Bercinta';
            }
          } else {
            // Default logic untuk gender/orientasi lainnya (peluang total 65%)
            if (random.nextInt(100) < 65) {
              int marriageChance = 40;
              if (isFather || isMother) {
                final bool isLivingWithProposer = (isFather && character.custodyParent == 'Ayah') ||
                                                  (isMother && character.custodyParent == 'Ibu');
                marriageChance = isLivingWithProposer ? 70 : 50;
              } else if (isStepFather || isStepMother || isSibling || isExtendedFamily) {
                marriageChance = 50;
              }
              
              if (differentCountry) {
                proposalType = 'Lamar Nikah';
              } else {
                proposalType = (random.nextInt(100) < marriageChance) ? 'Lamar Nikah' : 'Bercinta';
              }
            }
          }
        }

        if (proposalType != null) {
          character.activeProposal = {
            'name': partnerName,
            'relation': relationLabel,
            'type': proposalType,
            'gender': partnerGender == 'laki-laki' ? 'Laki-laki' : 'Perempuan',
            'age': partnerAgeStr,
            'role': (isFather || isMother || isSibling || isExtendedFamily) 
                ? 'Keluarga' 
                : ((isStepFather || isStepMother) ? 'Tiri' : 'Partner'),
          };
        }
      }
    }

    // 2. Collect School / College / Job candidates
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

    // Collect Family candidates
    List<Map<String, dynamic>> familyCandidates = [];
    if (character.fatherName != null && !character.isFatherDeceased && !character.isAnyPartnerNameMatching(character.fatherName!)) {
      familyCandidates.add({
        'name': character.fatherName!,
        'relation': 'Ayah',
        'gender': 'Laki-laki',
        'age': (character.fatherAge ?? 40).toString(),
        'role': 'Keluarga',
      });
    }
    if (character.motherName != null && !character.isMotherDeceased && !character.isAnyPartnerNameMatching(character.motherName!)) {
      familyCandidates.add({
        'name': character.motherName!,
        'relation': 'Ibu',
        'gender': 'Perempuan',
        'age': (character.motherAge ?? 38).toString(),
        'role': 'Keluarga',
      });
    }
    if (character.stepFatherName != null && !character.isStepFatherDeceased && !character.isAnyPartnerNameMatching(character.stepFatherName!)) {
      familyCandidates.add({
        'name': character.stepFatherName!,
        'relation': 'Ayah Tiri',
        'gender': 'Laki-laki',
        'age': (character.stepFatherAge ?? 40).toString(),
        'role': 'Tiri',
      });
    }
    if (character.stepMotherName != null && !character.isStepMotherDeceased && !character.isAnyPartnerNameMatching(character.stepMotherName!)) {
      familyCandidates.add({
        'name': character.stepMotherName!,
        'relation': 'Ibu Tiri',
        'gender': 'Perempuan',
        'age': (character.stepMotherAge ?? 38).toString(),
        'role': 'Tiri',
      });
    }
    for (var sib in character.siblings) {
      final sName = sib['name'] ?? '';
      if (sib['isDeceased'] != 'true' && sName.isNotEmpty && !character.isAnyPartnerNameMatching(sName)) {
        familyCandidates.add({
          'name': sName,
          'relation': sib['relation'] ?? 'Saudara',
          'gender': sib['gender'] ?? 'Laki-laki',
          'age': sib['age'] ?? '18',
          'role': 'Keluarga',
        });
      }
    }
    for (var ext in character.extendedFamily) {
      final eName = ext['name'] ?? '';
      if (ext['isDeceased'] != 'true' && eName.isNotEmpty && !character.isAnyPartnerNameMatching(eName)) {
        familyCandidates.add({
          'name': eName,
          'relation': ext['relation'] ?? 'Keluarga',
          'gender': ext['gender'] ?? 'Laki-laki',
          'age': ext['age'] ?? '18',
          'role': 'Keluarga',
        });
      }
    }

    // Tentukan pool kandidat terpilih (Beri peluang 65% untuk keluarga agar lebih sering muncul)
    List<Map<String, dynamic>> selectedPool = [];
    if (familyCandidates.isNotEmpty && random.nextInt(100) < 65) {
      selectedPool = familyCandidates;
    } else {
      selectedPool = schoolCandidates;
    }

    if (selectedPool.isEmpty && familyCandidates.isNotEmpty) {
      selectedPool = familyCandidates;
    }
    if (selectedPool.isEmpty && schoolCandidates.isNotEmpty) {
      selectedPool = schoolCandidates;
    }

    // Try processing proposal
    if (selectedPool.isNotEmpty) {
      List<Map<String, dynamic>> sameSexCandidates = [];
      List<Map<String, dynamic>> oppositeSexCandidates = [];
      for (var c in selectedPool) {
        final String candGender = (c['gender'] ?? 'Laki-laki').trim().toLowerCase();
        if (candGender == myGenderLower) {
          sameSexCandidates.add(c);
        } else {
          oppositeSexCandidates.add(c);
        }
      }

      Map<String, dynamic>? candidate;
      final String mySexuality = character.sexuality.trim().toLowerCase();
      final int roll = random.nextInt(100);

      if (mySexuality == 'heteroseksual') {
        if (roll < 70) {
          if (oppositeSexCandidates.isNotEmpty) {
            candidate = oppositeSexCandidates[random.nextInt(oppositeSexCandidates.length)];
          }
        } else if (roll < 85) {
          if (sameSexCandidates.isNotEmpty) {
            candidate = sameSexCandidates[random.nextInt(sameSexCandidates.length)];
          }
        }
        // remaining 15% (roll >= 85) results in no proposal (candidate remains null)
      } else if (mySexuality == 'homoseksual' || mySexuality == 'gay' || mySexuality == 'lesbian') {
        if (roll < 40) {
          if (oppositeSexCandidates.isNotEmpty) {
            candidate = oppositeSexCandidates[random.nextInt(oppositeSexCandidates.length)];
          }
        } else {
          if (sameSexCandidates.isNotEmpty) {
            candidate = sameSexCandidates[random.nextInt(sameSexCandidates.length)];
          }
        }
      } else {
        // Bisexual or others: 50% opposite sex, 50% same sex
        if (roll < 50) {
          if (oppositeSexCandidates.isNotEmpty) {
            candidate = oppositeSexCandidates[random.nextInt(oppositeSexCandidates.length)];
          }
        } else {
          if (sameSexCandidates.isNotEmpty) {
            candidate = sameSexCandidates[random.nextInt(sameSexCandidates.length)];
          }
        }
      }

      if (candidate == null) return;

      final String candRole = candidate['role'];
      final String candGender = (candidate['gender'] ?? 'Laki-laki').trim().toLowerCase();

      final bool isGay = (myGenderLower == 'laki-laki' && candGender == 'laki-laki');
      final bool isLesbian = (myGenderLower == 'perempuan' && candGender == 'perempuan');

      if (character.disableSameSexProposals && (isGay || isLesbian)) {
        return;
      }

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
      } else if (candRole == 'Keluarga' || candRole == 'Tiri') {
        final String rel = (candidate['relation'] ?? '').toString().toLowerCase();
        final bool isCloseFamily = rel == 'ayah' || rel == 'ayah kandung' || rel == 'ayah tiri' ||
            rel == 'ibu' || rel == 'ibu kandung' || rel == 'ibu tiri' ||
            rel.contains('kakak') || rel.contains('adik') || rel.contains('saudara');

        // Jika keluarga dekat, 75% Masturbasi, 25% Ajak Pacaran
        // Jika keluarga jauh, 30% Bercinta (Make Love), 70% Ajak Pacaran
        final int threshold = isCloseFamily ? 25 : 70;
        final String proposalType = random.nextInt(100) < threshold ? 'Ajak Pacaran' : (isCloseFamily ? 'Masturbasi' : 'Bercinta');
        
        if (proposalType == 'Ajak Pacaran') {
          if (isGay) {
            character.activeProposal = AjakanPacaranGayKeluarga.check(character, candidate, random);
          } else if (isLesbian) {
            character.activeProposal = AjakanPacaranLesbianKeluarga.check(character, candidate, random);
          } else {
            character.activeProposal = AjakanPacaranHeteroKeluarga.check(character, candidate, random);
          }
        } else if (proposalType == 'Masturbasi') {
          character.activeProposal = {
            'name': candidate['name'],
            'relation': candidate['relation'],
            'type': 'Masturbasi',
            'gender': candidate['gender'],
            'age': candidate['age'],
            'role': candidate['role'],
          };
        } else {
          if (isGay) {
            character.activeProposal = AjakanMlGayKeluarga.check(character, candidate, random);
          } else if (isLesbian) {
            character.activeProposal = AjakanMlLesbianKeluarga.check(character, candidate, random);
          } else {
            character.activeProposal = AjakanMlHeteroKeluarga.check(character, candidate, random);
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





    if (character.activeProposal != null) {
      final String propGender = (character.activeProposal!['gender'] ?? '').trim().toLowerCase();
      final bool isSameSex = (myGenderLower == propGender);
      final bool isFromOthers = !character.isAnyPartnerNameMatching(character.activeProposal!['name'] ?? '');

      if (isSameSex) {
        if (hasOppositeSexPartner && random.nextInt(100) >= 10) {
          character.activeProposal = null;
        }
      } else {
        if (isFromOthers && hasOppositeSexPartner && random.nextInt(100) >= 15) {
          character.activeProposal = null;
        }
      }
    }
  }
}
