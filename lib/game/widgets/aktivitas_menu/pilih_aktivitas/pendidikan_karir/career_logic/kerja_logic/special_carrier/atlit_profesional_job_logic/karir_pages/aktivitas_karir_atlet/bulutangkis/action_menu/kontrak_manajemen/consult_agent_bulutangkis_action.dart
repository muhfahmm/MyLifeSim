import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../../tim_tertarik_bulutangkis_modal.dart';

class ConsultAgentBulutangkisAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
  }) {
    TimTertarikBulutangkisModal.show(
      context: context,
      character: character,
      onDone: onRefresh,
    );
  }
}
