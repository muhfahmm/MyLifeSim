// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/basket/action_menu/sosial_media_fans/press_conference_basket_action.dart

import 'package:flutter/material.dart';

import 'package:mylifesim/pilih_karakter/character.dart';

class PressConferenceBasketAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    character.popularity = (character.popularity + 4).clamp(0, 100);
    character.publicTrust = (character.publicTrust + 3).clamp(0, 100);
    onRefresh();

    showResult(
      'Konferensi Pers Basket 🎙️',
      'Kamu menjawab pertanyaan wartawan olahraga tentang target juara tim basket musim ini secara bijak. Popularitas dan Kepercayaan Publik meningkat!',
      Icons.mic,
      Colors.lightBlue,
    );
  }
}
