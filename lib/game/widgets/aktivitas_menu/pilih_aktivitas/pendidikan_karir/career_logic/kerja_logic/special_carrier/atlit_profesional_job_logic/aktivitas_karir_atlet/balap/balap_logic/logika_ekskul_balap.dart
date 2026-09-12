// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/balap/balap_logic/logika_ekskul_balap.dart

import 'package:mylifesim/pilih_karakter/character.dart';

class LogikaEkskulBalap {
  /// Mengecek apakah karakter sedang atau pernah mengikuti Ekstrakurikuler Balap / Gokart di sekolah
  static bool apakahIkutEkskulBalap(Character character) {
    return character.joinedExtracurriculars.any(
      (ext) {
        final l = ext.toLowerCase();
        return l.contains('balap') || l.contains('gokart') || l == 'otomotif';
      },
    );
  }

  /// Peluang diterima tim balap berdasarkan keikutsertaan ekskul & latihan (90% vs 15%)
  static int hitungPeluangDiterimaBalap(Character character, int baseChance) {
    final bool ikutEkskul = apakahIkutEkskulBalap(character);
    final int practiceCount = character.extracurricularPracticeCounts['Balap'] ?? character.extracurricularPracticeCounts['Gokart'] ?? 0;
    if (ikutEkskul && practiceCount >= 3) {
      return 90;
    } else {
      return 15;
    }
  }
}
