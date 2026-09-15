// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_user_perempuan/desahan_user_perempuan_makelove.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class DesahanUserPerempuanMakeLove {
  static final Random _random = Random();

  // ==========================================================
  // LIBRARY DESAHAN USER PEREMPUAN (PURE MOANS FROM DESAHAN WANITA)
  // ==========================================================
  static const List<String> _shyMoans = [
    // Awal masuk / baru nembus
    "Ahh...",
    "Ngh... pelan...",
    "Aahh... dalam...",
    "Ngh... ahh...",
    // Saat mulai digoyang
    "Ahh... ahh...",
    "Ngh... ahh... enak...",
    "Aahh... lebih dalam...",
    "Ahh... ahh... ahh...",
    // Tempo naik
    "Ahhh... enak...",
    "Ngh... ahh... ahh...!",
    "Aahh... terus...",
    "Ahhh... ahhh...",
    // Semakin kencang / hampir klimaks
    "Ahhh... mau keluar...",
    "Ngh... ahh... ahh...!",
    "Ahhhh... tidak kuat...",
    "Ahh... ahh... ahh...!",
    // Saat klimaks
    "Ahhh... keluar... ahhh!",
    "Ngh... ahh... ahh...!",
    "Ahhhh... ahhh...!",
    "Ngh... ahh... ahh...!",
    // Setelah klimaks
    "Ahh... masih...",
    "Ngh... ahh...",
    "Aahh... enak...",
    "Ngh... ahh...",
  ];

  static const List<String> _boldMoans = [
    "Ahh...",
    "Ngh... pelan...",
    "Aahh... dalam...",
    "Ngh... ahh...",
    "Ahh... ahh...",
    "Ngh... ahh... enak...",
    "Aahh... lebih dalam...",
    "Ahh... ahh... ahh...",
    "Ahhh... enak...",
    "Ngh... ahh... ahh...!",
    "Aahh... terus...",
    "Ahhh... ahhh...",
    "Ahhh... mau keluar...",
    "Ngh... ahh... ahh...!",
    "Ahhhh... tidak kuat...",
    "Ahh... ahh... ahh...!",
    "Ahhh... keluar... ahhh!",
    "Ngh... ahh... ahh...!",
    "Ahhhh... ahhh...!",
    "Ngh... ahh... ahh...!",
    "Ahh... masih...",
    "Ngh... ahh...",
    "Aahh... enak...",
    "Ngh... ahh...",
  ];

  static const List<String> _kindMoans = [
    "Ahh...",
    "Ngh... pelan...",
    "Aahh... dalam...",
    "Ngh... ahh...",
    "Ahh... ahh...",
    "Ngh... ahh... enak...",
    "Aahh... lebih dalam...",
    "Ahh... ahh... ahh...",
    "Ahhh... enak...",
    "Ngh... ahh... ahh...!",
    "Aahh... terus...",
    "Ahhh... ahhh...",
    "Ahhh... mau keluar...",
    "Ngh... ahh... ahh...!",
    "Ahhhh... tidak kuat...",
    "Ahh... ahh... ahh...!",
    "Ahhh... keluar... ahhh!",
    "Ngh... ahh... ahh...!",
    "Ahhhh... ahhh...!",
    "Ngh... ahh... ahh...!",
    "Ahh... masih...",
    "Ngh... ahh...",
    "Aahh... enak...",
    "Ngh... ahh...",
  ];

  static final Map<String, List<String>> _shuffledPools = {};

  static String getRandomMoan([dynamic player]) {
    String trait = '';
    if (player is Character) {
      trait = player.traits.join(' ').toLowerCase();
    } else if (player is Map<String, dynamic>) {
      trait = (player['personality'] ?? player['trait'] ?? '').toString().toLowerCase();
    }

    String poolKey = 'kind';
    if (trait.contains('pemalu') || trait.contains('shy') || trait.contains('pendiam')) {
      poolKey = 'shy';
    } else if (trait.contains('ekstrovert') || trait.contains('bold') || trait.contains('gairah') || trait.contains('percaya diri')) {
      poolKey = 'bold';
    }

    List<String>? currentDeck = _shuffledPools[poolKey];
    if (currentDeck == null || currentDeck.isEmpty) {
      List<String> sourcePool;
      switch (poolKey) {
        case 'shy':
          sourcePool = _shyMoans;
          break;
        case 'bold':
          sourcePool = _boldMoans;
          break;
        default:
          sourcePool = _kindMoans;
          break;
      }
      currentDeck = List<String>.from(sourcePool)..shuffle(_random);
      _shuffledPools[poolKey] = currentDeck;
    }

    return currentDeck.removeLast();
  }
}
