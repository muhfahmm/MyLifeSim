// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sma/lomba_osn_sma.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaOsnSMA(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Turunan pertama dari fungsi f(x) = 3x^2 + 5x - 7 adalah?',
      'options': ['6x + 5', '3x + 5', '6x - 7', '6x^2 + 5'],
      'correct': 0,
    },
    {
      'question': 'Hukum Termodinamika manakah yang menyatakan konsep Entropi alam semesta selalu meningkat?',
      'options': ['Hukum ke-0', 'Hukum ke-1', 'Hukum ke-2', 'Hukum ke-3'],
      'correct': 2,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Olimpiade Sains Tingkat Nasional/Internasional',
      category: 'Akademik',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 1000 + Random().nextInt(1001); // $1000-$2000
        character.intelligence = (character.intelligence + 20).clamp(0, 100);
        character.willpower = (character.willpower + 15).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Medali Emas Olimpiade Internasional! 🥇🏆',
          'Pencapaian sains tingkat dunia! Kamu mendapat beasiswa kuliah internasional penuh dan hadiah besar!\n\n'
          'Kecerdasan +++ (+20%)\n'
          'Tekad ++ (+15%)\n'
          'Hadiah Uang: \$$rewardMoney + Beasiswa Kuliah',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 6).clamp(0, 100);
        showLombaOutcome(
          context,
          'Finalis Olimpiade Sains 🧪',
          'Soal-soal tingkat olimpico sangat kompleks, namun analisis ilmumu meningkat drastis!\n\n'
          'Kecerdasan +6%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
