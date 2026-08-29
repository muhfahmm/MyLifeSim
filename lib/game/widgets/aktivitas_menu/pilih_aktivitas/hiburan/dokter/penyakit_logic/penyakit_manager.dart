import 'dart:math';
import '../../../../../../../../pilih_karakter/character.dart';
import 'penyakit_ringan.dart';
import 'penyakit_berat.dart';

class PenyakitManager {
  static void checkAnnualDisease(Character character, List<String> events) {
    final int currentHealth = character.health;
    // Peluang Sakit (%) berdasarkan tingkat kesehatan
    int sicknessChance = 5;
    if (currentHealth >= 100) {
      sicknessChance = 5;
    } else if (currentHealth >= 95) {
      sicknessChance = 8;
    } else if (currentHealth >= 90) {
      sicknessChance = 10;
    } else if (currentHealth >= 85) {
      sicknessChance = 13;
    } else if (currentHealth >= 80) {
      sicknessChance = 15;
    } else if (currentHealth >= 75) {
      sicknessChance = 17;
    } else if (currentHealth >= 70) {
      sicknessChance = 20;
    } else if (currentHealth >= 65) {
      sicknessChance = 23;
    } else if (currentHealth >= 60) {
      sicknessChance = 25;
    } else if (currentHealth >= 55) {
      sicknessChance = 28;
    } else if (currentHealth >= 50) {
      sicknessChance = 30;
    } else {
      // Untuk kesehatan < 50%, peluang sakit bertambah seiring penurunan kesehatan
      sicknessChance = 30 + (50 - currentHealth);
    }
    
    final random = Random();
    if (random.nextInt(100) < sicknessChance) {
      // Terkena penyakit! Tentukan tingkat keparahan berdasarkan kesehatan saat ini
      Map<String, dynamic> penyakit;
      final int severityRoll = random.nextInt(100);
      
      if (currentHealth >= 70) {
        // 70% ringan, 30% sedang
        if (severityRoll < 70) {
          penyakit = PenyakitRinganHelper.getRandomRingan();
        } else {
          penyakit = PenyakitRinganHelper.getRandomSedang();
        }
      } else if (currentHealth >= 40) {
        // 30% ringan, 50% sedang, 20% berat
        if (severityRoll < 30) {
          penyakit = PenyakitRinganHelper.getRandomRingan();
        } else if (severityRoll < 80) {
          penyakit = PenyakitRinganHelper.getRandomSedang();
        } else {
          penyakit = PenyakitBeratHelper.getRandomBerat();
        }
      } else if (currentHealth >= 30) {
        // 30% s/d 39%: 10% ringan, 50% sedang, 40% berat
        if (severityRoll < 10) {
          penyakit = PenyakitRinganHelper.getRandomRingan();
        } else if (severityRoll < 60) {
          penyakit = PenyakitRinganHelper.getRandomSedang();
        } else {
          penyakit = PenyakitBeratHelper.getRandomBerat();
        }
      } else {
        // Kurang dari 30%: penyakit berat sebesar 60%, sisanya 40% sedang
        if (severityRoll < 40) {
          penyakit = PenyakitRinganHelper.getRandomSedang();
        } else {
          penyakit = PenyakitBeratHelper.getRandomBerat();
        }
      }
      
      final String name = penyakit['name'];
      final int minDmg = penyakit['min'];
      final int maxDmg = penyakit['max'];
      final String emoji = penyakit['emoji'];
      
      // Hitung damage acak di dalam rentang min dan max
      final int damage = minDmg + random.nextInt(maxDmg - minDmg + 1);
      
      // Kurangi kesehatan
      character.health = (character.health - damage).clamp(0, 100);
      
      // Tambahkan kejadian ke events dan inbox
      final String logMessage = '🤒 Penyakit Instan: Kamu terdiagnosis mengidap $name $emoji. Kesehatanmu turun sebesar -$damage%.';
      events.add(logMessage);
      character.inbox.add(logMessage);
      
      // Tambahkan ke riwayat penyakit aktif
      if (!character.riwayatPenyakit.contains(name)) {
        character.riwayatPenyakit.add(name);
      }
    }
  }
}
