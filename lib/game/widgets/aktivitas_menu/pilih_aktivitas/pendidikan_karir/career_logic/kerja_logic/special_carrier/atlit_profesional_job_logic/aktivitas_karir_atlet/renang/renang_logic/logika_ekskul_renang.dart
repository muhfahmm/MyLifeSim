// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/renang/renang_logic/logika_ekskul_renang.dart

import 'package:mylifesim/pilih_karakter/character.dart';

class LogikaEkskulRenang {
  static bool apakahIkutEkskulRenang(Character character) {
    return character.joinedExtracurriculars.any(
      (ext) {
        final l = ext.toLowerCase();
        return l.contains('renang') || l.contains('swimming') || l == 'olahraga';
      },
    );
  }

  static int hitungPeluangDiterima(Character character, int baseChance) {
    final bool ikutEkskul = apakahIkutEkskulRenang(character);
    final int practiceCount = character.extracurricularPracticeCounts['Renang'] ?? 0;
    if (ikutEkskul && practiceCount >= 3) {
      return 90;
    } else {
      return 15;
    }
  }
}
