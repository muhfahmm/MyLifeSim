import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../../tim_tertarik_tinju_mma_modal.dart';

class ConsultAgentTinjuMMAAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
  }) {
    TimTertarikTinjuMMAModal.show(
      context: context,
      character: character,
      onDone: onRefresh,
    );
  }
}
