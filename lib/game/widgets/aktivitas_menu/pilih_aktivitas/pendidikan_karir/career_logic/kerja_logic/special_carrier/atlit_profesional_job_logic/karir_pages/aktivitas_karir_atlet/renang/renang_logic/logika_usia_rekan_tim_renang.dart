// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/renang/renang_logic/logika_usia_rekan_tim_renang.dart

import 'dart:math';

class LogikaUsiaRekanTimRenang {
  static int generateUsiaRekanRenang(Random rand) {
    return 16 + rand.nextInt(15); // Usia perenang 16 - 30 tahun
  }
}
