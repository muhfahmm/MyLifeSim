// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/balap/balap_logic/database_formasi_pelatih_balap.dart

import 'dart:math';

class FormasiPelatihBalap {
  final String code;
  final String name;
  final int engineers;
  final int mechanics;
  final int strategists;
  final List<String> orderedRoles;

  const FormasiPelatihBalap({
    required this.code,
    required this.name,
    required this.engineers,
    required this.mechanics,
    required this.strategists,
    required this.orderedRoles,
  });
}

class FormasiPelatihBalapDatabase {
  static const List<FormasiPelatihBalap> listFormasi = [
    FormasiPelatihBalap(
      code: 'Aggressive Pace & Undercut',
      name: 'Strategi Pit Stop Cepat & Serangan Lap Awal',
      engineers: 3,
      mechanics: 4,
      strategists: 2,
      orderedRoles: ['Pembalap Utama', 'Pembalap Pendamping', 'Race Engineer', 'Pit Crew Chief', 'Strategist'],
    ),
    FormasiPelatihBalap(
      code: 'Tire Management & Endurance',
      name: 'Manajemen Ban & Konsistensi Pace Panjang',
      engineers: 4,
      mechanics: 3,
      strategists: 3,
      orderedRoles: ['Pembalap Utama', 'Pembalap Pendamping', 'Data Engineer', 'Tire Specialist', 'Lead Strategist'],
    ),
  ];

  static FormasiPelatihBalap getRandomFormasi(Random rand) {
    return listFormasi[rand.nextInt(listFormasi.length)];
  }
}
