import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

/// Logika panggilan untuk hubungan Pasangan (Pacar, Tunangan, Suami, Istri).
class PanggilanPacar {
  static final Random _random = Random();

  /// Mendapatkan panggilan romantis untuk pacar/pasangan.
  /// [isSpeakerPlayer]: true jika User yang bicara ke NPC, false jika NPC bicara ke User.
  static String getPanggilan({
    required String targetName,
    String? targetGender,
    String? targetRole,
    bool isSpeakerPlayer = false,
    String? userName,
    String? userGender,
    bool includeName = true,
    Character? character,
  }) {
    final bool isUserMale = (userGender ?? '').toLowerCase().contains('laki') || (userGender ?? '').toLowerCase().contains('male');
    final bool isTargetFemale = (targetGender == null || targetGender.isEmpty || targetGender.toLowerCase().contains('perempuan') || targetGender.toLowerCase().contains('female') || targetGender.toLowerCase().contains('cewek'));

    // Jika User adalah Staf Laki-laki dan NPC adalah Idol Perempuan
    final bool isUserStaff = character != null && character.isIdolStaff;
    final bool isDating = character != null && character.isAnyPartnerNameMatching(targetName);

    if (!isSpeakerPlayer && isUserMale && isTargetFemale && isUserStaff) {
      if (isDating) {
        // Sudah PACAR RESMI: Idol perempuan memanggil staf laki-laki dengan "Om Sayang", "Om", "Sayang", atau "Mas"
        final List<String> omPool = ['Om Sayang', 'Om', 'Sayang', 'Mas'];
        return omPool[_random.nextInt(omPool.length)];
      } else {
        // BELUM BERPACARAN (Formal/Biasa): Idol perempuan memanggil staf laki-laki dengan "Om" atau "Pak"
        final List<String> formalPool = ['Om', 'Pak', 'Staf', 'Mas'];
        return formalPool[_random.nextInt(formalPool.length)];
      }
    }

    // Jika NPC (perempuan) memanggil User (laki-laki) yang merupakan pacar
    if (!isSpeakerPlayer && isUserMale && isTargetFemale) {
      return 'Sayang';
    }

    final String g = isSpeakerPlayer
        ? (targetGender ?? '').toLowerCase()
        : (userGender ?? '').toLowerCase();

    final String listenerName = isSpeakerPlayer ? targetName : (userName ?? '');
    final bool isMale = g == 'laki-laki' || g == 'male' || (isSpeakerPlayer && targetRole == 'Suami');

    final List<String> listPanggilan = [
      'Sayang',
      'Sayangku',
      'Beb',
      'Honey',
      'Cinta',
      'Cintaku',
      'Manisku',
      'Love',
    ];

    if (isMale) {
      listPanggilan.addAll([
        'Mas',
        'Abang',
        'Hubby',
        if (includeName && listenerName.isNotEmpty) 'Mas $listenerName',
        if (includeName && listenerName.isNotEmpty) 'Abang $listenerName',
      ]);
    } else {
      listPanggilan.addAll([
        'Adek',
        'Dek',
        'Wife',
        'Cantik',
        'Manis',
        if (includeName && listenerName.isNotEmpty) 'Dek $listenerName',
        if (includeName && listenerName.isNotEmpty) 'Sayang $listenerName',
      ]);
    }

    return listPanggilan[_random.nextInt(listPanggilan.length)];
  }
}
