// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/daftar_olahraga/database_olahraga.dart

import 'package:flutter/material.dart';

class OlahragaDatabase {
  static final List<Map<String, dynamic>> sports = [
    {
      'name': 'Sepakbola',
      'desc': 'Karir sebagai pemain sepakbola profesional di liga utama.',
      'icon': Icons.sports_soccer,
      'color': Colors.green,
      'positions': [
        {
          'title': 'Striker (Penyerang Sepakbola)',
          'baseSalary': 8500,
          'minHealth': 75,
          'minDiscipline': 65,
          'minIntel': 20,
          'desc': 'Mencetak gol dan memimpin lini serang klub sepakbola.',
        },
        {
          'title': 'Gelandang Kreatif (Midfielder)',
          'baseSalary': 8000,
          'minHealth': 75,
          'minDiscipline': 70,
          'minIntel': 40,
          'desc': 'Mengatur ritme permainan dan memberikan umpan manja.',
        },
        {
          'title': 'Bek Bertahan (Defender)',
          'baseSalary': 7500,
          'minHealth': 80,
          'minDiscipline': 70,
          'minIntel': 30,
          'desc': 'Mementalkan serangan lawan dan menjaga benteng pertahanan.',
        },
        {
          'title': 'Kiper Utama (Goalkeeper)',
          'baseSalary': 7800,
          'minHealth': 70,
          'minDiscipline': 75,
          'minIntel': 35,
          'desc': 'Penyelamat di bawah mistar gawang dengan refleks kilat.',
        },
      ],
    },
    {
      'name': 'Basket',
      'desc': 'Karir sebagai pemain basket profesional di liga utama.',
      'icon': Icons.sports_basketball,
      'color': Colors.orange,
      'positions': [
        {
          'title': 'Point Guard (Basket Pro)',
          'baseSalary': 9000,
          'minHealth': 75,
          'minDiscipline': 70,
          'minIntel': 45,
          'desc': 'Jenderal lapangan pembagi bola dan pengatur strategi tim basket.',
        },
        {
          'title': 'Shooting Guard (Basket Pro)',
          'baseSalary': 9500,
          'minHealth': 80,
          'minDiscipline': 65,
          'minIntel': 35,
          'desc': 'Eksekutor tembakan 3 angka dan pencetak poin utama.',
        },
        {
          'title': 'Center / Power Forward (Basket Pro)',
          'baseSalary': 10500,
          'minHealth': 85,
          'minDiscipline': 70,
          'minIntel': 30,
          'desc': 'Menguasai area bawah ring dan melakukan dunk spektakuler.',
        },
      ],
    },
    {
      'name': 'Bulu Tangkis',
      'desc': 'Bertanding dalam kejuaraan badminton internasional.',
      'icon': Icons.sports_tennis,
      'color': Colors.redAccent,
      'positions': [
        {
          'title': 'Pemain Tunggal Bulu Tangkis',
          'baseSalary': 7000,
          'minHealth': 80,
          'minDiscipline': 80,
          'minIntel': 35,
          'desc': 'Bertanding secara individu dalam kejuaraan dunia badminton.',
        },
        {
          'title': 'Pemain Ganda Bulu Tangkis',
          'baseSalary': 7500,
          'minHealth': 80,
          'minDiscipline': 75,
          'minIntel': 35,
          'desc': 'Berpasangan menjaga keharmonisan pergerakan dan smash cepat.',
        },
      ],
    },
    {
      'name': 'Balap Motor & Mobil',
      'desc': 'Adu kecepatan di lintasan balap kelas dunia.',
      'icon': Icons.sports_motorsports,
      'color': Colors.red,
      'positions': [
        {
          'title': 'Pebalap Moto2 / Moto3',
          'baseSalary': 14000,
          'minHealth': 80,
          'minDiscipline': 80,
          'minIntel': 50,
          'desc': 'Aksi adu kecepatan di lintasan balap motor grand prix.',
        },
        {
          'title': 'Pebalap Formula (F1 / F3)',
          'baseSalary': 28000,
          'minHealth': 85,
          'minDiscipline': 85,
          'minIntel': 65,
          'desc': 'Kasta tertinggi balap mobil jet darat internasional.',
        },
      ],
    },
    {
      'name': 'Tenis',
      'desc': 'Berkompetisi di ajang turnamen Grand Slam dunia.',
      'icon': Icons.sports_tennis,
      'color': Colors.lightGreen,
      'positions': [
        {
          'title': 'Petenis Tunggal Pro (ATP/WTA)',
          'baseSalary': 11000,
          'minHealth': 80,
          'minDiscipline': 80,
          'minIntel': 40,
          'desc': 'Berkompetisi di ajang turnamen Grand Slam dunia.',
        },
      ],
    },
    {
      'name': 'Binaraga & Fitness',
      'desc': 'Membentuk fisik dan estetika otot di kejuaraan binaraga.',
      'icon': Icons.fitness_center,
      'color': Colors.deepPurple,
      'positions': [
        {
          'title': 'Atlet Binaraga (Bodybuilder Pro)',
          'baseSalary': 8500,
          'minHealth': 85,
          'minDiscipline': 90,
          'minIntel': 30,
          'desc': 'Membentuk simetris dan massa otot ideal untuk kompetisi Mr. Olympia.',
        },
      ],
    },
    {
      'name': 'Tinju & MMA',
      'desc': 'Seni bela diri campuran dan petinju di ring kejuaraan.',
      'icon': Icons.sports_mma,
      'color': Colors.brown,
      'positions': [
        {
          'title': 'Petarung MMA Profesional',
          'baseSalary': 12500,
          'minHealth': 85,
          'minDiscipline': 80,
          'minIntel': 35,
          'desc': 'Seni bela diri campuran di dalam octagon turnamen.',
        },
        {
          'title': 'Petinju Profesional (Boxer)',
          'baseSalary': 11500,
          'minHealth': 85,
          'minDiscipline': 80,
          'minIntel': 30,
          'desc': 'Menguasai pukulan jab, hook, dan upper-cut di atas ring.',
        },
      ],
    },
    {
      'name': 'Renang',
      'desc': 'Menjadi atlet renang tercepat di berbagai gaya perlombaan.',
      'icon': Icons.pool,
      'color': Colors.blue,
      'positions': [
        {
          'title': 'Perenang Atlet Profesional',
          'baseSalary': 6500,
          'minHealth': 85,
          'minDiscipline': 80,
          'minIntel': 30,
          'desc': 'Spesialis gaya bebas dan kupu-kupu di kejuaraan renang.',
        },
      ],
    },
    {
      'name': 'Catur',
      'desc': 'Adu strategi pikiran papan catur tingkat dunia.',
      'icon': Icons.extension,
      'color': Colors.blueGrey,
      'positions': [
        {
          'title': 'Pecatur Grandmaster (Chess Pro)',
          'baseSalary': 9000,
          'minHealth': 40,
          'minDiscipline': 75,
          'minIntel': 85,
          'desc': 'Adu strategi pikiran papan catur tingkat dunia.',
        },
      ],
    },
  ];
}
