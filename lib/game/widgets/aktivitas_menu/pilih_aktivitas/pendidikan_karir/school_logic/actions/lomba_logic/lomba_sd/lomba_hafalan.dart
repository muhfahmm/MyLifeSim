// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_hafalan.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaHafalanSD(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Surah apakah yang merupakan surah pertama dalam Al-Qur\'an?',
      'options': ['Al-Ikhlas', 'Al-Fatihah', 'An-Nas', 'Al-Falaq'],
      'correct': 1,
    },
    {
      'question': 'Dalam pembacaan puisi, penggunaan ekspresi wajah dan gerakan tubuh disebut?',
      'options': ['Intonasi', 'MIMIK & Gestur', 'Lafal', 'Rima'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Menghafal (Al-Qur\'an / Puisi)',
      category: 'Agama & Bahasa',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        character.discipline = (character.discipline + 10).clamp(0, 100);
        character.karma = (character.karma + 10).clamp(0, 100);

        showLombaOutcome(
          context,
          'Juara Hafalan & Deklamasi! 📖🏆',
          'Lafal dan daya ingatmu sangat presisi dan menginspirasi!\n\n'
          'Disiplin +10%\n'
          'Karma +10%',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.discipline = (character.discipline + 3).clamp(0, 100);
        showLombaOutcome(
          context,
          'Peserta Lomba Hafalan 📖',
          'Kamu berhasil tampil tenang dan menyelesaikan hafalanmu dengan baik!\n\n'
          'Disiplin +3%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
