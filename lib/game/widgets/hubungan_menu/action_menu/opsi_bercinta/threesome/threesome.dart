// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/threesome.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_tempat/pilih_tempat.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/pilih_waktu/pilih_waktu.dart';

class ThreesomeHelper {
  /// Memulai logika ajak 3some/4some/5some/6some jika user memiliki minimal 2 pacar.
  static void processThreesome({
    required BuildContext context,
    required Character character,
    required VoidCallback updateState,
  }) {
    final int count = character.activePartnersCount;
    if (count < 2) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text('Syarat Kurang', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Untuk mengajak hubungan ini, kamu harus memiliki minimal 2 pacar aktif!',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return;
    }

    final List<String> names = [];
    if (character.partner != null && character.partner!['isDeceased'] != 'true') names.add(character.partner!['name']!);
    if (character.secondPartner != null && character.secondPartner!['isDeceased'] != 'true') names.add(character.secondPartner!['name']!);
    if (character.thirdPartner != null && character.thirdPartner!['isDeceased'] != 'true') names.add(character.thirdPartner!['name']!);
    if (character.fourthPartner != null && character.fourthPartner!['isDeceased'] != 'true') names.add(character.fourthPartner!['name']!);
    if (character.fifthPartner != null && character.fifthPartner!['isDeceased'] != 'true') names.add(character.fifthPartner!['name']!);

    final String partnerNamesText = names.join(' dan ');
    final String someName = '${count + 1}some';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.people, color: Colors.purple, size: 28),
            const SizedBox(width: 8),
            Text('Ajak $someName? 🔥', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah kamu yakin ingin mengajak $partnerNamesText untuk melakukan $someName bersama-sama?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Text(
                'ℹ️ Info: Ada 60% peluang pacar-pacarmu akan menerima ajakan ini. Jika ditolak, hubungan kalian tidak akan putus.',
                style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              
              // Tampilkan dialog tempat dan waktu
              final String? loc = await TempatBercintaHelper.showLocationChooser(
                context: context,
                character: character,
                partnerName: 'Pacar-pacarmu',
                userAge: character.age,
                targetAge: 20,
              );
              if (loc == null) return;

              if (!context.mounted) return;
              final String? time = await PilihWaktuHelper.showTimeChooser(context, loc);
              if (time == null) return;

              final List<Map<String, dynamic>> femalePartners = [];
              if (character.partner != null && character.partner!['isDeceased'] != 'true' && (character.partner!['gender'] ?? 'Perempuan') == 'Perempuan') {
                femalePartners.add(character.partner!);
              }
              if (character.secondPartner != null && character.secondPartner!['isDeceased'] != 'true' && (character.secondPartner!['gender'] ?? 'Perempuan') == 'Perempuan') {
                femalePartners.add(character.secondPartner!);
              }
              if (character.thirdPartner != null && character.thirdPartner!['isDeceased'] != 'true' && (character.thirdPartner!['gender'] ?? 'Perempuan') == 'Perempuan') {
                femalePartners.add(character.thirdPartner!);
              }
              if (character.fourthPartner != null && character.fourthPartner!['isDeceased'] != 'true' && (character.fourthPartner!['gender'] ?? 'Perempuan') == 'Perempuan') {
                femalePartners.add(character.fourthPartner!);
              }
              if (character.fifthPartner != null && character.fifthPartner!['isDeceased'] != 'true' && (character.fifthPartner!['gender'] ?? 'Perempuan') == 'Perempuan') {
                femalePartners.add(character.fifthPartner!);
              }

              bool useCondom = false;
              if ((character.gender.toLowerCase() == 'laki-laki' || character.gender.toLowerCase() == 'male') && femalePartners.isNotEmpty && context.mounted) {
                final bool? chooseCondom = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    title: const Row(
                      children: [
                        Icon(Icons.security, color: Colors.blue),
                        SizedBox(width: 10),
                        Text('Gunakan Pengaman?', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    content: const Text(
                      'Apakah kamu ingin menggunakan pengaman (kondom) saat melakukan threesome untuk mencegah kehamilan?',
                      style: TextStyle(fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Ya, pakai', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Tidak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
                if (chooseCondom == null) return;
                useCondom = chooseCondom;
              }

              if (!context.mounted) return;
              _executeThreesome(context, character, partnerNamesText, someName, loc, time, useCondom, femalePartners, updateState);
            },
            child: const Text('Ya, Lakukan!', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static void _executeThreesome(
    BuildContext context,
    Character character,
    String partnerNamesText,
    String someName,
    String loc,
    String time,
    bool useCondom,
    List<Map<String, dynamic>> femalePartners,
    VoidCallback updateState,
  ) {
    final Random random = Random();
    final int roll = random.nextInt(100);

    if (roll >= 60) {
      character.inbox.add('📢 $someName Ditolak: $partnerNamesText menolak ajakan $someName karena merasa belum siap. Hubungan kalian tetap berjalan baik.');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blueGrey),
              SizedBox(width: 8),
              Text('Ajakan Ditolak', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Ajakan $someName ditolak. $partnerNamesText menolak ajakan $someName karena merasa belum siap. Hubungan kalian tetap berjalan baik.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                updateState();
              },
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      if (character.partner != null) {
        int rel = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
        character.partner!['relationship'] = (rel + 20).clamp(0, 100).toString();
      }
      if (character.secondPartner != null) {
        int rel = int.tryParse(character.secondPartner!['relationship'] ?? '50') ?? 50;
        character.secondPartner!['relationship'] = (rel + 20).clamp(0, 100).toString();
      }
      if (character.thirdPartner != null) {
        int rel = int.tryParse(character.thirdPartner!['relationship'] ?? '50') ?? 50;
        character.thirdPartner!['relationship'] = (rel + 20).clamp(0, 100).toString();
      }
      if (character.fourthPartner != null) {
        int rel = int.tryParse(character.fourthPartner!['relationship'] ?? '50') ?? 50;
        character.fourthPartner!['relationship'] = (rel + 20).clamp(0, 100).toString();
      }
      if (character.fifthPartner != null) {
        int rel = int.tryParse(character.fifthPartner!['relationship'] ?? '50') ?? 50;
        character.fifthPartner!['relationship'] = (rel + 20).clamp(0, 100).toString();
      }

      character.happiness = (character.happiness + 30).clamp(0, 100);

      // Logika Kehamilan Threesome (Masing-masing wanita 50% peluang hamil mandiri jika tidak pakai kondom)
      List<String> newlyPregnantNames = [];
      if (!useCondom && femalePartners.length >= 2) {
        final bool female1Pregnant = random.nextInt(100) < 50;
        final bool female2Pregnant = random.nextInt(100) < 50;
        if (female1Pregnant) newlyPregnantNames.add(femalePartners[0]['name'] ?? 'Pacar 1');
        if (female2Pregnant) newlyPregnantNames.add(femalePartners[1]['name'] ?? 'Pacar 2');
      }

      String detailsText = '';
      if (newlyPregnantNames.isNotEmpty) {
        character.partnerIsPregnant = true;
        final String existingPreg = character.pregnantByPartnerName ?? '';
        final List<String> currentList = existingPreg.isEmpty ? [] : existingPreg.split(', ');
        for (var pName in newlyPregnantNames) {
          if (!currentList.contains(pName)) {
            currentList.add(pName);
          }
        }
        character.pregnantByPartnerName = currentList.join(', ');
        detailsText = '\n\n🤰 Kehamilan: ${newlyPregnantNames.join(" dan ")} telah hamil hasil dari threesome ini!';
      }

      character.inbox.add('🔥 Sukses $someName: Kamu berhasil melakukan $someName yang luar biasa memuaskan bersama $partnerNamesText $loc pada waktu $time!$detailsText');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.bolt, color: Colors.purple),
              SizedBox(width: 8),
              Text('Sukses Fantastis! 🔥', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Luar biasa! $partnerNamesText menerima ajakanmu dengan gairah yang membara. Pengalaman $someName kalian $loc pada waktu $time berjalan sangat memuaskan!$detailsText',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                updateState();
              },
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }
}
