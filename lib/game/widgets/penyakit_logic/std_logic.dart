// lib/game/widgets/penyakit_logic/std_logic.dart
import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

void handleSTDCheck(Character character, String partnerRole, String partnerName, Random random) {
  final String roleLower = partnerRole.toLowerCase();
  final String nameLower = partnerName.toLowerCase();
  final String myGender = character.gender.trim().toLowerCase();

  // Ambil gender pasangan untuk cek gay/lesbian
  String partnerGender = 'laki-laki'; // default
  if (nameLower.startsWith('ibu') || nameLower.contains('(kakak perempuan)') || nameLower.contains('(adik perempuan)')) {
    partnerGender = 'perempuan';
  } else if (nameLower.startsWith('ayah') || nameLower.contains('(kakak laki-laki)') || nameLower.contains('(adik laki-laki)')) {
    partnerGender = 'laki-laki';
  } else if (character.partner != null && character.partner!['name'] == partnerName) {
    partnerGender = (character.partner!['gender'] ?? 'Laki-laki').trim().toLowerCase();
  }

  final bool isGay = myGender == 'laki-laki' && partnerGender == 'laki-laki';
  final bool isLesbian = myGender == 'perempuan' && partnerGender == 'perempuan';

  // Hanya memicu STD jika hubungan adalah gay atau lesbian
  if (isGay || isLesbian) {
    final int roll = random.nextInt(100);

    if (roll < 4) { // 3-5% HIV / AIDS
      if (!character.hasHIV) {
        character.hasHIV = true;
        final String msg = '🚨 Diagnosis HIV/AIDS: Setelah memutuskan berhubungan intim sesama jenis (${isGay ? 'Gay' : 'Lesbian'}) dengan $partnerName, kamu terdiagnosis mengidap HIV/AIDS! Kesehatanmu akan terus turun perlahan setiap tahun.';
        character.inbox.add(msg);
      }
    } else if (roll >= 4 && roll < 14) { // 8-12% Sifilis / Gonore
      if (!character.hasSifilis) {
        character.hasSifilis = true;
        character.health = (character.health - 20).clamp(0, 100);
        final String msg = '🚨 Terjangkit Sifilis & Gonore: Kamu tertular penyakit kelamin menular dari $partnerName. Kesehatanmu langsung turun drastis (-20% kesehatan)!';
        character.inbox.add(msg);
      }
    } else if (roll >= 14 && roll < 19) { // 5% HPV
      if (!character.hasHPV) {
        character.hasHPV = true;
        character.happiness = (character.happiness - 15).clamp(0, 100);
        character.appearance = (character.appearance - 15).clamp(0, 100);
        final String msg = '🚨 Terjangkit HPV: Hubungan intim sesama jenis menyebabkan infeksi virus HPV. Kulit gatal-gatal menurunkan penampilan dan kebahagiaanmu!';
        character.inbox.add(msg);
      }
    }
  }
}
