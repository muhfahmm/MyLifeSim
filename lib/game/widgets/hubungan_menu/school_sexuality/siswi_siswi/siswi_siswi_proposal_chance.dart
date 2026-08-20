// lib/game/widgets/hubungan_menu/school_sexuality/siswi_siswi/siswi_siswi_proposal_chance.dart

class SiswiSiswiProposalChance {
  /// Mendapatkan persentase ajakan pacaran dari Siswi Perempuan ke Siswi Perempuan (Lesbian) berdasarkan usia
  static int getPacaranChance(int age) {
    if (age == 6) return 5;
    if (age == 7) return 10;
    if (age == 8) return 15;
    if (age == 9) return 20;
    if (age == 10) return 25;
    if (age == 11) return 30;
    if (age == 12) return 35;
    if (age == 13) return 40;
    if (age == 14) return 45;
    if (age >= 15) return 50;
    return 0;
  }

  /// Mendapatkan persentase ajakan berhubungan intim dari Siswi Perempuan ke Siswi Perempuan (Lesbian) berdasarkan usia
  static int getBercintaChance(int age) {
    if (age == 6) return 3;
    if (age == 7) return 7;
    if (age == 8) return 15;
    if (age == 9) return 18;
    if (age == 10) return 23;
    if (age == 11) return 30;
    if (age == 12) return 35;
    if (age == 13) return 40;
    if (age == 14) return 45;
    if (age >= 15) return 50;
    return 0;
  }
}
