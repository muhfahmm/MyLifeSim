// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/toko_online/alat_olahraga/database_brand.dart
class AlatOlahragaDatabase {
  static final List<String> brands = ['Decathlon 🏋️', 'Specs ⚽', 'Yonex 🏸'];

  static final Map<String, List<Map<String, dynamic>>> products = {
    'Decathlon 🏋️': [
      {'name': 'Dumbbell Set 10kg 🏋️', 'cost': 30, 'happiness': 8, 'health': 5, 'desc': 'Set beban untuk latihan di rumah.'},
      {'name': 'Matras Yoga Premium 🧘', 'cost': 20, 'happiness': 7, 'health': 4, 'desc': 'Matras empuk dan anti selip.'},
      {'name': 'Treadmill Elektrik Home 🏃', 'cost': 400, 'happiness': 18, 'health': 12, 'desc': 'Treadmill canggih untuk joging harian.'},
    ],
    'Specs ⚽': [
      {'name': 'Sepatu Bola Specs Accelerator ⚽', 'cost': 45, 'happiness': 10, 'health': 6, 'desc': 'Sepatu futsal & bola bahan lokal terbaik.'},
      {'name': 'Bola Sepak Match Ball ⚽', 'cost': 25, 'happiness': 8, 'health': 5, 'desc': 'Bola standar pertandingan resmi.'},
    ],
    'Yonex 🏸': [
      {'name': 'Raket Bulutangkis Astrox 🏸', 'cost': 120, 'happiness': 15, 'health': 8, 'desc': 'Raket smash kencang andalan pemain profesional.'},
      {'name': 'Tas Raket Yonex Pro 🏸', 'cost': 50, 'happiness': 11, 'health': 3, 'desc': 'Tas khusus muat 6 raket.'},
    ],
  };
}
