// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_smp/lomba_essay_smp.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaEssaySMP(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Struktur esai yang berisi tesis dan pengenalan topik terletak pada bagian?',
      'options': ['Pendahuluan (Introduction)', 'Isi (Body)', 'Penutup (Conclusion)', 'Daftar Pustaka'],
      'correct': 0,
    },
    {
      'question': 'Cerita pendek (cerpen) umumnya memiliki ciri khas yaitu?',
      'options': ['Memiliki banyak alur bercabang', 'Fokus pada satu konflik utama', 'Terdiri dari ratusan halaman', 'Memiliki puluhan tokoh utama'],
      'correct': 1,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Essay & Cerpen SMP',
      category: 'Bahasa & Sastra',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 50 + Random().nextInt(101); // $50-$150
        character.intelligence = (character.intelligence + 10).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara Menulis Karya Sastra! ✍️🏆',
          'Naskah tulisanmu diterbitkan di majalah sekolah dan nasional!\n\n'
          'Kecerdasan +10%\n'
          'Hadiah Uang: \$$rewardMoney + Kesempatan Terbit',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.intelligence = (character.intelligence + 4).clamp(0, 100);
        showLombaOutcome(
          context,
          'Kompetisi Menulis Esai ✍️',
          'Tulisanku diapresiasi juri dan menambah keterampilan mengarangmu!\n\n'
          'Kecerdasan +4%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
