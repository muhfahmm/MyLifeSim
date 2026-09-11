// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/sepakbola/sepakbola_logic/logika_ekskul_sepakbola.dart

import 'package:mylifesim/pilih_karakter/character.dart';

/// Logika keterkaitan antara Ekstrakurikuler Sekolah (Sepakbola)
/// dengan pekerjaan sebagai Pemain Sepakbola Profesional.
class LogikaEkskulSepakbola {
  /// Mengecek apakah karakter sedang atau pernah mengikuti Ekstrakurikuler Sepakbola di sekolah
  static bool apakahIkutEkskulSepakbola(Character character) {
    return character.joinedExtracurriculars.any(
      (ext) => ext.toLowerCase().contains('sepakbola'),
    );
  }

  /// Menghitung/menyesuaikan persentase peluang diterima kontrak pemain sepakbola.
  /// Jika user tidak mengikuti ekstrakurikuler sepakbola, persentase diterimanya hanya 30%.
  static int hitungPeluangDiterima({
    required Character character,
    required int baseChance,
    bool isSoccer = true,
  }) {
    if (!isSoccer) return baseChance;

    final bool ikutEkskul = apakahIkutEkskulSepakbola(character);
    if (ikutEkskul) {
      // Jika user mengikuti ekstrakurikuler sepakbola, persentase diterimanya menjadi 90%
      return 90;
    } else {
      // Jika user tidak mengikuti ekstrakurikuler sepakbola, persentase diterimanya hanya 30%
      return 30;
    }
  }
}
