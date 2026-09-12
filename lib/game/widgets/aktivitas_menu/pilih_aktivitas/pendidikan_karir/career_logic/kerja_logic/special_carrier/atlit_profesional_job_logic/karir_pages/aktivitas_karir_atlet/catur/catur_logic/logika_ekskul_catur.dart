// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/catur/catur_logic/logika_ekskul_catur.dart

import 'package:mylifesim/pilih_karakter/character.dart';

class LogikaEkskulCatur {
  static bool apakahIkutEkskulCatur(Character character) {
    return character.joinedExtracurriculars.any(
      (ext) {
        final l = ext.toLowerCase();
        return l.contains('catur') || l.contains('chess') || l == 'olahraga';
      },
    );
  }

  static int hitungPeluangDiterima(Character character, int baseChance) {
    final bool ikutEkskul = apakahIkutEkskulCatur(character);
    final int practiceCount = character.extracurricularPracticeCounts['Catur'] ?? 0;
    if (ikutEkskul && practiceCount >= 3) {
      return 90;
    } else {
      return 15;
    }
  }
}
