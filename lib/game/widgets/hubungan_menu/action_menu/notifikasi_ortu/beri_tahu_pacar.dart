// lib/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_pacar.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class BeritahuPacarHelper {
  /// Dipanggil setelah user berhasil merayu pacar kedua.
  /// Memberi pilihan apakah mau memberitahu pacar pertama tentang hubungan baru ini.
  static Future<void> showTellFirstPartnerDialog({
    required BuildContext context,
    required Character character,
    required String secondPartnerName,
    required VoidCallback onComplete,
  }) async {
    final String? firstPartnerName = character.partner?['name'];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.favorite, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Pacar Baru!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kamu berhasil menjalin hubungan dengan $secondPartnerName. Kamu sudah memiliki pacar ($firstPartnerName). Apakah kamu ingin memberitahu pacarmu tentang hubungan baru ini?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: const Text(
                '⚠️ Perhatian: Memberitahu pacar mungkin akan mengakhiri salah satu hubungan. Merahasiakannya bisa berakhir dengan ketahuan dan dampak yang lebih buruk!',
                style: TextStyle(fontSize: 12, color: Colors.orange),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _executeTellFirstPartner(context, character, firstPartnerName ?? 'Pacarmu', secondPartnerName, onComplete);
            },
            child: const Text('Ya, Beritahu Pacar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Rahasiakan - simpan sebagai affair
              character.isHavingAffair = true;
              character.inbox.add('🤫 Rahasia: Kamu diam-diam menjalin hubungan dengan $secondPartnerName tanpa sepengetahuan $firstPartnerName!');
              onComplete();
            },
            child: const Text('Tidak, Rahasiakan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  static void _executeTellFirstPartner(
    BuildContext context,
    Character character,
    String firstPartnerName,
    String secondPartnerName,
    VoidCallback onComplete,
  ) {
    // Reaksi pacar pertama: 70% marah dan putus, 30% menerima (poliamorisme)
    final bool accepted = (DateTime.now().millisecond % 10) < 3; // ~30% chance

    String reactionTitle;
    String reactionText;
    Color themeColor;

    if (accepted) {
      reactionTitle = 'Pacar Menerima 💔→❤️';
      reactionText = '$firstPartnerName terkejut namun akhirnya menerima hubunganmu dengan $secondPartnerName. Kalian setuju menjalani hubungan terbuka. Hubungan dengan $firstPartnerName sedikit merenggang.';
      themeColor = Colors.orange;
      // Menurunkan relationship dengan pacar pertama tapi tidak putus
      if (character.partner != null) {
        int rel = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
        character.partner!['relationship'] = (rel - 20).clamp(0, 100).toString();
      }
      character.isHavingAffair = true;
    } else {
      reactionTitle = 'Putus! 💔';
      reactionText = '$firstPartnerName sangat marah dan merasa dikhianati! Dia langsung memutuskan hubungan denganmu setelah mengetahui kamu selingkuh dengan $secondPartnerName.';
      themeColor = Colors.red;
      // Pacar pertama putus
      character.partner = character.secondPartner;
      character.secondPartner = null;
      character.isHavingAffair = false;
      character.happiness = (character.happiness - 20).clamp(0, 100);
    }

    character.inbox.add('💔 Beritahu Pacar: $reactionText');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: themeColor),
            const SizedBox(width: 8),
            Flexible(child: Text(reactionTitle, style: const TextStyle(fontWeight: FontWeight.bold))),
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
          ),
        ],
      ),
    );
  }
}
