// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/threesome/threesome.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class ThreesomeHelper {
  /// Memulai logika ajak 3some jika user memiliki 2 pacar (partner dan secondPartner).
  /// - Risiko: 60% salah satu pacar memutuskan hubungan.
  /// - Syarat: Harus punya 2 pacar aktif.
  static void processThreesome({
    required BuildContext context,
    required Character character,
    required VoidCallback updateState,
  }) {
    if (character.partner == null || character.secondPartner == null) {
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
            'Untuk mengajak 3some, kamu harus memiliki pacar resmi dan pacar kedua (selingkuhan) secara aktif!',
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

    final String firstPartnerName = character.partner!['name']!;
    final String secondPartnerName = character.secondPartner!['name']!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.people, color: Colors.purple, size: 28),
            SizedBox(width: 8),
            Text('Ajak 3some? 🔥', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apakah kamu yakin ingin mengajak $firstPartnerName dan $secondPartnerName untuk melakukan 3some bersama-sama?',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: const Text(
                '⚠️ PERINGATAN KERAS: Aksi ini sangat strict dan berisiko tinggi! Ada 60% peluang salah satu pacarmu akan marah besar dan langsung memutuskan hubungan!',
                style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _executeThreesome(context, character, firstPartnerName, secondPartnerName, updateState);
            },
            child: const Text('Ya, Lakukan!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static void _executeThreesome(
    BuildContext context,
    Character character,
    String firstPartnerName,
    String secondPartnerName,
    VoidCallback updateState,
  ) {
    final Random random = Random();
    final int roll = random.nextInt(100);

    if (roll < 60) {
      // Gagal - diputuskan oleh salah satu pacar (50/50 pacar ke-1 atau pacar ke-2)
      final bool breakWithFirst = random.nextBool();
      String brokenName;
      if (breakWithFirst) {
        brokenName = firstPartnerName;
        // Pindahkan pacar kedua ke pacar pertama karena pacar pertama pergi
        character.partner = character.secondPartner;
        character.secondPartner = null;
        character.isHavingAffair = false;
      } else {
        brokenName = secondPartnerName;
        character.secondPartner = null;
        character.isHavingAffair = false;
      }

      character.happiness = (character.happiness - 35).clamp(0, 100);
      character.inbox.add('💔 3some Gagal Total: $brokenName merasa sangat tersinggung dan murka dengan ajakan 3some ini! Dia langsung memutuskan hubungan denganmu.');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.heart_broken, color: Colors.red),
              SizedBox(width: 8),
              Text('Diputuskan! 💔', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Ajakan 3some berakhir bencana! $brokenName merasa terhina dan langsung memutuskan hubungan denganmu saat itu juga.',
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
      // Berhasil! Menambah kepuasan dan kebahagiaan luar biasa
      if (character.partner != null) {
        int rel = int.tryParse(character.partner!['relationship'] ?? '50') ?? 50;
        character.partner!['relationship'] = (rel + 20).clamp(0, 100).toString();
      }
      if (character.secondPartner != null) {
        int rel = int.tryParse(character.secondPartner!['relationship'] ?? '50') ?? 50;
        character.secondPartner!['relationship'] = (rel + 20).clamp(0, 100).toString();
      }
      character.happiness = (character.happiness + 30).clamp(0, 100);
      character.inbox.add('🔥 Sukses 3some: Kamu berhasil melakukan 3some yang luar biasa memuaskan bersama $firstPartnerName dan $secondPartnerName!');

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
            'Luar biasa! $firstPartnerName dan $secondPartnerName menerima ajakanmu dengan gairah yang membara. Pengalaman 3some kalian bertiga berjalan sangat memuaskan!',
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
