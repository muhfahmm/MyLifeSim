// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/basket/basket_logic/logika_usia_rekan_tim_basket.dart

class LogikaUsiaRekanTimBasket {
  static String getKategoriTimBerdasarkanUsia({required int usia}) {
    if (usia <= 12) {
      return 'Tim U-12';
    } else if (usia <= 16) {
      return 'Tim U-16';
    } else if (usia <= 20) {
      return 'Tim U-20';
    } else {
      return 'Tim Utama';
    }
  }

  static String getRentangUsiaRekanTim({required int usia}) {
    if (usia <= 12) {
      return '10-12 Tahun';
    } else if (usia <= 16) {
      return '13-16 Tahun';
    } else if (usia <= 20) {
      return '17-20 Tahun';
    } else {
      return '21-38 Tahun';
    }
  }
}
