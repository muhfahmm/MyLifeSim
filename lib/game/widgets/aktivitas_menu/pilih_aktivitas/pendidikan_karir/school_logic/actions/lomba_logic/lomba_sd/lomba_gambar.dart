// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_sd/lomba_gambar.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import '../lomba_helper.dart';

void runLombaGambarSD(BuildContext context, Character character, VoidCallback onRefresh) {
  final quizzes = [
    {
      'question': 'Warna apakah yang dihasilkan jika mencampurkan warna Merah dan Kuning?',
      'options': ['Hijau', 'Jingga / Oranye', 'Ungu', 'Cokelat'],
      'correct': 1,
    },
    {
      'question': 'Warna apakah yang merupakan warna primer (warna dasar)?',
      'options': ['Hijau', 'Merah', 'Ungu', 'Oranye'],
      'correct': 1,
    },
    {
      'question': 'Alat apa yang biasanya digunakan untuk meruncingkan pensil gambar?',
      'options': ['Penggaris', 'Penghapus', 'Rautan', 'Kuas'],
      'correct': 2,
    },
  ];

  final quiz = quizzes[Random().nextInt(quizzes.length)];

  showDialog(
    context: context,
    builder: (ctx) => LombaQuizDialog(
      title: 'Lomba Menggambar & Mewarnai',
      category: 'Seni',
      question: quiz['question'] as String,
      options: List<String>.from(quiz['options'] as List),
      correctIndex: quiz['correct'] as int,
      onSuccess: () {
        int rewardMoney = 50 + Random().nextInt(51); // $50-$100
        character.happiness = (character.happiness + 10).clamp(0, 100);
        character.appearance = (character.appearance + 5).clamp(0, 100);
        character.money += rewardMoney;

        showLombaOutcome(
          context,
          'Juara 1 Lomba Menggambar! 🎨🏆',
          'Gambar karya manismu memukau para juri! Kamu berhasil meraih Juara 1!\n\n'
          'Kebahagiaan +10%\n'
          'Penampilan +5%\n'
          'Hadiah Uang: \$$rewardMoney',
          onConfirm: onRefresh,
        );
      },
      onFail: () {
        character.happiness = (character.happiness + 3).clamp(0, 100);
        showLombaOutcome(
          context,
          'Peserta Lomba Menggambar 🎨',
          'Kamu belum berhasil meraih juara, namun karya gambarmu mendapat apresiasi dari juri!\n\n'
          'Kebahagiaan +3%',
          onConfirm: onRefresh,
        );
      },
    ),
  );
}
