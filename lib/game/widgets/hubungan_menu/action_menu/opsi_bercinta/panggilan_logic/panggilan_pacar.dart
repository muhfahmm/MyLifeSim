// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_pacar.dart

import 'dart:math';

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
  }) {
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
