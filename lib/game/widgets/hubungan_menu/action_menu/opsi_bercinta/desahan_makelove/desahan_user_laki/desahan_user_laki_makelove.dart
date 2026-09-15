// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_user_laki/desahan_user_laki_makelove.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class DesahanUserLakiMakeLove {
  static final Random _random = Random();

  // ==========================================================
  // LIBRARY DESAHAN USER LAKI-LAKI (PURE MOANS FROM DESAHAN PRIA)
  // ==========================================================
  static const List<String> _shyMoans = [
    // Awal masuk / baru nembus
    "Ahh... enak...",
    "Ngh... sempit banget...",
    "Ahh... pelan dulu...",
    "Ngh... ahh...",
    // Saat mulai digoyang
    "Ahh... ahh... enak...",
    "Ngh... ahh... dalam...",
    "Ahh... basah banget...",
    "Ngh... ahh... ahh...",
    // Tempo naik
    "Ahhh... enak banget...",
    "Ngh... ahh... ahh...!",
    "Ahhh... lebih kencang...",
    "Ngh... ahh... ahh... ahh...",
    // Semakin kencang / hampir klimaks
    "Ahhh... mau keluar...",
    "Ngh... ahh... ahh...! Enak...!",
    "Ahhh... terus... ahhh!",
    "Ngh... ahh... ahh... mau crot...!",
    // Saat klimaks
    "Ahhh... keluar... ahhh!",
    "Ngh... ahh... ahh...! Isi...!",
    "Ahhhh... enak... ahhh!",
    "Ngh... ahh... ahh...!",
    // Setelah klimaks
    "Ahh... hangat...",
    "Ngh... masih ketat...",
    "Ahh... enak banget...",
    "Ngh... ahh...",
  ];

  static const List<String> _boldMoans = [
    "Ahh... enak...",
    "Ngh... sempit banget...",
    "Ahh... pelan dulu...",
    "Ngh... ahh...",
    "Ahh... ahh... enak...",
    "Ngh... ahh... dalam...",
    "Ahh... basah banget...",
    "Ngh... ahh... ahh...",
    "Ahhh... enak banget...",
    "Ngh... ahh... ahh...!",
    "Ahhh... lebih kencang...",
    "Ngh... ahh... ahh... ahh...",
    "Ahhh... mau keluar...",
    "Ngh... ahh... ahh...! Enak...!",
    "Ahhh... terus... ahhh!",
    "Ngh... ahh... ahh... mau crot...!",
    "Ahhh... keluar... ahhh!",
    "Ngh... ahh... ahh...! Isi...!",
    "Ahhhh... enak... ahhh!",
    "Ngh... ahh... ahh...!",
    "Ahh... hangat...",
    "Ngh... masih ketat...",
    "Ahh... enak banget...",
    "Ngh... ahh...",
  ];

  static const List<String> _kindMoans = [
    "Ahh... enak...",
    "Ngh... sempit banget...",
    "Ahh... pelan dulu...",
    "Ngh... ahh...",
    "Ahh... ahh... enak...",
    "Ngh... ahh... dalam...",
    "Ahh... basah banget...",
    "Ngh... ahh... ahh...",
    "Ahhh... enak banget...",
    "Ngh... ahh... ahh...!",
    "Ahhh... lebih kencang...",
    "Ngh... ahh... ahh... ahh...",
    "Ahhh... mau keluar...",
    "Ngh... ahh... ahh...! Enak...!",
    "Ahhh... terus... ahhh!",
    "Ngh... ahh... ahh... mau crot...!",
    "Ahhh... keluar... ahhh!",
    "Ngh... ahh... ahh...! Isi...!",
    "Ahhhh... enak... ahhh!",
    "Ngh... ahh... ahh...!",
    "Ahh... hangat...",
    "Ngh... masih ketat...",
    "Ahh... enak banget...",
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
