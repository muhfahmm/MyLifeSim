// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/mall/sepatu_sneakers/database_brand.dart
class SepatuSneakersDatabase {
  static final List<String> brands = ['Nike 👟', 'Adidas 👟', 'Puma 🐆'];

  static final Map<String, List<Map<String, dynamic>>> products = {
    'Nike 👟': [
      {'name': 'Air Force 1 White 👟', 'cost': 100, 'happiness': 15, 'desc': 'Sneakers putih paling ikonik.'},
      {'name': 'Air Jordan 1 Retro 👟', 'cost': 220, 'happiness': 25, 'desc': 'Sepatu basket klasik buruan kolektor.'},
      {'name': 'Nike Dunk Low 👟', 'cost': 120, 'happiness': 18, 'desc': 'Sneakers kasual trendy.'},
    ],
    'Adidas 👟': [
      {'name': 'Adidas Samba OG 👟', 'cost': 130, 'happiness': 20, 'desc': 'Sneakers retro yang sangat hits.'},
      {'name': 'Ultraboost Light 👟', 'cost': 180, 'happiness': 22, 'desc': 'Sepatu lari paling nyaman.'},
      {'name': 'Adidas Stan Smith 👟', 'cost': 90, 'happiness': 14, 'desc': 'Sepatu santai desain simpel.'},
    ],
    'Puma 🐆': [
      {'name': 'Puma Suede Classic 👟', 'cost': 75, 'happiness': 12, 'desc': 'Sepatu bahan suede legendaris.'},
      {'name': 'Puma RS-X Triple 👟', 'cost': 110, 'happiness': 16, 'desc': 'Sneakers bergaya chunky modern.'},
    ],
  };
}
