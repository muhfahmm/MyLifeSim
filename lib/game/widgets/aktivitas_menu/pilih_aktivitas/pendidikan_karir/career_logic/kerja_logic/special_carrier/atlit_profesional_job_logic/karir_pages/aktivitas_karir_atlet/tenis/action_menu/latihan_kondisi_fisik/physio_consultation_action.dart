import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PhysioConsultationAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (!character.athleteIsInjured) {
      showResult(
        'Kondisi Sehat 👨‍⚕️',
        'Kamu dalam kondisi sehat dan tidak membutuhkan penanganan cedera.',
        Icons.health_and_safety,
        Colors.blue,
      );
      return;
    }

    character.athleteIsInjured = false;
    character.athleteInjuryType = null;
    character.health = (character.health + 25).clamp(0, 100);
    onRefresh();

    showResult(
      'Fisioterapi Berhasil! 🏥',
      'Sesi penanganan fisioterapi profesional berhasil menyembuhkan cederamu! (+25 Kesehatan)',
      Icons.medical_services,
      Colors.green,
    );
  }
}
