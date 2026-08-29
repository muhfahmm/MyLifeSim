// lib/pilih_karakter/character.dart
import 'dart:math';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/school_generator.dart';
import 'package:bitlife/game/widgets/penyakit_logic/incest_logic.dart';
import 'package:bitlife/avatar/skin_color_inheritance.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/idol_logic/idol_manager.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_handler.dart';
import 'package:bitlife/game/widgets/hubungan_menu/relationship_button/parent_remarriage.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/kerja_menu.dart';

// Import Atribut Karakter yang Dipisah
import 'package:bitlife/pilih_karakter/atribut_karakter/disiplin.dart';
import 'package:bitlife/pilih_karakter/atribut_karakter/kesuburan.dart';
import 'package:bitlife/pilih_karakter/atribut_karakter/kebahagiaan.dart';
import 'package:bitlife/pilih_karakter/atribut_karakter/kesehatan.dart';
import 'package:bitlife/pilih_karakter/atribut_karakter/karma.dart';
import 'package:bitlife/pilih_karakter/atribut_karakter/penampilan.dart';
import 'package:bitlife/pilih_karakter/atribut_karakter/seksualitas.dart';
import 'package:bitlife/pilih_karakter/atribut_karakter/kecerdasan.dart';
import 'package:bitlife/pilih_karakter/atribut_karakter/tekad.dart';

// Export agar file lain yang mengimpor character.dart tetap mendapatkan ekstensi atribut
export 'package:bitlife/pilih_karakter/atribut_karakter/disiplin.dart';
export 'package:bitlife/pilih_karakter/atribut_karakter/kesuburan.dart';
export 'package:bitlife/pilih_karakter/atribut_karakter/kebahagiaan.dart';
export 'package:bitlife/pilih_karakter/atribut_karakter/kesehatan.dart';
export 'package:bitlife/pilih_karakter/atribut_karakter/karma.dart';
export 'package:bitlife/pilih_karakter/atribut_karakter/penampilan.dart';
export 'package:bitlife/pilih_karakter/atribut_karakter/seksualitas.dart';
export 'package:bitlife/pilih_karakter/atribut_karakter/kecerdasan.dart';
export 'package:bitlife/pilih_karakter/atribut_karakter/tekad.dart';

class Character {
  String name;
  String gender;
  String location;
  String? birthCountry;
  int age;
  int health;
  int happiness;
  int intelligence;
  int money;
  int appearance;
  bool isAlive;
  int followers = 0;

  // --- WAKTU PERMAINAN (TANGGAL DINAMIS) ---
  DateTime? birthDate;
  DateTime? currentDate;

  // --- KUSTOMISASI ATRIBUT & TALENTA BARU ---
  int discipline;
  int fertility;
  int karma;
  String sexuality;
  int willpower;
  String specialTalent;

  // --- PARAMETER AVATAR DARI KUSTOMISASI ---
  String? avatarTopType;
  String? avatarAccessoriesType;
  String? avatarHairColor;
  String? avatarClotheType;
  String? avatarClotheColor;
  String? avatarSkinColor;
  String? avatarFacialHairType;
  int eyeTestsCountYoung = 0;
  int eyeTestsCountOld = 0;
  int idolStaffDatingFailures = 0;
  int idolSalaryRaiseCount = 0;

  // --- WARNA KULIT ORANG TUA (untuk warisan) ---
  String? fatherSkinColor;  // hex warna kulit ayah
  String? motherSkinColor;  // hex warna kulit ibu
  String? partnerSkinColor; // hex warna kulit pasangan (untuk warisan ke anak)
  String? stepFatherSkinColor; // hex warna kulit ayah tiri
  String? stepMotherSkinColor; // hex warna kulit ibu tiri


  // --- FIELD KELUARGA BARU ---
  String? fatherName;        // Nama Ayah Kandung
  String? motherName;        // Nama Ibu Kandung
  String? stepFatherName;    // Nama Ayah Tiri (jika ada)
  String? stepMotherName;    // Nama Ibu Tiri (jika ada)
  int birthOrder;            // Urutan kelahiran (1 = anak pertama, 2 = kedua, dst)
  List<Map<String, String>> siblings; // Daftar saudara [{name: '...', gender: 'Laki-laki', relation: '...', relationship: '50', age: '2', isDeceased: 'false'}]
  List<Map<String, String>> extendedFamily = []; // Daftar kakek, nenek, paman, bibi, sepupu [{name: '...', gender: 'Laki-laki', relation: 'Kakek (dari Ayah)', relationship: '50', age: '70', isDeceased: 'false'}]
  List<Map<String, String>> classmates = []; // Daftar teman sekelas [{name: '...', gender: 'Laki-laki', relationship: '50', age: '12', isDeceased: 'false'}]
  List<Map<String, String>> univClassmates = []; // Daftar teman kuliah
  List<Map<String, String>> univLecturers = []; // Daftar dosen
  List<Map<String, String>> coworkers = []; // Daftar rekan kerja
  Map<String, String>? supervisor; // Supervisor / Atasan kerja
  String? smaMajor; // Jurusan SMA ('IPA', 'IPS', 'Bahasa', atau null)
  String? schoolType; // Jenis sekolah ('Negeri' atau 'Swasta')
  String? univMajor; // Jurusan Universitas (e.g. 'Teknik Informatika', dll), null jika belum kuliah
  List<String> graduatedMajors = [];
  Map<String, String> educationHistory = {};
  int currentUnivStudyYears = 0;
  String? justGraduatedStage; // Menyimpan jenjang pendidikan yang baru saja lulus (misal 'S1')
  String? justGraduatedMajor; // Menyimpan jurusan kuliah yang baru saja lulus
  List<Map<String, String>> secretPartners = [];
  List<Map<String, String>> sdTeachers = []; // Daftar guru SD
  List<Map<String, String>> smpTeachers = []; // Daftar guru SMP
  List<Map<String, String>> smaTeachers = []; // Daftar guru SMA
  Map<String, String>? headmaster; // Kepala Sekolah SMA
  Map<String, String>? bkTeacher; // Guru BK SMA
  Map<String, String>? sdHeadmaster; // Kepala Sekolah SD
  Map<String, String>? sdBkTeacher; // Guru BK SD
  Map<String, String>? smpHeadmaster; // Kepala Sekolah SMP
  Map<String, String>? smpBkTeacher; // Guru BK SMP

  // --- HUBUNGAN (RELATIONSHIP BARS) ---
  int? fatherRelationship;
  int? motherRelationship;
  int? stepFatherRelationship;
  int? stepMotherRelationship;

  // --- KEKAYAAN KELUARGA (PARENT WEALTH) ---
  int? fatherWealth;
  int? motherWealth;
  int? stepFatherWealth;
  int? stepMotherWealth;
  int? fatherInLawWealth;
  int? motherInLawWealth;

  // --- PEKERJAAN ORANG TUA / MERTUA ---
  String? fatherJob;
  int? fatherSalary;
  String? motherJob;
  int? motherSalary;
  String? stepFatherJob;
  int? stepFatherSalary;
  String? stepMotherJob;
  int? stepMotherSalary;
  String? fatherInLawJob;
  int? fatherInLawSalary;
  String? motherInLawJob;
  int? motherInLawSalary;

  // --- UMUR KELUARGA ---
  int? fatherAge;
  int? motherAge;
  int? stepFatherAge;
  int? stepMotherAge;

  // --- FIELD PEKERJAAN ---
  String? jobName;
  int? jobSalary;
  String? custodyParent; // 'Ayah' atau 'Ibu' setelah cerai

  // --- FIELD PEKERJAAN IDOL ---
  bool get isIdol => jobName == 'Idol (Trainee)' || jobName == 'Idol (Main Performer)';
  bool get isIdolStaff => jobName == 'General Manager Idol' || jobName == 'Deputy General Manager Idol' || jobName == 'Staf Operasional Idol';
  bool get isIdolRelated => isIdol || isIdolStaff;
  int yearsInTrainee = 0;
  List<Map<String, String>> idolTrainees = [];
  List<Map<String, String>> idolMainMembers = [];
  List<Map<String, String>> idolStaff = [];
  List<String> idolNews = [];
  bool hasGraduatedIdol = false;

  // --- FINANSIAL TRANSAKSI & PINJAMAN ---
  List<Map<String, dynamic>> cashTransactions = [];
  List<Map<String, dynamic>> cashLoans = [];

  // --- KASINO PERSISTEN ---
  List<Map<String, dynamic>> casinoHistory = [];
  int casinoTotalWin = 0;
  int casinoTotalLoss = 0;
  int casinoSlotJackpot = 0;

  Map<String, dynamic>? garasiMobil;
  List<Map<String, dynamic>> ownedAccessories = [];

  // --- INVESTASI PERSISTEN ---
  Map<String, int> saham = {};
  Map<String, double> averageSahamBuyPrice = {};
  double emasGram = 0;
  double averageEmasBuyPrice = 0.0;
  Map<String, double> kripto = {};
  Map<String, double> averageKriptoBuyPrice = {};

  // --- STATUS KEHAMILAN KARAKTER ---
  bool isPregnant = false;

  // --- STATUS KEHAMILAN PASANGAN (Jika Karakter Utama Laki-laki) ---
  bool partnerIsPregnant = false; 

  // --- PELAKU HUBUNGAN KEHAMILAN ---
  String? pregnantByPartnerName;
  String? pregnantByPartnerRole;

  // --- DAFTAR ANAK ---
  List<Map<String, String>> children = []; // [{name: '...', gender: 'Laki-laki', relationship: '80', age: '0', father: '...', mother: '...', isDeceased: 'false'}]

  // --- KEJADIAN AJAKAN (PROPOSAL) ---
  Map<String, dynamic>? activeProposal; // {'name': '...', 'relation': '...', 'type': 'Pacaran' / 'Bercinta', 'gender': '...', 'age': '...'}

  // --- DATA PACAR / PASANGAN ---
  Map<String, String>? _partner;
  Map<String, String>? get partner => _partner;
  set partner(Map<String, String>? val) {
    _partner = val;
    if (val != null) {
      if (val['skinColor'] == null) {
        val['skinColor'] = SkinColorInheritance.randomSkin();
      }
      partnerSkinColor = val['skinColor'];
    } else {
      partnerSkinColor = null;
    }
  }

  // --- DATA PACAR KEDUA (SELINGKUHAN) ---
  Map<String, String>? _secondPartner;
  Map<String, String>? get secondPartner => _secondPartner;
  set secondPartner(Map<String, String>? val) {
    _secondPartner = val;
    if (val != null && val['skinColor'] == null) {
      val['skinColor'] = SkinColorInheritance.randomSkin();
    }
  }

  // --- DATA PACAR KETIGA ---
  Map<String, String>? _thirdPartner;
  Map<String, String>? get thirdPartner => _thirdPartner;
  set thirdPartner(Map<String, String>? val) {
    _thirdPartner = val;
    if (val != null && val['skinColor'] == null) {
      val['skinColor'] = SkinColorInheritance.randomSkin();
    }
  }

  // --- DATA PACAR KEEMPAT ---
  Map<String, String>? _fourthPartner;
  Map<String, String>? get fourthPartner => _fourthPartner;
  set fourthPartner(Map<String, String>? val) {
    _fourthPartner = val;
    if (val != null && val['skinColor'] == null) {
      val['skinColor'] = SkinColorInheritance.randomSkin();
    }
  }

  // --- DATA PACAR KELIMA ---
  Map<String, String>? _fifthPartner;
  Map<String, String>? get fifthPartner => _fifthPartner;
  set fifthPartner(Map<String, String>? val) {
    _fifthPartner = val;
    if (val != null && val['skinColor'] == null) {
      val['skinColor'] = SkinColorInheritance.randomSkin();
    }
  }

  int get activePartnersCount {
    int count = 0;
    if (partner != null && partner!['isDeceased'] != 'true') count++;
    if (secondPartner != null && secondPartner!['isDeceased'] != 'true') count++;
    if (thirdPartner != null && thirdPartner!['isDeceased'] != 'true') count++;
    if (fourthPartner != null && fourthPartner!['isDeceased'] != 'true') count++;
    if (fifthPartner != null && fifthPartner!['isDeceased'] != 'true') count++;
    count += secretPartners.where((p) => p['isDeceased'] != 'true').length;
    return count;
  }

  // DATA FOLLOWERS SOSIAL MEDIA
  Map<String, int> platformFollowers = {};
  // DATA POSTINGAN SOSIAL MEDIA SECARA DINAMIS
  List<Map<String, dynamic>> posts = [];

  void syncNPCsAndPartners() {
    void syncMap(Map<String, String>? partnerMap) {
      if (partnerMap == null) return;
      final String pName = (partnerMap['name'] ?? '').toLowerCase();
      if (pName.isEmpty) return;

      // 1. Cari di classmates
      for (var cm in classmates) {
        final String cmName = (cm['name'] ?? '').toLowerCase();
        if (cmName == pName || cmName.contains(pName) || pName.contains(cmName)) {
          partnerMap['relationship'] = cm['relationship'] ?? partnerMap['relationship'] ?? '50';
          partnerMap['age'] = cm['age'] ?? partnerMap['age'] ?? '18';
          partnerMap['isDeceased'] = cm['isDeceased'] ?? partnerMap['isDeceased'] ?? 'false';
          final String? sc = cm['skinColor'] ?? partnerMap['skinColor'];
          if (sc != null) partnerMap['skinColor'] = sc;
          return;
        }
      }
      // 2. Cari di univClassmates
      for (var cm in univClassmates) {
        final String cmName = (cm['name'] ?? '').toLowerCase();
        if (cmName == pName || cmName.contains(pName) || pName.contains(cmName)) {
          partnerMap['relationship'] = cm['relationship'] ?? partnerMap['relationship'] ?? '50';
          partnerMap['age'] = cm['age'] ?? partnerMap['age'] ?? '18';
          partnerMap['isDeceased'] = cm['isDeceased'] ?? partnerMap['isDeceased'] ?? 'false';
          final String? sc = cm['skinColor'] ?? partnerMap['skinColor'];
          if (sc != null) partnerMap['skinColor'] = sc;
          return;
        }
      }
      // 3. Cari di coworkers
      for (var cw in coworkers) {
        final String cwName = (cw['name'] ?? '').toLowerCase();
        if (cwName == pName || cwName.contains(pName) || pName.contains(cwName)) {
          partnerMap['relationship'] = cw['relationship'] ?? partnerMap['relationship'] ?? '50';
          partnerMap['age'] = cw['age'] ?? partnerMap['age'] ?? '18';
          partnerMap['isDeceased'] = cw['isDeceased'] ?? partnerMap['isDeceased'] ?? 'false';
          final String? scCw = cw['skinColor'] ?? partnerMap['skinColor'];
          if (scCw != null) partnerMap['skinColor'] = scCw;
          return;
        }
      }
    }

    syncMap(partner);
    syncMap(secondPartner);
    syncMap(thirdPartner);
    syncMap(fourthPartner);
    syncMap(fifthPartner);
    for (var sp in secretPartners) {
      syncMap(sp);
    }
  }

  void syncPartnerDeathStatus() {
    bool checkIfDeceased(String partnerName) {
      final String nameLower = partnerName.toLowerCase();
      if (motherName != null && isMotherDeceased) {
        final String mName = motherName!.toLowerCase();
        if (nameLower == mName || nameLower.contains(mName) || mName.contains(nameLower)) return true;
      }
      if (fatherName != null && isFatherDeceased) {
        final String fName = fatherName!.toLowerCase();
        if (nameLower == fName || nameLower.contains(fName) || fName.contains(nameLower)) return true;
      }
      if (stepMotherName != null && isStepMotherDeceased) {
        final String smName = stepMotherName!.toLowerCase();
        if (nameLower == smName || nameLower.contains(smName) || smName.contains(nameLower)) return true;
      }
      if (stepFatherName != null && isStepFatherDeceased) {
        final String sfName = stepFatherName!.toLowerCase();
        if (nameLower == sfName || nameLower.contains(sfName) || sfName.contains(nameLower)) return true;
      }
      for (var sib in siblings) {
        if (sib['isDeceased'] == 'true') {
          final String sibName = (sib['name'] ?? '').toLowerCase();
          if (sibName.isNotEmpty && (nameLower == sibName || nameLower.contains(sibName) || sibName.contains(nameLower))) {
            return true;
          }
        }
      }
      return false;
    }

    if (partner != null && checkIfDeceased(partner!['name'] ?? '')) {
      partner = null;
    }
    if (secondPartner != null && checkIfDeceased(secondPartner!['name'] ?? '')) {
      secondPartner = null;
    }
    if (thirdPartner != null && checkIfDeceased(thirdPartner!['name'] ?? '')) {
      thirdPartner = null;
    }
    if (fourthPartner != null && checkIfDeceased(fourthPartner!['name'] ?? '')) {
      fourthPartner = null;
    }
    if (fifthPartner != null && checkIfDeceased(fifthPartner!['name'] ?? '')) {
      fifthPartner = null;
    }
    secretPartners.removeWhere((p) => checkIfDeceased(p['name'] ?? ''));
  }

  String? getFamilyMemberSkinColor(String targetName) {
    final String lowerTarget = targetName.toLowerCase();
    if (lowerTarget.startsWith('ibu') && !lowerTarget.contains('tiri')) {
      return motherSkinColor;
    }
    if (lowerTarget.startsWith('ayah') && !lowerTarget.contains('tiri')) {
      return fatherSkinColor;
    }
    if (lowerTarget.startsWith('ibu') && lowerTarget.contains('tiri')) {
      return stepMotherSkinColor;
    }
    if (lowerTarget.startsWith('ayah') && lowerTarget.contains('tiri')) {
      return stepFatherSkinColor;
    }
    for (var sib in siblings) {
      final String sibName = sib['name'] ?? '';
      final String expectedLabel = '$sibName (${sib['relation']})';
      if (expectedLabel == targetName || sibName == targetName) {
        return sib['skinColor'];
      }
    }
    for (var child in children) {
      final String childName = child['name'] ?? '';
      if (childName.toLowerCase() == lowerTarget) {
        return child['skinColor'];
      }
    }
    return null;
  }

  void syncSocialRelationships() {
    void syncSinglePartner(Map<String, String>? partnerMap) {
      if (partnerMap == null) return;
      final String partnerName = (partnerMap['name'] ?? '').toLowerCase();
      if (partnerName.isEmpty) return;

      // 1. Cari di classmates
      for (var cm in classmates) {
        final String cmName = (cm['name'] ?? '').toLowerCase();
        if (cmName == partnerName || partnerName.contains(cmName) || cmName.contains(partnerName)) {
          // Partner map (pacar aktif) adalah source of truth untuk umur dan skinColor
          cm['age'] = partnerMap['age'] ?? cm['age'] ?? '18';
          if (partnerMap['skinColor'] != null) cm['skinColor'] = partnerMap['skinColor']!;
          // Hubungan diselaraskan ke rata-rata atau salah satunya
          final int pRel = int.tryParse(partnerMap['relationship'] ?? '50') ?? 50;
          final int cRel = int.tryParse(cm['relationship'] ?? '50') ?? 50;
          final int targetRel = (pRel + cRel) ~/ 2;
          partnerMap['relationship'] = targetRel.toString();
          cm['relationship'] = targetRel.toString();
          return;
        }
      }

      // 2. Cari di univClassmates
      for (var cm in univClassmates) {
        final String cmName = (cm['name'] ?? '').toLowerCase();
        if (cmName == partnerName || partnerName.contains(cmName) || cmName.contains(partnerName)) {
          cm['age'] = partnerMap['age'] ?? cm['age'] ?? '18';
          if (partnerMap['skinColor'] != null) cm['skinColor'] = partnerMap['skinColor']!;
          final int pRel = int.tryParse(partnerMap['relationship'] ?? '50') ?? 50;
          final int cRel = int.tryParse(cm['relationship'] ?? '50') ?? 50;
          final int targetRel = (pRel + cRel) ~/ 2;
          partnerMap['relationship'] = targetRel.toString();
          cm['relationship'] = targetRel.toString();
          return;
        }
      }

      // 3. Cari di coworkers
      for (var cw in coworkers) {
        final String cwName = (cw['name'] ?? '').toLowerCase();
        if (cwName == partnerName || partnerName.contains(cwName) || cwName.contains(partnerName)) {
          cw['age'] = partnerMap['age'] ?? cw['age'] ?? '18';
          if (partnerMap['skinColor'] != null) cw['skinColor'] = partnerMap['skinColor']!;
          final int pRel = int.tryParse(partnerMap['relationship'] ?? '50') ?? 50;
          final int cRel = int.tryParse(cw['relationship'] ?? '50') ?? 50;
          final int targetRel = (pRel + cRel) ~/ 2;
          partnerMap['relationship'] = targetRel.toString();
          cw['relationship'] = targetRel.toString();
          return;
        }
      }
    }

    syncSinglePartner(partner);
    syncSinglePartner(secondPartner);
    syncSinglePartner(thirdPartner);
    syncSinglePartner(fourthPartner);
    syncSinglePartner(fifthPartner);
    for (var sp in secretPartners) {
      syncSinglePartner(sp);
    }
  }

  void updateRelationshipValue(String targetName, int newValue) {
    final String nameLower = targetName.toLowerCase();
    final String valStr = newValue.toString();

    if (partner != null && (partner!['name']!.toLowerCase() == nameLower || partner!['name']!.toLowerCase().contains(nameLower))) {
      partner!['relationship'] = valStr;
    }
    if (secondPartner != null && (secondPartner!['name']!.toLowerCase() == nameLower || secondPartner!['name']!.toLowerCase().contains(nameLower))) {
      secondPartner!['relationship'] = valStr;
    }
    if (thirdPartner != null && (thirdPartner!['name']!.toLowerCase() == nameLower || thirdPartner!['name']!.toLowerCase().contains(nameLower))) {
      thirdPartner!['relationship'] = valStr;
    }
    if (fourthPartner != null && (fourthPartner!['name']!.toLowerCase() == nameLower || fourthPartner!['name']!.toLowerCase().contains(nameLower))) {
      fourthPartner!['relationship'] = valStr;
    }
    if (fifthPartner != null && (fifthPartner!['name']!.toLowerCase() == nameLower || fifthPartner!['name']!.toLowerCase().contains(nameLower))) {
      fifthPartner!['relationship'] = valStr;
    }
    for (var sp in secretPartners) {
      if (sp['name']!.toLowerCase() == nameLower || sp['name']!.toLowerCase().contains(nameLower)) {
        sp['relationship'] = valStr;
      }
    }

    for (var cm in classmates) {
      if (cm['name']!.toLowerCase() == nameLower || cm['name']!.toLowerCase().contains(nameLower)) {
        cm['relationship'] = valStr;
      }
    }
    for (var cm in univClassmates) {
      if (cm['name']!.toLowerCase() == nameLower || cm['name']!.toLowerCase().contains(nameLower)) {
        cm['relationship'] = valStr;
      }
    }
    for (var cw in coworkers) {
      if (cw['name']!.toLowerCase() == nameLower || cw['name']!.toLowerCase().contains(nameLower)) {
        cw['relationship'] = valStr;
      }
    }
    
    if (motherName != null && motherName!.toLowerCase() == nameLower) {
      motherRelationship = newValue;
    }
    if (fatherName != null && fatherName!.toLowerCase() == nameLower) {
      fatherRelationship = newValue;
    }
    if (stepMotherName != null && stepMotherName!.toLowerCase() == nameLower) {
      stepMotherRelationship = newValue;
    }
    if (stepFatherName != null && stepFatherName!.toLowerCase() == nameLower) {
      stepFatherRelationship = newValue;
    }
    for (var sib in siblings) {
      if (sib['name']!.toLowerCase() == nameLower) {
        sib['relationship'] = valStr;
      }
    }
  }

  void addPartnerToFreeSlot(Map<String, String> val) {
    final bool isSecret = val['relation'] == 'Pacar (Selingkuhan)' || val['relation'] == 'Pacar (Rahasia)';
    if (isSecret) {
      if (secondPartner == null) {
        secondPartner = val;
        isHavingAffair = true;
      } else {
        secretPartners.add(val);
        isHavingAffair = true;
      }
      return;
    }
    if (partner == null) {
      partner = val;
    } else if (secondPartner == null) {
      secondPartner = val;
    } else if (thirdPartner == null) {
      thirdPartner = val;
    } else if (fourthPartner == null) {
      fourthPartner = val;
    } else if (fifthPartner == null) {
      fifthPartner = val;
    } else {
      secretPartners.add(val);
      isHavingAffair = true;
    }
  }

  bool isAnyPartnerNameMatching(String name) {
    bool checkPartner(Map<String, String>? p) {
      if (p == null) return false;
      final pName = p['name'];
      if (pName == null) return false;
      return pName == name || pName.contains(name) || name.contains(pName);
    }
    if (checkPartner(partner)) return true;
    if (checkPartner(secondPartner)) return true;
    if (checkPartner(thirdPartner)) return true;
    if (checkPartner(fourthPartner)) return true;
    if (checkPartner(fifthPartner)) return true;
    for (var sp in secretPartners) {
      if (checkPartner(sp)) return true;
    }
    return false;
  }

  String? getPartnerRelation(String name) {
    bool checkPartner(Map<String, String>? p) {
      if (p == null) return false;
      final pName = p['name'];
      if (pName == null) return false;
      return pName == name || pName.contains(name) || name.contains(pName);
    }
    if (checkPartner(partner)) return partner!['relation'] ?? 'Pacar';
    if (checkPartner(secondPartner)) return secondPartner!['relation'] ?? 'Pacar';
    if (checkPartner(thirdPartner)) return thirdPartner!['relation'] ?? 'Pacar';
    if (checkPartner(fourthPartner)) return fourthPartner!['relation'] ?? 'Pacar';
    if (checkPartner(fifthPartner)) return fifthPartner!['relation'] ?? 'Pacar';
    for (var sp in secretPartners) {
      if (checkPartner(sp)) return sp['relation'] ?? 'Pacar';
    }
    return null;
  }

  bool isHavingAffair = false; // true jika user sedang selingkuh
  List<Map<String, String>> exPartners = []; // List of ex-partners/mantan pacar

  // --- STATUS KEMATIAN KELUARGA KANDUNG ---
  bool isFatherDeceased = false;
  bool isMotherDeceased = false;
  bool isFatherDivorced = false;
  bool isMotherDivorced = false;
  bool isFatherPersuadedNotToRemarry = false;
  bool isStepFatherDeceased = false;
  bool isStepMotherDeceased = false;
  bool motherWillTryForBaby = false;
  bool isMotherImprisoned = false;
  int motherPrisonYears = 0;
  bool isFatherImprisoned = false;
  int fatherPrisonYears = 0;

  // --- DATA MERTUA ---
  String? fatherInLawName;
  String? motherInLawName;
  int? fatherInLawAge;
  int? motherInLawAge;
  int? fatherInLawRelationship;
  int? motherInLawRelationship;
  bool isFatherInLawDeceased = false;
  bool isMotherInLawDeceased = false;

  // --- STATUS PENYAKIT SEKSUAL ---
  bool hasHIV = false;
  bool hasSifilis = false;
  bool hasHPV = false;

  // --- LOGIKA MASTURBASI ---
  int lastMasturbationAge = -5;
  int addictionLevel = 0;

  // --- DATABASE NAMA DARI JSON (GLOBAL CACHE) ---
  static List<String> globalMaleFirstNames = [];
  static List<String> globalFemaleFirstNames = [];
  static List<String> globalLastNames = [];

  // --- DATABASE NAMA DARI JSON ---
  List<String>? maleFirstNames;
  List<String>? femaleFirstNames;
  List<String>? lastNames;

  Character({
    required this.name,
    required this.gender,
    required this.location,
    this.age = 0,
    this.health = 100,
    this.happiness = 50,
    this.intelligence = 50,
    this.money = 0,
    this.appearance = 50,
    this.isAlive = true,
    this.discipline = 50,
    this.fertility = 50,
    this.karma = 50,
    this.sexuality = 'Straight',
    this.willpower = 50,
    this.specialTalent = 'None',
    // Default keluarga
    this.fatherName,
    this.motherName,
    this.stepFatherName,
    this.stepMotherName,
    this.birthOrder = 1,
    this.siblings = const [],
    this.extendedFamily = const [],
    this.fatherRelationship = 50,
    this.motherRelationship = 50,
    this.stepFatherRelationship = 50,
    this.stepMotherRelationship = 50,
    this.fatherAge,
    this.motherAge,
    this.stepFatherAge,
    this.stepMotherAge,
    this.fatherInLawName,
    this.motherInLawName,
    this.fatherInLawAge,
    this.motherInLawAge,
    this.fatherInLawRelationship = 50,
    this.motherInLawRelationship = 50,
    Map<String, String>? partner,
    this.maleFirstNames,
    this.femaleFirstNames,
    this.lastNames,
    this.avatarTopType,
    this.avatarAccessoriesType,
    this.avatarHairColor,
    this.avatarClotheType,
    this.avatarClotheColor,
    this.avatarSkinColor,
    this.avatarFacialHairType,
  }) : inbox = [] {
    birthCountry = location;
    if (partner != null) {
      this.partner = partner;
    }
    // Default game date to real life DateTime
    birthDate ??= DateTime.now();
    currentDate ??= birthDate;
  }

  // --- KOTAK MASUK / INBOX NOTIFIKASI ---
  List<String> inbox;

  // --- LABEL URUTAN KELAHIRAN (ANAK PERTAMA/TENGAH/TERAKHIR/TUNGGAL) ---
  String get birthOrderLabel {
    final hasKakak = birthOrder > 1;
    final hasAdik = siblings.any((sib) => sib['relation']?.startsWith('Adik') == true);

    if (hasKakak && hasAdik) {
      return 'Anak Tengah';
    } else if (hasKakak && !hasAdik) {
      return 'Anak Terakhir';
    } else if (!hasKakak && hasAdik) {
      return 'Anak Pertama';
    } else {
      return 'Anak Tunggal';
    }
  }

  // updateHealthDynamic dipindahkan ke lib/pilih_karakter/atribut_karakter/kesehatan.dart sebagai extension method.

  // Method untuk bertambah umur (mengembalikan list log kejadian)
  List<String> ageUp() {
    List<String> events = [];
    justGraduatedStage = null;
    justGraduatedMajor = null;
    final random = Random();
    age++;
    updateHealthDynamic(isDaily: false);
    updateIntelligenceDynamic();
    updateDisciplineDynamic();
    accumulateNPCsWealth();

    // Tambah tahun pada currentDate jika tidak null
    if (currentDate != null) {
      currentDate = DateTime(currentDate!.year + 1, currentDate!.month, currentDate!.day);
    }

    // Age up all NPCs
    for (var list in [classmates, univClassmates, univLecturers, sdTeachers, smpTeachers, smaTeachers, coworkers]) {
      for (var npc in list) {
        if (npc['age'] != null) {
          final currentAge = int.tryParse(npc['age']!) ?? 0;
          npc['age'] = (currentAge + 1).toString();
        }
      }
    }
    if (supervisor != null && supervisor!['age'] != null) {
      final currentAge = int.tryParse(supervisor!['age']!) ?? 0;
      supervisor!['age'] = (currentAge + 1).toString();
    }

    // Check supervisor retirement (retired age: 60-65)
    if (jobName != null && supervisor != null) {
      final supAge = int.tryParse(supervisor!['age'] ?? '40') ?? 40;
      final retiredThreshold = 60 + random.nextInt(6); // 60 to 65
      if (supAge >= retiredThreshold) {
        final oldSupName = supervisor!['name']!;
        // Generate new supervisor (minimal age 26)
        final supGender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
        final firstList = supGender == 'Laki-laki'
            ? ((maleFirstNames != null && maleFirstNames!.isNotEmpty) ? maleFirstNames! : globalMaleFirstNames)
            : ((femaleFirstNames != null && femaleFirstNames!.isNotEmpty) ? femaleFirstNames! : globalFemaleFirstNames);
        final lastList = (lastNames != null && lastNames!.isNotEmpty) ? lastNames! : globalLastNames;
        final newSupName = '${firstList[random.nextInt(firstList.length)]} ${lastList[random.nextInt(lastList.length)]}';
        final newSupAge = 26 + random.nextInt(34); // Minimal 26 to 59
        
        supervisor = {
          'name': newSupName,
          'gender': supGender,
          'relationship': (40 + random.nextInt(21)).toString(),
          'age': newSupAge.toString(),
          'isDeceased': 'false',
          'sexuality': 'Heteroseksual',
          'intelligence': (50 + random.nextInt(41)).toString(),
        };

        final String notice = '💼 Atasan Pensiun: Atasan lamamu, $oldSupName ($supAge tahun), telah pensiun. Atasan barumu kini adalah $newSupName ($newSupAge tahun).';
        events.add(notice);
        inbox.add(notice);
      }
    }

    // Check coworkers retirement/resignation (retired age: 60-65)
    if (jobName != null && coworkers.isNotEmpty) {
      final List<Map<String, String>> retiredCoworkers = [];
      for (var cm in coworkers) {
        final cmAge = int.tryParse(cm['age'] ?? '30') ?? 30;
        final retiredThreshold = 60 + random.nextInt(6);
        if (cmAge >= retiredThreshold) {
          retiredCoworkers.add(cm);
        }
      }

      for (var retired in retiredCoworkers) {
        coworkers.remove(retired);
        
        // Generate new coworker (fresh graduate: 22-23 years old)
        final cmGender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
        final firstList = cmGender == 'Laki-laki'
            ? ((maleFirstNames != null && maleFirstNames!.isNotEmpty) ? maleFirstNames! : globalMaleFirstNames)
            : ((femaleFirstNames != null && femaleFirstNames!.isNotEmpty) ? femaleFirstNames! : globalFemaleFirstNames);
        final lastList = (lastNames != null && lastNames!.isNotEmpty) ? lastNames! : globalLastNames;
        final newCmName = '${firstList[random.nextInt(firstList.length)]} ${lastList[random.nextInt(lastList.length)]}';
        final newCmAge = 22 + random.nextInt(2); // 22 to 23 (fresh grad)
        
        coworkers.add({
          'name': newCmName,
          'gender': cmGender,
          'relationship': (40 + random.nextInt(21)).toString(),
          'age': newCmAge.toString(),
          'isDeceased': 'false',
          'sexuality': 'Heteroseksual',
          'intelligence': (30 + random.nextInt(61)).toString(),
        });

        final String notice = '💼 Pergantian Rekan Kerja: Rekan kerjamu, ${retired['name']} (${retired['age']} tahun), telah pensiun/keluar dan digantikan oleh $newCmName ($newCmAge tahun).';
        events.add(notice);
        inbox.add(notice);
      }
    }

    // Tambah gaji dari pekerjaan jika ada
    if (jobName != null && jobSalary != null) {
      final double raisePercent = 0.03 + (random.nextDouble() * 0.03);
      final int raiseAmount = (jobSalary! * raisePercent).round();
      jobSalary = jobSalary! + raiseAmount;
      money += jobSalary!;
      final String notice = '💼 Gajian: Kamu menerima gaji sebesar \$$jobSalary (naik \$$raiseAmount) dari pekerjaanmu sebagai $jobName.';
      inbox.add(notice);
    }

    // Update karir Idol jika ada
    IdolManager.ageUpIdol(this, events, inbox);

    if (age == 12) {
      if (educationHistory['SD'] == 'Belum Lulus') {
        educationHistory['SD'] = 'Lulus';
      }
    } else if (age == 15) {
      if (educationHistory['SMP'] == 'Belum Lulus') {
        educationHistory['SMP'] = 'Lulus';
      }
    } else if (age == 18) {
      if (educationHistory['SMA'] == 'Belum Lulus') {
        educationHistory['SMA'] = 'Lulus';
      }
      final String notice = '🎓 Lulus SMA: Selamat! Kamu telah resmi lulus dari Sekolah Menengah Atas (SMA) 🎉';
      events.add(notice);
      inbox.add(notice);
      classmates.clear();
      smaTeachers.clear();
      smpTeachers.clear();
      sdTeachers.clear();
      headmaster = null;
      bkTeacher = null;
    }

    if (univMajor != null) {
      currentUnivStudyYears += 1;
      int targetYears = 4;
      String currentStage = 'S1';
      if (educationHistory['S2'] == 'Belum Lulus') {
        targetYears = 2;
        currentStage = 'S2';
      } else if (educationHistory['S3'] == 'Belum Lulus') {
        targetYears = 3;
        currentStage = 'S3';
      }

      if (currentUnivStudyYears >= targetYears) {
        educationHistory[currentStage] = 'Lulus';
        justGraduatedStage = currentStage; // Simpan jenjang yang baru lulus
        justGraduatedMajor = univMajor; // Simpan jurusan kuliah yang baru lulus
        final String notice = '🎓 Kelulusan Kuliah: Selamat! Kamu telah resmi lulus dari jenjang $currentStage dengan jurusan $univMajor! 🎉';
        if (currentStage != 'S1') {
          events.add(notice);
        }
        inbox.add(notice);
        if (univMajor != null) {
          final baseName = univMajor!.split(' (').first;
          if (!graduatedMajors.contains(baseName)) {
            graduatedMajors.add(baseName);
          }
        }
        univMajor = null;
        currentUnivStudyYears = 0;
        univClassmates.clear();
        univLecturers.clear();
      }
    }
    // Generate data sekolah secara otomatis jika kosong agar bisa memicu ajakan proposal di ageUp
    SchoolGenerator.generateClassmatesIfEmpty(this);
    SchoolGenerator.generateTeachersIfEmpty(this);

    // Logika HIV mengurangi kesehatan secara perlahan setiap tahun
    if (hasHIV) {
      health -= 10;
      events.add('🚨 Kesehatan Menurun: Virus HIV/AIDS yang bersarang di tubuhmu aktif dan menurunkan sistem kekebalan tubuh (-10% kesehatan).');
      inbox.add('🚨 Penyakit Kronis: Virus HIV/AIDS mengurangi kesehatanmu sebesar 10% tahun ini.');
    }

    if (health <= 0 || age > 100) {
      isAlive = false;
    }

    // 1. Cek Kematian Orang Tua
    if (fatherName != null && !isFatherDeceased && fatherAge != null) {
      fatherAge = fatherAge! + 1;
      if (isFatherImprisoned) {
        fatherPrisonYears--;
        if (fatherPrisonYears <= 0) {
          isFatherImprisoned = false;
          events.add('📢 Ayah Bebas: Ayahmu, $fatherName, telah menyelesaikan masa hukumannya dan dibebaskan dari penjara.');
        }
      }
      if (fatherAge! > 60) {
        int deathChance = (fatherAge! - 60) ~/ 2 + 1; // 1% - 15%
        if (random.nextInt(100) < deathChance) {
          isFatherDeceased = true;
          fatherRelationship = 0;
          isFatherImprisoned = false;
          events.add('👴 Kabar Duka: Ayahmu, $fatherName, meninggal dunia pada usia $fatherAge tahun.');
        }
      }
    }

    if (motherName != null && !isMotherDeceased && motherAge != null) {
      motherAge = motherAge! + 1;
      if (isMotherImprisoned) {
        motherPrisonYears--;
        if (motherPrisonYears <= 0) {
          isMotherImprisoned = false;
          events.add('📢 Ibu Bebas: Ibumu, $motherName, telah menyelesaikan masa hukumannya dan dibebaskan dari penjara.');
        }
      }
      if (motherAge! > 60) {
        int deathChance = (motherAge! - 60) ~/ 2 + 1;
        if (random.nextInt(100) < deathChance) {
          isMotherDeceased = true;
          motherRelationship = 0;
          isMotherImprisoned = false;
          events.add('👵 Kabar Duka: Ibumu, $motherName, meninggal dunia pada usia $motherAge tahun.');
        }
      }
    }

    if (stepFatherName != null && !isStepFatherDeceased && stepFatherAge != null) {
      stepFatherAge = stepFatherAge! + 1;
      if (stepFatherAge! > 60) {
        int deathChance = (stepFatherAge! - 60) ~/ 2 + 1;
        if (random.nextInt(100) < deathChance) {
          isStepFatherDeceased = true;
          stepFatherRelationship = 0;
          events.add('👨 Kabar Duka: Ayah tirimu, $stepFatherName, meninggal dunia pada usia $stepFatherAge tahun.');
        }
      }
    }

    if (stepMotherName != null && !isStepMotherDeceased && stepMotherAge != null) {
      stepMotherAge = stepMotherAge! + 1;
      if (stepMotherAge! > 60) {
        int deathChance = (stepMotherAge! - 60) ~/ 2 + 1;
        if (random.nextInt(100) < deathChance) {
          isStepMotherDeceased = true;
          stepMotherRelationship = 0;
          events.add('👩 Kabar Duka: Ibu tirimu, $stepMotherName, meninggal dunia pada usia $stepMotherAge tahun.');
        }
      }
    }

    if (fatherInLawName != null && !isFatherInLawDeceased && fatherInLawAge != null) {
      fatherInLawAge = fatherInLawAge! + 1;
      if (fatherInLawAge! > 60) {
        int deathChance = (fatherInLawAge! - 60) ~/ 2 + 1;
        if (random.nextInt(100) < deathChance) {
          isFatherInLawDeceased = true;
          fatherInLawRelationship = 0;
          events.add('👴 Kabar Duka: Ayah mertuamu, $fatherInLawName, meninggal dunia pada usia $fatherInLawAge tahun.');
        }
      }
    }

    if (motherInLawName != null && !isMotherInLawDeceased && motherInLawAge != null) {
      motherInLawAge = motherInLawAge! + 1;
      if (motherInLawAge! > 60) {
        int deathChance = (motherInLawAge! - 60) ~/ 2 + 1;
        if (random.nextInt(100) < deathChance) {
          isMotherInLawDeceased = true;
          motherInLawRelationship = 0;
          events.add('👵 Kabar Duka: Ibu mertuamu, $motherInLawName, meninggal dunia pada usia $motherInLawAge tahun.');
        }
      }
    }

    // --- LOGIKA REMARRY: DELEGASI KE PARENT_REMARRIAGE ---
    ParentRemarriage.checkAndApplyRemarriage(this, random, events);

    // Pastikan list siblings mutable agar bisa ditambahkan adik baru
    siblings = List<Map<String, String>>.from(siblings);

    // --- LOGIKA KELAHIRAN ADIK BARU DARI IBU / IBU TIRI YANG SUBUR ---
    final List<String> sibBoys = (maleFirstNames != null && maleFirstNames!.isNotEmpty) ? maleFirstNames! : ['Rafi', 'Daffa', 'Gibran', 'Zian', 'Aldi', 'Rehan', 'Fadel', 'Budi', 'Aditya'];
    final List<String> sibGirls = (femaleFirstNames != null && femaleFirstNames!.isNotEmpty) ? femaleFirstNames! : ['Aura', 'Nadia', 'Sania', 'Fatimah', 'Zahra', 'Keysha', 'Aurel', 'Santi', 'Putri'];

    // Kelahiran dari Ibu Kandung
    if (motherName != null && !isMotherDeceased && motherAge != null && motherAge! >= 18 && motherAge! <= 45) {
      // Jika orang tua sudah cerai, ibu tidak bisa melahirkan kecuali menikah lagi dengan pria lain (ada ayah tiri)
      final bool cannotHaveChild = isMotherDivorced && (stepFatherName == null || isStepFatherDeceased);
      
      final int birthChance = motherWillTryForBaby ? 80 : 6;
      if (!cannotHaveChild && random.nextInt(100) < birthChance) {
        motherWillTryForBaby = false; // reset flag
        final String gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
        final String firstName = gender == 'Laki-laki' ? sibBoys[random.nextInt(sibBoys.length)] : sibGirls[random.nextInt(sibGirls.length)];
        
        // Ambil nama belakang dari ayah kandung atau ayah tiri, jika tidak ada pakai nama belakang player/ibu
        String lastName = '';
        if (fatherName != null && !isFatherDeceased && !isMotherDivorced) {
          final parts = fatherName!.split(' ');
          if (parts.length > 1) lastName = parts.last;
        } else if (stepFatherName != null && !isStepFatherDeceased) {
          final parts = stepFatherName!.split(' ');
          if (parts.length > 1) lastName = parts.last;
        }
        
        if (lastName.isEmpty) {
          final parts = name.split(' ');
          if (parts.length > 1) lastName = parts.last;
        }
        
        final String babyName = lastName.isNotEmpty ? '$firstName $lastName' : firstName;
        
        // Tentukan apakah saudara tiri atau kandung
        // Jika tidak ada ayah kandung, atau ayah kandung meninggal, atau orang tua sudah cerai tapi ada ayah tiri -> adik tiri
        final bool isStepSibling = (fatherName == null || isFatherDeceased || isMotherDivorced);
        final String relType = isStepSibling
            ? (gender == 'Laki-laki' ? 'Adik Tiri Laki-laki' : 'Adik Tiri Perempuan')
            : (gender == 'Laki-laki' ? 'Adik Laki-laki' : 'Adik Perempuan');
            
        final String notice = '👶 Adik Baru Lahir! Ibumu melahirkan seorang $relType bernama $babyName.';
        events.add(notice);
        inbox.add(notice);
        
        siblings.add({
          'name': babyName,
          'gender': gender,
          'relation': relType,
          'relationship': '80',
          'age': '0',
          'isDeceased': 'false',
        });
      }
    }

    // Kelahiran dari Ibu Tiri
    if (stepMotherName != null && !isStepMotherDeceased && stepMotherAge != null && stepMotherAge! >= 18 && stepMotherAge! <= 45) {
      // Peluang 6% per tahun untuk melahirkan anak baru
      if (random.nextInt(100) < 6) {
        final String gender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
        final String firstName = gender == 'Laki-laki' ? sibBoys[random.nextInt(sibBoys.length)] : sibGirls[random.nextInt(sibGirls.length)];
        
        // Ibu tiri melahirkan anak dari ayah kandung kita
        String lastName = '';
        if (fatherName != null && !isFatherDeceased) {
          final parts = fatherName!.split(' ');
          if (parts.length > 1) lastName = parts.last;
        }
        if (lastName.isEmpty) {
          final parts = name.split(' ');
          if (parts.length > 1) lastName = parts.last;
        }
        
        final String babyName = lastName.isNotEmpty ? '$firstName $lastName' : firstName;
        
        // Anak dari Ibu Tiri selalu Adik Tiri bagi player
        final String relType = gender == 'Laki-laki' ? 'Adik Tiri Laki-laki' : 'Adik Tiri Perempuan';
        
        final String notice = '👶 Adik Baru Lahir! Ibu Tirimu ($stepMotherName) melahirkan seorang $relType bernama $babyName.';
        events.add(notice);
        inbox.add(notice);
        
        siblings.add({
          'name': babyName,
          'gender': gender,
          'relation': relType,
          'relationship': '80',
          'age': '0',
          'isDeceased': 'false',
        });
      }
    }

    // 2. Sibling Aging & Birth & Death
    for (var sib in siblings) {
      bool isDeceased = sib['isDeceased'] == 'true';
      if (!isDeceased) {
        int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
        int nextAge = sibAge + 1;
        sib['age'] = nextAge.toString();

        if (sibAge < 0 && nextAge == 0) {
          // Adik baru saja lahir
          events.add('👶 Adik Baru Lahir! Ibumu melahirkan seorang ${sib['relation']!.contains('Laki') ? 'Adik Laki-laki' : 'Adik Perempuan'} bernama ${sib['name']}.');
        } else {
          // Increment dating or engagement years if partner exists
          if (sib['spouseName'] != null) {
            if (sib['isEngaged'] == 'true') {
              final int engYears = int.tryParse(sib['engagementYears'] ?? '0') ?? 0;
              sib['engagementYears'] = (engYears + 1).toString();
            } else if (sib['isMarried'] == 'false') {
              final int datYears = int.tryParse(sib['datingYears'] ?? '0') ?? 0;
              sib['datingYears'] = (datYears + 1).toString();
            }
          }

          // --- LOGIKA DINAMIS PACARAN, LAMARAN, PERNIKAHAN, & KEHAMILAN SAUDARA (KAKA/ADIK) ---
          // A. Pacaran (Jika usia >= 12, belum bertunangan/menikah dan belum punya pasangan)
          if (nextAge >= 12 && sib['spouseName'] == null) {
            // Peluang 12% per tahun untuk dapat Pacar
            if (random.nextInt(100) < 12) {
              final String spouseGender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
              final List<String> boys = (maleFirstNames != null && maleFirstNames!.isNotEmpty) ? maleFirstNames! : Character.globalMaleFirstNames;
              final List<String> girls = (femaleFirstNames != null && femaleFirstNames!.isNotEmpty) ? femaleFirstNames! : Character.globalFemaleFirstNames;
              final List<String> familyNames = (lastNames != null && lastNames!.isNotEmpty) ? lastNames! : Character.globalLastNames;
              final String spouseName = spouseGender == 'Laki-laki' 
                  ? '${boys[random.nextInt(boys.length)]} ${familyNames[random.nextInt(familyNames.length)]}'
                  : '${girls[random.nextInt(girls.length)]} ${familyNames[random.nextInt(familyNames.length)]}';
              
              sib['spouseName'] = spouseName;
              sib['spouseGender'] = spouseGender;
              sib['spouseAge'] = (nextAge + random.nextInt(5) - 2).clamp(10, 100).toString();
              sib['isEngaged'] = 'false';
              sib['isMarried'] = 'false';
              sib['datingYears'] = '0';
              sib['engagementYears'] = '0';
              
              final String sibGender = sib['gender'] ?? 'Laki-laki';
              final String relationshipPrefix = (sibGender == spouseGender) 
                  ? (sibGender == 'Laki-laki' ? 'menjadi gay berpacaran dengan ' : 'menjadi lesbian berpacaran dengan ') 
                  : 'berpacaran dengan ';
              
              final String notice = '💬 Kabar Keluarga: Saudaramu, ${sib['name']} (${sib['relation']}, $nextAge tahun) sekarang $relationshipPrefix$spouseName!';
              events.add(notice);
              inbox.add(notice);
            }
          }
          // B. Dilamar / Melamar (Jika sudah punya pacar, belum bertunangan/menikah, dan usia >= 18)
          else if (sib['spouseName'] != null && sib['isEngaged'] == 'false' && sib['isMarried'] == 'false' && nextAge >= 18) {
            final int datingYears = int.tryParse(sib['datingYears'] ?? '0') ?? 0;
            int engageChance = 0;
            if (datingYears == 2) {
              engageChance = 25; // 25%
            } else if (datingYears == 3) {
              engageChance = 50; // 50%
            } else if (datingYears >= 4) {
              engageChance = 75; // 75%
            }

            if (engageChance > 0 && random.nextInt(100) < engageChance) {
              sib['isEngaged'] = 'true';
              sib['engagementYears'] = '0'; // reset/start engagement timer
              final bool isSameSex = sib['gender'] == sib['spouseGender'];
              final String notice = isSameSex
                  ? '💍 Kabar Keluarga: Saudaramu, ${sib['name']} (${sib['relation']}, $nextAge tahun) bertunangan sesama jenis dengan kekasihnya, ${sib['spouseName']}! 🏳️‍🌈'
                  : '💍 Kabar Keluarga: Saudaramu, ${sib['name']} (${sib['relation']}, $nextAge tahun) bertunangan dengan kekasihnya, ${sib['spouseName']}!';
              events.add(notice);
              inbox.add(notice);
            }
          }
          // C. Menikah (Jika sudah bertunangan, belum menikah, dan usia >= 18)
          else if (sib['isEngaged'] == 'true' && sib['isMarried'] == 'false' && nextAge >= 18) {
            int manAge = nextAge;
            if (sib['gender'] == 'Laki-laki') {
              manAge = nextAge;
            } else if (sib['spouseGender'] == 'Laki-laki') {
              manAge = int.tryParse(sib['spouseAge'] ?? '0') ?? 0;
            }

            if (manAge >= 20 && manAge <= 35) {
              final int engagementYears = int.tryParse(sib['engagementYears'] ?? '0') ?? 0;
              int marryChance = 0;
              if (engagementYears == 1) {
                marryChance = 30; // 30%
              } else if (engagementYears == 2) {
                marryChance = 60; // 60%
              } else if (engagementYears >= 3) {
                marryChance = 90; // 90%
              }

              if (marryChance > 0 && random.nextInt(100) < marryChance) {
                sib['isMarried'] = 'true';
                sib['isEngaged'] = 'false'; // ganti status
                final bool isSameSex = sib['gender'] == sib['spouseGender'];
                final String notice = isSameSex
                    ? '🎉 Kabar Keluarga: Selamat! Saudaramu, ${sib['name']} (${sib['relation']}, $nextAge tahun) resmi menikah sesama jenis dengan ${sib['spouseName']}! 🏳️‍🌈'
                    : '🎉 Kabar Keluarga: Selamat! Saudaramu, ${sib['name']} (${sib['relation']}, $nextAge tahun) resmi menikah dengan ${sib['spouseName']}!';
                events.add(notice);
                inbox.add(notice);
              }
            }
          }
          
          // D. Kehamilan / Anak
          // Hamil luar nikah: 20% di bawah umur, 25% cukup umur. Punya suami/istri (berbeda jenis kelamin): 70%
          if (nextAge >= 12 && nextAge <= 45) {
            final bool isFemale = sib['gender'] == 'Perempuan';
            final bool hasPartner = sib['spouseName'] != null;
            final bool isMarried = sib['isMarried'] == 'true';
            final bool hasOppositeSpouse = hasPartner && (sib['gender'] != sib['spouseGender']);
            
            double pregChance = 0.0;
            if (isMarried && hasOppositeSpouse) {
              pregChance = 70.0;
            } else if (hasPartner && !isMarried && hasOppositeSpouse) {
              if (nextAge < 18) {
                pregChance = 20.0;
              } else {
                pregChance = 25.0;
              }
            } else if (!hasPartner && isFemale) {
              if (nextAge < 18) {
                pregChance = 2.0;
              } else {
                pregChance = 4.0;
              }
            }
            
            if (random.nextInt(100) < pregChance) {
              final String babyGender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
              final List<String> boys = (maleFirstNames != null && maleFirstNames!.isNotEmpty) ? maleFirstNames! : globalMaleFirstNames;
              final List<String> girls = (femaleFirstNames != null && femaleFirstNames!.isNotEmpty) ? femaleFirstNames! : globalFemaleFirstNames;
              final List<String> familyNames = (lastNames != null && lastNames!.isNotEmpty) ? lastNames! : globalLastNames;
              final String babyName = babyGender == 'Laki-laki'
                  ? '${boys[random.nextInt(boys.length)]} ${familyNames[random.nextInt(familyNames.length)]}'
                  : '${girls[random.nextInt(girls.length)]} ${familyNames[random.nextInt(familyNames.length)]}';
                  
              final List<String> cNames = sib['childNames'] != null && sib['childNames']!.isNotEmpty ? sib['childNames']!.split(',') : [];
              final List<String> cAges = sib['childAges'] != null && sib['childAges']!.isNotEmpty ? sib['childAges']!.split(',') : [];
              final List<String> cGenders = sib['childGenders'] != null && sib['childGenders']!.isNotEmpty ? sib['childGenders']!.split(',') : [];
              
              cNames.add(babyName);
              cAges.add('0');
              cGenders.add(babyGender);
              
              sib['childNames'] = cNames.join(',');
              sib['childAges'] = cAges.join(',');
              sib['childGenders'] = cGenders.join(',');
              
              String notice;
              if (isFemale) {
                notice = isMarried
                    ? '👶 Kabar Keluarga: Saudaramu, ${sib['name']} (${sib['relation']}) melahirkan anak bernama $babyName dari suaminya!'
                    : '👶 Kabar Keluarga: Saudaramu, ${sib['name']} (${sib['relation']}) melahirkan anak di luar nikah bernama $babyName!';
              } else {
                notice = isMarried
                    ? '👶 Kabar Keluarga: Istri dari saudaramu, ${sib['name']} (${sib['relation']}) melahirkan seorang anak bernama $babyName!'
                    : '👶 Kabar Keluarga: Pacar dari saudaramu, ${sib['name']} (${sib['relation']}) melahirkan seorang anak bernama $babyName!';
              }
              events.add(notice);
              inbox.add(notice);
            }
          }
          
          // E. Umur anak-anak sibling (Keponakan) bertambah
          if (sib['childAges'] != null && sib['childAges']!.isNotEmpty) {
            final List<String> cAges = sib['childAges']!.split(',');
            for (int i = 0; i < cAges.length; i++) {
              int cAge = int.tryParse(cAges[i]) ?? 0;
              cAges[i] = (cAge + 1).toString();
            }
            sib['childAges'] = cAges.join(',');
          }

          if (nextAge > 65) {
            int deathChance = (nextAge - 65) ~/ 3 + 1;
            if (random.nextInt(100) < deathChance) {
              sib['isDeceased'] = 'true';
              sib['relationship'] = '0';
              events.add('💀 Kabar Duka: Saudaramu, ${sib['name']} (${sib['relation']}), meninggal dunia pada usia $nextAge tahun.');
            }
          }
        }
      }
    }

    // 2b. Extended Family Aging & Death
    for (var ext in extendedFamily) {
      bool isDeceased = ext['isDeceased'] == 'true';
      if (!isDeceased) {
        int extAge = int.tryParse(ext['age'] ?? '0') ?? 0;
        int nextAge = extAge + 1;
        ext['age'] = nextAge.toString();

        if (extAge < 0 && nextAge == 0) {
          // Sepupu baru lahir
          events.add('👶 Sepupu Baru Lahir! Paman/Bibimu dikaruniai anak bernama ${ext['name']}.');
        } else if (nextAge > 65) {
          // Risiko kematian lansia kakek/nenek/paman/bibi
          int deathChance = (nextAge - 65) ~/ 2 + 1;
          if (random.nextInt(100) < deathChance) {
            ext['isDeceased'] = 'true';
            ext['relationship'] = '0';
            events.add('💀 Kabar Duka: Keluargamu, ${ext['name']} (${ext['relation']}), meninggal dunia pada usia $nextAge tahun.');
          }
        }
      }
    }

    // 2c. Classmate Aging
    for (var cm in classmates) {
      bool isDeceased = cm['isDeceased'] == 'true';
      if (!isDeceased) {
        int cmAge = int.tryParse(cm['age'] ?? '0') ?? 0;
        int nextAge = cmAge + 1;
        cm['age'] = nextAge.toString();
      }
    }

    // 2d. Headmaster and BK Teacher Aging
    if (headmaster != null) {
      int headAge = int.tryParse(headmaster!['age'] ?? '0') ?? 0;
      headmaster!['age'] = (headAge + 1).toString();
    }
    if (bkTeacher != null) {
      int bkAge = int.tryParse(bkTeacher!['age'] ?? '0') ?? 0;
      bkTeacher!['age'] = (bkAge + 1).toString();
    }
    if (sdHeadmaster != null) {
      int headAge = int.tryParse(sdHeadmaster!['age'] ?? '0') ?? 0;
      sdHeadmaster!['age'] = (headAge + 1).toString();
    }
    if (sdBkTeacher != null) {
      int bkAge = int.tryParse(sdBkTeacher!['age'] ?? '0') ?? 0;
      sdBkTeacher!['age'] = (bkAge + 1).toString();
    }
    if (smpHeadmaster != null) {
      int headAge = int.tryParse(smpHeadmaster!['age'] ?? '0') ?? 0;
      smpHeadmaster!['age'] = (headAge + 1).toString();
    }
    if (smpBkTeacher != null) {
      int bkAge = int.tryParse(smpBkTeacher!['age'] ?? '0') ?? 0;
      smpBkTeacher!['age'] = (bkAge + 1).toString();
    }

    // 3. Child Aging & Death & Romance Activity
    for (var child in children) {
      bool isDeceased = child['isDeceased'] == 'true';
      if (!isDeceased) {
        int childAge = int.tryParse(child['age'] ?? '0') ?? 0;
        int nextAge = childAge + 1;
        child['age'] = nextAge.toString();

        // Cek kejadian anak pacaran/bercinta saat bertambah usia (untuk anak usia 12 ke atas)
        if (nextAge >= 12) {
          if (random.nextInt(100) < 15) {
            // Tentukan tipe aktivitas anak secara acak
            final List<String> activities = [
              'sedang berpacaran dengan teman sekolahnya secara diam-diam.',
              'ketahuan sedang bercinta (Make Love) dengan pasangannya.',
              'menghabiskan malam bersama kekasihnya di kamar.',
              'mengaku sudah melakukan hubungan intim (Make Love) pertama kalinya.'
            ];
            final String chosenActivity = activities[random.nextInt(activities.length)];
            final String notification = '📢 Aktivitas Anak: Anakmu, ${child['name']} (Usia $nextAge tahun), $chosenActivity';
            
            // Masukkan ke log events (Popup Age Up) dan Inbox
            events.add(notification);
            inbox.add(notification);
          }
        }

        if (random.nextInt(150) == 42) {
          child['isDeceased'] = 'true';
          child['relationship'] = '0';
          events.add('🥀 Kabar Duka: Anakmu, ${child['name']}, meninggal dunia secara tragis pada usia $nextAge tahun.');
        }
      }
    }

    // 4. Partner Aging & Death (Untuk semua partner)
    void ageUpPartnerMap(Map<String, String>? pMap, String defaultLabel) {
      if (pMap == null) return;
      bool isDeceased = pMap['isDeceased'] == 'true';
      if (!isDeceased) {
        int partnerAge = int.tryParse(pMap['age'] ?? '0') ?? 0;
        int nextAge = partnerAge + 1;
        pMap['age'] = nextAge.toString();
        if (nextAge > 60) {
          int deathChance = (nextAge - 60) ~/ 2 + 1;
          if (random.nextInt(100) < deathChance) {
            pMap['isDeceased'] = 'true';
            pMap['relationship'] = '0';
            events.add('💔 Kabar Duka: $defaultLabel-mu, ${pMap['name']}, meninggal dunia pada usia $nextAge tahun.');
          }
        }
      }
    }

    ageUpPartnerMap(partner, 'Pacar');
    ageUpPartnerMap(secondPartner, 'Pacar');
    ageUpPartnerMap(thirdPartner, 'Pacar');
    ageUpPartnerMap(fourthPartner, 'Pacar');
    ageUpPartnerMap(fifthPartner, 'Pacar');
    for (var sp in secretPartners) {
      ageUpPartnerMap(sp, 'Pacar (Rahasia)');
    }

    // --- LOGIKA MELAHIRKAN ---
    if (isPregnant || partnerIsPregnant) {
      // --- LOGIKA PENYAKIT & PENGAMATAN PENGAMAN ---
      // Tampilkan notifikasi di inbox jika user atau pasangan mengidap penyakit menular seksual aktif
      if (hasHIV || hasSifilis || hasHPV) {
        String diseases = [
          if (hasHIV) 'HIV/AIDS',
          if (hasSifilis) 'Sifilis & Gonore',
          if (hasHPV) 'HPV'
        ].join(', ');
        inbox.add('🚨 Kondisi Medis: Kamu saat ini mengidap penyakit $diseases. Segera lakukan pengobatan jika memungkinkan!');
      }

      void _handleSingleBirth(String? partnerName) {
        final String childGender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
        
        final List<String> boys = (maleFirstNames != null && maleFirstNames!.isNotEmpty) ? maleFirstNames! : ['Rafi', 'Daffa', 'Gibran', 'Zian', 'Aldi', 'Rehan', 'Fadel', 'Budi', 'Aditya'];
        final List<String> girls = (femaleFirstNames != null && femaleFirstNames!.isNotEmpty) ? femaleFirstNames! : ['Aura', 'Nadia', 'Sania', 'Fatimah', 'Zahra', 'Keysha', 'Aurel', 'Santi', 'Putri'];
        
        final String childFirstName = childGender == 'Laki-laki' 
            ? boys[random.nextInt(boys.length)] 
            : girls[random.nextInt(girls.length)];
        
        final List<String> playerParts = name.split(' ');
        final String childLastName = playerParts.length > 1 ? playerParts.last : '';
        final String childName = childLastName.isNotEmpty ? '$childFirstName $childLastName' : childFirstName;

        final String partnerNameClean = partnerName ?? (partner != null ? (partner!['name'] ?? 'Pasangan') : 'Pasangan');
        
        // Jalankan logika konsekuensi kehamilan inses
        final incestRes = handleIncestPregnancyEffect(this, random);

        if (incestRes['keguguran'] == true) {
          events.add(incestRes['pesan']);
        } else {
          final bool hasGeneticDefect = incestRes['kelainanGenetik'] == true;
          if (hasGeneticDefect) {
            events.add(incestRes['pesan']);
          }

          String father = 'Tidak diketahui';
          String mother = 'Tidak diketahui';

          if (gender == 'Laki-laki' || gender == 'laki-laki') {
            father = name;
            mother = partnerNameClean;
          } else {
            father = partnerNameClean;
            mother = name;
          }

          // Dapatkan warna kulit partner
          String? partnerSkinColor;
          if (partner != null && partner!['name'] == partnerNameClean) {
            partnerSkinColor = partner!['skinColor'];
          } else if (secondPartner != null && secondPartner!['name'] == partnerNameClean) {
            partnerSkinColor = secondPartner!['skinColor'];
          } else if (thirdPartner != null && thirdPartner!['name'] == partnerNameClean) {
            partnerSkinColor = thirdPartner!['skinColor'];
          } else if (fourthPartner != null && fourthPartner!['name'] == partnerNameClean) {
            partnerSkinColor = fourthPartner!['skinColor'];
          } else if (fifthPartner != null && fifthPartner!['name'] == partnerNameClean) {
            partnerSkinColor = fifthPartner!['skinColor'];
          }

          // Warna kulit anak = campuran warna kulit user dan pasangan
          final String childSkinColor = SkinColorInheritance.blendChildSkin(
            avatarSkinColor,
            partnerSkinColor,
          );

          children.add({
            'name': childName,
            'gender': childGender,
            'relationship': '80',
            'age': '0',
            'father': father,
            'mother': mother,
            'isDeceased': 'false',
            'trait': hasGeneticDefect ? 'Mengidap Kelainan Genetik' : 'Sehat',
            'skinColor': childSkinColor,
          });

          String birthMsg = '👶 Anak Baru Lahir! Selamat, anak ${childGender == 'Laki-laki' ? 'Laki-laki' : 'Perempuan'} bernama $childName telah lahir ke dunia (Ibu: $partnerNameClean).';
          if (hasGeneticDefect) {
            birthMsg += ' (⚠️ Anak lahir cacat akibat kelainan genetik dari hubungan sedarah)';
          }
          events.add(birthMsg);
          inbox.add(birthMsg);
        }
      }

      if (isPregnant) {
        _handleSingleBirth(null);
      }

      if (partnerIsPregnant) {
        if (pregnantByPartnerName != null && pregnantByPartnerName!.isNotEmpty) {
          final List<String> pregnantPartners = pregnantByPartnerName!.split(', ');
          for (var pName in pregnantPartners) {
            _handleSingleBirth(pName.trim());
          }
        } else {
          _handleSingleBirth(partner != null ? partner!['name'] : 'Pasangan');
        }
      }

      isPregnant = false;
      partnerIsPregnant = false;
      pregnantByPartnerName = null;
      pregnantByPartnerRole = null;
    }

    // --- LOGIKA AJAKAN INCEST DARI KELUARGA ATAU ROMANTIKA SEKOLAH ---
    // Dipicu jika usia karakter >= 6 tahun dan belum punya proposal aktif
    if (age >= 6 && activeProposal == null) {
      // --- DELEGASI LOGIKA AJAKAN PACARAN & MAKE LOVE KE AJAKAN_HANDLER ---
      AjakanHandler.checkAndGenerateProposal(this, random);
    }

    syncNPCsAndPartners();
    syncPartnerDeathStatus();
    syncSocialRelationships();
    return events;
  }

  // --- LOGIKA WEALTH GETTER & SETTER KELUARGA / NPC ---
  int getFatherWealth() {
    if (fatherWealth == null) {
      fatherWealth = Random().nextInt(9501) + 500;
    }
    return fatherWealth!;
  }

  int getMotherWealth() {
    if (motherWealth == null) {
      motherWealth = Random().nextInt(9501) + 500;
    }
    return motherWealth!;
  }

  int getStepFatherWealth() {
    if (stepFatherWealth == null) {
      stepFatherWealth = Random().nextInt(9501) + 500;
    }
    return stepFatherWealth!;
  }

  int getStepMotherWealth() {
    if (stepMotherWealth == null) {
      stepMotherWealth = Random().nextInt(9501) + 500;
    }
    return stepMotherWealth!;
  }

  int getFatherInLawWealth() {
    if (fatherInLawWealth == null) {
      fatherInLawWealth = Random().nextInt(9501) + 500;
    }
    return fatherInLawWealth!;
  }

  int getMotherInLawWealth() {
    if (motherInLawWealth == null) {
      motherInLawWealth = Random().nextInt(9501) + 500;
    }
    return motherInLawWealth!;
  }

  int getTargetWealth(String targetName, String targetRole) {
    final String cleanName = targetName.toLowerCase();
    final String cleanRole = targetRole.toLowerCase();

    // 1. Check parent fields
    if (fatherName != null && (cleanName == fatherName!.toLowerCase() || cleanName.contains(fatherName!.toLowerCase()))) {
      return getFatherWealth();
    }
    if (motherName != null && (cleanName == motherName!.toLowerCase() || cleanName.contains(motherName!.toLowerCase()))) {
      return getMotherWealth();
    }
    if (stepFatherName != null && (cleanName == stepFatherName!.toLowerCase() || cleanName.contains(stepFatherName!.toLowerCase()))) {
      return getStepFatherWealth();
    }
    if (stepMotherName != null && (cleanName == stepMotherName!.toLowerCase() || cleanName.contains(stepMotherName!.toLowerCase()))) {
      return getStepMotherWealth();
    }
    if (cleanRole.contains('mertua')) {
      if (targetName.startsWith('Ayah')) {
        return getFatherInLawWealth();
      } else {
        return getMotherInLawWealth();
      }
    }

    // Helper to get from a list of maps
    int? getFromList(List<Map<String, String>> list) {
      for (var item in list) {
        if (item['name'] == targetName || (item['name'] != null && cleanName.contains(item['name']!.toLowerCase()))) {
          if (!item.containsKey('money')) {
            int targetAge = int.tryParse(item['age'] ?? '0') ?? 0;
            final random = Random();
            int initialMoney = 0;
            if (targetAge >= 6 && targetAge <= 11) {
              initialMoney = random.nextInt(10) + 1;
            } else if (targetAge >= 12 && targetAge <= 14) {
              initialMoney = random.nextInt(31) + 20;
            } else if (targetAge >= 15 && targetAge <= 18) {
              initialMoney = random.nextInt(101) + 100;
            } else if (targetAge >= 19) {
              initialMoney = random.nextInt(9501) + 500;
            }
            item['money'] = initialMoney.toString();
          }
          return int.tryParse(item['money'] ?? '0') ?? 0;
        }
      }
      return null;
    }

    // 2. Check siblings, extendedFamily, classmates, coworkers, exPartners, etc.
    int? val = getFromList(children);
    if (val != null) return val;
    val = getFromList(siblings);
    if (val != null) return val;
    val = getFromList(extendedFamily);
    if (val != null) return val;
    val = getFromList(classmates);
    if (val != null) return val;
    val = getFromList(univClassmates);
    if (val != null) return val;
    val = getFromList(coworkers);
    if (val != null) return val;
    val = getFromList(exPartners);
    if (val != null) return val;

    // Check supervisor
    if (supervisor != null && supervisor!['name'] == targetName) {
      if (!supervisor!.containsKey('money')) {
        int initialMoney = (Random().nextInt(9501) + 500) * 2;
        supervisor!['money'] = initialMoney.toString();
      }
      return int.tryParse(supervisor!['money'] ?? '0') ?? 0;
    }

    // Check partners
    if (partner != null && partner!['name'] == targetName) {
      if (!partner!.containsKey('money')) {
        int targetAge = int.tryParse(partner!['age'] ?? '18') ?? 18;
        int initialMoney = targetAge >= 19 ? Random().nextInt(9501) + 500 : Random().nextInt(101) + 100;
        partner!['money'] = initialMoney.toString();
      }
      return int.tryParse(partner!['money'] ?? '0') ?? 0;
    }
    if (secondPartner != null && secondPartner!['name'] == targetName) {
      if (!secondPartner!.containsKey('money')) {
        int targetAge = int.tryParse(secondPartner!['age'] ?? '18') ?? 18;
        int initialMoney = targetAge >= 19 ? Random().nextInt(9501) + 500 : Random().nextInt(101) + 100;
        secondPartner!['money'] = initialMoney.toString();
      }
      return int.tryParse(secondPartner!['money'] ?? '0') ?? 0;
    }
    
    // Fallback if not found anywhere (e.g. teachers)
    int ageVal = 18;
    if (cleanRole.contains('guru') || cleanRole.contains('dosen') || cleanRole.contains('kepala sekolah')) {
      ageVal = 35;
    }
    int initialMoney = ageVal >= 19 ? Random().nextInt(9501) + 500 : Random().nextInt(101) + 100;
    return initialMoney;
  }

  void setTargetWealth(String targetName, String targetRole, int newWealth) {
    final String cleanName = targetName.toLowerCase();
    final String cleanRole = targetRole.toLowerCase();

    if (fatherName != null && (cleanName == fatherName!.toLowerCase() || cleanName.contains(fatherName!.toLowerCase()))) {
      fatherWealth = newWealth;
      return;
    }
    if (motherName != null && (cleanName == motherName!.toLowerCase() || cleanName.contains(motherName!.toLowerCase()))) {
      motherWealth = newWealth;
      return;
    }
    if (stepFatherName != null && (cleanName == stepFatherName!.toLowerCase() || cleanName.contains(stepFatherName!.toLowerCase()))) {
      stepFatherWealth = newWealth;
      return;
    }
    if (stepMotherName != null && (cleanName == stepMotherName!.toLowerCase() || cleanName.contains(stepMotherName!.toLowerCase()))) {
      stepMotherWealth = newWealth;
      return;
    }
    if (cleanRole.contains('mertua')) {
      if (targetName.startsWith('Ayah')) {
        fatherInLawWealth = newWealth;
      } else {
        motherInLawWealth = newWealth;
      }
      return;
    }

    void setInList(List<Map<String, String>> list) {
      for (var item in list) {
        if (item['name'] == targetName || (item['name'] != null && cleanName.contains(item['name']!.toLowerCase()))) {
          item['money'] = newWealth.toString();
          return;
        }
      }
    }

    setInList(children);
    setInList(siblings);
    setInList(extendedFamily);
    setInList(classmates);
    setInList(univClassmates);
    setInList(coworkers);
    setInList(exPartners);

    if (partner != null && partner!['name'] == targetName) {
      partner!['money'] = newWealth.toString();
    }
    if (secondPartner != null && secondPartner!['name'] == targetName) {
      secondPartner!['money'] = newWealth.toString();
    }
  }

  // --- LOGIKA PEKERJAAN & GAJI NPC ---
  Map<String, dynamic> _generateRandomJob() {
    final random = Random();
    final int roll = random.nextInt(100);
    List<String> categories;
    if (roll < 20) {
      categories = ['Dasar', 'Layanan'];
    } else if (roll < 60) {
      categories = ['Terampil', 'Kreatif'];
    } else if (roll < 90) {
      categories = ['Profesional'];
    } else {
      categories = ['Prestise'];
    }

    final candidateJobs = KerjaMenuScreen.availableJobs.where((j) {
      final String cat = j['category'] as String? ?? '';
      return categories.contains(cat);
    }).toList();

    final jobsList = candidateJobs.isNotEmpty ? candidateJobs : KerjaMenuScreen.availableJobs;
    final chosenJob = jobsList[random.nextInt(jobsList.length)];
    final String jobNameVal = chosenJob['title'] as String? ?? 'Karyawan';
    final int baseSalary = chosenJob['salary'] as int? ?? 1000;
    
    // Tambahkan sedikit variasi acak pada gaji awal (+/- 10%)
    final double variation = 0.9 + (random.nextDouble() * 0.2);
    final int salaryVal = (baseSalary * variation).round();

    return {'job': jobNameVal, 'salary': salaryVal};
  }

  Map<String, dynamic> getNPCJobInfo(String targetName, String targetRole) {
    final String cleanName = targetName.toLowerCase();
    final String cleanRole = targetRole.toLowerCase();

    int ageVal = 0;
    if (fatherName != null && (cleanName == fatherName!.toLowerCase() || cleanName.contains(fatherName!.toLowerCase()))) {
      ageVal = fatherAge ?? 40;
      if (ageVal < 19) return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
      if (fatherJob == null) {
        final j = _generateRandomJob();
        fatherJob = j['job'];
        fatherSalary = j['salary'];
      }
      return {'status': 'Bekerja', 'job': fatherJob, 'salary': fatherSalary};
    }
    if (motherName != null && (cleanName == motherName!.toLowerCase() || cleanName.contains(motherName!.toLowerCase()))) {
      ageVal = motherAge ?? 38;
      if (ageVal < 19) return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
      if (motherJob == null) {
        final j = _generateRandomJob();
        motherJob = j['job'];
        motherSalary = j['salary'];
      }
      return {'status': 'Bekerja', 'job': motherJob, 'salary': motherSalary};
    }
    if (stepFatherName != null && (cleanName == stepFatherName!.toLowerCase() || cleanName.contains(stepFatherName!.toLowerCase()))) {
      ageVal = stepFatherAge ?? 40;
      if (ageVal < 19) return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
      if (stepFatherJob == null) {
        final j = _generateRandomJob();
        stepFatherJob = j['job'];
        stepFatherSalary = j['salary'];
      }
      return {'status': 'Bekerja', 'job': stepFatherJob, 'salary': stepFatherSalary};
    }
    if (stepMotherName != null && (cleanName == stepMotherName!.toLowerCase() || cleanName.contains(stepMotherName!.toLowerCase()))) {
      ageVal = stepMotherAge ?? 38;
      if (ageVal < 19) return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
      if (stepMotherJob == null) {
        final j = _generateRandomJob();
        stepMotherJob = j['job'];
        stepMotherSalary = j['salary'];
      }
      return {'status': 'Bekerja', 'job': stepMotherJob, 'salary': stepMotherSalary};
    }
    if (cleanRole.contains('mertua')) {
      if (targetName.startsWith('Ayah')) {
        ageVal = fatherInLawAge ?? 50;
        if (ageVal < 19) return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
        if (fatherInLawJob == null) {
          final j = _generateRandomJob();
          fatherInLawJob = j['job'];
          fatherInLawSalary = j['salary'];
        }
        return {'status': 'Bekerja', 'job': fatherInLawJob, 'salary': fatherInLawSalary};
      } else {
        ageVal = motherInLawAge ?? 48;
        if (ageVal < 19) return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
        if (motherInLawJob == null) {
          final j = _generateRandomJob();
          motherInLawJob = j['job'];
          motherInLawSalary = j['salary'];
        }
        return {'status': 'Bekerja', 'job': motherInLawJob, 'salary': motherInLawSalary};
      }
    }

    Map<String, dynamic>? getFromList(List<Map<String, String>> list, String listRole) {
      for (var item in list) {
        if (item['name'] == targetName || (item['name'] != null && cleanName.contains(item['name']!.toLowerCase()))) {
          int targetAge = int.tryParse(item['age'] ?? '0') ?? 0;
          if (targetAge < 19) {
            return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
          }
          if (!item.containsKey('job')) {
            if (listRole == 'Rekan Kerja' && jobName != null) {
              item['job'] = jobName!;
              item['salary'] = (jobSalary ?? 2000).toString();
            } else {
              final j = _generateRandomJob();
              item['job'] = j['job'];
              item['salary'] = j['salary'].toString();
            }
          }
          return {
            'status': 'Bekerja',
            'job': item['job'],
            'salary': int.tryParse(item['salary'] ?? '0') ?? 0
          };
        }
      }
      return null;
    }

    var val = getFromList(siblings, 'Saudara');
    if (val != null) return val;
    val = getFromList(extendedFamily, 'Keluarga');
    if (val != null) return val;
    val = getFromList(classmates, 'Teman Sekelas');
    if (val != null) return val;
    val = getFromList(univClassmates, 'Teman Kuliah');
    if (val != null) return val;
    val = getFromList(coworkers, 'Rekan Kerja');
    if (val != null) return val;
    val = getFromList(exPartners, 'Mantan');
    if (val != null) return val;

    if (supervisor != null && supervisor!['name'] == targetName) {
      int targetAge = int.tryParse(supervisor!['age'] ?? '35') ?? 35;
      if (targetAge < 19) return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
      if (!supervisor!.containsKey('job')) {
        final String supJob = 'Supervisor (${jobName ?? "Perusahaan"})';
        final int supSalary = (jobSalary ?? 2000) * 2;
        supervisor!['job'] = supJob;
        supervisor!['salary'] = supSalary.toString();
      }
      return {
        'status': 'Bekerja',
        'job': supervisor!['job'],
        'salary': int.tryParse(supervisor!['salary'] ?? '0') ?? 0
      };
    }

    if (partner != null && partner!['name'] == targetName) {
      int targetAge = int.tryParse(partner!['age'] ?? '18') ?? 18;
      if (targetAge < 19) return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
      if (!partner!.containsKey('job')) {
        final j = _generateRandomJob();
        partner!['job'] = j['job'];
        partner!['salary'] = j['salary'].toString();
      }
      return {
        'status': 'Bekerja',
        'job': partner!['job'],
        'salary': int.tryParse(partner!['salary'] ?? '0') ?? 0
      };
    }
    if (secondPartner != null && secondPartner!['name'] == targetName) {
      int targetAge = int.tryParse(secondPartner!['age'] ?? '18') ?? 18;
      if (targetAge < 19) return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
      if (!secondPartner!.containsKey('job')) {
        final j = _generateRandomJob();
        secondPartner!['job'] = j['job'];
        secondPartner!['salary'] = j['salary'].toString();
      }
      return {
        'status': 'Bekerja',
        'job': secondPartner!['job'],
        'salary': int.tryParse(secondPartner!['salary'] ?? '0') ?? 0
      };
    }

    int fallbackAge = 18;
    if (cleanRole.contains('guru') || cleanRole.contains('dosen') || cleanRole.contains('kepala sekolah')) {
      fallbackAge = 35;
    }
    if (fallbackAge < 19) return {'status': 'Sekolah/Kuliah', 'job': '', 'salary': 0};
    
    String jobStr = 'Dosen';
    int salaryVal = 7000;
    if (cleanRole.contains('guru')) {
      jobStr = 'Guru';
      salaryVal = 3000;
    } else if (cleanRole.contains('kepala sekolah')) {
      jobStr = 'Kepala Sekolah';
      salaryVal = 5000;
    }
    return {'status': 'Bekerja', 'job': jobStr, 'salary': salaryVal};
  }

  void accumulateNPCsWealth() {
    final rand = Random();

    if (fatherName != null && !isFatherDeceased && fatherAge != null && fatherAge! >= 19) {
      if (fatherJob != null && fatherSalary != null) {
        final double raisePercent = 0.03 + (rand.nextDouble() * 0.03);
        fatherSalary = (fatherSalary! * (1 + raisePercent)).round();
      }
      final jobInfo = getNPCJobInfo(fatherName!, 'Kandung');
      if (jobInfo['status'] == 'Bekerja') {
        int currentW = getFatherWealth();
        fatherWealth = currentW + ((fatherSalary ?? jobInfo['salary'] as int) * 1.2).toInt();
      }
    }
    if (motherName != null && !isMotherDeceased && motherAge != null && motherAge! >= 19) {
      if (motherJob != null && motherSalary != null) {
        final double raisePercent = 0.03 + (rand.nextDouble() * 0.03);
        motherSalary = (motherSalary! * (1 + raisePercent)).round();
      }
      final jobInfo = getNPCJobInfo(motherName!, 'Kandung');
      if (jobInfo['status'] == 'Bekerja') {
        int currentW = getMotherWealth();
        motherWealth = currentW + ((motherSalary ?? jobInfo['salary'] as int) * 1.2).toInt();
      }
    }
    if (stepFatherName != null && !isStepFatherDeceased && stepFatherAge != null && stepFatherAge! >= 19) {
      if (stepFatherJob != null && stepFatherSalary != null) {
        final double raisePercent = 0.03 + (rand.nextDouble() * 0.03);
        stepFatherSalary = (stepFatherSalary! * (1 + raisePercent)).round();
      }
      final jobInfo = getNPCJobInfo(stepFatherName!, 'Tiri');
      if (jobInfo['status'] == 'Bekerja') {
        int currentW = getStepFatherWealth();
        stepFatherWealth = currentW + ((stepFatherSalary ?? jobInfo['salary'] as int) * 1.2).toInt();
      }
    }
    if (stepMotherName != null && !isStepMotherDeceased && stepMotherAge != null && stepMotherAge! >= 19) {
      if (stepMotherJob != null && stepMotherSalary != null) {
        final double raisePercent = 0.03 + (rand.nextDouble() * 0.03);
        stepMotherSalary = (stepMotherSalary! * (1 + raisePercent)).round();
      }
      final jobInfo = getNPCJobInfo(stepMotherName!, 'Tiri');
      if (jobInfo['status'] == 'Bekerja') {
        int currentW = getStepMotherWealth();
        stepMotherWealth = currentW + ((stepMotherSalary ?? jobInfo['salary'] as int) * 1.2).toInt();
      }
    }
    if (fatherInLawName != null && !isFatherInLawDeceased && fatherInLawAge != null && fatherInLawAge! >= 19) {
      if (fatherInLawJob != null && fatherInLawSalary != null) {
        final double raisePercent = 0.03 + (rand.nextDouble() * 0.03);
        fatherInLawSalary = (fatherInLawSalary! * (1 + raisePercent)).round();
      }
      final jobInfo = getNPCJobInfo(fatherInLawName!, 'Mertua');
      if (jobInfo['status'] == 'Bekerja') {
        int currentW = getFatherInLawWealth();
        fatherInLawWealth = currentW + ((fatherInLawSalary ?? jobInfo['salary'] as int) * 1.2).toInt();
      }
    }
    if (motherInLawName != null && !isMotherInLawDeceased && motherInLawAge != null && motherInLawAge! >= 19) {
      if (motherInLawJob != null && motherInLawSalary != null) {
        final double raisePercent = 0.03 + (rand.nextDouble() * 0.03);
        motherInLawSalary = (motherInLawSalary! * (1 + raisePercent)).round();
      }
      final jobInfo = getNPCJobInfo(motherInLawName!, 'Mertua');
      if (jobInfo['status'] == 'Bekerja') {
        int currentW = getMotherInLawWealth();
        motherInLawWealth = currentW + ((motherInLawSalary ?? jobInfo['salary'] as int) * 1.2).toInt();
      }
    }

    void accumulateList(List<Map<String, String>> list, String role) {
      for (var item in list) {
        final String name = item['name'] ?? '';
        final int targetAge = int.tryParse(item['age'] ?? '0') ?? 0;
        final bool isDeceased = item['isDeceased'] == 'true';
        if (name.isNotEmpty && !isDeceased && targetAge >= 19) {
          if (item['salary'] != null && item['salary'] != '0') {
            final double raisePercent = 0.03 + (rand.nextDouble() * 0.03);
            final int currentSalary = int.tryParse(item['salary']!) ?? 0;
            item['salary'] = (currentSalary * (1 + raisePercent)).round().toString();
          }
          final jobInfo = getNPCJobInfo(name, role);
          if (jobInfo['status'] == 'Bekerja') {
            int currentW = getTargetWealth(name, role);
            int newW = currentW + ((jobInfo['salary'] as int) * 1.2).toInt();
            item['money'] = newW.toString();
          }
        }
      }
    }

    accumulateList(siblings, 'Saudara');
    accumulateList(extendedFamily, 'Keluarga');
    accumulateList(classmates, 'Teman Sekelas');
    accumulateList(univClassmates, 'Teman Kuliah');
    accumulateList(coworkers, 'Rekan Kerja');
    accumulateList(exPartners, 'Mantan');

    if (supervisor != null && supervisor!['name'] != null) {
      final name = supervisor!['name']!;
      final int targetAge = int.tryParse(supervisor!['age'] ?? '18') ?? 18;
      if (targetAge >= 19) {
        if (supervisor!['salary'] != null && supervisor!['salary'] != '0') {
          final double raisePercent = 0.03 + (rand.nextDouble() * 0.03);
          final int currentSalary = int.tryParse(supervisor!['salary']!) ?? 0;
          supervisor!['salary'] = (currentSalary * (1 + raisePercent)).round().toString();
        }
        final jobInfo = getNPCJobInfo(name, 'Supervisor');
        if (jobInfo['status'] == 'Bekerja') {
          int currentW = getTargetWealth(name, 'Supervisor');
          int newW = currentW + ((jobInfo['salary'] as int) * 1.2).toInt();
          supervisor!['money'] = newW.toString();
        }
      }
    }

    if (partner != null && partner!['name'] != null) {
      final name = partner!['name']!;
      final int targetAge = int.tryParse(partner!['age'] ?? '18') ?? 18;
      if (targetAge >= 19) {
        if (partner!['salary'] != null && partner!['salary'] != '0') {
          final double raisePercent = 0.03 + (rand.nextDouble() * 0.03);
          final int currentSalary = int.tryParse(partner!['salary']!) ?? 0;
          partner!['salary'] = (currentSalary * (1 + raisePercent)).round().toString();
        }
        final jobInfo = getNPCJobInfo(name, 'Partner');
        if (jobInfo['status'] == 'Bekerja') {
          int currentW = getTargetWealth(name, 'Partner');
          int newW = currentW + ((jobInfo['salary'] as int) * 1.2).toInt();
          partner!['money'] = newW.toString();
        }
      }
    }
    if (secondPartner != null && secondPartner!['name'] != null) {
      final name = secondPartner!['name']!;
      final int targetAge = int.tryParse(secondPartner!['age'] ?? '18') ?? 18;
      if (targetAge >= 19) {
        if (secondPartner!['salary'] != null && secondPartner!['salary'] != '0') {
          final double raisePercent = 0.03 + (rand.nextDouble() * 0.03);
          final int currentSalary = int.tryParse(secondPartner!['salary']!) ?? 0;
          secondPartner!['salary'] = (currentSalary * (1 + raisePercent)).round().toString();
        }
        final jobInfo = getNPCJobInfo(name, 'Partner');
        if (jobInfo['status'] == 'Bekerja') {
          int currentW = getTargetWealth(name, 'Partner');
          int newW = currentW + ((jobInfo['salary'] as int) * 1.2).toInt();
          secondPartner!['money'] = newW.toString();
        }
      }
    }
  }
}