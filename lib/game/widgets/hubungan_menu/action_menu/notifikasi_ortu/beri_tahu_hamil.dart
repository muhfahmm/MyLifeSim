// lib/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_hamil.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class BeritahuKehamilanHelper {
  static Future<void> showTellOrNotDialog({
    required BuildContext context,
    required Character character,
    required String partnerName,
    required String partnerRole,
    required VoidCallback onComplete,
  }) async {
    // Mengecek apakah ada orang tua kandung yang hidup untuk diberitahu
    final bool hasLivingParents = 
        (character.fatherName != null && !character.isFatherDeceased) ||
        (character.motherName != null && !character.isMotherDeceased);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.baby_changing_station, color: Colors.pinkAccent),
            SizedBox(width: 8),
            Text('Kabar Kehamilan!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat! Kehamilan berhasil dikonfirmasi. Apakah kamu ingin memberi tahu orang tuamu tentang kabar bahagia ini?',
              style: TextStyle(fontSize: 14),
            ),
            if (!hasLivingParents) ...[
              const SizedBox(height: 12),
              const Text(
                'Catatan: Kamu tidak memiliki orang tua yang masih hidup untuk diberitahu.',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ]
          ],
        ),
        actions: [
          if (hasLivingParents)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _executeTellParents(context, character, partnerName, partnerRole, onComplete);
              },
              child: const Text('Ya, Beritahu Ortu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Tidak memberi tahu ortu
              character.inbox.add('🤫 Rahasia: Kamu memutuskan untuk merahasiakan kehamilan ini dari orang tuamu.');
              onComplete();
            },
            child: const Text('Tidak, Rahasiakan saja', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  static void _executeTellParents(
      BuildContext context, Character character, String partnerName, String partnerRole, VoidCallback onComplete) {
    // Hitung reaksi orang tua
    // Jika pacar adalah keluarga (Incest), reaksi ortu negatif
    final bool isIncest = partnerRole.contains('Saudara') ||
        partnerRole.contains('Kandung') ||
        partnerRole.contains('Tiri') ||
        partnerName.toLowerCase().contains('kakak') ||
        partnerName.toLowerCase().contains('adik') ||
        partnerName.toLowerCase().contains('ayah') ||
        partnerName.toLowerCase().contains('ibu');

    String reactionTitle = '';
    String reactionText = '';
    Color themeColor = Colors.green;

    final int partnerAgeVal = () {
      final String cleanPartner = partnerName.toLowerCase();
      if (character.partner != null && character.partner!['name']!.toLowerCase().contains(cleanPartner)) {
        return int.tryParse(character.partner!['age'] ?? '18') ?? 18;
      }
      if (character.secondPartner != null && character.secondPartner!['name']!.toLowerCase().contains(cleanPartner)) {
        return int.tryParse(character.secondPartner!['age'] ?? '18') ?? 18;
      }
      if (character.thirdPartner != null && character.thirdPartner!['name']!.toLowerCase().contains(cleanPartner)) {
        return int.tryParse(character.thirdPartner!['age'] ?? '18') ?? 18;
      }
      if (character.fourthPartner != null && character.fourthPartner!['name']!.toLowerCase().contains(cleanPartner)) {
        return int.tryParse(character.fourthPartner!['age'] ?? '18') ?? 18;
      }
      if (character.fifthPartner != null && character.fifthPartner!['name']!.toLowerCase().contains(cleanPartner)) {
        return int.tryParse(character.fifthPartner!['age'] ?? '18') ?? 18;
      }
      return 18;
    }();

    final bool isMinorPartner = partnerAgeVal < 18;
    final int roll = character.ageUp().hashCode % 100; // deterministic random seed fallback or standard random roll
    final bool minorIsAngry = isMinorPartner && (roll < 70); // 70% chance of anger

    if (isIncest) {
      reactionTitle = 'Reaksi Murka! 😡💣';
      reactionText = 'Orang tuamu mengetahui bahwa kamu hamil akibat hubungan dengan anggota keluarga ($partnerName)! Mereka sangat syok, kecewa, dan murka! Hubungan keluarga memburuk secara ekstrem.';
      themeColor = Colors.red;

      // Efek penalti
      if (character.fatherName != null) character.fatherRelationship = (character.fatherRelationship ?? 50) - 40;
      if (character.motherName != null) character.motherRelationship = (character.motherRelationship ?? 50) - 40;
      character.happiness = (character.happiness - 35).clamp(0, 100);
    } else if (minorIsAngry) {
      reactionTitle = 'Reaksi Marah! 😡💢';
      reactionText = 'Orang tuamu sangat marah mengetahui kamu menghamili pacarmu ($partnerName) yang masih di bawah umur (${partnerAgeVal} tahun)! Hubungan keluarga memburuk.';
      themeColor = Colors.red;

      // Efek penalti
      if (character.fatherName != null) character.fatherRelationship = (character.fatherRelationship ?? 50) - 20;
      if (character.motherName != null) character.motherRelationship = (character.motherRelationship ?? 50) - 20;
      character.happiness = (character.happiness - 20).clamp(0, 100);
    } else {
      reactionTitle = 'Reaksi Bahagia! 🎉🍼';
      reactionText = 'Orang tuamu sangat senang mendengar bahwa mereka akan segera mendapatkan cucu dari hubunganmu dengan $partnerName! Hubungan keluarga semakin hangat.';
      themeColor = Colors.green;

      // Efek bonus
      if (character.fatherName != null) character.fatherRelationship = (character.fatherRelationship ?? 50) + 15;
      if (character.motherName != null) character.motherRelationship = (character.motherRelationship ?? 50) + 15;
      character.happiness = (character.happiness + 15).clamp(0, 100);
    }

    character.inbox.add('📢 Reaksi Ortu: $reactionText');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: themeColor),
            const SizedBox(width: 8),
            Text(reactionTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(reactionText),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onComplete();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
