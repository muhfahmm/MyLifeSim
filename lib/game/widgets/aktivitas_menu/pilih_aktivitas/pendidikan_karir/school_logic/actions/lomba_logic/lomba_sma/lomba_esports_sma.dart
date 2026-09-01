// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sma/lomba_esports_sma.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaEsportsSMA(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Istilah MOBA singkatan dari?',
      'options': ['Multiplayer Online Battle Arena', 'Massive Open Battle Area', 'Main Online Battle Action', 'Mode Online Battle Arena'],
      'correct': 0,
    },
    {
      'question': 'Strategi mikro dalam Esports yang melatih reflek waktu reaksi pemain disebut?',
      'options': ['Macro Play', 'Micro Play / Mechanical Skill', 'Drafting', 'Draft Pick'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Turnamen Esports Profesional',
      category: 'Gaming',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 2000 + Random().nextInt(1001); // $2000-$3000
        character.intelligence = (character.intelligence + 10).clamp(0, 100);
        character.happiness = (character.happiness + 15).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara Turnamen Esports Nasional! 🎮🏆',
          'Refleks dan strategi mekanikmu membantai tim lawan! Kamu ditawari kontrak Pro Player!\n\n'
          'Kecerdasan +10%\n'
          'Kebahagiaan +15%\n'
          'Hadiah Uang Sangat Besar: \$$rewardMoney + Membuka Karier Pro Player',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.happiness = (character.happiness + 5).clamp(0, 100);
        showLombaOutcome(
          context,
          'Turnamen Esports 🎮',
          'Pertandingan berlangsung hingga late game, kamu menimba pengalaman taktik gaming!\n\n'
          'Kebahagiaan +5%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
