// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/desahan_makelove/desahan_npc_laki/desahan_npc_laki_makelove.dart

import 'dart:math';

enum NPCLakiPersonalityType { shy, bold, kind }

class DesahanNpcLakiMakeLove {
  static final Random _random = Random();

  static NPCLakiPersonalityType _getNPCPersonality(Map<String, dynamic> npc) {
    final String trait = (npc['personality'] ?? npc['trait'] ?? '').toString().toLowerCase();
    if (trait.contains('pemalu') || trait.contains('shy') || trait.contains('pendiam')) {
      return NPCLakiPersonalityType.shy;
    }
    if (trait.contains('ekstrovert') || trait.contains('bold') || trait.contains('gairah') || trait.contains('percaya diri')) {
      return NPCLakiPersonalityType.bold;
    }
    return NPCLakiPersonalityType.kind;
  }

  // ==========================================================
  // LIBRARY DESAHAN NPC LAKI (PURE MOANS FROM DESAHAN PRIA)
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

  static String getRandomMoan(Map<String, dynamic> npc) {
    final personality = _getNPCPersonality(npc);
    List<String> pool;
    switch (personality) {
      case NPCLakiPersonalityType.shy:
        pool = _shyMoans;
        break;
      case NPCLakiPersonalityType.bold:
        pool = _boldMoans;
        break;
      case NPCLakiPersonalityType.kind:
        pool = _kindMoans;
        break;
    }
    return pool[_random.nextInt(pool.length)];
  }
}
