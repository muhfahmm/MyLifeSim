// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/renang_logic/gaji_pemain_renang.dart

import 'package:mylifesim/pilih_karakter/character.dart';

class GajiPemainRenang {
  static int hitungGajiTahunanRenang(Character character) {
    int baseSalary = 45000000; // Rp 45.000.000 / tahun base
    int totalGolds = 0;
    for (var item in character.athleteSeasonStats) {
      totalGolds += (item['goldMedals'] as num?)?.toInt() ?? 0;
    }
    final currentStats = character.currentAthleteStats;
    if (currentStats != null) {
      totalGolds += (currentStats['goldMedals'] as num?)?.toInt() ?? 0;
    }

    baseSalary += totalGolds * 15000000;
    return baseSalary;
  }
}
