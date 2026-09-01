// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_smp/lomba_pramuka_smp.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaPramukaSMP(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Sandi dalam Pramuka yang menggunakan sistem bendera merah-kuning dinamakan?',
      'options': ['Sandi Morse', 'Sandi Semaphore', 'Sandi Rumput', 'Sandi Kotak'],
      'correct': 1,
    },
    {
      'question': 'Simpul yang digunakan untuk mengikat tali pada tiang dinamakan?',
      'options': ['Simpul Mati', 'Simpul Pangkal', 'Simpul Jangkar', 'Simpul Erat'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Jambore Pramuka / Scouts Competition',
      category: 'Outdoor',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        character.discipline = (character.discipline + 12).clamp(0, 100);
        character.health = (character.health + 8).clamp(0, 100);
        character.willpower = (character.willpower + 8).clamp(0, 100);

        showLombaOutcome(
          context,
          'Regu Terbaik Jambore! ⛺🏆',
          'Ketangkasan pionering dan kekompakan regumu menyabet gelar Regu Utama!\n\n'
          'Disiplin +12%\n'
          'Kesehatan +8%\n'
          'Tekad +8%',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.discipline = (character.discipline + 4).clamp(0, 100);
        character.health = (character.health + 3).clamp(0, 100);
        showLombaOutcome(
          context,
          'Perkemahan Pramuka ⛺',
          'Pengalaman survival outdoor melatih kedisiplinan dan kemandirianmu!\n\n'
          'Disiplin +4%\n'
          'Kesehatan +3%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
