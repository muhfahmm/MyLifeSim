// lib/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_pacar.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

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
              executeTellFirstPartner(
                context: context,
                character: character,
                firstPartnerName: firstPartnerName ?? 'Pacarmu',
                secondPartnerName: secondPartnerName,
                onComplete: onComplete,
              );
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

  static void executeTellFirstPartner({
    required BuildContext context,
    required Character character,
    required String firstPartnerName,
    required String secondPartnerName,
    required VoidCallback onComplete,
    Map<String, dynamic>? proposalData,
    bool isBercinta = false,
  }) {
    final random = Random();
    
    final int currentCount = character.activePartnersCount;
    
    int successChance = 50;
    if (currentCount == 2) successChance = 40;
    else if (currentCount == 3) successChance = 30;
    else if (currentCount == 4) successChance = 20;
    else if (currentCount >= 5) successChance = 0;
    
    final bool accepted = random.nextInt(100) < successChance;

    String reactionTitle;
    String reactionText;
    Color themeColor;

    if (accepted) {
      if (isBercinta) {
        reactionTitle = '🔥 Sukses 3some!';
        reactionText = '$firstPartnerName menyetujui ajakanmu! Kalian melakukan hubungan intim bersama yang luar biasa memuaskan.';
        themeColor = Colors.orange;
        
        if (character.partner != null) {
          int rel = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
          character.partner!['relationship'] = (rel + 15).clamp(0, 100).toString();
        }
        if (character.secondPartner != null) {
          int rel = int.tryParse(character.secondPartner!['relationship'] ?? '50') ?? 50;
          character.secondPartner!['relationship'] = (rel + 15).clamp(0, 100).toString();
        }
        if (character.thirdPartner != null) {
          int rel = int.tryParse(character.thirdPartner!['relationship'] ?? '50') ?? 50;
          character.thirdPartner!['relationship'] = (rel + 15).clamp(0, 100).toString();
        }
        if (character.fourthPartner != null) {
          int rel = int.tryParse(character.fourthPartner!['relationship'] ?? '50') ?? 50;
          character.fourthPartner!['relationship'] = (rel + 15).clamp(0, 100).toString();
        }
        if (character.fifthPartner != null) {
          int rel = int.tryParse(character.fifthPartner!['relationship'] ?? '50') ?? 50;
          character.fifthPartner!['relationship'] = (rel + 15).clamp(0, 100).toString();
        }
        character.isHavingAffair = false;
      } else {
        final int partnerNumber = currentCount + 1;
        reactionTitle = 'Pacar Menerima! 💔→❤️';
        reactionText = '$firstPartnerName terkejut namun akhirnya menerima hubunganmu dengan $secondPartnerName. Kalian setuju menjalani hubungan terbuka secara resmi! Sekarang kamu memiliki $partnerNumber pacar resmi.';
        themeColor = Colors.green;
        
        if (character.partner != null) {
          int rel = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
          character.partner!['relationship'] = (rel - 10).clamp(0, 100).toString();
        }
        if (character.secondPartner != null) {
          int rel = int.tryParse(character.secondPartner!['relationship'] ?? '50') ?? 50;
          character.secondPartner!['relationship'] = (rel - 10).clamp(0, 100).toString();
        }
        if (character.thirdPartner != null) {
          int rel = int.tryParse(character.thirdPartner!['relationship'] ?? '50') ?? 50;
          character.thirdPartner!['relationship'] = (rel - 10).clamp(0, 100).toString();
        }
        if (character.fourthPartner != null) {
          int rel = int.tryParse(character.fourthPartner!['relationship'] ?? '50') ?? 50;
          character.fourthPartner!['relationship'] = (rel - 10).clamp(0, 100).toString();
        }
        if (character.fifthPartner != null) {
          int rel = int.tryParse(character.fifthPartner!['relationship'] ?? '50') ?? 50;
          character.fifthPartner!['relationship'] = (rel - 10).clamp(0, 100).toString();
        }
        
        final Map<String, String> newPartnerData = {
          'name': secondPartnerName,
          'gender': proposalData?['gender']?.toString() ?? 'Perempuan',
          'age': proposalData?['age']?.toString() ?? '20',
          'relationship': '100',
          'relation': 'Pacar',
        };
        character.addPartnerToFreeSlot(newPartnerData);
        character.isHavingAffair = false;
      }
    } else {
      reactionTitle = '⚔️ Perebutan Cinta!';
      
      final List<String> activeSlots = [];
      if (character.partner != null && character.partner!['isDeceased'] != 'true') activeSlots.add('partner');
      if (character.secondPartner != null && character.secondPartner!['isDeceased'] != 'true') activeSlots.add('secondPartner');
      if (character.thirdPartner != null && character.thirdPartner!['isDeceased'] != 'true') activeSlots.add('thirdPartner');
      if (character.fourthPartner != null && character.fourthPartner!['isDeceased'] != 'true') activeSlots.add('fourthPartner');
      if (character.fifthPartner != null && character.fifthPartner!['isDeceased'] != 'true') activeSlots.add('fifthPartner');
      
      final String targetSlot = activeSlots.isNotEmpty ? activeSlots[random.nextInt(activeSlots.length)] : 'partner';
      
      final Map<String, String>? existingFighter = (targetSlot == 'partner'
          ? character.partner
          : targetSlot == 'secondPartner'
              ? character.secondPartner
              : targetSlot == 'thirdPartner'
                  ? character.thirdPartner
                  : targetSlot == 'fourthPartner'
                      ? character.fourthPartner
                      : character.fifthPartner);
                      
      final String fighterName = existingFighter != null ? (existingFighter['name'] ?? 'Pacarmu') : 'Pacarmu';
      
      bool firstPartnerWins = false;
      final String fighterNameLower = fighterName.toLowerCase();
      final bool isParentFighter = (character.fatherName != null && fighterNameLower.contains(character.fatherName!.toLowerCase())) ||
                                   (character.motherName != null && fighterNameLower.contains(character.motherName!.toLowerCase())) ||
                                   (character.stepFatherName != null && fighterNameLower.contains(character.stepFatherName!.toLowerCase())) ||
                                   (character.stepMotherName != null && fighterNameLower.contains(character.stepMotherName!.toLowerCase()));
                                   
      if (isParentFighter) {
        firstPartnerWins = random.nextInt(100) < 70;
      } else {
        firstPartnerWins = random.nextBool();
      }
      
      if (firstPartnerWins) {
        reactionText = '$fighterName marah besar mengetahui hal ini dan berkelahi sengit dengan $secondPartnerName untuk memperebutkan cintamu. \n\n🏆 $fighterName MEMENANGKAN perkelahian! Kamu tetap bersama $fighterName dan hubungan dengan $secondPartnerName dibatalkan.';
        themeColor = Colors.blue;
        
        character.isHavingAffair = false;
        character.happiness = (character.happiness - 10).clamp(0, 100);
      } else {
        reactionText = '$fighterName marah besar mengetahui hal ini dan berkelahi sengit dengan $secondPartnerName untuk memperebutkan cintamu. \n\n🏆 $secondPartnerName MEMENANGKAN perkelahian! Kamu kini berpacaran resmi dengan $secondPartnerName dan memutuskan hubungan dengan $fighterName.';
        themeColor = Colors.redAccent;
        
        final Map<String, String> newPartnerData = {
          'name': secondPartnerName,
          'gender': proposalData?['gender']?.toString() ?? 'Perempuan',
          'age': proposalData?['age']?.toString() ?? '20',
          'relationship': '100',
          'relation': 'Pacar',
        };
        
        if (targetSlot == 'partner') character.partner = newPartnerData;
        else if (targetSlot == 'secondPartner') character.secondPartner = newPartnerData;
        else if (targetSlot == 'thirdPartner') character.thirdPartner = newPartnerData;
        else if (targetSlot == 'fourthPartner') character.fourthPartner = newPartnerData;
        else if (targetSlot == 'fifthPartner') character.fifthPartner = newPartnerData;
        
        character.isHavingAffair = false;
        character.happiness = (character.happiness - 10).clamp(0, 100);
      }
    }

    character.inbox.add('📢 Beritahu Pacar: $reactionText');

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
