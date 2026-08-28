// lib/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/persentase_efek_samping/pria.dart
import 'package:bitlife/pilih_karakter/character.dart';

class PersentaseEfekSampingPria {
  /// Mendapatkan persentase peluang terjadinya efek samping untuk pria
  /// berdasarkan hubungan/partner saat bermasturbasi.
  static int getChance(String relationType) {
    final String r = relationType.toLowerCase();

    if (r == 'biasa' || r.isEmpty) {
      return 15; // Solo Masturbation
    } else if (r == 'ayah' || r == 'ayah kandung' || r == 'ayah tiri') {
      return 18; // Bersama Ayah
    } else if (r == 'ibu' || r == 'ibu kandung' || r == 'ibu tiri') {
      return 26; // Bersama Ibu
    } else if (r.contains('kakak') || r.contains('adik') || r.contains('saudara')) {
      return 20; // Bersama Keluarga Lain
    } else {
      return 15; // Bersama Orang selain keluarga (Pacar, Teman, dll)
    }
  }
}
