// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/basket/action_menu/kontrak_manajemen/consult_agent_basket_action.dart

import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import '../../tim_tertarik_basket_modal.dart';

class ConsultAgentBasketAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
  }) {
    TimTertarikBasketModal.show(
      context: context,
      character: character,
      onDone: onRefresh,
    );
  }
}
