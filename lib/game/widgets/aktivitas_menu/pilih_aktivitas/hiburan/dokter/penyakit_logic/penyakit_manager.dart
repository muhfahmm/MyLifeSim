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
    
    // 1. Hitung ageFactor berdasarkan usia karakter
    double ageFactor = 1.0;
    final int currentAge = character.age;
    if (currentAge < 18) {
      ageFactor = 0.7; // Usia muda
    } else if (currentAge < 40) {
      ageFactor = 1.0; // Usia dewasa (baseline)
    } else if (currentAge < 60) {
      ageFactor = 1.4; // Usia paruh baya
    } else {
      ageFactor = 2.0; // Lansia
    }
    
    // 2. Modifikasi sicknessChance dengan mengalikan faktor usia (kemudian di-clamp ke 0-100)
    final int finalSicknessChance = (sicknessChance * ageFactor).round().clamp(0, 100);
    
    final random = Random();
    if (random.nextInt(100) < finalSicknessChance) {
      // Terkena penyakit! Tentukan tingkat keparahan berdasarkan usia dan kesehatan saat ini
      Map<String, dynamic> penyakit;
      final int severityRoll = random.nextInt(100);
      bool isBerat = false;
      
      // 3. Tentukan baseline threshold berdasarkan kelompok usia
      int ringanThreshold = 50;
      int sedangThreshold = 85;
      
      if (currentAge < 18) {
        ringanThreshold = 60;
        sedangThreshold = 90;
      } else if (currentAge < 40) {
        ringanThreshold = 50;
        sedangThreshold = 85;
      } else if (currentAge < 60) {
        ringanThreshold = 30;
        sedangThreshold = 70;
      } else {
        ringanThreshold = 15;
        sedangThreshold = 50;
      }
      
      // Penyesuaian Kesehatan Rendah: jika health < 40, threshold ringan diturunkan setengah (berat naik)
      if (currentHealth < 40) {
        final int oldRinganThreshold = ringanThreshold;
        ringanThreshold = (ringanThreshold / 2).round();
        // Sedang threshold bergeser turun sebanding agar lebar kategori sedang tetap sama
        sedangThreshold = ringanThreshold + (sedangThreshold - oldRinganThreshold);
      }
      
      // Tentukan keparahan berdasarkan threshold akhir
      if (severityRoll < ringanThreshold) {
        if (currentAge <= 12) {
          penyakit = _getChildDisease(currentAge, 'ringan');
        } else {
          penyakit = PenyakitRinganHelper.getRandomRingan();
        }
      } else if (severityRoll < sedangThreshold) {
        if (currentAge <= 12) {
          penyakit = _getChildDisease(currentAge, 'sedang');
        } else {
          penyakit = PenyakitRinganHelper.getRandomSedang();
        }
      } else {
        if (currentAge <= 12) {
          penyakit = _getChildDisease(currentAge, 'berat');
        } else {
          penyakit = PenyakitBeratHelper.getRandomBerat();
        }
        isBerat = true;
      }
      
      final String name = penyakit['name'];
      final int minDmg = penyakit['min'];
      final int maxDmg = penyakit['max'];
      final String emoji = penyakit['emoji'];
      
      // Hitung damage acak di dalam rentang min dan max
      final int damage = minDmg + random.nextInt(maxDmg - minDmg + 1);
      
      // Kurangi kesehatan
      character.health = (character.health - damage).clamp(0, 100);
      
      // Kurangi kebahagiaan berdasarkan tingkat keparahan penyakit
      int happinessDeduction = 0;
      if (isBerat) {
        // jika berat 10-30
        happinessDeduction = 10 + random.nextInt(21);
      } else {
        // jika ringan/sedang 1-10
        happinessDeduction = 1 + random.nextInt(10);
      }
      character.happiness = (character.happiness - happinessDeduction).clamp(0, 100);
      
      // Tambahkan kejadian ke events dan inbox
      final String logMessage = '🤒 Penyakit Instan: Kamu terdiagnosis mengidap $name $emoji. Kesehatanmu turun sebesar -$damage% dan Kebahagiaanmu turun sebesar -$happinessDeduction%.';
      events.add(logMessage);
      character.inbox.add(logMessage);
      
      // Tambahkan ke riwayat penyakit aktif
      if (!character.riwayatPenyakit.contains(name)) {
        character.riwayatPenyakit.add(name);
      }
    }
  }

  static Map<String, dynamic> _getChildDisease(int age, String category) {
    final random = Random();
    
    if (age <= 4) {
      if (category == 'ringan') {
        final list = [
          {'name': 'Kolik infantil', 'min': 1, 'max': 3, 'emoji': '🍼'},
          {'name': 'Ruam popok', 'min': 1, 'max': 2, 'emoji': '👶'},
          {'name': 'Batuk pilek bayi', 'min': 1, 'max': 3, 'emoji': '🤧'},
          {'name': 'Biang keringat bayi', 'min': 1, 'max': 2, 'emoji': '🔴'},
        ];
        return list[random.nextInt(list.length)];
      } else if (category == 'sedang') {
        final list = [
          {'name': 'Flu Singapura (HFMD)', 'min': 5, 'max': 8, 'emoji': '🤒'},
          {'name': 'Cacar air', 'min': 6, 'max': 10, 'emoji': '🔴'},
          {'name': 'Diare balita', 'min': 4, 'max': 8, 'emoji': '🤢'},
          {'name': 'Demam tumbuh gigi', 'min': 3, 'max': 6, 'emoji': '🦷'},
        ];
        return list[random.nextInt(list.length)];
      } else {
        final list = [
          {'name': 'Pneumonia balita', 'min': 12, 'max': 20, 'emoji': '🫁'},
          {'name': 'Kejang demam (Step)', 'min': 15, 'max': 25, 'emoji': '⚡'},
        ];
        return list[random.nextInt(list.length)];
      }
    } else if (age <= 8) {
      if (category == 'ringan') {
        final list = [
          {'name': 'Infeksi cacingan', 'min': 2, 'max': 4, 'emoji': '🐛'},
          {'name': 'Batuk musiman anak', 'min': 1, 'max': 3, 'emoji': '😷'},
          {'name': 'Alergi jajanan sekolah', 'min': 2, 'max': 4, 'emoji': '🍿'},
          {'name': 'Biang keringat gatal', 'min': 1, 'max': 3, 'emoji': '🔴'},
        ];
        return list[random.nextInt(list.length)];
      } else if (category == 'sedang') {
        final list = [
          {'name': 'Radang tenggorokan (Faringitis)', 'min': 5, 'max': 9, 'emoji': '👄'},
          {'name': 'Gondongan (Mumps)', 'min': 6, 'max': 10, 'emoji': '🤕'},
          {'name': 'Demam Berdarah Dengue (DBD) anak', 'min': 10, 'max': 15, 'emoji': '🦟'},
          {'name': 'Gastroenteritis anak', 'min': 6, 'max': 11, 'emoji': '🤢'},
        ];
        return list[random.nextInt(list.length)];
      } else {
        final list = [
          {'name': 'Asma akut anak', 'min': 15, 'max': 22, 'emoji': '🫁'},
          {'name': 'Meningitis anak', 'min': 18, 'max': 28, 'emoji': '🧠'},
        ];
        return list[random.nextInt(list.length)];
      }
    } else {
      // 9-12
      if (category == 'ringan') {
        final list = [
          {'name': 'Sakit gigi karies', 'min': 2, 'max': 5, 'emoji': '🦷'},
          {'name': 'Luka lecet jatuh sepeda', 'min': 1, 'max': 3, 'emoji': '🚲'},
          {'name': 'Sakit kepala belajar', 'min': 1, 'max': 3, 'emoji': '📚'},
          {'name': 'Kram kaki bermain bola', 'min': 2, 'max': 4, 'emoji': '⚽'},
        ];
        return list[random.nextInt(list.length)];
      } else if (category == 'sedang') {
        final list = [
          {'name': 'Radang amandel (Tonsilitis)', 'min': 6, 'max': 11, 'emoji': '👅'},
          {'name': 'Tipes anak sekolah', 'min': 8, 'max': 12, 'emoji': '🤒'},
          {'name': 'Mata merah menular', 'min': 4, 'max': 8, 'emoji': '👁️'},
          {'name': 'Influenza tipe B', 'min': 7, 'max': 12, 'emoji': '😷'},
        ];
        return list[random.nextInt(list.length)];
      } else {
        final list = [
          {'name': 'Radang paru akut', 'min': 16, 'max': 24, 'emoji': '🫁'},
          {'name': 'Demam rematik akut', 'min': 18, 'max': 26, 'emoji': '❤️'},
        ];
        return list[random.nextInt(list.length)];
      }
    }
  }
}
