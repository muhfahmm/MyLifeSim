// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/basket/basket_logic/logika_ekskul_basket.dart

import 'package:mylifesim/pilih_karakter/character.dart';

class LogikaEkskulBasket {
  /// Mengecek apakah karakter sedang atau pernah mengikuti Ekstrakurikuler Basket di sekolah
  static bool apakahIkutEkskulBasket(Character character) {
    return character.joinedExtracurriculars.any(
      (ext) {
        final l = ext.toLowerCase();
        return l.contains('basket') || l == 'olahraga';
      },
    );
  }

  /// Peluang diterima tim basket berdasarkan keikutsertaan ekskul bola basket (90% vs 30%)
  static int hitungPeluangDiterimaBasket(Character character, int baseChance) {
    final bool ikutEkskul = apakahIkutEkskulBasket(character);
    if (ikutEkskul) {
      return 90;
    } else {
      return 30;
    }
  }
}

