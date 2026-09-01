// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sma/lomba_film_sma.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaFilmSMA(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Istilah untuk pengaturan pencahayaan dasar dalam videografi (Key, Fill, Back light) adalah?',
      'options': ['Three-Point Lighting', 'Golden Hour Lighting', 'Bokeh Lighting', 'Chroma Key'],
      'correct': 0,
    },
    {
      'question': 'Ukuran kecepatan bingkai gambar per detik standar sinematik film adalah?',
      'options': ['60 fps', '24 fps', '120 fps', '30 fps'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Film Pendek / Fotografi / Videografi',
      category: 'Multimedia',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 250 + Random().nextInt(351); // $250-$600
        character.appearance = (character.appearance + 10).clamp(0, 100);
        character.intelligence = (character.intelligence + 10).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Sutradara / Fotografer Terbaik! 🎬🏆',
          'Karya videografimu memenangkan Festival Film Pelajar Nasional!\n\n'
          'Penampilan +10%\n'
          'Kecerdasan Produksi +10%\n'
          'Hadiah Uang: \$$rewardMoney + Peluang Content Creator',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.appearance = (character.appearance + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Festival Videografi 🎬',
          'Film pendek buatanmu tayang di bioskop sekolah dan mendapat banyak pujian penonton!\n\n'
          'Penampilan +4%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
