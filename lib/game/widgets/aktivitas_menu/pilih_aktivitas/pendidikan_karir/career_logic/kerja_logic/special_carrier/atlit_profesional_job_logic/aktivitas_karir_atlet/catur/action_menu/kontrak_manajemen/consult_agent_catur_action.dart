import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../../tim_tertarik_catur_modal.dart';

class ConsultAgentCaturAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
  }) {
    TimTertarikCaturModal.show(
      context: context,
      character: character,
      onDone: onRefresh,
    );
  }
}
