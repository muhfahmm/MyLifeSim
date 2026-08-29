// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/persentase_efek_samping/wanita.dart
import 'package:bitlife/pilih_karakter/character.dart';

class PersentaseEfekSampingWanita {
  /// Mendapatkan persentase peluang terjadinya efek samping untuk perempuan
  /// berdasarkan hubungan/partner saat bermasturbasi.
  static int getChance(String relationType) {
    final String r = relationType.toLowerCase();

    if (r == 'biasa' || r.isEmpty) {
      return 12; // Solo Masturbation
    } else if (r == 'ayah' || r == 'ayah kandung' || r == 'ayah tiri') {
      return 38; // Bersama Ayah (+10% dari 28)
    } else if (r == 'kakek') {
      return 28; // Bersama Kakek (+10% dari 18 baseline)
    } else if (r == 'ibu' || r == 'ibu kandung' || r == 'ibu tiri') {
      return 20; // Bersama Ibu
    } else if (r.contains('paman')) {
      return 28; // Bersama Paman (+10% dari 18 baseline)
    } else if (r.contains('kakak') || r.contains('adik') || r.contains('saudara')) {
      // Jika itu saudara laki-laki
      if (r.contains('laki')) {
        return 32; // Bersama Saudara Laki-laki (+10% dari 22)
      }
      return 22; // Bersama Saudara Perempuan / lainnya
    } else {
      return 18; // Bersama Orang selain keluarga (Pacar, Teman, dll)
    }
  }
}
