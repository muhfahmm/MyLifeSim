// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_matematika.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaMatematikaSD(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Berapakah hasil dari 25 + 37?',
      'options': ['52', '62', '64', '58'],
      'correct': 1,
    },
    {
      'question': 'Berapakah hasil dari 12 x 8?',
      'options': ['84', '96', '98', '108'],
      'correct': 1,
    },
    {
      'question': 'Berapakah sisa pembagian 15 dibagi 4?',
      'options': ['1', '2', '3', '0'],
      'correct': 2,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Matematika & Berhitung Cepat',
      category: 'Akademik',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        character.intelligence = (character.intelligence + 10).clamp(0, 100);
        character.willpower = (character.willpower + 8).clamp(0, 100);

        showLombaOutcome(
          context,
          'Juara Berhitung Cepat! 🧮🏆',
          'Kecepatan dan ketepatan berhitungmu membuat juri takjub!\n\n'
          'Kecerdasan +10%\n'
          'Tekad +8%',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 3).clamp(0, 100);
        showLombaOutcome(
          context,
          'Kompetisi Berhitung 🧮',
          'Kamu melakukan sedikit kesalahan berhitung di babak final, namun asah otak ini mengasah kecerdasanmu!\n\n'
          'Kecerdasan +3%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
