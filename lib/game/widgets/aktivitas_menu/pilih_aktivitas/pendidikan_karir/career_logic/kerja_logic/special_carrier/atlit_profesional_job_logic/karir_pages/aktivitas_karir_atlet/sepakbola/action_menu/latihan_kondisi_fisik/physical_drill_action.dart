import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';

class PhysicalDrillAction {
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

    // Peluang cedera fisik intensif (lebih tinggi)
    double injuryChance = 0.0;
    if (trainCount >= 2) {
      injuryChance += (trainCount - 1) * 20.0; // Latihan ke-2: 20%, ke-3: 40%, dst
    }
    if (character.health < 60) {
      injuryChance += (60 - character.health) * 1.0;
    }

    final bool isInjuredRoll = Random().nextDouble() * 100 < injuryChance;

    if (isInjuredRoll) {
      character.athleteIsInjured = true;
      character.athleteInjuryType = 'Cedera Hamstring / Rotator Cuff';
      character.health = (character.health - 20).clamp(0, 100);
      character.happiness = (character.happiness - 15).clamp(0, 100);
      onRefresh();

      showResult(
        'Terjadi Cedera Fisik Parah! 🚑🔥',
        'Otot hamstring milikmu tertarik keras saat latihan sprint (${character.athleteInjuryType})! Segera lakukan Pemulihan atau Fisioterapi!',
        Icons.healing,
        Colors.red,
      );
      return;
    }

    character.health = (character.health + 5).clamp(0, 100);
    character.discipline = (character.discipline + 3).clamp(0, 100);
    character.happiness = (character.happiness - 2).clamp(0, 100);
    onRefresh();

    final String warningMsg = trainCount >= 2
        ? '\n\n⚠️ Peringatan: Kamu sudah berlatih fisik $trainCount kali berturut-turut! Risiko cedera fisik membesar!'
        : '';

    showResult(
      'Latihan Sprint & Ketahanan 🏃‍♂️⚡',
      'Latihan fisik intensif bersama pelatih kebugaran. Fisikmu makin prima dan cepat! (+5 Kesehatan, +3 Kedisiplinan).$warningMsg',
      Icons.fitness_center,
      Colors.orange,
    );
  }
}
