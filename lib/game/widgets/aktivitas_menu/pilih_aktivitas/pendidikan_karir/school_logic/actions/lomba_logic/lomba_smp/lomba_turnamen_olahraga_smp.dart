// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_smp/lomba_turnamen_olahraga_smp.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaOlahragaSMP(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Berapakah jumlah pemain inti dalam satu tim bola basket di lapangan?',
      'options': ['5 orang', '6 orang', '11 orang', '7 orang'],
      'correct': 0,
    },
    {
      'question': 'Pukulan sajian pertama untuk memulai permainan badminton dinamakan?',
      'options': ['Smash', 'Servis', 'Drive', 'Dropshot'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Turnamen Badminton / Basket / Voli SMP',
      category: 'Olahraga',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 100 + Random().nextInt(151); // $100-$250
        character.health = (character.health + 12).clamp(0, 100);
        character.willpower = (character.willpower + 8).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara Turnamen Olahraga! 🏸🏀🏆',
          'Tim sekolahmu memenangkan babak final antar sekolah!\n\n'
          'Kesehatan +12%\n'
          'Tekad +8%\n'
          'Hadiah Uang: \$$rewardMoney',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.health = (character.health + 5).clamp(0, 100);
        showLombaOutcome(
          context,
          'Turnamen Olahraga SMP 🏸',
          'Pertandingan berlangsung sengit sampai set penentu, kamu belajar banyak tentang kerja sama tim!\n\n'
          'Kesehatan +5%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
