// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/pikiran_tubuh/pikiran_tubuh_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'pikiran_tubuh_modal.dart';

class PikiranTubuhMenuHelper {
  static void showPikiranTubuhMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 12) {
      DialogHelper.show(
        context: context,
        title: 'Akses Dibatasi',
        content: const Text('Kamu harus berusia minimal 12 tahun untuk melakukan latihan pikiran dan tubuh.'),
      );
      return;
    }

    DialogHelper.show(
      context: context,
      title: 'Pikiran & Tubuh 🧘',
      headerColor: Colors.indigo.shade700,
      isNotification: false,
      content: PikiranTubuhContent(
        character: character,
        onComplete: onComplete,
      ),
    );
  }
}
