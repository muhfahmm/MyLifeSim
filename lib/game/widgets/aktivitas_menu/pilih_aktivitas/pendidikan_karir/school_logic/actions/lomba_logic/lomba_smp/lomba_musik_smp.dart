// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_smp/lomba_musik_smp.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaMusikSMP(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Alat musik gesek yang memiliki ukuran paling kecil dan nada paling tinggi adalah?',
      'options': ['Cello', 'Biola (Violin)', 'Kontrabas', 'Viola'],
      'correct': 1,
    },
    {
      'question': 'Istilah untuk tempo musik yang lambat dan tenang dinamakan?',
      'options': ['Allegro', 'Adagio', 'Presto', 'Vivace'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Band / Musik Akustik SMP',
      category: 'Seni & Musik',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 75 + Random().nextInt(126); // $75-$200
        character.happiness = (character.happiness + 12).clamp(0, 100);
        character.appearance = (character.appearance + 8).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara Festival Musik! 🎸🏆',
          'Harmoni dan aransemen band-mu mempesona para juri dan penonton!\n\n'
          'Kebahagiaan +12%\n'
          'Penampilan +8%\n'
          'Hadiah Uang: \$$rewardMoney + Rekaman Demo Studio',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.happiness = (character.happiness + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Festival Musik SMP 🎸',
          'Penampilan panggungmu enerjik dan disambut hangat penonton!\n\n'
          'Kebahagiaan +4%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
