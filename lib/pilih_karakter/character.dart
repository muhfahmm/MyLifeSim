// lib/pilih_karakter/character.dart
import 'dart:math';
import 'package:bitlife/game/widgets/penyakit_logic/incest_logic.dart';

class Character {
  String name;
  String gender;
  String location;
  int age;
  int health;
  int happiness;
  int intelligence;
  int money;
  int appearance;
  bool isAlive;

  // --- FIELD KELUARGA BARU ---
  String? fatherName;        // Nama Ayah Kandung
  String? motherName;        // Nama Ibu Kandung
  String? stepFatherName;    // Nama Ayah Tiri (jika ada)
  String? stepMotherName;    // Nama Ibu Tiri (jika ada)
  int birthOrder;            // Urutan kelahiran (1 = anak pertama, 2 = kedua, dst)
  List<Map<String, String>> siblings; // Daftar saudara [{name: '...', gender: 'Laki-laki', relation: '...', relationship: '50', age: '2', isDeceased: 'false'}]
  List<Map<String, String>> extendedFamily = []; // Daftar kakek, nenek, paman, bibi, sepupu [{name: '...', gender: 'Laki-laki', relation: 'Kakek (dari Ayah)', relationship: '50', age: '70', isDeceased: 'false'}]

  // --- HUBUNGAN (RELATIONSHIP BARS) ---
  int? fatherRelationship;
  int? motherRelationship;
  int? stepFatherRelationship;
  int? stepMotherRelationship;

  // --- UMUR KELUARGA ---
  int? fatherAge;
  int? motherAge;
  int? stepFatherAge;
  int? stepMotherAge;

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
  Map<String, String>? partner; // {'name': '...', 'relationship': '70', 'gender': '...', 'age': '20', 'relation': 'Pacar', 'isDeceased': 'false'}

  // --- STATUS KEMATIAN KELUARGA KANDUNG ---
  bool isFatherDeceased = false;
  bool isMotherDeceased = false;
  bool isStepFatherDeceased = false;
  bool isStepMotherDeceased = false;

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
    this.partner,
  }) : inbox = [];

  // --- KOTAK MASUK / INBOX NOTIFIKASI ---
  List<String> inbox;

  // Method untuk bertambah umur (mengembalikan list log kejadian)
  List<String> ageUp() {
    List<String> events = [];
    age++;
    health -= 2;
    
    // Logika HIV mengurangi kesehatan secara perlahan setiap tahun
    if (hasHIV) {
      health -= 10;
      events.add('🚨 Kesehatan Menurun: Virus HIV/AIDS yang bersarang di tubuhmu aktif dan menurunkan sistem kekebalan tubuh (-10% kesehatan).');
      inbox.add('🚨 Penyakit Kronis: Virus HIV/AIDS mengurangi kesehatanmu sebesar 10% tahun ini.');
    }

    if (health <= 0 || age > 100) {
      isAlive = false;
    }

    final Random random = Random();

    // 1. Cek Kematian Orang Tua
    if (fatherName != null && !isFatherDeceased && fatherAge != null) {
      fatherAge = fatherAge! + 1;
      if (fatherAge! > 60) {
        int deathChance = (fatherAge! - 60) ~/ 2 + 1; // 1% - 15%
        if (random.nextInt(100) < deathChance) {
          isFatherDeceased = true;
          fatherRelationship = 0;
          events.add('👴 Kabar Duka: Ayahmu, $fatherName, meninggal dunia pada usia $fatherAge tahun.');
        }
      }
    }

    if (motherName != null && !isMotherDeceased && motherAge != null) {
      motherAge = motherAge! + 1;
      if (motherAge! > 60) {
        int deathChance = (motherAge! - 60) ~/ 2 + 1;
        if (random.nextInt(100) < deathChance) {
          isMotherDeceased = true;
          motherRelationship = 0;
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

    // --- LOGIKA REMARRY: PENDAPATAN AYAH/IBU TIRI SETELAH LAHIR (35% CHANCE) ---
    // Kasus 1: Ibu kandung hidup, tetapi tidak ada ayah kandung (atau wafat) dan belum punya ayah tiri
    if (motherName != null && !isMotherDeceased && (fatherName == null || isFatherDeceased) && stepFatherName == null) {
      if (random.nextInt(100) < 35) {
        stepFatherName = 'Fajar Pratama'; // Default fallback name
        stepFatherAge = motherAge! + random.nextInt(5) - 2;
        stepFatherRelationship = 50;
        isStepFatherDeceased = false;
        final String notice = '💍 Kabar Keluarga: Ibumu menikah lagi! Sekarang kamu memiliki Ayah Tiri bernama $stepFatherName.';
        events.add(notice);
        inbox.add(notice);
      }
    }
    // Kasus 2: Ayah kandung hidup, tetapi tidak ada ibu kandung (atau wafat) dan belum punya ibu tiri
    else if (fatherName != null && !isFatherDeceased && (motherName == null || isMotherDeceased) && stepMotherName == null) {
      if (random.nextInt(100) < 35) {
        stepMotherName = 'Dian Lestari'; // Default fallback name
        stepMotherAge = fatherAge! + random.nextInt(5) - 2;
        stepMotherRelationship = 50;
        isStepMotherDeceased = false;
        final String notice = '💍 Kabar Keluarga: Ayahmu menikah lagi! Sekarang kamu memiliki Ibu Tiri bernama $stepMotherName.';
        events.add(notice);
        inbox.add(notice);
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
        } else if (nextAge > 65) {
          int deathChance = (nextAge - 65) ~/ 3 + 1;
          if (random.nextInt(100) < deathChance) {
            sib['isDeceased'] = 'true';
            sib['relationship'] = '0';
            events.add('💀 Kabar Duka: Saudaramu, ${sib['name']} (${sib['relation']}), meninggal dunia pada usia $nextAge tahun.');
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

    // 4. Partner Aging & Death
    if (partner != null) {
      bool isDeceased = partner!['isDeceased'] == 'true';
      if (!isDeceased) {
        int partnerAge = int.tryParse(partner!['age'] ?? '0') ?? 0;
        int nextAge = partnerAge + 1;
        partner!['age'] = nextAge.toString();
        if (nextAge > 60) {
          int deathChance = (nextAge - 60) ~/ 2 + 1;
          if (random.nextInt(100) < deathChance) {
            partner!['isDeceased'] = 'true';
            partner!['relationship'] = '0';
            events.add('💔 Kabar Duka: Pacarmu, ${partner!['name']}, meninggal dunia pada usia $nextAge tahun.');
          }
        }
      }
    }

    // --- LOGIKA MELAHIRKAN ---
    if (isPregnant || partnerIsPregnant) {
      final String childGender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
      
      final List<String> boys = ['Rafi', 'Daffa', 'Gibran', 'Zian', 'Aldi', 'Rehan', 'Fadel', 'Budi', 'Aditya'];
      final List<String> girls = ['Aura', 'Nadia', 'Sania', 'Fatimah', 'Zahra', 'Keysha', 'Aurel', 'Santi', 'Putri'];
      
      final String childFirstName = childGender == 'Laki-laki' 
          ? boys[random.nextInt(boys.length)] 
          : girls[random.nextInt(girls.length)];
      
      final List<String> playerParts = name.split(' ');
      final String childLastName = playerParts.length > 1 ? playerParts.last : '';
      final String childName = childLastName.isNotEmpty ? '$childFirstName $childLastName' : childFirstName;

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

      final String partnerNameClean = pregnantByPartnerName ?? (partner != null ? (partner!['name'] ?? 'Pasangan') : 'Pasangan');
      
      // Jalankan logika konsekuensi kehamilan inses
      final incestRes = handleIncestPregnancyEffect(this, random);

      if (incestRes['keguguran'] == true) {
        events.add(incestRes['pesan']);
        isPregnant = false;
        partnerIsPregnant = false;
        pregnantByPartnerName = null;
        pregnantByPartnerRole = null;
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

        children.add({
          'name': childName,
          'gender': childGender,
          'relationship': '80',
          'age': '0',
          'father': father,
          'mother': mother,
          'isDeceased': 'false',
          'trait': hasGeneticDefect ? 'Mengidap Kelainan Genetik' : 'Sehat',
        });

        String birthMsg = '👶 Anak Baru Lahir! Selamat, anak ${childGender == 'Laki-laki' ? 'Laki-laki' : 'Perempuan'} bernama $childName telah lahir ke dunia.';
        if (hasGeneticDefect) {
          birthMsg += ' (⚠️ Anak lahir cacat akibat kelainan genetik dari hubungan sedarah)';
        }
        events.add(birthMsg);
        inbox.add(birthMsg);

        isPregnant = false;
        partnerIsPregnant = false;
        pregnantByPartnerName = null;
        pregnantByPartnerRole = null;
      }
    }

    // --- LOGIKA AJAKAN INCEST DARI KELUARGA ---
    // Dipicu hanya jika usia karakter >= 12 tahun dan belum punya pacar/pasangan (atau peluang pacaran/bercinta)
    if (age >= 12 && partner == null) {
      final String myGenderLower = gender.trim().toLowerCase();
      
      // Kumpulkan kandidat keluarga yang hidup & usia >= 12
      List<Map<String, dynamic>> candidates = [];
      
      if (fatherName != null && !isFatherDeceased && fatherAge != null && fatherAge! >= 12 && myGenderLower != 'laki-laki') {
        candidates.add({
          'name': 'Ayah ($fatherName)',
          'relation': 'Ayah',
          'gender': 'Laki-laki',
          'age': fatherAge.toString(),
          'role': 'Kandung',
        });
      }
      if (motherName != null && !isMotherDeceased && motherAge != null && motherAge! >= 12) {
        candidates.add({
          'name': 'Ibu ($motherName)',
          'relation': 'Ibu',
          'gender': 'Perempuan',
          'age': motherAge.toString(),
          'role': 'Kandung',
        });
      }
      if (stepFatherName != null && !isStepFatherDeceased && stepFatherAge != null && stepFatherAge! >= 12 && myGenderLower != 'laki-laki') {
        candidates.add({
          'name': 'Ayah Tiri ($stepFatherName)',
          'relation': 'Ayah Tiri',
          'gender': 'Laki-laki',
          'age': stepFatherAge.toString(),
          'role': 'Tiri',
        });
      }
      
      for (var sib in siblings) {
        final int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
        final bool isDeceased = sib['isDeceased'] == 'true';
        if (!isDeceased && sibAge >= 12) {
          candidates.add({
            'name': '${sib['name']} (${sib['relation']})',
            'relation': sib['relation'] ?? 'Saudara',
            'gender': sib['gender'] ?? 'Laki-laki',
            'age': sibAge.toString(),
            'role': 'Kandung',
          });
        }
      }

      if (candidates.isNotEmpty) {
        // Pilih satu kandidat acak
        final candidate = candidates[random.nextInt(candidates.length)];
        final String rel = candidate['relation'].toString().toLowerCase();
        
        int chance = 0;
        if (myGenderLower == 'perempuan') {
          // Player adalah Perempuan (Anak Perempuan)
          if (rel.contains('ayah')) chance = 40;
          else if (rel.contains('ibu')) chance = 30;
          else if (rel.contains('kakak perempuan')) chance = 30;
          else if (rel.contains('adik perempuan')) chance = 30;
          else if (rel.contains('adik laki')) chance = 40;
          else if (rel.contains('kakak laki')) chance = 40;
          else chance = 30; // keluarga yang lain
        } else {
          // Player adalah Laki-laki (Anak Laki-laki)
          if (rel.contains('ayah')) chance = 10;
          else if (rel.contains('ibu')) chance = 10;
          else if (rel.contains('kakak perempuan')) chance = 30;
          else if (rel.contains('adik perempuan')) chance = 40;
          else if (rel.contains('adik laki')) chance = 5;
          else if (rel.contains('kakak laki')) chance = 5;
          else chance = 10; // default candidate chance
        }

        if (random.nextInt(100) < chance) {
          // Tentukan tipe ajakan: Ajak Pacaran (80%) atau Bercinta (20%)
          final String proposalType = random.nextInt(100) < 80 ? 'Ajak Pacaran' : 'Bercinta';
          activeProposal = {
            'name': candidate['name'],
            'relation': candidate['relation'],
            'type': proposalType,
            'gender': candidate['gender'],
            'age': candidate['age'],
            'role': candidate['role'],
          };
        }
      }
    } else if (age >= 12 && partner != null && partner!['isDeceased'] != 'true') {
      // Logika: Jika user sudah memiliki pacar aktif, ada persentase mengajak berhubungan intim sebanyak 60% saat pertambahan umur
      if (random.nextInt(100) < 60) {
        activeProposal = {
          'name': partner!['name'],
          'relation': partner!['relation'] ?? 'Pacar',
          'type': 'Bercinta',
          'gender': partner!['gender'] ?? 'Perempuan',
          'age': partner!['age'] ?? '18',
          'role': 'Partner',
        };
      }
    }

    return events;
  }
}