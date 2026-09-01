// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_menyanyi.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaMenyanyiSD(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Lagu anak-anak "Balonku Ada Lima", balon warna apa yang meletus?',
      'options': ['Merah', 'Hijau', 'Kuning', 'Biru'],
      'correct': 1,
    },
    {
      'question': 'Tangga nada diatonis dimulai dari nada apa?',
      'options': ['Do', 'Re', 'Mi', 'Fa'],
      'correct': 0,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Menyanyi Solo / Paduan Suara',
      category: 'Musik',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        character.happiness = (character.happiness + 12).clamp(0, 100);
        character.appearance = (character.appearance + 6).clamp(0, 100);

        showLombaOutcome(
          context,
          'Penampilan Terbaik! 🎵🎤',
          'Suara merdumu membuat seluruh penonton bersorak! Kamu membawa pulang piala!\n\n'
          'Kebahagiaan +12%\n'
          'Penampilan +6%',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.happiness = (character.happiness + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Pengalaman Pentas 🎤',
          'Suaramu terdengar indah di atas panggung meskipun belum berhasil menjadi juara 1!\n\n'
          'Kebahagiaan +4%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
