// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/sepakbola_logic/logika_ekskul_sepakbola.dart

import 'package:mylifesim/pilih_karakter/character.dart';

/// Logika keterkaitan antara Ekstrakurikuler Sekolah (Sepakbola)
/// dengan pekerjaan sebagai Pemain Sepakbola Profesional.
class LogikaEkskulSepakbola {
  /// Mengecek apakah karakter sedang atau pernah mengikuti Ekstrakurikuler Sepakbola di sekolah
  static bool apakahIkutEkskulSepakbola(Character character) {
    return character.joinedExtracurriculars.any(
      (ext) {
        final l = ext.toLowerCase();
        return l.contains('sepakbola') || l.contains('soccer') || l.contains('football') || l == 'olahraga';
      },
    );
  }

  /// Menghitung/menyesuaikan persentase peluang diterima kontrak pemain sepakbola.
  /// Jika user belum ikut ekskul atau belum melakukan setidaknya 3 kali aktivitas/latihan, peluang 15%.
  /// Jika sudah ikut ekskul DAN sudah melakukan at least 3 kali latihan, peluang 90%.
  static int hitungPeluangDiterima({
    required Character character,
    required int baseChance,
    bool isSoccer = true,
  }) {
    if (!isSoccer) return baseChance;

    final bool ikutEkskul = apakahIkutEkskulSepakbola(character);
    final int practiceCount = character.extracurricularPracticeCounts['Sepakbola'] ?? 0;

    if (ikutEkskul && practiceCount >= 3) {
      return 90;
    } else {
      return 15;
    }
  }
}
