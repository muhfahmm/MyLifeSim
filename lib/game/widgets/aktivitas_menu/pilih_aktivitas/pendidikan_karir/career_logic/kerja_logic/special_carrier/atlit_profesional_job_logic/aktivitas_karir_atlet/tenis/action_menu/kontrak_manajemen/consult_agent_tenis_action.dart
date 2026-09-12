import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../../tim_tertarik_tenis_modal.dart';

class ConsultAgentTenisAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
  }) {
    TimTertarikTenisModal.show(
      context: context,
      character: character,
      onDone: onRefresh,
    );
  }
}
