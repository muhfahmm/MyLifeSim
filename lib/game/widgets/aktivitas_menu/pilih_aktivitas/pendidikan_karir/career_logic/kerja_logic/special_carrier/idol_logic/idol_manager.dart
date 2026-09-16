import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';

class IdolManager {
  static String _generateName(String gender, Random rand, Character character) {
    final firstList = gender == 'Perempuan'
        ? (character.femaleFirstNames ?? [])
        : (character.maleFirstNames ?? []);
    final lastList = character.lastNames ?? [];

    final resolvedFirstList = firstList.isNotEmpty
        ? firstList
        : (gender == 'Perempuan' ? Character.globalFemaleFirstNames : Character.globalMaleFirstNames);
    final resolvedLastList = lastList.isNotEmpty ? lastList : Character.globalLastNames;

    final first = resolvedFirstList.isNotEmpty ? resolvedFirstList[rand.nextInt(resolvedFirstList.length)] : '';
    final last = resolvedLastList.isNotEmpty ? resolvedLastList[rand.nextInt(resolvedLastList.length)] : '';
    return '$first $last'.trim();
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

  static void ensureWelcomeNews(Character character) {
    if (character.idolNews.isNotEmpty) return;

    final String jobRole = (character.jobName ?? '').isNotEmpty ? character.jobName! : 'Anggota Agensi';
    String welcomeNews = '';
    if (jobRole.contains('Manager') || jobRole.contains('GM')) {
      welcomeNews = '📢 Pengumuman Manajemen: Selamat datang! ${character.name} resmi bergabung dan menjabat sebagai $jobRole baru di agensi idol!';
    } else if (jobRole.contains('Idol') || jobRole.contains('Trainee')) {
      welcomeNews = '🌟 Anggota Baru: Selamat datang! ${character.name} resmi bergabung sebagai $jobRole di grup idol!';
    } else {
      welcomeNews = '💼 Staf Baru: Selamat datang! ${character.name} resmi bergabung ke tim operasional agensi sebagai $jobRole!';
    }
    character.idolNews.add(welcomeNews);
  }

  // Initialize trainees (Gen 6, Gen 7, dan 30% peluang Gen 8) and staff
  static void initializeTraineeTeam(Character character) {
    final rand = Random();
    character.idolTrainees.clear();
    character.idolMainMembers.clear();
    character.idolStaff.clear();
    character.idolGraduatedMembers.clear();
    character.idolNews.clear();
    character.yearsInTrainee = 0;

    // Generasi Trainee Awal: Gen 6 & Gen 7 selalu ada. Gen 8 ada dengan 30% peluang.
    int numGenerations = 2; // Gen 6 & Gen 7
    if (rand.nextDouble() < 0.30) {
      numGenerations = 3; // Gen 6, Gen 7, & Gen 8
    }

    // Tiap generasi trainee 8 hingga 15 anggota
    for (int g = 0; g < numGenerations; g++) {
      final int numTrainees = 8 + rand.nextInt(8); // 8 to 15 per generasi
      final int genNum = 6 + g; // Gen 6, Gen 7, Gen 8
      
      // Masa pelatihan & usia berurutan sesuai generasi:
      // Gen 6 (terlama di trainee) -> pelatihan 2 th (usia 15)
      // Gen 7                     -> pelatihan 1 th (usia 13-14)
      // Gen 8 (terbaru)           -> pelatihan 0 th (usia 12)
      int yearsInTrainee;
      int traineeAge;
      if (genNum == 6) {
        yearsInTrainee = 2;
        traineeAge = 15;
      } else if (genNum == 7) {
        yearsInTrainee = 1;
        traineeAge = 13 + rand.nextInt(2); // 13-14
      } else {
        yearsInTrainee = 0;
        traineeAge = 12;
      }

      for (int i = 0; i < numTrainees; i++) {
        character.idolTrainees.add({
          'name': _generateName('Perempuan', rand, character),
          'gender': 'Perempuan',
          'age': traineeAge.toString(),
          'yearsInTrainee': yearsInTrainee.toString(),
          'generation': genNum.toString(),
          'relationship': (40 + rand.nextInt(41)).toString(), // 40% to 80%
          'skinColor': _generateSkinColor(rand),
        });
      }
    }

    // Initialize Tim Utama (Gen 1, Gen 2, Gen 3, Gen 4, Gen 5)
    initializeMainTeam(character);

    // Generate staff
    _generateManagementStaff(character, rand);

    // Tambahkan berita sambutan selamat datang untuk pengguna
    ensureWelcomeNews(character);
  }

  // Initialize main team (Gen 1 s/d Gen 5)
  static void initializeMainTeam(Character character) {
    final rand = Random();
    character.idolMainMembers.clear();
    character.yearsInTrainee = 0;

    // Tim Utama terdiri dari Gen 1, Gen 2, Gen 3, Gen 4, Gen 5 (masing-masing 8-15 anggota)
    for (int genNum = 1; genNum <= 5; genNum++) {
      final int count = 8 + rand.nextInt(8); // 8 sampai 15 member per generasi
      int memberAge;
      if (genNum == 1) {
        memberAge = 26 + rand.nextInt(5); // 26-30
      } else if (genNum == 2) {
        memberAge = 23 + rand.nextInt(3); // 23-25
      } else if (genNum == 3) {
        memberAge = 20 + rand.nextInt(3); // 20-22
      } else if (genNum == 4) {
        memberAge = 17 + rand.nextInt(3); // 17-19
      } else {
        memberAge = 15 + rand.nextInt(2); // 15-16
      }

      for (int i = 0; i < count; i++) {
        character.idolMainMembers.add({
          'name': _generateName('Perempuan', rand, character),
          'gender': 'Perempuan',
          'age': memberAge.toString(),
          'generation': genNum.toString(),
          'relationship': (40 + rand.nextInt(41)).toString(),
          'skinColor': _generateSkinColor(rand),
        });
      }
    }

    // Ensure staff exists
    if (character.idolStaff.isEmpty) {
      _generateManagementStaff(character, rand);
    }
  }

  static void _generateManagementStaff(Character character, Random rand) {
    character.idolStaff.clear();

    void addStaff(String role, String dept, {String? forcedGender, int minAge = 22, int maxAge = 45}) {
      final gender = forcedGender ?? (rand.nextBool() ? 'Laki-laki' : 'Perempuan');
      character.idolStaff.add({
        'name': _generateName(gender, rand, character),
        'gender': gender,
        'age': (minAge + rand.nextInt(maxAge - minAge + 1)).toString(),
        'role': role,
        'department': dept,
        'relationship': (40 + rand.nextInt(41)).toString(),
        'skinColor': _generateSkinColor(rand),
      });
    }

    // ============================================================
    // 1. MANAJEMEN PUNCAK & ADMIN (5-10 orang)
    // ============================================================
    // General Manager (1 orang)
    final gmGender = rand.nextBool() ? 'Laki-laki' : 'Perempuan';
    character.idolStaff.add({
      'name': _generateName(gmGender, rand, character),
      'gender': gmGender,
      'age': (35 + rand.nextInt(16)).toString(), // 35-50
      'role': 'General Manager',
      'department': 'Manajemen Puncak & Admin',
      'relationship': (55 + rand.nextInt(26)).toString(),
      'skinColor': _generateSkinColor(rand),
    });

    // Deputy General Manager (1 orang)
    final dgmGender = rand.nextBool() ? 'Laki-laki' : 'Perempuan';
    character.idolStaff.add({
      'name': _generateName(dgmGender, rand, character),
      'gender': dgmGender,
      'age': (28 + rand.nextInt(18)).toString(), // 28-45
      'role': 'Deputy General Manager',
      'department': 'Manajemen Puncak & Admin',
      'relationship': (50 + rand.nextInt(31)).toString(),
      'skinColor': _generateSkinColor(rand),
    });

    // Manajer Divisi: Promosi, Operasional, Keuangan (3 orang)
    for (final divisi in ['Manajer Divisi Promosi', 'Manajer Divisi Operasional', 'Manajer Divisi Keuangan']) {
      addStaff(divisi, 'Manajemen Puncak & Admin', minAge: 27, maxAge: 45);
    }

    // Staf Administrasi & HRD (2-4 orang)
    final numAdmin = 2 + rand.nextInt(3);
    for (int i = 0; i < numAdmin; i++) {
      final adminRoles = ['Staf Administrasi', 'Staf HRD', 'Staf Administrasi Kontrak'];
      addStaff(adminRoles[rand.nextInt(adminRoles.length)], 'Manajemen Puncak & Admin', minAge: 22, maxAge: 40);
    }

    // ============================================================
    // 2. TIM PELATIHAN / TRAINER (5-8 orang)
    // ============================================================
    // Pelatih Tari / Koreografer (2-3 orang)
    final numDance = 2 + rand.nextInt(2);
    for (int i = 0; i < numDance; i++) {
      addStaff('Pelatih Tari (Koreografer)', 'Tim Pelatihan (Trainer)', minAge: 25, maxAge: 40);
    }
    // Pelatih Vokal (1-2 orang)
    final numVokal = 1 + rand.nextInt(2);
    for (int i = 0; i < numVokal; i++) {
      addStaff('Pelatih Vokal', 'Tim Pelatihan (Trainer)', minAge: 25, maxAge: 45);
    }
    // Pelatih Akting/MC (1-2 orang)
    final numAkting = 1 + rand.nextInt(2);
    for (int i = 0; i < numAkting; i++) {
      addStaff('Pelatih Akting/MC', 'Tim Pelatihan (Trainer)', minAge: 25, maxAge: 45);
    }

    // ============================================================
    // 3. TIM PRODUKSI TEATER & ACARA (10-15 orang)
    // ============================================================
    // Sound Engineer (1-2)
    final numSound = 1 + rand.nextInt(2);
    for (int i = 0; i < numSound; i++) {
      addStaff('Sound Engineer', 'Tim Produksi Teater & Acara', minAge: 23, maxAge: 42);
    }
    // Lighting Engineer (1-2)
    final numLight = 1 + rand.nextInt(2);
    for (int i = 0; i < numLight; i++) {
      addStaff('Lighting Engineer', 'Tim Produksi Teater & Acara', minAge: 23, maxAge: 42);
    }
    // Stage Manager (1)
    addStaff('Stage Manager', 'Tim Produksi Teater & Acara', minAge: 27, maxAge: 45);
    // Tim Backstage (3-5)
    final numBackstage = 3 + rand.nextInt(3);
    for (int i = 0; i < numBackstage; i++) {
      addStaff('Staf Backstage', 'Tim Produksi Teater & Acara', minAge: 20, maxAge: 38);
    }
    // Tim Properti Panggung (2-3)
    final numProps = 2 + rand.nextInt(2);
    for (int i = 0; i < numProps; i++) {
      addStaff('Staf Properti Panggung', 'Tim Produksi Teater & Acara', minAge: 20, maxAge: 38);
    }

    // ============================================================
    // 4. TIM KREATIF & KONTEN DIGITAL (5-10 orang)
    // ============================================================
    // Fotografer dan Videografer (2-3)
    final numFotoVideo = 2 + rand.nextInt(2);
    final fotoVideoRoles = ['Fotografer Resmi', 'Videografer Resmi'];
    for (int i = 0; i < numFotoVideo; i++) {
      addStaff(fotoVideoRoles[i % 2], 'Tim Kreatif & Konten Digital', minAge: 22, maxAge: 38);
    }
    // Editor Video (1-2)
    final numEditor = 1 + rand.nextInt(2);
    for (int i = 0; i < numEditor; i++) {
      addStaff('Editor Video', 'Tim Kreatif & Konten Digital', minAge: 22, maxAge: 38);
    }
    // Desainer Grafis (1-2)
    final numDesainer = 1 + rand.nextInt(2);
    for (int i = 0; i < numDesainer; i++) {
      addStaff('Desainer Grafis', 'Tim Kreatif & Konten Digital', minAge: 22, maxAge: 38);
    }
    // Social Media Manager (1-2)
    final numSosmed = 1 + rand.nextInt(2);
    for (int i = 0; i < numSosmed; i++) {
      addStaff('Pengelola Sosial Media', 'Tim Kreatif & Konten Digital', minAge: 20, maxAge: 35);
    }

    // ============================================================
    // 5. TIM MERCHANDISE & OFFICIAL STORE (3-5 orang)
    // ============================================================
    final numMerch = 3 + rand.nextInt(3);
    for (int i = 0; i < numMerch; i++) {
      final merchRoles = ['Staf Merchandise', 'Staf Penjualan Toko', 'Koordinator Merchandise'];
      addStaff(merchRoles[rand.nextInt(merchRoles.length)], 'Tim Merchandise & Official Store', minAge: 20, maxAge: 38);
    }

    // ============================================================
    // 6. TIM MAKEUP ARTIST (MUA) & KOSTUM (3-5 orang)
    // ============================================================
    // MUA (2-3)
    final numMUA = 2 + rand.nextInt(2);
    for (int i = 0; i < numMUA; i++) {
      addStaff('Makeup Artist (MUA)', 'Tim MUA & Kostum', forcedGender: 'Perempuan', minAge: 22, maxAge: 40);
    }
    // Kostum (1-2)
    final numKostum = 1 + rand.nextInt(2);
    for (int i = 0; i < numKostum; i++) {
      addStaff('Staf Kostum', 'Tim MUA & Kostum', forcedGender: 'Perempuan', minAge: 22, maxAge: 40);
    }

    // ============================================================
    // 7. TIM KEAMANAN & OPERASIONAL TEATER (5-10 orang)
    // ============================================================
    // Satpam / Penjaga Keamanan (3-5)
    final numSatpam = 3 + rand.nextInt(3);
    for (int i = 0; i < numSatpam; i++) {
      addStaff('Petugas Keamanan', 'Tim Keamanan & Operasional Teater', forcedGender: 'Laki-laki', minAge: 22, maxAge: 45);
    }
    // Staf Tiket & Pintu Masuk (2-4)
    final numTiket = 2 + rand.nextInt(3);
    for (int i = 0; i < numTiket; i++) {
      final tiketRoles = ['Staf Tiket', 'Penjaga Pintu Masuk'];
      addStaff(tiketRoles[rand.nextInt(tiketRoles.length)], 'Tim Keamanan & Operasional Teater', minAge: 20, maxAge: 38);
    }

    // Deduct 1 NPC holding the exact role the user occupies to respect capacity limits (e.g. GM, Deputy GM, Manager)
    syncUserStaffRole(character);
  }

  static void syncUserStaffRole(Character character) {
    if (character.isIdolStaff && character.jobName != null) {
      final index = character.idolStaff.indexWhere((s) => s['role'] == character.jobName);
      if (index != -1) {
        character.idolStaff.removeAt(index);
      }
    }
  }

  // Core hook triggered during character's ageUp
  static void ageUpIdol(Character character, List<String> events, List<String> inbox) {
    if (!character.isIdolRelated && character.idolTrainees.isEmpty && character.idolMainMembers.isEmpty && character.idolStaff.isEmpty) return;

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
        // Gaji Tim Utama Idol: $2000 - $3000 USD / bulan (harus selalu lebih tinggi dari gaji Trainee)
        final int currentSal = character.jobSalary ?? 1000;
        final int baseNewSal = 2000 + rand.nextInt(1001); // $2000 - $3000
        final int finalSal = max(currentSal + 500, baseNewSal);
        character.setJob('Idol (Main Performer)', finalSal);
        
        final String notice = '✨ Promosi Idol: Selamat! Setelah berjuang sebagai Trainee, kamu resmi dipromosikan menjadi anggota tim utama (Main Team) dengan gaji ${CurrencySettings.format(finalSal)}/bulan! 🎤🌟';
        events.add(notice);
        inbox.add(notice);
      }
    }

    // 2. Age up coworkers & staff
    for (var member in character.idolTrainees) {
      final currentAge = int.tryParse(member['age'] ?? '13') ?? 13;
      member['age'] = (currentAge + 1).toString();
      final currentYears = int.tryParse(member['yearsInTrainee'] ?? '0') ?? 0;
      member['yearsInTrainee'] = (currentYears + 1).toString();
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
    final bool isGMUser = character.jobName == 'General Manager';
    final List<Map<String, String>> activeTrainees = List.from(character.idolTrainees);
    character.idolTrainees.clear();

    for (var member in activeTrainees) {
      final ageVal = int.tryParse(member['age'] ?? '15') ?? 15;
      final yearsVal = int.tryParse(member['yearsInTrainee'] ?? '1') ?? 1;

      // Jika BUKAN GM, NPC/AI mempromosikan otomatis trainee berpengalaman ke tim utama
      bool promotedByAI = false;
      if (!isGMUser && yearsVal >= 2 && rand.nextDouble() < 0.35) {
        promotedByAI = true;
        character.idolMainMembers.add(member);
        final promoNotice = '⭐ Promosi Tim Utama: ${member['name']} telah dipromosikan ke Tim Utama oleh manajemen!';
        character.idolNews.add(promoNotice);
        inbox.add(promoNotice);
      }

      if (promotedByAI) {
        continue;
      }

      if (ageVal >= 17) {
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
      int maxGen = 7;
      for (var list in [character.idolTrainees, character.idolMainMembers, character.idolGraduatedMembers]) {
        for (var m in list) {
          final g = int.tryParse(m['generation'] ?? '0') ?? 0;
          if (g > maxGen) maxGen = g;
        }
      }
      final newGen = maxGen + 1;

      final name = _generateName('Perempuan', rand, character);
      character.idolTrainees.add({
        'name': name,
        'gender': 'Perempuan',
        'age': '12', // fresh trainee
        'yearsInTrainee': '0', // benar-benar gen/rekruitan baru
        'generation': newGen.toString(),
        'relationship': (40 + rand.nextInt(41)).toString(),
        'skinColor': _generateSkinColor(rand),
      });
      final entryNotice = '🆕 Generasi Baru: Trainee Baru $name (12 th, Gen $newGen) telah bergabung ke tim Trainee!';
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
        
        final gradMember = Map<String, String>.from(member);
        gradMember['graduatedAge'] = member['age'] ?? '20';
        character.idolGraduatedMembers.add(gradMember);
      } else {
        character.idolMainMembers.add(member);
      }
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
    
    // Ensure GM and Deputy GM exist (unless filled by the user)
    bool hasGM = character.idolStaff.any((s) => s['role'] == 'General Manager') || character.jobName == 'General Manager';
    bool hasDeputy = character.idolStaff.any((s) => s['role'] == 'Deputy General Manager') || character.jobName == 'Deputy General Manager';
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

    syncUserStaffRole(character);

    // 5. User graduation check (Disabled: User only graduates manually)
    /*
    final bool isMainTeam = character.jobName == 'Idol (Main Performer)';
    if (isMainTeam && character.age >= 25) {
      bool delayGraduation = false;
      if (character.age < 30) {
        delayGraduation = rand.nextDouble() < 0.05;
      }
      
      if (!delayGraduation) {
        character.resignJob();
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
    */
  }
}
