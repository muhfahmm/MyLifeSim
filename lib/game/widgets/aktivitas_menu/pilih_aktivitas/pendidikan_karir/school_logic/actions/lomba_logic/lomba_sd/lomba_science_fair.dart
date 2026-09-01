// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_science_fair.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaScienceFairSD(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Proses tumbuhan hijau membuat makanan sendiri dengan bantuan sinar matahari disebut?',
      'options': ['Respirasi', 'Fotosintesis', 'Evaporasi', 'Kondensasi'],
      'correct': 1,
    },
    {
      'question': 'Planet terbesar di tata surya kita adalah?',
      'options': ['Mars', 'Bumi', 'Jupiter', 'Saturnus'],
      'correct': 2,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Science Fair Sederhana',
      category: 'Sains',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        character.intelligence = (character.intelligence + 8).clamp(0, 100);
        character.happiness = (character.happiness + 5).clamp(0, 100);

        showLombaOutcome(
          context,
          'Peneliti Cilik Berbakat! 🔬🏆',
          'Eksperimen sains sederhana buatanmu berhasil memukau dewan juri!\n\n'
          'Kecerdasan +8%\n'
          'Kebahagiaan +5%',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 3).clamp(0, 100);
        showLombaOutcome(
          context,
          'Pameran Sains 🔬',
          'Proyek sainsmu berjalan lancar dan menambah wawasan ilmiahmu!\n\n'
          'Kecerdasan +3%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
