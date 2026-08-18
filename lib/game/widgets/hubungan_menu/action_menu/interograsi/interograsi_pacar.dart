// lib/game/widgets/hubungan_menu/action_menu/interograsi/interograsi_pacar.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class InterograsiPacarHelper {
  /// Membuka dialog interograsi/konfrontasi ketika pacar mengetahui rencana selingkuh dari pembocor (informant).
  static void showInterograsiDialog({
    required BuildContext context,
    required Character character,
    required String partnerName,
    required String informantName,
    required VoidCallback onComplete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String selectedReason = 'Khilaf / Cuma Iseng';
        final List<String> reasons = [
          'Khilaf / Cuma Iseng',
          'Aku tidak merasa dicintai lagi olehmu',
          'Tadi itu cuma salah paham saja!',
          'Maafkan aku, aku janji tidak akan mengulanginya',
        ];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.gavel, color: Colors.redAccent, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Konfrontasi: $partnerName 😡',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$partnerName menatapmu dengan mata berkaca-kaca penuh amarah. Dia berkata:\n\n'
                    '"Aku baru saja diberitahu oleh $informantName kalau kamu mencoba merayunya untuk pacaran! '
                    'Jelaskan padaku, kenapa kamu tega melakukan ini di belakangku?!"',
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pilih alasan / pembelaan diri:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: selectedReason,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: reasons.map((String reason) {
                      return DropdownMenuItem<String>(
                        value: reason,
                        child: Text(reason, style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedReason = val;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _processResponse(context, character, partnerName, selectedReason, onComplete);
                  },
                  child: const Text('Kirim Penjelasan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void _processResponse(
    BuildContext context,
    Character character,
    String partnerName,
    String reason,
    VoidCallback onComplete,
  ) {
    String reactionText;
    int happinessPenalty = 10;
    int relationshipPenalty = 15;
    bool didBreakUp = false;

    // Logika berdasarkan alasan yang dipilih
    if (reason == 'Tadi itu cuma salah paham saja!') {
      // 30% dimaafkan (sedikit penalty), 70% makin marah
      final bool forgiven = (DateTime.now().millisecond % 10) < 3;
      if (forgiven) {
        reactionText = '$partnerName mendengus kesal, namun memilih untuk memercayaimu kali ini. "Awas saja kalau terulang lagi!"';
        relationshipPenalty = 10;
        happinessPenalty = 5;
      } else {
        reactionText = '$partnerName berteriak: "Salah paham kepalamu! Aku tidak sebodoh itu!" Hubungan kalian retak parah.';
        relationshipPenalty = 30;
        happinessPenalty = 20;
      }
    } else if (reason == 'Maafkan aku, aku janji tidak akan mengulanginya') {
      // 50% dimaafkan dengan penyesalan
      final bool forgiven = (DateTime.now().millisecond % 10) < 5;
      if (forgiven) {
        reactionText = '$partnerName melihat penyesalan di matamu. Dia memaafkanmu, namun dengan syarat ketat.';
        relationshipPenalty = 15;
        happinessPenalty = 10;
      } else {
        reactionText = '$partnerName menangis dan berkata: "Maaf tidak bisa memperbaiki kepercayaanku yang sudah hancur!"';
        didBreakUp = true;
      }
    } else if (reason == 'Aku tidak merasa dicintai lagi olehmu') {
      // Mengkambinghitamkan pasangan, 80% putus
      final bool forgiven = (DateTime.now().millisecond % 10) < 2;
      if (forgiven) {
        reactionText = '$partnerName terdiam dan merasa bersalah, dia berjanji akan mencoba lebih memperhatikanmu.';
        relationshipPenalty = 5;
      } else {
        reactionText = '$partnerName marah besar: "Jadi ini salahku?! Kita selesai!"';
        didBreakUp = true;
      }
    } else {
      // Khilaf / Cuma Iseng -> 75% putus
      final bool forgiven = (DateTime.now().millisecond % 10) < 2.5;
      if (forgiven) {
        reactionText = '$partnerName sangat kecewa dengan sikap santaimu, tapi memberimu satu kesempatan terakhir.';
        relationshipPenalty = 25;
      } else {
        reactionText = '$partnerName berteriak: "Iseng kamu bilang?! Pergi sana!" Hubungan kalian berakhir.';
        didBreakUp = true;
      }
    }

    if (didBreakUp) {
      character.partner = character.secondPartner; // Pindahkan selingkuhan jika ada ke partner utama, atau null
      character.secondPartner = null;
      character.isHavingAffair = false;
      character.happiness = (character.happiness - 30).clamp(0, 100);
      character.inbox.add('💔 Putus: Kamu diputuskan oleh $partnerName setelah diinterograsi tentang perselingkuhan.');
    } else {
      if (character.partner != null) {
        int rel = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
        character.partner!['relationship'] = (rel - relationshipPenalty).clamp(0, 100).toString();
      }
      character.happiness = (character.happiness - happinessPenalty).clamp(0, 100);
      character.inbox.add('⚠️ Interograsi: Kamu diinterograsi oleh $partnerName. Penjelasanmu membuat hubungan berkurang -$relationshipPenalty%.');
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(didBreakUp ? Icons.heart_broken : Icons.info_outline, color: didBreakUp ? Colors.red : Colors.orange),
            const SizedBox(width: 8),
            Text(didBreakUp ? 'Putus Hubungan' : 'Hasil Interograsi', style: const TextStyle(fontWeight: FontWeight.bold)),
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
