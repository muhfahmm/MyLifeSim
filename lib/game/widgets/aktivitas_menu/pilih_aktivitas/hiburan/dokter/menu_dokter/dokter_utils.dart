import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class DokterUtils {
  static String fmt(int amount) {
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  static void updateStats(Character character, int healthGain, int happinessGain, int intelligenceGain) {
    character.health = (character.health + healthGain).clamp(0, 100);
    character.happiness = (character.happiness + happinessGain).clamp(0, 100);
    character.intelligence = (character.intelligence + intelligenceGain).clamp(0, 100);
  }

  static void showResultDialog(BuildContext context, String title, String msg, VoidCallback onComplete) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onComplete();
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  static String getRequiredMenu(String diseaseName) {
    final String nameLower = diseaseName.toLowerCase();
    final List<String> beratList = [
      'pneumonia berat', 'stroke', 'serangan jantung', 'ginjal', 'kanker', 
      'meningitis', 'tuberkulosis', 'tbc', 'pankreatitis', 'hiv', 'aids', 'cedera jaringan', 'laserasi'
    ];
    final List<String> darahList = [
      'sifilis', 'gonore', 'hpv', 'hiv', 'aids', 'hepatitis', 'infeksi saluran kemih', 'isk', 'disentri', 'jamur', 'kontak'
    ];
    
    if (beratList.any((key) => nameLower.contains(key))) {
      return 'Medical Check Up';
    } else if (darahList.any((key) => nameLower.contains(key))) {
      return 'Tes Darah';
    } else {
      return 'Pemeriksaan Umum';
    }
  }

  static Map<String, dynamic> getDiseaseCostAndSuccessRate(String diseaseName) {
    final String nameLower = diseaseName.toLowerCase();
    
    // Penyakit tidak dapat disembuhkan / sangat kronis
    if (nameLower.contains('hiv') || nameLower.contains('aids')) {
      return {'cost': 2000, 'successRate': 0, 'incurable': true};
    }
    if (nameLower.contains('kanker')) {
      return {'cost': 1500, 'successRate': 15, 'incurable': false};
    }

    final List<String> ringanList = [
      'flu', 'sakit kepala', 'batuk', 'alergi', 'sakit gigi', 'pusing', 'diare', 
      'lecet', 'robekan kecil', 'kram', 'iritasi overstimulasi', 'luka mikro', 'dehidrasi'
    ];
    final List<String> beratList = [
      'pneumonia berat', 'stroke', 'serangan jantung', 'ginjal', 'meningitis', 
      'tuberkulosis', 'tbc', 'pankreatitis', 'cedera jaringan', 'laserasi'
    ];

    if (ringanList.any((key) => nameLower.contains(key))) {
      return {'cost': 100, 'successRate': 95, 'incurable': false};
    } else if (beratList.any((key) => nameLower.contains(key))) {
      return {'cost': 800, 'successRate': 40, 'incurable': false};
    } else {
      // Sedang
      return {'cost': 250, 'successRate': 75, 'incurable': false};
    }
  }

  static Future<bool> handleDiseaseTreatment(BuildContext context, Character character, String menuType) async {
    String? targetDisease;
    for (var disease in character.riwayatPenyakit) {
      if (getRequiredMenu(disease) == menuType) {
        targetDisease = disease;
        break; 
      }
    }

    if (targetDisease == null) {
      return false;
    }

    final data = getDiseaseCostAndSuccessRate(targetDisease);
    final int cost = data['cost'];
    final int successRate = data['successRate'];
    final bool isIncurable = data['incurable'];

    bool parentPaid = false;

    if (character.money < cost) {
      final bool hasFather = character.fatherName != null && !character.isFatherDeceased;
      final bool hasMother = character.motherName != null && !character.isMotherDeceased;
      final bool hasParents = hasFather || hasMother;

      bool? askParents = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Saldo Kurang 💸'),
          content: Text('Kamu tidak memiliki cukup uang untuk membayar biaya pengobatan sebesar \$${fmt(cost)}.\n' +
              (hasParents 
                  ? 'Apakah kamu ingin meminta bantuan orang tuamu untuk membiayai pengobatan?' 
                  : 'Kamu tidak memiliki orang tua untuk dimintai bantuan.')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Mengerti', style: TextStyle(color: Colors.grey)),
            ),
            if (hasParents)
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Minta Orang Tua 👨‍👩‍👧', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      );

      if (askParents == true) {
        int parentRelation = 0;
        int parentCount = 0;
        if (hasMother) {
          parentRelation += character.motherRelationship ?? 50;
          parentCount++;
        }
        if (hasFather) {
          parentRelation += character.fatherRelationship ?? 50;
          parentCount++;
        }
        final int avgRelation = parentCount > 0 ? (parentRelation / parentCount).round() : 50;
        
        final r = Random();
        final bool agree = r.nextInt(100) < avgRelation;

        if (agree) {
          parentPaid = true;
          if (hasMother) {
            character.motherRelationship = ((character.motherRelationship ?? 50) + 10).clamp(0, 100);
          }
          if (hasFather) {
            character.fatherRelationship = ((character.fatherRelationship ?? 50) + 10).clamp(0, 100);
          }

          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Orang Tua Setuju 🎉'),
              content: Text('Orang tuamu bersedia membayar pengobatan sebesar \$${fmt(cost)}! Hubunganmu dengan mereka meningkat.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Lanjutkan'),
                ),
              ],
            ),
          );
        } else {
          if (hasMother) {
            character.motherRelationship = ((character.motherRelationship ?? 50) - 8).clamp(0, 100);
          }
          if (hasFather) {
            character.fatherRelationship = ((character.fatherRelationship ?? 50) - 8).clamp(0, 100);
          }

          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Bantuan Ditolak 😔'),
              content: const Text('Orang tuamu menolak membiayai pengobatanmu. Mereka meminta kamu agar lebih mandiri dan berhemat.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Mengerti'),
                ),
              ],
            ),
          );
          return false;
        }
      } else {
        return false;
      }
    }

    if (!parentPaid) {
      bool? proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Penyakit Terdeteksi 🤒'),
          content: Text('Dokter mendeteksi kamu mengidap $targetDisease.\nApakah kamu ingin sekalian mengobatinya dengan biaya \$${fmt(cost)} melalui $menuType?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Tidak, Biarkan saja', style: const TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Ya, Obati', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );

      if (proceed != true) {
        return false;
      }

      character.money -= cost;
    }
    final r = Random();
    final bool isSuccess = r.nextInt(100) < successRate;

    if (isSuccess) {
      character.riwayatPenyakit.remove(targetDisease);
      if (targetDisease.contains('HIV')) {
        character.hasHIV = false;
      } else if (targetDisease.contains('Sifilis')) {
        character.hasSifilis = false;
      } else if (targetDisease.contains('HPV')) {
        character.hasHPV = false;
      }
      character.health = (character.health + 25).clamp(0, 100);
      character.inbox.add('🏥 Pengobatan: Kamu telah sembuh dari $targetDisease via $menuType (-\$$cost uang, +25% Kesehatan)');

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Pengobatan Berhasil 🎉'),
          content: Text('Dokter berhasil mengobati $targetDisease.\nKesehatanmu meningkat +25% (\$${fmt(cost)} uang berkurang).'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Bagus'),
            ),
          ],
        ),
      );
    } else {
      // Gagal sembuh: kesehatan naik sedikit 5-15%
      final int partialHeal = 5 + r.nextInt(11);
      character.health = (character.health + partialHeal).clamp(0, 100);
      
      String failMsg = '';
      if (isIncurable) {
        failMsg = 'Penyakit ini kronis dan tidak dapat disembuhkan sepenuhnya, namun terapi medis berhasil meredakan gejalanya.';
      } else {
        failMsg = 'Dokter telah berusaha semaksimal mungkin, namun penyakitmu belum berhasil disembuhkan sepenuhnya.';
      }
      
      character.inbox.add('🏥 Pengobatan Gagal: Upaya mengobati $targetDisease via $menuType belum berhasil (-\$$cost uang, +$partialHeal% Kesehatan)');

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Pengobatan Belum Berhasil 😔'),
          content: Text('$failMsg\nPenyakit tetap ada di tubuhmu, tetapi kesehatanmu membaik sedikit +$partialHeal% karena terapi medis.\nBiaya sebesar \$${fmt(cost)} tetap ditagihkan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Mengerti'),
            ),
          ],
        ),
      );
    }

    return true; 
  }
}