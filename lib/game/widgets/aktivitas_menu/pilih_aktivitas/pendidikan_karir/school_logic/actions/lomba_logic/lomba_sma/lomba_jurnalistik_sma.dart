// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sma/lomba_jurnalistik_sma.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaJurnalistikSMA(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Prinsip utama dalam penulisan berita jurnalistik yang mencakup informasi dasar adalah?',
      'options': ['5W + 1H', '3R + 1D', '4P + 1M', '2T + 1C'],
      'correct': 0,
    },
    {
      'question': 'Jenis tulisan jurnalistik yang mendalam, naratif, dan humanis dinamakan?',
      'options': ['Straight News', 'Feature News', 'Editorial', 'Opini'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Menulis Jurnalistik / Feature',
      category: 'Media',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 150 + Random().nextInt(251); // $150-$400
        character.intelligence = (character.intelligence + 10).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Jurnalis Muda Berbakat! 📰🏆',
          'Artikel feature investigasimu memenangkan piala jurnalistik pelajar nasional!\n\n'
          'Kecerdasan +10%\n'
          'Hadiah Uang: \$$rewardMoney + Kesempatan Magang Media',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Lomba Jurnalistik Pelajar 📰',
          'Hasil reportasemu menarik perhatian dan mempertajam analisis jurnalistikmu!\n\n'
          'Kecerdasan +4%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
