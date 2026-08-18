// lib/game/widgets/penyakit_logic/incest_logic.dart
import 'dart:math';
import 'package:bitlife/pilih_karakter/character.dart';

// Fungsi untuk menangani konsekuensi medis kehamilan incest saat melahirkan (di ageUp)
Map<String, dynamic> handleIncestPregnancyEffect(Character character, Random random) {
  final String? role = character.pregnantByPartnerRole;
  final String? partnerName = character.pregnantByPartnerName;
  if (role == null || partnerName == null) {
    return {'keguguran': false, 'kelainanGenetik': false};
  }

  final String roleLower = role.toLowerCase();
  final String nameLower = partnerName.toLowerCase();

  // Cek apakah target adalah keluarga sedarah (incest)
  final bool isIncest = roleLower == 'kandung' || 
                        roleLower == 'tiri' || 
                        roleLower == 'laki-laki' || 
                        roleLower == 'perempuan' ||
                        roleLower.contains('saudara') || 
                        nameLower.contains('kakak') || 
                        nameLower.contains('adik') ||
                        nameLower.startsWith('ayah') || 
                        nameLower.startsWith('ibu');

  if (!isIncest) {
    return {'keguguran': false, 'kelainanGenetik': false};
  }

  final int roll = random.nextInt(100);

  // Keguguran/Lahir mati hanya 10-20% saja (kita gunakan 15%)
  if (roll < 15) {
    character.happiness = (character.happiness - 40).clamp(0, 100);
    final String logMsg = '🥀 Tragedi Inses: Kehamilan hasil hubungan sedarah dengan $partnerName berakhir dengan keguguran / bayi lahir dalam keadaan meninggal. Kamu merasa sangat sedih (-40% Kebahagiaan).';
    character.inbox.add(logMsg);
    return {'keguguran': true, 'kelainanGenetik': false, 'pesan': logMsg};
  } 
  
  // 80-90% Bayi berhasil lahir (85% sisa chance). Di dalam peluang lahir ini, ada risiko 40-50% cacat bawaan/kelainan genetik.
  final int geneticRoll = random.nextInt(100);
  if (geneticRoll < 45) { // 45% peluang cacat fisik/mental/Down Syndrome
    character.happiness = (character.happiness - 35).clamp(0, 100);
    final String logMsg = '⚠️ Kelainan Genetik Inses: Anak hasil hubungan sedarah dengan $partnerName lahir dengan kelainan genetik bawaan serius (cacat fisik/mental). Kebahagiaanmu turun drastis!';
    character.inbox.add(logMsg);
    return {'keguguran': false, 'kelainanGenetik': true, 'pesan': logMsg};
  }

  return {'keguguran': false, 'kelainanGenetik': false};
}

