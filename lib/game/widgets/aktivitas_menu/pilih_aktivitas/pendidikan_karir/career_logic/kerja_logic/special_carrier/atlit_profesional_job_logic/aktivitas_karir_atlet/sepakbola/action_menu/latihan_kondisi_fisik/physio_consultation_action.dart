import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PhysioConsultationAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.money < 200) {
      showResult('Uang Tidak Cukup 💵', 'Kamu butuh \$200 untuk konsultasi fisioterapis pribadi.', Icons.warning, Colors.red);
      return;
    }

    final bool wasInjured = character.athleteIsInjured;
    character.money -= 200;
    character.athleteIsInjured = false;
    character.athleteInjuryType = null;
    character.athleteTrainingCountInTurn = 0; // Reset kelelahan latihan
    character.health = (character.health + 15).clamp(0, 100);
    onRefresh();

    if (wasInjured) {
      showResult(
        'Fisioterapi Berhasil! 🩺✨',
        'Fisioterapis profesional merawat cederamu hingga sembuh total! Ototmu kini bebas cedera (- \$200, +15 Kesehatan).',
        Icons.medical_services,
        Colors.blue,
      );
    } else {
      showResult(
        'Sesi Fisioterapi 🩺✨',
        'Fisioterapis memeriksa persendian dan merawat otot kaki. Ototmu bebas dari ketegangan cedera! (- \$200, +15 Kesehatan).',
        Icons.medical_services,
        Colors.blue,
      );
    }
  }
}
