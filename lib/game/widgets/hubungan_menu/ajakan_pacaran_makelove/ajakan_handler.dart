import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/pilih_karakter/settings/global_settings.dart';
import 'package:bitlife/store_page/fitur_premium/adult_features.dart';

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

// BA_talent sub-handlers
import 'ajakan_makelove/gay/BA_talent/ajakan_ml_gay_ba_talent.dart';
import 'ajakan_makelove/hetero/BA_talent/ajakan_ml_hetero_ba_talent.dart';
import 'ajakan_makelove/lesbian/BA_talent/ajakan_ml_lesbian_ba_talent.dart';
import 'ajakan_pacaran/gay/BA_talent/ajakan_pacaran_gay_ba_talent.dart';
import 'ajakan_pacaran/hetero/BA_talent/ajakan_pacaran_hetero_ba_talent.dart';
import 'ajakan_pacaran/lesbian/BA_talent/ajakan_pacaran_lesbian_ba_talent.dart';

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
            'relation': 'Guru ${t['subject'] ?? ''}',
            'gender': t['gender'] ?? 'Laki-laki',
            'age': t['age'] ?? '35',
            'role': 'Guru',
          });
        }
      }

      // Tambahkan Guru BK
      if (character.bkTeacher != null) {
        final bk = character.bkTeacher!;
        final String sexuality = bk['sexuality'] ?? 'Heteroseksual';
        final String tGender = (bk['gender'] ?? 'Laki-laki').trim().toLowerCase();
        final String name = bk['name'] ?? '';
        if (!character.isAnyPartnerNameMatching(name)) {
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
              'name': name,
              'relation': 'Guru BK',
              'gender': bk['gender'] ?? 'Laki-laki',
              'age': bk['age'] ?? '35',
              'role': 'Guru',
            });
          }
        }
      }

      // Tambahkan Kepala Sekolah
      if (character.headmaster != null) {
        final hs = character.headmaster!;
        final String sexuality = hs['sexuality'] ?? 'Heteroseksual';
        final String tGender = (hs['gender'] ?? 'Laki-laki').trim().toLowerCase();
        final String name = hs['name'] ?? '';
        if (!character.isAnyPartnerNameMatching(name)) {
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
              'name': name,
              'relation': 'Kepala Sekolah',
              'gender': hs['gender'] ?? 'Laki-laki',
              'age': hs['age'] ?? '45',
              'role': 'Guru',
            });
          }
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

      // Tambahkan rekan kerja untuk user muda (esports BA/Talent/Pro Player di bawah 18 tahun)
      if (character.jobName != null) {
        final String userJobUnder18 = character.jobName ?? '';
        final bool isEsportUnder18 = userJobUnder18.startsWith('Pro Player Esport') || userJobUnder18.startsWith('Brand Ambassador Esport') || userJobUnder18.startsWith('Talent Esports');

        for (var cw in character.coworkers) {
          final String sexuality = cw['sexuality'] ?? 'Heteroseksual';
          final String cwGender = (cw['gender'] ?? 'Laki-laki').trim().toLowerCase();
          final String name = cw['name'] ?? '';
          if (character.isAnyPartnerNameMatching(name)) continue;

          bool match = false;
          if (sexuality == 'Heteroseksual') {
            match = (myGenderLower != cwGender);
          } else if (sexuality == 'Biseksual') {
            match = true;
          } else {
            match = (myGenderLower == cwGender);
          }

          if (match) {
            final String coworkerRole = cw['role'] ?? 'Rekan Kerja';
            schoolCandidates.add({
              'name': cw['name'],
              'relation': coworkerRole,
              'gender': cw['gender'] ?? 'Laki-laki',
              'age': cw['age'] ?? age.toString(),
              'role': coworkerRole,
            });
          }
        }

        // CEO / Supervisor untuk user esports muda
        if (character.supervisor != null) {
          final sv = character.supervisor!;
          final String sexuality = sv['sexuality'] ?? 'Heteroseksual';
          final String svGender = (sv['gender'] ?? 'Laki-laki').trim().toLowerCase();
          final String svName = sv['name'] ?? '';
          if (!character.isAnyPartnerNameMatching(svName)) {
            bool match = false;
            if (sexuality == 'Heteroseksual') {
              match = (myGenderLower != svGender);
            } else if (sexuality == 'Biseksual') {
              match = true;
            } else {
              match = (myGenderLower == svGender);
            }
            if (match) {
              final String svRole = isEsportUnder18 ? 'CEO' : 'Supervisor';
              schoolCandidates.add({
                'name': svName,
                'relation': svRole,
                'gender': sv['gender'] ?? 'Laki-laki',
                'age': sv['age'] ?? '40',
                'role': svRole,
              });
            }
          }
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
        final String userJob = character.jobName ?? '';
        final bool isEsport = userJob.startsWith('Pro Player Esport') || userJob.startsWith('Brand Ambassador Esport') || userJob.startsWith('Talent Esports');

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
            final String coworkerRole = cm['role'] ?? 'Rekan Kerja';
            schoolCandidates.add({
              'name': cm['name'],
              'relation': coworkerRole,
              'gender': cm['gender'] ?? 'Laki-laki',
              'age': cm['age'] ?? age.toString(),
              'role': coworkerRole,
            });
          }
        }

        // Collect supervisor / CEO
        if (character.supervisor != null) {
          final sv = character.supervisor!;
          final String sexuality = sv['sexuality'] ?? 'Heteroseksual';
          final String svGender = (sv['gender'] ?? 'Laki-laki').trim().toLowerCase();
          final String name = sv['name'] ?? '';
          if (!character.isAnyPartnerNameMatching(name)) {
            bool match = false;
            if (sexuality == 'Heteroseksual') {
              match = (myGenderLower != svGender);
            } else if (sexuality == 'Biseksual') {
              match = true;
            } else {
              match = (myGenderLower == svGender);
            }

            if (match) {
              final String svRole = isEsport ? 'CEO' : 'Supervisor';
              schoolCandidates.add({
                'name': name,
                'relation': svRole,
                'gender': sv['gender'] ?? 'Laki-laki',
                'age': sv['age'] ?? '40',
                'role': svRole,
              });
            }
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

    // --- PRIORITAS KHUSUS GURU/DOSEN ---
    // Agar guru lebih dominan dibanding teman sekelas (karena jumlah teman sekelas jauh lebih banyak di pool),
    // kita beri peluang 60% untuk memotong pool hanya menyisakan Guru/Dosen jika kandidat Guru/Dosen tersedia.
    if (selectedPool.isNotEmpty) {
      final List<Map<String, dynamic>> guruDosenPool = selectedPool.where((c) {
        final r = c['role'] ?? '';
        return r == 'Guru' || r == 'Dosen';
      }).toList();

      if (guruDosenPool.isNotEmpty && random.nextInt(100) < 60) {
        selectedPool = guruDosenPool;
      }
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

      // Deteksi peran coworker, baik coworker biasa maupun role esports spesifik
      final bool isCoworkerRole = candRole == 'Rekan Kerja' ||
          candRole == 'Pro Player' ||
          candRole == 'Brand Ambassador' ||
          candRole == 'Talent Esports' ||
          candRole == 'CEO' ||
          candRole == 'Supervisor';

      if (isCoworkerRole) {
        final String userJob = character.jobName ?? '';
        final bool isEsport = userJob.startsWith('Pro Player Esport') || userJob.startsWith('Brand Ambassador Esport') || userJob.startsWith('Talent Esports');

        if (isEsport) {
          if (isGay) {
            final pacaranProp = AjakanPacaranGayBaTalent.check(character, candidate, random);
            final mlProp = AjakanMlGayBaTalent.check(character, candidate, random);
            character.activeProposal = mlProp ?? pacaranProp;
          } else if (isLesbian) {
            final pacaranProp = AjakanPacaranLesbianBaTalent.check(character, candidate, random);
            final mlProp = AjakanMlLesbianBaTalent.check(character, candidate, random);
            character.activeProposal = mlProp ?? pacaranProp;
          } else {
            final pacaranProp = AjakanPacaranHeteroBaTalent.check(character, candidate, random);
            final mlProp = AjakanMlHeteroBaTalent.check(character, candidate, random);
            character.activeProposal = mlProp ?? pacaranProp;
          }
        } else {
          if (isGay) {
            final pacaranProp = AjakanPacaranGayCoworker.check(character, candidate, random);
            final mlProp = AjakanMlGayCoworker.check(character, candidate, random);
            character.activeProposal = mlProp ?? pacaranProp;
          } else if (isLesbian) {
            final pacaranProp = AjakanPacaranLesbianCoworker.check(character, candidate, random);
            final mlProp = AjakanMlLesbianCoworker.check(character, candidate, random);
            character.activeProposal = mlProp ?? pacaranProp;
          } else {
            final pacaranProp = AjakanPacaranHeteroCoworker.check(character, candidate, random);
            final mlProp = AjakanMlHeteroCoworker.check(character, candidate, random);
            character.activeProposal = mlProp ?? pacaranProp;
          }
        }

        // Jika tidak mendapat ajakan pacaran/ML, beri peluang 15% diajak Masturbasi
        if (character.activeProposal == null && random.nextInt(100) < 15) {
          character.activeProposal = {
            'name': candidate['name'],
            'relation': candidate['relation'],
            'type': 'Masturbasi',
            'gender': candidate['gender'],
            'age': candidate['age'],
            'role': candidate['role'],
          };
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
        final bool isTeacherOrLecturer = candRole == 'Guru' || candRole == 'Dosen';
        
        // Membagi rata peluang: Guru/Dosen memiliki peluang acak 45% langsung mengajak Masturbasi
        if (isTeacherOrLecturer && random.nextInt(100) < 45) {
          if (!(character.disableSameSexProposals && (isGay || isLesbian))) {
            character.activeProposal = {
              'name': candidate['name'],
              'relation': candidate['relation'],
              'type': 'Masturbasi',
              'gender': candidate['gender'],
              'age': candidate['age'],
              'role': candidate['role'],
            };
          }
        }

        if (character.activeProposal == null) {
          if (isGay) {
            if (candRole == 'Guru') {
              final pacaran = AjakanPacaranGayGuruSekolah.check(character, candidate, random);
              final ml = AjakanMlGayGuruSekolah.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else if (candRole == 'Dosen') {
              final pacaran = AjakanPacaranGayDosen.check(character, candidate, random);
              final ml = AjakanMlGayDosen.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else if (candRole == 'Staf Idol') {
              final pacaran = AjakanPacaranGayStafIdol.check(character, candidate, random);
              final ml = AjakanMlGayStafIdol.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else if (candRole == 'Rekan Idol') {
              final pacaran = AjakanPacaranGayRekanIdol.check(character, candidate, random);
              final ml = AjakanMlGayRekanIdol.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else {
              final pacaran = AjakanPacaranGayTemanSekolah.check(character, candidate, random);
              final ml = AjakanMlGayTemanSekolah.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            }
          } else if (isLesbian) {
            if (candRole == 'Guru') {
              final pacaran = AjakanPacaranLesbianGuruSekolah.check(character, candidate, random);
              final ml = AjakanMlLesbianGuruSekolah.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else if (candRole == 'Dosen') {
              final pacaran = AjakanPacaranLesbianDosen.check(character, candidate, random);
              final ml = AjakanMlLesbianDosen.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else if (candRole == 'Staf Idol') {
              final pacaran = AjakanPacaranLesbianStafIdol.check(character, candidate, random);
              final ml = AjakanMlLesbianStafIdol.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else if (candRole == 'Rekan Idol') {
              final pacaran = AjakanPacaranLesbianRekanIdol.check(character, candidate, random);
              final ml = AjakanMlLesbianRekanIdol.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else {
              final pacaran = AjakanPacaranLesbianTemanSekolah.check(character, candidate, random);
              final ml = AjakanMlLesbianTemanSekolah.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            }
          } else {
            // Hetero
            if (candRole == 'Guru') {
              final pacaran = AjakanPacaranHeteroGuruSekolah.check(character, candidate, random);
              final ml = AjakanMlHeteroGuruSekolah.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else if (candRole == 'Dosen') {
              final pacaran = AjakanPacaranHeteroDosen.check(character, candidate, random);
              final ml = AjakanMlHeteroDosen.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else if (candRole == 'Staf Idol') {
              final pacaran = AjakanPacaranHeteroStafIdol.check(character, candidate, random);
              final ml = AjakanMlHeteroStafIdol.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else if (candRole == 'Rekan Idol') {
              final pacaran = AjakanPacaranHeteroRekanIdol.check(character, candidate, random);
              final ml = AjakanMlHeteroRekanIdol.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            } else {
              final pacaran = AjakanPacaranHeteroTemanSekolah.check(character, candidate, random);
              final ml = AjakanMlHeteroTemanSekolah.check(character, candidate, random);
              character.activeProposal = ml ?? pacaran;
            }
          }
        }

        // Jika tidak mendapat ajakan pacaran/ML, beri peluang 15% diajak Masturbasi (atau 45% untuk Guru/Dosen)
        if (character.activeProposal == null && random.nextInt(100) < (isTeacherOrLecturer ? 45 : 15)) {
          if (!(character.disableSameSexProposals && (isGay || isLesbian))) {
            character.activeProposal = {
              'name': candidate['name'],
              'relation': candidate['relation'],
              'type': 'Masturbasi',
              'gender': candidate['gender'],
              'age': candidate['age'],
              'role': candidate['role'],
            };
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

    // --- FILTER PREFERENSI KONTEN DEWASA ---
    if (character.activeProposal != null) {
      final proposal = character.activeProposal!;
      final type = proposal['type'] ?? '';
      final role = proposal['role'] ?? '';
      final isFamily = role == 'Keluarga' || role == 'Tiri' || 
                       (proposal['relation'] != null && 
                        (proposal['relation'].toString().toLowerCase().contains('ayah') || 
                         proposal['relation'].toString().toLowerCase().contains('ibu') ||
                         proposal['relation'].toString().toLowerCase().contains('kakak') ||
                         proposal['relation'].toString().toLowerCase().contains('adik') ||
                         proposal['relation'].toString().toLowerCase().contains('paman') ||
                         proposal['relation'].toString().toLowerCase().contains('bibi') ||
                         proposal['relation'].toString().toLowerCase().contains('kakek') ||
                         proposal['relation'].toString().toLowerCase().contains('nenek') ||
                         proposal['relation'].toString().toLowerCase().contains('saudara')));

      if (type == 'Masturbasi') {
        if (isFamily && GlobalSettings.disableMasturbationFamily.value) {
          character.activeProposal = null;
        } else if (!isFamily && GlobalSettings.disableMasturbationNonFamily.value) {
          character.activeProposal = null;
        }
        
        // Filter Premium: Ajak Masturbasi dilarang total bagi non-premium
        if (character.activeProposal != null && !AdultFeatures.canMasturbateTogether()) {
          character.activeProposal = null;
        }
      } else if (type == 'Bercinta' || type == 'Bercinta (Make Love)' || type == 'Bersetubuh') {
        if (isFamily && GlobalSettings.disableMakeLoveFamily.value) {
          character.activeProposal = null;
        } else if (!isFamily && GlobalSettings.disableMakeLoveNonFamily.value) {
          character.activeProposal = null;
        }
        
        // Filter Premium: Make Love dilarang jika tidak memenuhi syarat (usia < 18 atau dengan non-teman)
        if (character.activeProposal != null) {
          final String pRole = proposal['role'] ?? '';
          final String pRelation = proposal['relation'] ?? '';
          if (!AdultFeatures.canMakeLove(userAge: character.age, role: pRole, relation: pRelation)) {
            character.activeProposal = null;
          }
        }
      } else if (type == 'Ajak Pacaran' || type == 'Pacaran') {
        if (isFamily && GlobalSettings.disablePacaranFamily.value) {
          character.activeProposal = null;
        } else if (!isFamily && GlobalSettings.disablePacaranNonFamily.value) {
          character.activeProposal = null;
        }
        
        // Filter Premium: Ajakan pacaran dari Keluarga (seperti Adik, Kakak, Sepupu, dll.) 
        // hanya diperbolehkan jika user sudah premium.
        if (character.activeProposal != null && isFamily && !AdultFeatures.isPremiumUnlocked) {
          character.activeProposal = null;
        }
      }
    }
  }
}
