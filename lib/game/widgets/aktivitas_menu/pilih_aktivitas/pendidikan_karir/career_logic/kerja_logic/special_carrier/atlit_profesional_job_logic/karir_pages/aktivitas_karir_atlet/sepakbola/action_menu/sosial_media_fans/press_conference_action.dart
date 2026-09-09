// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/action_menu/sosial_media_fans/press_conference_action.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'press_conference_logic/press_conference_models.dart';
import 'press_conference_logic/press_conference_events.dart';
import 'press_conference_logic/press_conference_dialog.dart';

class PressConferenceAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    final events = PressConferenceEvents.getAllEvents();
    final Random random = Random();

    // Pilih event konferensi pers secara acak / dinamis
    final PressEvent chosenEvent = events[random.nextInt(events.length)];

    PressConferenceDialog.show(
      context: context,
      character: character,
      pressEvent: chosenEvent,
      onDone: onRefresh,
    );
  }
}
