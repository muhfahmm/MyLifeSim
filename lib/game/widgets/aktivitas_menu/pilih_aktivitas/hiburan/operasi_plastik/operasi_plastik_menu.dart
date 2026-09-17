// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/operasi_plastik/operasi_plastik_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'operasi_plastik_modal.dart';

class OperasiPlastikMenuHelper {
  static void showOperasiPlastikMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      DialogHelper.show(
        context: context,
        title: 'Akses Dibatasi',
        content: const Text('Kamu harus berusia minimal 18 tahun untuk operasi plastik.'),
      );
      return;
    }

    DialogHelper.show(
      context: context,
      title: 'Operasi Plastik 🏥',
      headerColor: Colors.cyan.shade800,
      isNotification: false,
      content: OperasiPlastikContent(
        character: character,
        onComplete: onComplete,
      ),
    );
  }
}
