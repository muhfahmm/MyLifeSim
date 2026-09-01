// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_smp/lomba_debat_smp.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaDebatSMP(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Dalam debat formal, tim yang menyanggah mosi dinamakan?',
      'options': ['Tim Afirmatif (Pro)', 'Tim Oposisi (Kontra)', 'Tim Netral', 'Moderator'],
      'correct': 1,
    },
    {
      'question': 'Istilah untuk argumen utama yang dijadikan topik perdebatan dinamakan?',
      'options': ['Mosi', 'Notula', 'Sanggahan', 'Kesimpulan'],
      'correct': 0,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Debat & Retorika SMP',
      category: 'Bahasa & Logika',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        character.intelligence = (character.intelligence + 10).clamp(0, 100);
        character.appearance = (character.appearance + 8).clamp(0, 100);

        showLombaOutcome(
          context,
          'Best Speaker Debat SMP! 🗣️🏆',
          'Kemampuan public speaking dan argumen logismu berhasil mematahkan tim lawan!\n\n'
          'Kecerdasan +10%\n'
          'Penampilan (Public Speaking) +8%',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Peserta Debat SMP 🗣️',
          'Sesi debat berlangsung sengit dan memperluas wawasan berpikir kritismu!\n\n'
          'Kecerdasan +4%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
