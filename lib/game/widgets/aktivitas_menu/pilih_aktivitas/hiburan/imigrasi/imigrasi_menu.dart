// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/imigrasi_menu.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/imigrasi/pindah_negara_menu.dart';

class ImigrasimMenuHelper {
  static void showImigrasimMenu(BuildContext context, Character character, VoidCallback onComplete) {
    if (character.age < 18) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Akses Dibatasi'),
          content: const Text('Kamu harus berusia minimal 18 tahun untuk berimigrasi.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PindahNegaraMenuPage(
          character: character,
          onComplete: onComplete,
        ),
      ),
    );
  }
}
