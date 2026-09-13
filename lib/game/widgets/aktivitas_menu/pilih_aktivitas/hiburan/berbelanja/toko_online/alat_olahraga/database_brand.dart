// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/toko_online/alat_olahraga/database_brand.dart
class AlatOlahragaDatabase {
  static final List<String> brands = ['Decathlon 🏋️', 'Specs ⚽', 'Yonex 🏸'];

  static final Map<String, List<Map<String, dynamic>>> products = {
    'Decathlon 🏋️': [
      {'name': 'Dumbbell Set 10kg 🏋️', 'cost': 500000, 'happiness': 8, 'health': 5, 'desc': 'Set beban untuk latihan di rumah.'},
      {'name': 'Matras Yoga Premium 🧘', 'cost': 350000, 'happiness': 7, 'health': 4, 'desc': 'Matras empuk dan anti selip.'},
      {'name': 'Treadmill Elektrik Home 🏃', 'cost': 6500000, 'happiness': 18, 'health': 12, 'desc': 'Treadmill canggih untuk joging harian.'},
    ],
    'Specs ⚽': [
      {'name': 'Sepatu Bola Specs Accelerator ⚽', 'cost': 750000, 'happiness': 10, 'health': 6, 'desc': 'Sepatu futsal & bola bahan lokal terbaik.'},
      {'name': 'Bola Sepak Match Ball ⚽', 'cost': 400000, 'happiness': 8, 'health': 5, 'desc': 'Bola standar pertandingan resmi.'},
    ],
    'Yonex 🏸': [
      {'name': 'Raket Bulutangkis Astrox 🏸', 'cost': 1800000, 'happiness': 15, 'health': 8, 'desc': 'Raket smash kencang andalan pemain profesional.'},
      {'name': 'Tas Raket Yonex Pro 🏸', 'cost': 800000, 'happiness': 11, 'health': 3, 'desc': 'Tas khusus muat 6 raket.'},
    ],
  };
}
