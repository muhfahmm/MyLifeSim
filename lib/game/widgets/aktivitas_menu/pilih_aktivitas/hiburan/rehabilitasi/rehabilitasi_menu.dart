// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/rehabilitasi/rehabilitasi_menu.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'rehabilitasi_modal.dart';

class RehabilitasiMenuHelper {
  static void showRehabilitasiMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      DialogHelper.show(
        context: context,
        title: 'Akses Dibatasi',
        content: const Text('Kamu harus berusia minimal 18 tahun untuk program rehabilitasi.'),
      );
      return;
    }

    DialogHelper.show(
      context: context,
      title: 'Program Rehabilitasi 💚',
      headerColor: Colors.purple.shade700,
      isNotification: false,
      content: RehabilitasiContent(
        character: character,
        onComplete: onComplete,
      ),
    );
  }
}
