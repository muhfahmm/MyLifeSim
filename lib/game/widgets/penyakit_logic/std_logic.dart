// lib/game/widgets/penyakit_logic/std_logic.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/store_page/store_page.dart';

// ============================================================
// STD berlaku untuk:
//  1. Hubungan sesama jenis (Gay / Lesbian) - siapapun
//  2. Hubungan incest lawan jenis juga bisa kena STD
// ============================================================

/// Deteksi gender pasangan dari berbagai sumber data character
String _detectPartnerGender(Character character, String partnerRole, String partnerName) {
  final String roleLower = partnerRole.toLowerCase();
  final String nameLower = partnerName.toLowerCase();

  // Deteksi dari nama/role keluarga
  if (nameLower.startsWith('ibu') || roleLower.contains('ibu') ||
      nameLower.contains('(kakak perempuan)') || nameLower.contains('(adik perempuan)') ||
      roleLower.contains('bibi') || roleLower.contains('nenek')) {
    return 'perempuan';
  }
  if (nameLower.startsWith('ayah') || roleLower.contains('ayah') ||
      nameLower.contains('(kakak laki-laki)') || nameLower.contains('(adik laki-laki)') ||
      roleLower.contains('paman') || roleLower.contains('kakek')) {
    return 'laki-laki';
  }

  // Deteksi dari slot partner aktif
  for (final p in [
    character.partner,
    character.secondPartner,
    character.thirdPartner,
    character.fourthPartner,
    character.fifthPartner,
  ]) {
    if (p != null && p['name'] == partnerName) {
      return (p['gender'] ?? 'Laki-laki').trim().toLowerCase();
    }
  }

  // Deteksi dari extended family
  for (final ext in character.extendedFamily) {
    if (ext['name'] == partnerName) {
      return (ext['gender'] ?? 'Laki-laki').trim().toLowerCase();
    }
  }

  // Deteksi dari siblings
  for (final sib in character.siblings) {
    if (sib['name'] == partnerName) {
      return (sib['gender'] ?? 'Laki-laki').trim().toLowerCase();
    }
  }

  return 'laki-laki'; // default
}

/// Modal notifikasi STD
Future<void> _showSTDModal(
  BuildContext context, {
  required String disease,
  required String emoji,
  required String description,
  required Color color,
  required String partnerName,
  required String sexType,
}) async {
  if (!context.mounted) return;
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Row(
        children: [
          Icon(Icons.coronavirus, color: color, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text('$emoji Terdiagnosis $disease',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Setelah berhubungan intim $sexType dengan $partnerName tanpa pengaman,',
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text('kamu terdiagnosis mengidap $disease.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withAlpha(80)),
            ),
            child: Text(description, style: const TextStyle(fontSize: 13, color: Colors.black87)),
          ),
          const SizedBox(height: 10),
          const Text('Selalu gunakan pengaman untuk mengurangi risiko penularan penyakit.',
              style: TextStyle(fontSize: 11, color: Colors.black45)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    ),
  );
}

/// Fungsi utama: dipanggil dari bercinta.dart setelah bercinta berhasil TANPA kondom.
/// Berlaku untuk gay (laki-laki sesama jenis) maupun hubungan incest lawan jenis.
Future<void> handleSTDCheck(
  BuildContext context,
  Character character,
  String partnerRole,
  String partnerName,
  Random random,
) async {
  if (StorePage.isImmunityUnlocked) return;
  final String myGender = character.gender.trim().toLowerCase();
  final String partnerGender = _detectPartnerGender(character, partnerRole, partnerName);

  final bool isGay = myGender == 'laki-laki' && partnerGender == 'laki-laki';
  final bool isLesbian = myGender == 'perempuan' && partnerGender == 'perempuan';

  // Tentukan peluang per penyakit berdasarkan tipe hubungan
  // Gay: risiko tertinggi HIV
  // Lesbian: risiko lebih rendah
  // Lawan jenis (incest/normal): risiko menengah
  late int hivChance, sFilisChance, hpvChance;
  late String sexTypeLabel;

  if (isGay) {
    hivChance = 5;      // 5% HIV
    sFilisChance = 12;  // 12% Sifilis & Gonore
    hpvChance = 6;      // 6% HPV
    sexTypeLabel = 'sesama jenis (Gay)';
  } else if (isLesbian) {
    hivChance = 1;      // 1% HIV
    sFilisChance = 5;   // 5% Sifilis
    hpvChance = 8;      // 8% HPV
    sexTypeLabel = 'sesama jenis (Lesbian)';
  } else {
    // Lawan jenis (bisa incest atau bukan)
    hivChance = 2;      // 2% HIV
    sFilisChance = 6;   // 6% Sifilis & Gonore
    hpvChance = 4;      // 4% HPV
    sexTypeLabel = 'lawan jenis';
  }

  // Hanya gay pasti dapat efek STD tambahan; lawan jenis dan lesbian punya peluang lebih rendah
  // Tapi tetap roll untuk semua
  final int roll = random.nextInt(100);

  if (roll < hivChance) {
    if (!character.hasHIV) {
      character.hasHIV = true;
      if (!character.riwayatPenyakit.contains('HIV/AIDS')) {
        character.riwayatPenyakit.add('HIV/AIDS');
      }
      character.health = (character.health - 10).clamp(0, 100);
      final String msg =
          '🚨 Diagnosis HIV/AIDS: Setelah berhubungan intim $sexTypeLabel dengan $partnerName tanpa pengaman, '
          'kamu terdiagnosis mengidap HIV/AIDS! Kesehatanmu akan terus turun perlahan setiap tahun.';
      character.inbox.add(msg);
      await _showSTDModal(
        context,
        disease: 'HIV/AIDS',
        emoji: '🚨',
        description:
            'HIV adalah virus yang menyerang sistem kekebalan tubuh. Tanpa pengobatan, '
            'dapat berkembang menjadi AIDS yang fatal. Kesehatanmu akan turun setiap tahun.',
        color: Colors.red,
        partnerName: partnerName,
        sexType: sexTypeLabel,
      );
    }
  } else if (roll < hivChance + sFilisChance) {
    if (!character.hasSifilis) {
      character.hasSifilis = true;
      if (!character.riwayatPenyakit.contains('Sifilis & Gonore')) {
        character.riwayatPenyakit.add('Sifilis & Gonore');
      }
      character.health = (character.health - 20).clamp(0, 100);
      final String msg =
          '🚨 Terjangkit Sifilis & Gonore: Kamu tertular penyakit kelamin menular dari $partnerName '
          'saat berhubungan $sexTypeLabel. Kesehatanmu langsung turun drastis (-20% kesehatan)!';
      character.inbox.add(msg);
      await _showSTDModal(
        context,
        disease: 'Sifilis & Gonore',
        emoji: '⚠️',
        description:
            'Sifilis dan Gonore adalah infeksi bakteri menular seksual yang dapat menyebabkan '
            'komplikasi serius jika tidak diobati, termasuk kerusakan organ dan infertilitas. '
            'Kesehatanmu turun -20%.',
        color: Colors.orange,
        partnerName: partnerName,
        sexType: sexTypeLabel,
      );
    }
  } else if (roll < hivChance + sFilisChance + hpvChance) {
    if (!character.hasHPV) {
      character.hasHPV = true;
      if (!character.riwayatPenyakit.contains('HPV (Human Papillomavirus)')) {
        character.riwayatPenyakit.add('HPV (Human Papillomavirus)');
      }
      character.happiness = (character.happiness - 15).clamp(0, 100);
      character.happiness = (character.happiness - 10).clamp(0, 100); // HPV menurunkan kualitas hidup
      final String msg =
          '🚨 Terjangkit HPV: Hubungan intim $sexTypeLabel dengan $partnerName menyebabkan '
          'infeksi virus HPV. Kebahagiaanmu menurun (-25% total)!';
      character.inbox.add(msg);
      await _showSTDModal(
        context,
        disease: 'HPV (Human Papillomavirus)',
        emoji: '🔴',
        description:
            'HPV adalah virus yang menyebabkan kutil kelamin dan dapat meningkatkan risiko '
            'kanker serviks. Kebahagiaan kamu menurun -25% total.',
        color: Colors.deepOrange,
        partnerName: partnerName,
        sexType: sexTypeLabel,
      );
    }
  }
}

/// Versi tanpa context (untuk dipanggil dari index.dart / ageUp tanpa UI)
void handleSTDCheckNoContext(
  Character character,
  String partnerRole,
  String partnerName,
  Random random,
) {
  final String myGender = character.gender.trim().toLowerCase();
  final String partnerGender = _detectPartnerGender(character, partnerRole, partnerName);

  final bool isGay = myGender == 'laki-laki' && partnerGender == 'laki-laki';
  final bool isLesbian = myGender == 'perempuan' && partnerGender == 'perempuan';

  int hivChance, sFilisChance, hpvChance;
  String sexTypeLabel;

  if (isGay) {
    hivChance = 5; sFilisChance = 12; hpvChance = 6;
    sexTypeLabel = 'sesama jenis (Gay)';
  } else if (isLesbian) {
    hivChance = 1; sFilisChance = 5; hpvChance = 8;
    sexTypeLabel = 'sesama jenis (Lesbian)';
  } else {
    hivChance = 2; sFilisChance = 6; hpvChance = 4;
    sexTypeLabel = 'lawan jenis';
  }

  final int roll = random.nextInt(100);
  if (roll < hivChance && !character.hasHIV) {
    character.hasHIV = true;
    if (!character.riwayatPenyakit.contains('HIV/AIDS')) {
      character.riwayatPenyakit.add('HIV/AIDS');
    }
    character.health = (character.health - 10).clamp(0, 100);
    character.inbox.add('🚨 Diagnosis HIV/AIDS: Setelah berhubungan intim $sexTypeLabel dengan $partnerName, kamu terdiagnosis HIV/AIDS!');
  } else if (roll < hivChance + sFilisChance && !character.hasSifilis) {
    character.hasSifilis = true;
    if (!character.riwayatPenyakit.contains('Sifilis & Gonore')) {
      character.riwayatPenyakit.add('Sifilis & Gonore');
    }
    character.health = (character.health - 20).clamp(0, 100);
    character.inbox.add('🚨 Terjangkit Sifilis & Gonore dari $partnerName. Kesehatan -20%!');
  } else if (roll < hivChance + sFilisChance + hpvChance && !character.hasHPV) {
    character.hasHPV = true;
    if (!character.riwayatPenyakit.contains('HPV (Human Papillomavirus)')) {
      character.riwayatPenyakit.add('HPV (Human Papillomavirus)');
    }
    character.happiness = (character.happiness - 15).clamp(0, 100);
    character.appearance = (character.appearance - 15).clamp(0, 100);
    character.inbox.add('🚨 Terjangkit HPV dari $partnerName. Penampilan & kebahagiaan -15%!');
  }
}
