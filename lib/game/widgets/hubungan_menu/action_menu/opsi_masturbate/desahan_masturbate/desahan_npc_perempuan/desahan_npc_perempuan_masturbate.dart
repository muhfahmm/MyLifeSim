// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/desahan_npc_perempuan/desahan_npc_perempuan_masturbate.dart

import 'dart:math';

enum NPCPerempuanPersonalityType { shy, bold, kind }

class DesahanNpcPerempuanMasturbate {
  static final Random _random = Random();

  static NPCPerempuanPersonalityType _getNPCPersonality(Map<String, dynamic> npc) {
    final String trait = (npc['personality'] ?? npc['trait'] ?? '').toString().toLowerCase();
    if (trait.contains('pemalu') || trait.contains('shy') || trait.contains('pendiam')) {
      return NPCPerempuanPersonalityType.shy;
    }
    if (trait.contains('ekstrovert') || trait.contains('bold') || trait.contains('gairah') || trait.contains('percaya diri')) {
      return NPCPerempuanPersonalityType.bold;
    }
    return NPCPerempuanPersonalityType.kind;
  }

  // ==========================================================
  // LIBRARY DESAHAN NPC PEREMPUAN MASTURBATE (PURE MOANS FROM DESAHAN WANITA)
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

  static final Map<NPCPerempuanPersonalityType, List<String>> _shuffledPools = {};

  static String getRandomMoan(Map<String, dynamic> npc) {
    final personality = _getNPCPersonality(npc);
    List<String>? currentDeck = _shuffledPools[personality];

    if (currentDeck == null || currentDeck.isEmpty) {
      List<String> sourcePool;
      switch (personality) {
        case NPCPerempuanPersonalityType.shy:
          sourcePool = _shyMoans;
          break;
        case NPCPerempuanPersonalityType.bold:
          sourcePool = _boldMoans;
          break;
        case NPCPerempuanPersonalityType.kind:
          sourcePool = _kindMoans;
          break;
      }
      currentDeck = List<String>.from(sourcePool)..shuffle(_random);
      _shuffledPools[personality] = currentDeck;
    }

    return currentDeck.removeLast();
  }
}
