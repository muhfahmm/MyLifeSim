import 'dart:math';

class PenyakitRinganHelper {
  static final List<Map<String, dynamic>> daftarPenyakitRingan = [
    {'name': 'Flu ringan', 'min': 1, 'max': 3, 'emoji': '🤧'},
    {'name': 'Sakit kepala atau migrain ringan', 'min': 1, 'max': 2, 'emoji': '🤕'},
    {'name': 'Batuk berdahak', 'min': 2, 'max': 4, 'emoji': '😷'},
    {'name': 'Alergi musiman', 'min': 1, 'max': 3, 'emoji': '🤧'},
    {'name': 'Sakit gigi ringan', 'min': 2, 'max': 5, 'emoji': '🦷'},
    {'name': 'Pusing atau vertigo ringan', 'min': 1, 'max': 3, 'emoji': '🌀'},
    {'name': 'Diare ringan', 'min': 2, 'max': 4, 'emoji': '🤢'},
  ];

  static final List<Map<String, dynamic>> daftarPenyakitSedang = [
    {'name': 'Tipes atau demam tifoid', 'min': 8, 'max': 12, 'emoji': '🤒'},
    {'name': 'Demam Berdarah Dengue (DBD) ringan', 'min': 10, 'max': 15, 'emoji': '🦟'},
    {'name': 'Radang paru-paru atau pneumonia ringan', 'min': 8, 'max': 13, 'emoji': '🫁'},
    {'name': 'Hepatitis A', 'min': 7, 'max': 12, 'emoji': '🟡'},
    {'name': 'Infeksi saluran kemih atau ISK', 'min': 6, 'max': 10, 'emoji': '🚽'},
    {'name': 'Disentri atau diare berdarah', 'min': 9, 'max': 14, 'emoji': '🩸'},
    {'name': 'Radang usus buntu atau apendisitis', 'min': 10, 'max': 15, 'emoji': '⚡'},
  ];

  static Map<String, dynamic> getRandomRingan() {
    final random = Random();
    return daftarPenyakitRingan[random.nextInt(daftarPenyakitRingan.length)];
  }

  static Map<String, dynamic> getRandomSedang() {
    final random = Random();
    return daftarPenyakitSedang[random.nextInt(daftarPenyakitSedang.length)];
  }
}
