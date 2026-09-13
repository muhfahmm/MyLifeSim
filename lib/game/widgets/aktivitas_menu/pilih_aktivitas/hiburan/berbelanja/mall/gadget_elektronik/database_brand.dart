// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/berbelanja/mall/gadget_elektronik/database_brand.dart
class GadgetElektronikDatabase {
  static final List<String> brands = ['Apple 🍎', 'Samsung 📱', 'Sony 🎮'];

  static final Map<String, List<Map<String, dynamic>>> products = {
    'Apple 🍎': [
      {'name': 'iPhone 15 Pro Max 📱', 'cost': 1200, 'happiness': 25, 'desc': 'Smartphone titanium tercanggih.'},
      {'name': 'MacBook Pro M3 Max 💻', 'cost': 3500, 'happiness': 30, 'desc': 'Laptop monster untuk profesional.'},
      {'name': 'iPad Pro M2 📲', 'cost': 1000, 'happiness': 20, 'desc': 'Tablet canggih untuk kreasi dan kerja.'},
    ],
    'Samsung 📱': [
      {'name': 'Samsung Galaxy S24 Ultra 📱', 'cost': 1300, 'happiness': 24, 'desc': 'Smartphone flagship dengan S-Pen.'},
      {'name': 'Samsung Galaxy Z Fold 5 📱', 'cost': 1800, 'happiness': 27, 'desc': 'Smartphone lipat canggih futuristik.'},
    ],
    'Sony 🎮': [
      {'name': 'PlayStation 5 Disc Edition 🎮', 'cost': 500, 'happiness': 22, 'desc': 'Konsol game next-gen paling populer.'},
      {'name': 'Sony WH-1000XM5 Headphone 🎧', 'cost': 350, 'happiness': 16, 'desc': 'Headphone noise-cancelling terbaik.'},
    ],
  };
}
