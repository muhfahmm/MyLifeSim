// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/mall/pakaian_kasual/database_brand.dart
class PakaianKasualDatabase {
  static final List<String> brands = ['Uniqlo 👕', 'H&M 👔', 'Zara 🧥'];

  static final Map<String, List<Map<String, dynamic>>> products = {
    'Uniqlo 👕': [
      {'name': 'Kaos Polos Airism 👕', 'cost': 15, 'happiness': 5, 'desc': 'Kaos polos adem dan nyaman.'},
      {'name': 'Kemeja Casual Flannel 👔', 'cost': 30, 'happiness': 8, 'desc': 'Kemeja kotak-kotak bahan lembut.'},
      {'name': 'Jaket Parka Ringan 🧥', 'cost': 50, 'happiness': 10, 'desc': 'Jaket kasual tahan angin.'},
    ],
    'H&M 👔': [
      {'name': 'Basic Cotton Tee 👕', 'cost': 18, 'happiness': 6, 'desc': 'Kaos katun kasual kekinian.'},
      {'name': 'Sweater Hoodie Overzied 🧥', 'cost': 45, 'happiness': 9, 'desc': 'Sweater hangat dan modis.'},
      {'name': 'Celana Chino Slim Fit 👖', 'cost': 35, 'happiness': 7, 'desc': 'Celana kasual elegan.'},
    ],
    'Zara 🧥': [
      {'name': 'Kemeja Linen Premium 👔', 'cost': 60, 'happiness': 12, 'desc': 'Kemeja kasual gaya Eropa.'},
      {'name': 'Blazer Casual Modern 🧥', 'cost': 120, 'happiness': 15, 'desc': 'Blazer keren cocok untuk hangout.'},
      {'name': 'Jaket Denim Vintage 🧥', 'cost': 85, 'happiness': 13, 'desc': 'Jaket jeans klasik stylish.'},
    ],
  };
}
