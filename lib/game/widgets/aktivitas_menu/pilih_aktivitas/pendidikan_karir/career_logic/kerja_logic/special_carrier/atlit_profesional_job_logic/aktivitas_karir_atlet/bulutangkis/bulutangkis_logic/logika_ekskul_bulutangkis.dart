// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/bulutangkis/bulutangkis_logic/logika_ekskul_bulutangkis.dart

import 'package:mylifesim/pilih_karakter/character.dart';

class LogikaEkskulBulutangkis {
  static bool apakahIkutEkskulBulutangkis(Character character) {
    return character.joinedExtracurriculars.any(
      (ext) {
        final l = ext.toLowerCase();
        return l.contains('badminton') || l.contains('bulutangkis') || l == 'olahraga';
      },
    );
  }

  static int hitungPeluangDiterima(Character character, int baseChance) {
    final bool ikutEkskul = apakahIkutEkskulBulutangkis(character);
    if (ikutEkskul) {
      return 90;
    } else {
      return 30;
    }
  }
}
