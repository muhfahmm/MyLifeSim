// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/mall/sepatu_sneakers/database_brand.dart
class SepatuSneakersDatabase {
  static final List<String> brands = ['Nike 👟', 'Adidas 👟', 'Puma 🐆'];

  static final Map<String, List<Map<String, dynamic>>> products = {
    'Nike 👟': [
      {'name': 'Air Force 1 White 👟', 'cost': 1500000, 'happiness': 15, 'desc': 'Sneakers putih paling ikonik.'},
      {'name': 'Air Jordan 1 Retro 👟', 'cost': 3500000, 'happiness': 25, 'desc': 'Sepatu basket klasik buruan kolektor.'},
      {'name': 'Nike Dunk Low 👟', 'cost': 2000000, 'happiness': 18, 'desc': 'Sneakers kasual trendy.'},
    ],
    'Adidas 👟': [
      {'name': 'Adidas Samba OG 👟', 'cost': 2200000, 'happiness': 20, 'desc': 'Sneakers retro yang sangat hits.'},
      {'name': 'Ultraboost Light 👟', 'cost': 2800000, 'happiness': 22, 'desc': 'Sepatu lari paling nyaman.'},
      {'name': 'Adidas Stan Smith 👟', 'cost': 1400000, 'happiness': 14, 'desc': 'Sepatu santai desain simpel.'},
    ],
    'Puma 🐆': [
      {'name': 'Puma Suede Classic 👟', 'cost': 1200000, 'happiness': 12, 'desc': 'Sepatu bahan suede legendaris.'},
      {'name': 'Puma RS-X Triple 👟', 'cost': 1800000, 'happiness': 16, 'desc': 'Sneakers bergaya chunky modern.'},
    ],
  };
}
