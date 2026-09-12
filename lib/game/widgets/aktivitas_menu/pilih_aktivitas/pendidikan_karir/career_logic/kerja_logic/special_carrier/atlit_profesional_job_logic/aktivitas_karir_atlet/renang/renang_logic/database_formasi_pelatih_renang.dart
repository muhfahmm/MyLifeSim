// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/renang/renang_logic/database_formasi_pelatih_renang.dart

import 'dart:math';

class FormasiPelatihRenang {
  final String code;
  final String name;
  final int sprinters;
  final int distanceSwimmers;
  final int medleySwimmers;
  final List<String> orderedSpecialties;

  const FormasiPelatihRenang({
    required this.code,
    required this.name,
    required this.sprinters,
    required this.distanceSwimmers,
    required this.medleySwimmers,
    required this.orderedSpecialties,
  });
}

class FormasiPelatihRenangDatabase {
  static const List<FormasiPelatihRenang> listFormasi = [
    FormasiPelatihRenang(
      code: 'Sprint & Relay Focus',
      name: 'Fokus Kecepatan Tinggi Sprint & Estafet',
      sprinters: 4,
      distanceSwimmers: 1,
      medleySwimmers: 2,
      orderedSpecialties: ['Gaya Bebas 50m/100m', 'Gaya Dada 50m', 'Gaya Kupu-kupu 50m', 'Gaya Punggung 100m', 'Estafet 4x100m'],
    ),
    FormasiPelatihRenang(
      code: 'Individual Medley & Endurance',
      name: 'Fokus Daya Tahan & Renang Campuran Medley',
      sprinters: 2,
      distanceSwimmers: 3,
      medleySwimmers: 3,
      orderedSpecialties: ['Gaya Ganti 200m/400m', 'Gaya Bebas 400m/800m', 'Gaya Kupu-kupu 200m', 'Gaya Punggung 200m', 'Gaya Dada 200m'],
    ),
  ];

  static FormasiPelatihRenang getRandomFormasi(Random rand) {
    return listFormasi[rand.nextInt(listFormasi.length)];
  }
}
