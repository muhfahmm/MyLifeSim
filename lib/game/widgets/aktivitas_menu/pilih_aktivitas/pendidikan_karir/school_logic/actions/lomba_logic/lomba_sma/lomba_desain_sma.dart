// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sma/lomba_desain_sma.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaDesainSMA(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Dalam desain UI/UX, perbedaan antara UI (User Interface) dan UX (User Experience) adalah?',
      'options': ['UI fokus pada visual/tampilan, UX fokus pada kenyamanan/pengalaman pengguna', 'UI untuk coding, UX untuk gambar', 'UI dan UX adalah hal yang sama', 'UX fokus pada warna, UI fokus pada teks'],
      'correct': 0,
    },
    {
      'question': 'Format gambar vektor yang tidak pecah saat diperbesar adalah?',
      'options': ['PNG', 'JPG', 'SVG', 'GIF'],
      'correct': 2,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Desain Grafis / UI/UX',
      category: 'Teknologi & Kreatif',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 200 + Random().nextInt(301); // $200-$500
        character.intelligence = (character.intelligence + 10).clamp(0, 100);
        character.appearance = (character.appearance + 8).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Desainer Grafis / UI/UX Terbaik! 🎨🏆',
          'Prototipe desain buatanmu sangat estetik dan fungsional!\n\n'
          'Kecerdasan +10%\n'
          'Penampilan +8%\n'
          'Hadiah Uang: \$$rewardMoney + Portofolio Kerja',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Kompetisi Desain Grafis 🎨',
          'Konsep visualmu dinilai kreatif oleh dewan juri desainer profesional!\n\n'
          'Kecerdasan +4%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
