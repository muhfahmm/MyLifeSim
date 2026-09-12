// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/tinju_mma/tinju_mma_logic/logika_ekskul_tinju_mma.dart

import 'package:mylifesim/pilih_karakter/character.dart';

class LogikaEkskulTinjuMMA {
  static bool apakahIkutEkskulBelaDiri(Character character) {
    return character.joinedExtracurriculars.any(
      (ext) => ext.toLowerCase().contains('tinju') || ext.toLowerCase().contains('mma') || ext.toLowerCase().contains('bela diri') || ext.toLowerCase().contains('karate'),
    );
  }

  static int hitungPeluangDiterima(Character character, int baseChance) {
    final bool ikutEkskul = apakahIkutEkskulBelaDiri(character);
    if (ikutEkskul) {
      return 90;
    } else {
      return 30;
    }
  }
}
