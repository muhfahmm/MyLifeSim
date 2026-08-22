// lib/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_lamar.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class BeritahuLamaranHelper {
  static Future<void> showTellOrNotDialog({
    required BuildContext context,
    required Character character,
    required String partnerName,
    required String partnerRole,
    required VoidCallback onComplete,
  }) async {
    final bool hasLivingParents = 
        (character.fatherName != null && !character.isFatherDeceased) ||
        (character.motherName != null && !character.isMotherDeceased);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.diamond, color: Colors.blueAccent),
            SizedBox(width: 8),
            Text('Kabar Lamaran!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat! Lamaranmu telah diterima. Apakah kamu ingin memberi tahu orang tuamu tentang pertunangan baru ini?',
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
              character.inbox.add('🤫 Rahasia: Kamu memilih untuk tidak membagikan berita pertunanganmu dengan orang tuamu.');
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

    if (isIncest) {
      reactionTitle = 'Kemarahan Besar! 😡💢';
      reactionText = 'Orang tuamu sangat murka dan menentang keras pertunanganmu dengan anggota keluarga ($partnerName)! Hubungan keluarga hancur berantakan.';
      themeColor = Colors.red;

      if (character.fatherName != null) character.fatherRelationship = (character.fatherRelationship ?? 50) - 35;
      if (character.motherName != null) character.motherRelationship = (character.motherRelationship ?? 50) - 35;
      character.happiness = (character.happiness - 30).clamp(0, 100);
    } else {
      reactionTitle = 'Restu Orang Tua! 💖✨';
      reactionText = 'Orang tuamu memberikan restu penuh dengan senyuman lebar! Mereka menyukai $partnerName and memberikan ucapan selamat yang hangat.';
      themeColor = Colors.green;

      if (character.fatherName != null) character.fatherRelationship = (character.fatherRelationship ?? 50) + 10;
      if (character.motherName != null) character.motherRelationship = (character.motherRelationship ?? 50) + 10;
      character.happiness = (character.happiness + 10).clamp(0, 100);
    }

    character.inbox.add('📢 Reaksi Lamaran: $reactionText');

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
