import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

class IdolManager {
  static String _generateName(String gender, Random rand, Character character) {
    final firstList = gender == 'Perempuan'
        ? (character.femaleFirstNames ?? [])
        : (character.maleFirstNames ?? []);
    final lastList = character.lastNames ?? [];

    if (firstList.isEmpty || lastList.isEmpty) {
      return gender == 'Perempuan' ? 'Putri Laksani' : 'Budi Saputra';
    }

    final first = firstList[rand.nextInt(firstList.length)];
    final last = lastList[rand.nextInt(lastList.length)];
    return '$first $last';
  }

  static String _generateSkinColor(Random rand) {
    if (rand.nextDouble() < 0.90) {
      final lightSkins = ['ffdbb4', 'edb98a', 'f8d25c'];
      return lightSkins[rand.nextInt(lightSkins.length)];
    } else {
      final darkSkins = ['fd9841', 'ae5d29', 'd08b5b', '614335'];
      return darkSkins[rand.nextInt(darkSkins.length)];
    }
  }

  // Initialize trainees (8 to 15 members, aged 12-15) and staff
  static void initializeTraineeTeam(Character character) {
    final rand = Random();
    character.idolTrainees.clear();
    character.idolMainMembers.clear();
    character.idolStaff.clear();
    character.yearsInTrainee = 0;

    // Generate Trainee members (8 to 15)
    final numTrainees = 8 + rand.nextInt(8); // 8 to 15
    for (int i = 0; i < numTrainees; i++) {
      character.idolTrainees.add({
        'name': _generateName('Perempuan', rand, character),
        'gender': 'Perempuan',
        'age': (12 + rand.nextInt(4)).toString(), // 12 to 15
        'relationship': (40 + rand.nextInt(41)).toString(), // 40% to 80%
        'skinColor': _generateSkinColor(rand),
      });
    }

    // Initialize Main Team too, so Trainee user can see them
    final numMain = 20 + rand.nextInt(11); // 20 to 30
    for (int i = 0; i < numMain; i++) {
      int memberAge = 16 + rand.nextInt(10); // 16 to 25
      if (rand.nextDouble() < 0.05) {
        memberAge = 26 + rand.nextInt(5); // 26 to 30
      }
      character.idolMainMembers.add({
        'name': _generateName('Perempuan', rand, character),
        'gender': 'Perempuan',
        'age': memberAge.toString(),
        'relationship': (40 + rand.nextInt(41)).toString(),
        'skinColor': _generateSkinColor(rand),
      });
    }

    // Generate staff
    _generateManagementStaff(character, rand);
  }

  // Initialize main team (20 to 30 members, aged 16-25, 5% up to 30)
  static void initializeMainTeam(Character character) {
    final rand = Random();
    character.idolMainMembers.clear();
    character.yearsInTrainee = 0;

    final numMembers = 20 + rand.nextInt(11); // 20 to 30
    for (int i = 0; i < numMembers; i++) {
      int memberAge = 16 + rand.nextInt(10); // 16 to 25
      if (rand.nextDouble() < 0.05) {
        memberAge = 26 + rand.nextInt(5); // 26 to 30
      }
      character.idolMainMembers.add({
        'name': _generateName('Perempuan', rand, character),
        'gender': 'Perempuan',
        'age': memberAge.toString(),
        'relationship': (40 + rand.nextInt(41)).toString(),
        'skinColor': _generateSkinColor(rand),
      });
    }

    // Ensure staff exists
    if (character.idolStaff.isEmpty) {
      _generateManagementStaff(character, rand);
    }
  }

  static void _generateManagementStaff(Character character, Random rand) {
    character.idolStaff.clear();
    
    // 1 General Manager
    character.idolStaff.add({
      'name': _generateName(rand.nextBool() ? 'Laki-laki' : 'Perempuan', rand, character),
      'gender': rand.nextBool() ? 'Laki-laki' : 'Perempuan',
      'age': (30 + rand.nextInt(21)).toString(), // 30 to 50
      'role': 'General Manager',
      'relationship': (50 + rand.nextInt(31)).toString(),
      'skinColor': _generateSkinColor(rand),
    });

    // 1 Deputy GM
    character.idolStaff.add({
      'name': _generateName(rand.nextBool() ? 'Laki-laki' : 'Perempuan', rand, character),
      'gender': rand.nextBool() ? 'Laki-laki' : 'Perempuan',
      'age': (25 + rand.nextInt(21)).toString(), // 25 to 45
      'role': 'Deputy General Manager',
      'relationship': (50 + rand.nextInt(31)).toString(),
      'skinColor': _generateSkinColor(rand),
    });

    // 10-15 Operations Team (aged 22-45)
    final numOps = 10 + rand.nextInt(6); // 10 to 15
    for (int i = 0; i < numOps; i++) {
      character.idolStaff.add({
        'name': _generateName(rand.nextBool() ? 'Laki-laki' : 'Perempuan', rand, character),
        'gender': rand.nextBool() ? 'Laki-laki' : 'Perempuan',
        'age': (22 + rand.nextInt(24)).toString(), // 22 to 45
        'role': 'Operations Staff',
        'relationship': (40 + rand.nextInt(41)).toString(),
        'skinColor': _generateSkinColor(rand),
      });
    }
  }

  // Core hook triggered during character's ageUp
  static void ageUpIdol(Character character, List<String> events, List<String> inbox) {
    if (!character.isIdol) return;

    final rand = Random();

    // 1. Process User Promotion (from Trainee to Main Team)
    if (character.jobName == 'Idol (Trainee)') {
      character.yearsInTrainee += 1;
      bool getPromoted = false;
      if (character.yearsInTrainee >= 2) {
        getPromoted = true;
      } else if (character.yearsInTrainee == 1) {
        getPromoted = rand.nextBool(); // 50% chance
      }

      if (getPromoted) {
        character.jobName = 'Idol (Main Performer)';
        // 20M-40M IDR -> $1,333 to $2,667 USD
        character.jobSalary = 1333 + rand.nextInt(1335); 
        
        final notice = '✨ Promosi Idol: Selamat! Setelah berjuang sebagai Trainee, kamu resmi dipromosikan menjadi anggota tim utama (Main Team) dengan gaji \$${character.jobSalary}/tahun! 🎤🌟';
        events.add(notice);
        inbox.add(notice);
      }
    }

    // 2. Age up coworkers & staff
    for (var member in character.idolTrainees) {
      final currentAge = int.tryParse(member['age'] ?? '13') ?? 13;
      member['age'] = (currentAge + 1).toString();
    }
    for (var member in character.idolMainMembers) {
      final currentAge = int.tryParse(member['age'] ?? '18') ?? 18;
      member['age'] = (currentAge + 1).toString();
    }
    for (var staff in character.idolStaff) {
      final currentAge = int.tryParse(staff['age'] ?? '30') ?? 30;
      staff['age'] = (currentAge + 1).toString();
    }

    // 3. Trainee Graduation / Leaving & Replacements
    final List<Map<String, String>> activeTrainees = List.from(character.idolTrainees);
    character.idolTrainees.clear();

    for (var member in activeTrainees) {
      final ageVal = int.tryParse(member['age'] ?? '15') ?? 15;
      if (ageVal >= 16) {
        final gradNotice = '📢 Trainee Keluar: Trainee ${member['name']} (${member['age']} tahun) telah meninggalkan grup trainee.';
        character.idolNews.add(gradNotice);
        inbox.add(gradNotice);
      } else {
        character.idolTrainees.add(member);
      }
    }

    // Replenish trainee team: 8 to 15 members
    final targetTrainees = 8 + rand.nextInt(8);
    while (character.idolTrainees.length < targetTrainees) {
      final name = _generateName('Perempuan', rand, character);
      character.idolTrainees.add({
        'name': name,
        'gender': 'Perempuan',
        'age': '12', // fresh trainee
        'relationship': (40 + rand.nextInt(41)).toString(),
        'skinColor': _generateSkinColor(rand),
      });
      final entryNotice = '🆕 Generasi Baru: Trainee Baru $name (12 tahun) telah bergabung ke tim Trainee!';
      character.idolNews.add(entryNotice);
      inbox.add(entryNotice);
    }

    // 4. Main Team Graduation / Leaving & Replacements
    final List<Map<String, String>> activeMainMembers = List.from(character.idolMainMembers);
    character.idolMainMembers.clear();

    for (var member in activeMainMembers) {
      final ageVal = int.tryParse(member['age'] ?? '18') ?? 18;
      bool shouldLeave = false;
      if (ageVal >= 20) {
        double gradChance = 0.2; // 20% chance to graduate each year
        if (ageVal >= 25) {
          gradChance = 0.8; // 80% chance if >= 25
        }
        if (ageVal >= 30) {
          gradChance = 1.0; // 100% force leave
        }
        if (rand.nextDouble() < gradChance) {
          shouldLeave = true;
        }
      }

      if (shouldLeave) {
        final gradNotice = '🎓 Anggota Lulus: Anggota tim utamamu, ${member['name']} (${member['age']} tahun), telah resmi lulus (graduate) dari grup Idol.';
        character.idolNews.add(gradNotice);
        inbox.add(gradNotice);
      } else {
        character.idolMainMembers.add(member);
      }
    }

    // Replenish main team: 20 to 30 members
    final targetMain = 20 + rand.nextInt(11);
    while (character.idolMainMembers.length < targetMain) {
      final name = _generateName('Perempuan', rand, character);
      character.idolMainMembers.add({
        'name': name,
        'gender': 'Perempuan',
        'age': '16', // fresh main member
        'relationship': (40 + rand.nextInt(41)).toString(),
        'skinColor': _generateSkinColor(rand),
      });
      final entryNotice = '🆕 Promosi Tim Utama: $name (16 tahun) resmi bergabung ke Tim Utama!';
      character.idolNews.add(entryNotice);
      inbox.add(entryNotice);
    }

    // Replenish staff if they get too old (> 65) or leave
    final List<Map<String, String>> activeStaff = List.from(character.idolStaff);
    character.idolStaff.clear();
    for (var staff in activeStaff) {
      final ageVal = int.tryParse(staff['age'] ?? '30') ?? 30;
      if (ageVal > 65) {
        final notice = '💼 Staf Pensiun: Staf manajemen ${staff['name']} (${staff['role']}) telah pensiun pada usia $ageVal tahun.';
        events.add(notice);
        inbox.add(notice);
      } else {
        character.idolStaff.add(staff);
      }
    }
    
    // Ensure GM and Deputy GM exist
    bool hasGM = character.idolStaff.any((s) => s['role'] == 'General Manager');
    bool hasDeputy = character.idolStaff.any((s) => s['role'] == 'Deputy General Manager');
    if (!hasGM) {
      character.idolStaff.add({
        'name': _generateName(rand.nextBool() ? 'Laki-laki' : 'Perempuan', rand, character),
        'gender': rand.nextBool() ? 'Laki-laki' : 'Perempuan',
        'age': (30 + rand.nextInt(10)).toString(),
        'role': 'General Manager',
        'relationship': (50 + rand.nextInt(31)).toString(),
        'skinColor': _generateSkinColor(rand),
      });
    }
    if (!hasDeputy) {
      character.idolStaff.add({
        'name': _generateName(rand.nextBool() ? 'Laki-laki' : 'Perempuan', rand, character),
        'gender': rand.nextBool() ? 'Laki-laki' : 'Perempuan',
        'age': (25 + rand.nextInt(10)).toString(),
        'role': 'Deputy General Manager',
        'relationship': (50 + rand.nextInt(31)).toString(),
        'skinColor': _generateSkinColor(rand),
      });
    }

    // Maintain 10-15 operations staff
    final int targetOps = 10 + rand.nextInt(6);
    int currentOps = character.idolStaff.where((s) => s['role'] == 'Operations Staff').length;
    while (currentOps < targetOps) {
      character.idolStaff.add({
        'name': _generateName(rand.nextBool() ? 'Laki-laki' : 'Perempuan', rand, character),
        'gender': rand.nextBool() ? 'Laki-laki' : 'Perempuan',
        'age': (22 + rand.nextInt(15)).toString(),
        'role': 'Operations Staff',
        'relationship': (40 + rand.nextInt(41)).toString(),
        'skinColor': _generateSkinColor(rand),
      });
      currentOps++;
    }

    // 5. User graduation check
    final bool isMainTeam = character.jobName == 'Idol (Main Performer)';
    if (isMainTeam && character.age >= 25) {
      bool delayGraduation = false;
      if (character.age < 30) {
        delayGraduation = rand.nextDouble() < 0.05;
      }
      
      if (!delayGraduation) {
        character.jobName = null;
        character.jobSalary = null;
        character.idolTrainees.clear();
        character.idolMainMembers.clear();
        character.idolStaff.clear();
        character.hasGraduatedIdol = true;
        
        final gradNotice = '🎓 Hari Kelulusan (Graduation): Selamat! Setelah bertahun-tahun bersinar di atas panggung dan memikat hati fans, hari ini kamu resmi melangsungkan konser kelulusan (graduation concert) dan lulus dari grup Idol pada usia ${character.age} tahun. Terima kasih atas kerja keras dan dedikasimu! 🎉✨';
        events.add(gradNotice);
        inbox.add(gradNotice);
        return; // Early return
      }
    }

    // 6. Custom Dating Proposals (25% staff, 20% lesbian members)
    if (character.activeProposal == null && character.gender == 'Perempuan' && character.age >= 12) {
      if (rand.nextDouble() < 0.20) {
        final roll = rand.nextInt(100);
        if (roll < 25) {
          if (character.idolStaff.isNotEmpty) {
            final staff = character.idolStaff[rand.nextInt(character.idolStaff.length)];
            character.activeProposal = {
              'name': '${staff['name']} (Staf ${staff['role']})',
              'relation': 'Staf Idol (${staff['role']})',
              'type': 'Ajak Pacaran',
              'gender': staff['gender'] ?? 'Laki-laki',
              'age': staff['age'] ?? '30',
            };
          }
        } else if (roll < 45) {
          final sourceList = isMainTeam ? character.idolMainMembers : character.idolTrainees;
          if (sourceList.isNotEmpty) {
            final member = sourceList[rand.nextInt(sourceList.length)];
            character.activeProposal = {
              'name': '${member['name']} (Rekan Idol)',
              'relation': 'Rekan Idol',
              'type': 'Ajak Pacaran',
              'gender': 'Perempuan',
              'age': member['age'] ?? '16',
            };
          }
        }
      }
    }
  }
}
