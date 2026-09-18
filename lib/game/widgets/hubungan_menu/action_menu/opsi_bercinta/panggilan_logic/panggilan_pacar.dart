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
        // Sudah PACAR RESMI: Idol perempuan memanggil staf laki-laki dengan panggilan manja
        final List<String> omPool = ['Om Sayang', 'Sayang', 'Baby', 'Beb', 'Mas Sayang', 'Om'];
        return omPool[_random.nextInt(omPool.length)];
      } else {
        // BELUM BERPACARAN (Formal/Biasa): Idol perempuan memanggil staf laki-laki dengan "Om" atau "Pak"
        final List<String> formalPool = ['Om', 'Pak', 'Staf', 'Mas'];
        return formalPool[_random.nextInt(formalPool.length)];
      }
    }

    final String listenerGender = isSpeakerPlayer
        ? (targetGender ?? '').toLowerCase()
        : (userGender ?? '').toLowerCase();

    final String listenerName = isSpeakerPlayer ? targetName : (userName ?? '');
    final bool isListenerMale = listenerGender.contains('laki') || listenerGender.contains('male') || (isSpeakerPlayer && targetRole == 'Suami');

    final List<String> listPanggilan = [
      'Sayang',
      'Sayangku',
      'Beb',
      'Baby',
      'Honey',
      'Cinta',
      'Cintaku',
      'Manisku',
      'Love',
      'Dear',
    ];

    if (isListenerMale) {
      listPanggilan.addAll([
        'Mas Sayang',
        'Abang Sayang',
        'Mas',
        'Abang',
        'Hubby',
        if (includeName && listenerName.isNotEmpty) 'Sayang $listenerName',
        if (includeName && listenerName.isNotEmpty) 'Mas $listenerName',
      ]);
    } else {
      listPanggilan.addAll([
        'Dek Sayang',
        'Cantikku',
        'Adek',
        'Dek',
        'Wife',
        'Cantik',
        if (includeName && listenerName.isNotEmpty) 'Sayang $listenerName',
        if (includeName && listenerName.isNotEmpty) 'Dek $listenerName',
      ]);
    }

    return listPanggilan[_random.nextInt(listPanggilan.length)];
  }

  /// Mendapatkan sebutan panggilan manja khusus untuk pacar/pasangan (selalu manja seperti Sayang, Baby, Beb, etc.)
  static String getPanggilanManja({
    String? targetGender,
    bool isTargetMale = false,
  }) {
    final bool isMale = isTargetMale || (targetGender != null && (targetGender.toLowerCase().contains('laki') || targetGender.toLowerCase().contains('male')));
    final List<String> manjaPool = [
      'Sayang',
      'Sayangku',
      'Beb',
      'Baby',
      'Honey',
      'Cinta',
      'Cintaku',
      'Manisku',
      'Love',
      'Dear',
      if (isMale) 'Mas Sayang',
      if (isMale) 'Abang Sayang',
      if (!isMale) 'Dek Sayang',
      if (!isMale) 'Cantikku',
    ];
    return manjaPool[_random.nextInt(manjaPool.length)];
  }
}

