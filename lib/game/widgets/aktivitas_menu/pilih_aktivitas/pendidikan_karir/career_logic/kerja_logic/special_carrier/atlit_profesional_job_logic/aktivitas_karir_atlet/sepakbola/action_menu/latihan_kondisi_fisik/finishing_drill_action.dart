import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class FinishingDrillAction {
  static void execute({
    required BuildContext context,
    required Character character,
    required VoidCallback onRefresh,
    required Function(String title, String message, IconData icon, Color color) showResult,
  }) {
    if (character.athleteIsInjured) {
      showResult(
        'Sedang Cedera 🚑',
        'Kamu sedang mengalami ${character.athleteInjuryType ?? "cedera"}! Kamu tidak dapat melakukan latihan sebelum sembuh melalui Istirahat atau Fisioterapi.',
        Icons.warning_amber_rounded,
        Colors.red,
      );
      return;
    }

    character.athleteTrainingCountInTurn++;
    final int trainCount = character.athleteTrainingCountInTurn;

    // Peluang cedera meningkat seiring frekuensi latihan (mulai latihan ke-3 dst)
    // Kesehatan rendah juga meningkatkan peluang cedera
    double injuryChance = 0.0;
    if (trainCount >= 3) {
      injuryChance += (trainCount - 2) * 15.0; // Latihan ke-3: 15%, ke-4: 30%, dst
    }
    if (character.health < 50) {
      injuryChance += (50 - character.health) * 0.8;
    }

    final bool isInjuredRoll = Random().nextDouble() * 100 < injuryChance;

    if (isInjuredRoll) {
      character.athleteIsInjured = true;
      character.athleteInjuryType = 'Kram Otot / Sprain Ankle';
      character.health = (character.health - 15).clamp(0, 100);
      character.happiness = (character.happiness - 10).clamp(0, 100);
      onRefresh();

      showResult(
        'Terjadi Cedera Saat Latihan! 🚑⚡',
        'Kamu berlatih terlalu keras hingga mengalami ${character.athleteInjuryType}! Kesehatanmu menurun drastis. Segera lakukan Pemulihan atau Fisioterapi!',
        Icons.healing,
        Colors.red,
      );
      return;
    }

    character.discipline = (character.discipline + 4).clamp(0, 100);
    character.health = (character.health + 2).clamp(0, 100);
    onRefresh();

    final String warningMsg = trainCount >= 3
        ? '\n\n⚠️ Peringatan: Kamu sudah berlatih $trainCount kali berturut-turut! Risiko cedera meningkat!'
        : '';

    showResult(
      'Latihan Finishing & Tembakan ⚽🎯',
      'Kamu menghabiskan 2 jam melatih penyelesaian akhir, volley, dan tendangan penalti. Akurasi tembakanmu meningkat! (+4 Kedisiplinan, +2 Kesehatan).$warningMsg',
      Icons.sports_soccer,
      Colors.green,
    );
  }
}
