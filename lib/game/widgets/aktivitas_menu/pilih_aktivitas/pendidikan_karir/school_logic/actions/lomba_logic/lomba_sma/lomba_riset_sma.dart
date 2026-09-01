// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sma/lomba_riset_sma.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaRisetSMA(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Tahapan awal dalam metode ilmiah penelitian adalah?',
      'options': ['Menarik Kesimpulan', 'Merumuskan Masalah & Observasi', 'Uji Hipotesis', 'Publikasi Jurnal'],
      'correct': 1,
    },
    {
      'question': 'Variabel yang sengaja diubah-ubah dalam eksperimen sains disebut?',
      'options': ['Variabel Terikat', 'Variabel Bebas', 'Variabel Kontrol', 'Variabel Pengganggu'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Sains Fair / Riset Ilmiah Remaja',
      category: 'Riset',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 400 + Random().nextInt(401); // $400-$800
        character.intelligence = (character.intelligence + 15).clamp(0, 100);
        character.willpower = (character.willpower + 10).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Peneliti Muda Terbaik (LKIR)! 🔬🏆',
          'Riset ilmiah inovatif buatanmu berhasil dipublikasikan di jurnal ilmiah remaja!\n\n'
          'Kecerdasan ++ (+15%)\n'
          'Tekad + (+10%)\n'
          'Hadiah Uang: \$$rewardMoney + Peluang Publikasi Jurnal',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 5).clamp(0, 100);
        showLombaOutcome(
          context,
          'Karya Tulis Ilmiah Remaja 🔬',
          'Metodologi penelitianmu mendapat masukan berharga dari para ilmuwan dewan juri!\n\n'
          'Kecerdasan +5%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
