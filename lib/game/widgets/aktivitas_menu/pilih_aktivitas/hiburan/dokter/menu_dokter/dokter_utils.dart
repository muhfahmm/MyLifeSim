import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/pilih_karakter/settings/currency_settings.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';

class DokterUtils {
  static String fmt(int amount) {
    return CurrencySettings.format(amount);
  }

  static void updateStats(Character character, int healthGain, int happinessGain, int intelligenceGain) {
    character.health = (character.health + healthGain).clamp(0, 100);
    character.happiness = (character.happiness + happinessGain).clamp(0, 100);
    character.intelligence = (character.intelligence + intelligenceGain).clamp(0, 100);
  }

  static void showResultDialog(BuildContext context, String title, String msg, VoidCallback onComplete) {
    DialogHelper.show(
      context: context,
      title: title,
      content: Text(msg),
      onClose: onComplete,
    );
  }

  static Future<bool> handleInsufficientMoney(BuildContext context, Character character, int cost, String actionName) async {
    final bool hasFather = character.fatherName != null && !character.isFatherDeceased;
    final bool hasMother = character.motherName != null && !character.isMotherDeceased;
    final bool hasParents = hasFather || hasMother;

    bool? askParents = false;
    await DialogHelper.show(
      context: context,
      title: 'Saldo Kurang 💸',
      showCloseButton: false,
      content: Text('Kamu tidak memiliki cukup uang untuk membayar $actionName sebesar ${fmt(cost)}.\n' +
          (hasParents 
              ? 'Apakah kamu ingin meminta bantuan orang tuamu untuk membiayainya?' 
              : 'Kamu tidak memiliki orang tua untuk dimintai bantuan.')),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black87),
          onPressed: () {
            askParents = false;
            Navigator.pop(context);
          },
          child: const Text('Mengerti'),
        ),
        if (hasParents) ...[
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
            onPressed: () {
              askParents = true;
              Navigator.pop(context);
            },
            child: const Text('Minta Orang Tua 👨‍👩‍👧'),
          ),
        ],
      ],
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
        if (hasMother) {
          character.motherRelationship = ((character.motherRelationship ?? 50) + 10).clamp(0, 100);
        }
        if (hasFather) {
          character.fatherRelationship = ((character.fatherRelationship ?? 50) + 10).clamp(0, 100);
        }

        await DialogHelper.show(
          context: context,
          title: 'Orang Tua Setuju 🎉',
          content: Text('Orang tuamu bersedia membayarkan $actionName sebesar ${fmt(cost)}! Hubunganmu dengan mereka meningkat.'),
        );
        return true; // Dibayar oleh orang tua
      } else {
        if (hasMother) {
          character.motherRelationship = ((character.motherRelationship ?? 50) - 8).clamp(0, 100);
        }
        if (hasFather) {
          character.fatherRelationship = ((character.fatherRelationship ?? 50) - 8).clamp(0, 100);
        }

        await DialogHelper.show(
          context: context,
          title: 'Bantuan Ditolak 😔',
          content: const Text('Orang tuamu menolak membiayai pengobatanmu. Mereka meminta kamu agar lebih mandiri dan berhemat.'),
        );
        return false;
      }
    }

    return false;
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

  static int getHappinessGainOnCured(String diseaseName) {
    final String nameLower = diseaseName.toLowerCase();
    final List<String> ringanList = [
      'flu', 'sakit kepala', 'batuk', 'alergi', 'sakit gigi', 'pusing', 'diare', 
      'lecet', 'robekan kecil', 'kram', 'iritasi overstimulasi', 'luka mikro', 'dehidrasi'
    ];
    final List<String> beratList = [
      'pneumonia berat', 'stroke', 'serangan jantung', 'ginjal', 'kanker', 
      'meningitis', 'tubaberculosis', 'tbc', 'pankreatitis', 'hiv', 'aids', 'cedera jaringan', 'laserasi'
    ];

    final random = Random();
    if (ringanList.any((key) => nameLower.contains(key))) {
      return 5 + random.nextInt(6);
    } else if (beratList.any((key) => nameLower.contains(key))) {
      return 25 + random.nextInt(16);
    } else {
      return 10 + random.nextInt(11);
    }
  }

  static Future<bool> handleDiseaseTreatment(BuildContext context, Character character, String menuType, {String? specificDisease}) async {
    String? targetDisease = specificDisease;
    if (targetDisease == null) {
      for (var disease in character.riwayatPenyakit) {
        if (getRequiredMenu(disease) == menuType) {
          targetDisease = disease;
          break; 
        }
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

      bool? askParents = false;
      await DialogHelper.show(
        context: context,
        title: 'Saldo Kurang 💸',
        showCloseButton: false,
        content: Text('Kamu tidak memiliki cukup uang untuk membayar biaya pengobatan sebesar ${fmt(cost)}.\n' +
            (hasParents 
                ? 'Apakah kamu ingin meminta bantuan orang tuamu untuk membiayai pengobatan?' 
                : 'Kamu tidak memiliki orang tua untuk dimintai bantuan.')),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black87),
            onPressed: () {
              askParents = false;
              Navigator.pop(context);
            },
            child: const Text('Mengerti'),
          ),
          if (hasParents) ...[
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              onPressed: () {
                askParents = true;
                Navigator.pop(context);
              },
              child: const Text('Minta Orang Tua 👨‍👩‍👧'),
            ),
          ],
        ],
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

          await DialogHelper.show(
            context: context,
            title: 'Orang Tua Setuju 🎉',
            content: Text('Orang tuamu bersedia membayar pengobatan sebesar ${fmt(cost)}! Hubunganmu dengan mereka meningkat.'),
          );
        } else {
          if (hasMother) {
            character.motherRelationship = ((character.motherRelationship ?? 50) - 8).clamp(0, 100);
          }
          if (hasFather) {
            character.fatherRelationship = ((character.fatherRelationship ?? 50) - 8).clamp(0, 100);
          }

          await DialogHelper.show(
            context: context,
            title: 'Bantuan Ditolak 😔',
            content: const Text('Orang tuamu menolak membiayai pengobatanmu. Mereka meminta kamu agar lebih mandiri dan berhemat.'),
          );
          return false;
        }
      } else {
        return false;
      }
    }

    if (!parentPaid) {
      bool? proceed = false;
      await DialogHelper.show(
        context: context,
        title: 'Penyakit Terdeteksi 🤒',
        showCloseButton: false,
        content: Text('Dokter mendeteksi kamu mengidap $targetDisease.\nApakah kamu ingin sekalian mengobatinya dengan biaya ${fmt(cost)} melalui $menuType?'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black87),
            onPressed: () {
              proceed = false;
              Navigator.pop(context);
            },
            child: const Text('Tidak, Biarkan saja'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
            onPressed: () {
              proceed = true;
              Navigator.pop(context);
            },
            child: const Text('Ya, Obati'),
          ),
        ],
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
      final int hapGain = getHappinessGainOnCured(targetDisease);
      character.happiness = (character.happiness + hapGain).clamp(0, 100);
      character.inbox.add('🏥 Pengobatan: Kamu telah sembuh dari $targetDisease via $menuType (-${fmt(cost)} uang, +25% Kesehatan, +$hapGain% Kebahagiaan)');

      await DialogHelper.show(
        context: context,
        title: 'Pengobatan Berhasil 🎉',
        content: Text('Dokter berhasil mengobati $targetDisease.\nKesehatanmu meningkat +25% dan Kebahagiaanmu meningkat +$hapGain% (${fmt(cost)} uang berkurang).'),
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
      
      character.inbox.add('🏥 Pengobatan Gagal: Upaya mengobati $targetDisease via $menuType belum berhasil (-${fmt(cost)} uang, +$partialHeal% Kesehatan)');

      await DialogHelper.show(
        context: context,
        title: 'Pengobatan Belum Berhasil 😔',
        content: Text('$failMsg\nPenyakit tetap ada di tubuhmu, tetapi kesehatanmu membaik sedikit +$partialHeal% karena terapi medis.\nBiaya sebesar ${fmt(cost)} tetap ditagihkan.'),
      );
    }

    return true; 
  }
}
