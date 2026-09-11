// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/daftar_olahraga/database_olahraga.dart

import 'package:flutter/material.dart';

class OlahragaDatabase {
  static List<Map<String, dynamic>> getSportsForCharacter(String gender) {
    final bool isFemale = gender.trim().toLowerCase() == 'perempuan';
    final String soccerName = isFemale ? 'Sepakbola Wanita' : 'Sepakbola Pria';
    final String soccerDesc = isFemale
        ? 'Karir sebagai pemain sepakbola wanita profesional di liga utama.'
        : 'Karir sebagai pemain sepakbola pria profesional di liga utama.';
    final String basketballName = isFemale ? 'Basket Wanita' : 'Basket Pria';
    final String basketballDesc = isFemale
        ? 'Karir sebagai pemain basket wanita profesional di liga utama.'
        : 'Karir sebagai pemain basket pria profesional di liga utama.';

    return [
      {
        'name': soccerName,
        'desc': soccerDesc,
        'icon': Icons.sports_soccer,
        'color': Colors.green,
        'minAge': 6,
        'positions': [
          {
            'title': 'ST',
            'baseSalary': 8500,
            'minHealth': 75,
            'minDiscipline': 65,
            'minIntel': 20,
            'desc': 'Mencetak gol dan memimpin lini serang klub sepakbola.',
          },
          {
            'title': 'LW',
            'baseSalary': 8200,
            'minHealth': 75,
            'minDiscipline': 65,
            'minIntel': 25,
            'desc': 'Menyerang dari sayap kiri dengan kecepatan dan umpan silang.',
          },
          {
            'title': 'RW',
            'baseSalary': 8200,
            'minHealth': 75,
            'minDiscipline': 65,
            'minIntel': 25,
            'desc': 'Menyerang dari sayap kanan dengan kecepatan dan umpan silang.',
          },
          {
            'title': 'CAM',
            'baseSalary': 8100,
            'minHealth': 75,
            'minDiscipline': 70,
            'minIntel': 45,
            'desc': 'Playmaker penyuplai bola matang di lini depan.',
          },
          {
            'title': 'CM',
            'baseSalary': 8000,
            'minHealth': 75,
            'minDiscipline': 70,
            'minIntel': 40,
            'desc': 'Mengatur ritme permainan dan penyeimbang lini tengah.',
          },
          {
            'title': 'CDM',
            'baseSalary': 7800,
            'minHealth': 80,
            'minDiscipline': 75,
            'minIntel': 35,
            'desc': 'Gelandang bertahan pemutus serangan lawan.',
          },
          {
            'title': 'CB',
            'baseSalary': 7500,
            'minHealth': 80,
            'minDiscipline': 70,
            'minIntel': 30,
            'desc': 'Menjaga jantung pertahanan dan menghentikan striker lawan.',
          },
          {
            'title': 'LB',
            'baseSalary': 7500,
            'minHealth': 80,
            'minDiscipline': 70,
            'minIntel': 30,
            'desc': 'Menjaga sisi kiri pertahanan dan membantu serangan dari sayap.',
          },
          {
            'title': 'RB',
            'baseSalary': 7500,
            'minHealth': 80,
            'minDiscipline': 70,
            'minIntel': 30,
            'desc': 'Menjaga sisi kanan pertahanan dan membantu serangan dari sayap.',
          },
          {
            'title': 'GK',
            'baseSalary': 7800,
            'minHealth': 70,
            'minDiscipline': 75,
            'minIntel': 35,
            'desc': 'Penyelamat di bawah mistar gawang dengan refleks kilat.',
          },
        ],
      },
      {
        'name': basketballName,
        'desc': basketballDesc,
        'icon': Icons.sports_basketball,
        'color': Colors.orange,
        'minAge': 6,
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
        'name': 'Balap Motor & Mobil',
        'desc': 'Adu kecepatan di lintasan balap kelas dunia.',
        'icon': Icons.sports_motorsports,
        'color': Colors.red,
        'minAge': 12,
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
        'minAge': 10,
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
        'name': 'Tinju & MMA',
        'desc': 'Seni bela diri campuran dan petinju di ring kejuaraan.',
        'icon': Icons.sports_mma,
        'color': Colors.brown,
        'minAge': 16,
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
        'minAge': 6,
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
    ];
  }

  static final List<Map<String, dynamic>> sports = getSportsForCharacter('Laki-laki');
}
