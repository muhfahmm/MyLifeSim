// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_smp/lomba_osn_smp.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaOsnSMP(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Bagian sel yang berfungsi sebagai pusat pengendali seluruh kegiatan sel adalah?',
      'options': ['Mitokondria', 'Nukleus (Inti Sel)', 'Ribosom', 'Sitoplasma'],
      'correct': 1,
    },
    {
      'question': 'Hukum Newton manakah yang menyatakan F = m x a?',
      'options': ['Hukum I Newton', 'Hukum II Newton', 'Hukum III Newton', 'Hukum Gravitasi'],
      'correct': 1,
    },
    {
      'question': 'Senyawa kimia dengan rumus H2SO4 adalah?',
      'options': ['Asam Klorida', 'Asam Sulfat', 'Asam Nitrat', 'Natrium Hidroksida'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Olimpiade Sains Nasional (OSN SMP)',
      category: 'Akademik',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 100 + Random().nextInt(401); // $100-$500
        character.intelligence = (character.intelligence + 15).clamp(0, 100);
        character.willpower = (character.willpower + 10).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Medali Emas OSN SMP! 🏅🏆',
          'Luar biasa! Kamu meraih Medali Emas OSN SMP dan mendapat Beasiswa Jalur Prestasi SMA!\n\n'
          'Kecerdasan ++ (+15%)\n'
          'Tekad + (+10%)\n'
          'Hadiah Uang: \$$rewardMoney + Beasiswa SMA',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 5).clamp(0, 100);
        showLombaOutcome(
          context,
          'Peserta OSN SMP 🏅',
          'Soal-soal olimpiade sangat menantang, kamu mendapatkan pengalaman berharga!\n\n'
          'Kecerdasan +5%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
