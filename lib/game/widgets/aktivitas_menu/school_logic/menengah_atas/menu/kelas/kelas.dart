// lib/game/widgets/aktivitas_menu/school_logic/menengah_atas/menu/kelas/kelas.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/school_logic/classmate_helper.dart';

class KelasMenu {
  static void showMenu(BuildContext context, Character character, VoidCallback onRefresh) {
    ClassmateHelper.showClassmatesDialog(
      context: context,
      character: character,
      title: '📖 Ruang Kelas (SMA)',
      onRefresh: onRefresh,
    );
  }
}
