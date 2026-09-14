// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/salon_spa/salon_spa_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'salon_spa_modal.dart';

class SalonSpaMenuHelper {
  static void showSalonSpaMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 15) {
      DialogHelper.show(
        context: context,
        title: 'Akses Dibatasi',
        content: const Text('Kamu harus berusia minimal 15 tahun untuk pergi ke salon & spa.'),
      );
      return;
    }

    DialogHelper.show(
      context: context,
      title: 'Salon & Spa 💅',
      isNotification: false,
      content: SalonSpaContent(
        character: character,
        onComplete: onComplete,
      ),
    );
  }
}
