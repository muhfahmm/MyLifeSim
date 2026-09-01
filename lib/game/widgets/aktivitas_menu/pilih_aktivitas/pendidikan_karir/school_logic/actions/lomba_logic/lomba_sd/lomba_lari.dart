// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_lari.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaLariSD(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Dalam lomba lari estafet, tongkat diserahkan dari pelari ke pelari berikutnya di zona apa?',
      'options': ['Zona pergantian (Wissel)', 'Zona penalti', 'Garis start', 'Luar lintasan'],
      'correct': 0,
    },
    {
      'question': 'Start yang digunakan untuk lari jarak pendek adalah?',
      'options': ['Start melayang', 'Start jongkok', 'Start berdiri', 'Start duduk'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Lari / Estafet / Olahraga Dasar',
      category: 'Fisik',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        character.health = (character.health + 10).clamp(0, 100);
        character.willpower = (character.willpower + 8).clamp(0, 100);

        showLombaOutcome(
          context,
          'Pelari Tercepat! 🏃‍♂️🏆',
          'Lari kencangmu tak terkejar lawan hingga menyentuh garis finis pertama!\n\n'
          'Kesehatan +10%\n'
          'Tekad +8%',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.health = (character.health + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Lomba Olahraga 🏃‍♂️',
          'Kamu sudah memberikan kemampuan terbaikmu dan menambah stamina fisikmu!\n\n'
          'Kesehatan +4%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
