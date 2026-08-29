import 'dart:math';

class PenyakitBeratHelper {
  static final List<Map<String, dynamic>> daftarPenyakitBerat = [
    {'name': 'Pneumonia berat', 'min': 18, 'max': 25, 'emoji': '🫁'},
    {'name': 'Stroke ringan', 'min': 20, 'max': 28, 'emoji': '🧠'},
    {'name': 'Serangan jantung ringan', 'min': 18, 'max': 25, 'emoji': '🫀'},
    {'name': 'Gagal ginjal akut', 'min': 20, 'max': 30, 'emoji': '🏥'},
    {'name': 'Kanker stadium awal', 'min': 22, 'max': 30, 'emoji': '🎗️'},
    {'name': 'Meningitis atau radang selaput otak', 'min': 20, 'max': 28, 'emoji': '🧠'},
    {'name': 'Tuberkulosis (TBC) aktif', 'min': 18, 'max': 25, 'emoji': '🦠'},
    {'name': 'Pankreatitis akut', 'min': 16, 'max': 22, 'emoji': '🩺'},
  ];

  static Map<String, dynamic> getRandomBerat() {
    final random = Random();
    return daftarPenyakitBerat[random.nextInt(daftarPenyakitBerat.length)];
  }
}
