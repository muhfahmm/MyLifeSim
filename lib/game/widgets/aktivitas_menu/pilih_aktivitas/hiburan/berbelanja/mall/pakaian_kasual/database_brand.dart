// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/mall/pakaian_kasual/database_brand.dart
class PakaianKasualDatabase {
  static final List<String> brands = ['Uniqlo 👕', 'H&M 👔', 'Zara 🧥'];

  static final Map<String, List<Map<String, dynamic>>> products = {
    'Uniqlo 👕': [
      {'name': 'Kaos Polos Airism 👕', 'cost': 150000, 'happiness': 5, 'desc': 'Kaos polos adem dan nyaman.'},
      {'name': 'Kemeja Casual Flannel 👔', 'cost': 300000, 'happiness': 8, 'desc': 'Kemeja kotak-kotak bahan lembut.'},
      {'name': 'Jaket Parka Ringan 🧥', 'cost': 500000, 'happiness': 10, 'desc': 'Jaket kasual tahan angin.'},
    ],
    'H&M 👔': [
      {'name': 'Basic Cotton Tee 👕', 'cost': 180000, 'happiness': 6, 'desc': 'Kaos katun kasual kekinian.'},
      {'name': 'Sweater Hoodie Overzied 🧥', 'cost': 450000, 'happiness': 9, 'desc': 'Sweater hangat dan modis.'},
      {'name': 'Celana Chino Slim Fit 👖', 'cost': 350000, 'happiness': 7, 'desc': 'Celana kasual elegan.'},
    ],
    'Zara 🧥': [
      {'name': 'Kemeja Linen Premium 👔', 'cost': 600000, 'happiness': 12, 'desc': 'Kemeja kasual gaya Eropa.'},
      {'name': 'Blazer Casual Modern 🧥', 'cost': 1200000, 'happiness': 15, 'desc': 'Blazer keren cocok untuk hangout.'},
      {'name': 'Jaket Denim Vintage 🧥', 'cost': 850000, 'happiness': 13, 'desc': 'Jaket jeans klasik stylish.'},
    ],
  };
}
