// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/basket/basket_logic/database_formasi_pelatih_basket.dart

import 'dart:math';

class FormasiPelatihBasket {
  final String code; // e.g. 'Pencegahan Pace (Pace & Space)'
  final String name; // e.g. 'Fast Break & Perimeter 3PT'
  final int guards;
  final int forwards;
  final int centers;
  final List<String> orderedPositions;

  const FormasiPelatihBasket({
    required this.code,
    required this.name,
    required this.guards,
    required this.forwards,
    required this.centers,
    required this.orderedPositions,
  });
}

class FormasiPelatihBasketDatabase {
  static const List<FormasiPelatihBasket> listFormasi = [
    FormasiPelatihBasket(
      code: 'Small Ball (3PT & Pace)',
      name: 'Small Ball & Tembakan 3 Poin',
      guards: 2,
      forwards: 2,
      centers: 1,
      orderedPositions: ['Point Guard', 'Shooting Guard', 'Small Forward', 'Power Forward', 'Center'],
    ),
    FormasiPelatihBasket(
      code: 'Post-Up & Inside Defense',
      name: 'Dominasi Inside Ring & Post Defense',
      guards: 2,
      forwards: 1,
      centers: 2,
      orderedPositions: ['Point Guard', 'Shooting Guard', 'Power Forward', 'Center', 'Center (Bigman)'],
    ),
  ];

  static FormasiPelatihBasket getRandomFormasi(Random rand) {
    return listFormasi[rand.nextInt(listFormasi.length)];
  }
}
