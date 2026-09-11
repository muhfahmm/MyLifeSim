// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/karir_pages/aktivitas_karir_atlet/balap/balap_logic/logika_usia_rekan_tim_balap.dart

class LogikaUsiaRekanTimBalap {
  static String getKategoriTimBerdasarkanUsia({required int usia}) {
    if (usia <= 14) {
      return 'Tim Akademi Karting / Junior';
    } else if (usia <= 18) {
      return 'Tim Formula 4 / Moto3 Junior';
    } else {
      return 'Tim Utama Grand Prix';
    }
  }
}
