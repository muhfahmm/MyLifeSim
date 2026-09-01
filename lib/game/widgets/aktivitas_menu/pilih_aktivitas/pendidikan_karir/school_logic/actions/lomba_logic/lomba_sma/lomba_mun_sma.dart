// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sma/lomba_mun_sma.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaMunSMA(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Dokumen resmi yang berisi rekomendasi solusi isu internasional dalam persidangan MUN disebut?',
      'options': ['Position Paper', 'Draft Resolution', 'Working Paper', 'Press Release'],
      'correct': 1,
    },
    {
      'question': 'Badan utama PBB yang bertanggung jawab menjaga perdamaian dan keamanan internasional adalah?',
      'options': ['General Assembly (Majelis Umum)', 'Security Council (Dewan Keamanan)', 'UNESCO', 'UNICEF'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Model United Nations (MUN) / Debat Nasional',
      category: 'Sosial & Diplomasi',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 300 + Random().nextInt(501); // $300-$800
        character.intelligence = (character.intelligence + 15).clamp(0, 100);
        character.appearance = (character.appearance + 15).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Best Delegate MUN! 🌐🏆',
          'Pidato dan negosiasi diplomatikmu memenangi penghargaan Best Delegate!\n\n'
          'Kecerdasan ++ (+15%)\n'
          'Penampilan ++ (+15%)\n'
          'Hadiah Uang: \$$rewardMoney + Peluang Karier Diplomat/Pengacara',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 5).clamp(0, 100);
        character.appearance = (character.appearance + 5).clamp(0, 100);
        showLombaOutcome(
          context,
          'Honorable Mention MUN 🌐',
          'Debat negosiasi tingkat tinggi ini memperkuat wawasan politik internasionalmu!\n\n'
          'Kecerdasan +5%\n'
          'Penampilan +5%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
