// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/mall/tas_punggung/database_brand.dart
class TasPunggungDatabase {
  static final List<String> brands = ['Eiger 🎒', 'Herschel 🎒', 'JanSport 🎒'];

  static final Map<String, List<Map<String, dynamic>>> products = {
    'Eiger 🎒': [
      {'name': 'Eiger Daypack 18L 🎒', 'cost': 25, 'happiness': 7, 'desc': 'Tas daypack kokoh untuk aktivitas harian.'},
      {'name': 'Eiger Travel Backpack 35L 🎒', 'cost': 55, 'happiness': 12, 'desc': 'Tas ransel muat banyak untuk petualangan.'},
    ],
    'Herschel 🎒': [
      {'name': 'Herschel Little America 🎒', 'cost': 110, 'happiness': 18, 'desc': 'Tas ransel berdesain vintage kekinian.'},
      {'name': 'Herschel Heritage Backpack 🎒', 'cost': 75, 'happiness': 14, 'desc': 'Tas simpel elegan bahan berkualitas.'},
    ],
    'JanSport 🎒': [
      {'name': 'JanSport SuperBreak 🎒', 'cost': 35, 'happiness': 9, 'desc': 'Tas ransel legendaris anak sekolah & kampus.'},
      {'name': 'JanSport Right Pack 🎒', 'cost': 60, 'happiness': 13, 'desc': 'Tas ransel dengan alas kulit sintetis mewah.'},
    ],
  };
}
