// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_smp/lomba_robotik_smp.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaRobotikSMP(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Komponen elektronika yang berfungsi sebagai "otak" pengontrol robot (seperti Arduino) disebut?',
      'options': ['Resistor', 'Mikrokontroler', 'Kapasitor', 'Transistor'],
      'correct': 1,
    },
    {
      'question': 'Sensor yang sering digunakan pada robot penelusur garis (Line Follower) adalah?',
      'options': ['Sensor Suhu', 'Sensor Inframerah / LDR', 'Sensor Sentuh', 'Sensor Gas'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Robotik & Coding SMP',
      category: 'Teknologi',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 150 + Random().nextInt(251); // $150-$400
        character.intelligence = (character.intelligence + 12).clamp(0, 100);
        character.willpower = (character.willpower + 8).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara Lomba Robotik! 🤖🏆',
          'Robot buatanmu berhasil menyelesaikan sirkuit tanpa kendala dan melaju ke kompetisi internasional!\n\n'
          'Kecerdasan ++ (+12%)\n'
          'Tekad + (+8%)\n'
          'Hadiah Uang: \$$rewardMoney + Tiket Lomba Internasional',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Kompetisi Robotik 🤖',
          'Ada sedikit eror logika coding di menit akhir, namun pengalaman ini mengasah skill teknismu!\n\n'
          'Kecerdasan +4%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
