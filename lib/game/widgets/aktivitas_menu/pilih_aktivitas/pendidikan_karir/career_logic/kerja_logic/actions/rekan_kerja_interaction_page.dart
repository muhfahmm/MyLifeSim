// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/actions/rekan_kerja_interaction_page.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/action_menu.dart';

class RekanKerjaInteractionPage extends StatelessWidget {
  final Map<String, String> coworker;
  final Character character;
  final VoidCallback onRefresh;

  const RekanKerjaInteractionPage({
    super.key,
    required this.coworker,
    required this.character,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final String name = coworker['name'] ?? 'Rekan Kerja';
    final String roleTag = coworker['role'] ?? 'Rekan Kerja';

    return ActionMenuScreen(
      character: character,
      targetName: name,
      targetRole: roleTag,
    );
  }
}

