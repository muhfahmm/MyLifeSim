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
        'Kamu sedang mengalami ${character.athleteInjuryType ?? "cedera"}! Kamu tidak dapat latihan sebelum sembuh.',
        Icons.warning_amber_rounded,
        Colors.red,
      );
      return;
    }

    character.athleteTrainingCountInTurn++;
    final int trainCount = character.athleteTrainingCountInTurn;

    double injuryChance = 0.0;
    if (trainCount >= 2) {
      injuryChance += (trainCount - 1) * 20.0;
    }
    if (character.health < 60) {
      injuryChance += (60 - character.health) * 1.0;
    }

    final bool isInjuredRoll = Random().nextDouble() * 100 < injuryChance;

    if (isInjuredRoll) {
      character.athleteIsInjured = true;
      character.athleteInjuryType = 'Cedera Otot / Sendi';
      character.health = (character.health - 20).clamp(0, 100);
      character.happiness = (character.happiness - 15).clamp(0, 100);
      onRefresh();

      showResult(
        'Terjadi Cedera Fisik! 🚑🔥',
        'Kamu mengalami cedera otot saat latihan berat (${character.athleteInjuryType})! Segera lakukan pemulihan!',
        Icons.healing,
        Colors.red,
      );
      return;
    }

    character.health = (character.health + 5).clamp(0, 100);
    character.discipline = (character.discipline + 3).clamp(0, 100);
    character.happiness = (character.happiness - 2).clamp(0, 100);
    onRefresh();

    showResult(
      'Latihan Fisik & Ketahanan 🏃‍♂️⚡',
      'Latihan fisik intensif bersama pelatih. Fisikmu semakin prima! (+5 Kesehatan, +3 Kedisiplinan)',
      Icons.fitness_center,
      Colors.orange,
    );
  }
}
