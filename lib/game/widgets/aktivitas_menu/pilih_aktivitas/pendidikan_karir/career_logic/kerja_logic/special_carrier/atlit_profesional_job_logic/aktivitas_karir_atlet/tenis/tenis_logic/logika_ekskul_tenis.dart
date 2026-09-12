// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/tenis/tenis_logic/logika_ekskul_tenis.dart

import 'package:mylifesim/pilih_karakter/character.dart';

class LogikaEkskulTenis {
  static bool apakahIkutEkskulTenis(Character character) {
    return character.joinedExtracurriculars.any(
      (ext) => ext.toLowerCase().contains('tenis') || ext.toLowerCase().contains('tennis'),
    );
  }

  static int hitungPeluangDiterima(Character character, int baseChance) {
    final bool ikutEkskul = apakahIkutEkskulTenis(character);
    if (ikutEkskul) {
      return 90;
    } else {
      return 30;
    }
  }
}
